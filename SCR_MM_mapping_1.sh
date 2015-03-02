#! /bin/bash 

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
DIR_blaclist='/home/yunzhang/CAGE_project/black-list/blacklist'

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


echo Mapping to the blacklist 

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -l 25 -e 70 $DIR_blaclist -q $DIR_OUT/$SAMPLE_NAME".BC2_qfilter_trim" --un $DIR_OUT/$SAMPLE_NAME".BC2_BL_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_BL_mapped"

echo Mapping to the rDNA 

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_rDNA -q $DIR_OUT/$SAMPLE_NAME".BC2_BL_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_mapped"


echo Mapping to the Hg19 reference genome

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_HG19 -q $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC2_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_hg19_mapped"

echo Mapping to the r64 reference genome
bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_r64 -q $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC2_r64_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_r64_mapped"
