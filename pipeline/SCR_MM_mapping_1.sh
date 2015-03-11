#! /bin/bash 

# -A g2015009 -t 2:00:00 -p node -n 8 -o my_job_name.out

echo 'CAGE mapping pipeline for Uppmax'


echo Loading bioinformatics modules
module load bioinfo-tools 
module load Fastx 
module load bowtie
module list


INP_FILE="CAGE_VRSY_HELA_SPIKE_1P.fastq"
DIR_DATA="/home/yunzhang/CAGE_project/Experimental_data"
DIR_OUT="/home/yunzhang/CAGE_project/out/other"
DIR_BED="/home/yunzhang/CAGE_project/out/bed"

SAMPLE_NAME="CAGE_VRSY_HELA_SPIKE_1P"

DIR_PHIX='/home/yunzhang/CAGE_project/phix/phix'
DIR_HG19='/home/yunzhang/CAGE_project/hg19/hg19'
DIR_r64='/home/yunzhang/CAGE_project/yeast/s_cerevisiae'
DIR_rDNA='/home/yunzhang/CAGE_project/humanrDNA/humanrDNA'
DIR_BARCODES='/home/yunzhang/CAGE_project'
DIR_human_blacklist='/home/yunzhang/CAGE_project/human_blacklist/human_blacklist'
DIR_yeast_blacklist='/home/yunzhang/CAGE_project/yeast_blacklist/yeast_blacklist'

echo Description
echo Mapping against PhiX
echo Splitting by barcodes, quality filtering and trimming
echo Mapping against rDNA
echo Mapping against mm10
echo IN PROGRESS...
echo $SAMPLE_NAME

echo Mapping to PhiX

bowtie -S -t $DIR_PHIX -q $DIR_DATA/$INP_FILE --un $DIR_OUT/$SAMPLE_NAME.unPhiX > $DIR_OUT/$SAMPLE_NAME.PhiX_mapped 

echo Splitting by barcodes 

cat $DIR_OUT/$SAMPLE_NAME".unPhiX"  | fastx_barcode_splitter.pl --bcfile $DIR_BARCODES/barcodes.txt --bol --mismatches 0 --prefix $DIR_OUT/$SAMPLE_NAME. --suffix ".txt" > $DIR_OUT/out_barcode.txt

echo Quality filtering

fastq_quality_filter -Q 33 -q 30 -p 50 -i $DIR_OUT/$SAMPLE_NAME".BC2.txt" > $DIR_OUT/$SAMPLE_NAME".BC2_qfilter"

echo Trimming out linkers and echoP15

fastx_trimmer -Q33 -f 12 -l 36 -i $DIR_OUT/$SAMPLE_NAME".BC2_qfilter" > $DIR_OUT/$SAMPLE_NAME".BC2_qfilter_trim"


echo Mapping to the Human blacklist 
 
bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -l 25 -e 70 $DIR_human_blacklist -q $DIR_OUT/$SAMPLE_NAME".BC2_qfilter_trim" --un $DIR_OUT/$SAMPLE_NAME".unAl_BC2_human_bl" > $DIR_OUT/$SAMPLE_NAME".BC2_human_bl_mapped"
 
echo Mapping to the Yeast blacklist 
 
bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -l 25 -e 70 $DIR_yeast_blacklist -q $DIR_OUT/$SAMPLE_NAME".unAl_BC2_human_bl" --un $DIR_OUT/$SAMPLE_NAME".unAl_BC2_yeast_bl" > $DIR_OUT/$SAMPLE_NAME".BC2_yeast_bl_mapped"

echo Mapping to the rDNA 

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_rDNA -q $DIR_OUT/$SAMPLE_NAME".unAl_BC2_yeast_bl" --un $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_mapped"


echo Mapping to the Hg19 reference genome

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_HG19 -q $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC2_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_hg19_mapped"

echo Mapping to the r64 reference genome
bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_r64 -q $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC2_r64_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_r64_mapped"
