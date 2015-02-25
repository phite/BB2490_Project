#! /bin/bash -l
. /usr/share/Modules/init/sh
echo 'CAGE mapping pipeline for Uppmax'


echo Loading bioinformatics modules
module load bioinfo-tools 
module load Fastx 
module load bowtie
module list


INP_FILE="CAGE_VRSY_HELA_SPIKE_01P.fastq"
DIR_DATA="/home/yunzhang/CAGE_project/Experimental_data"
DIR_OUT="/home/yunzhang/CAGE_project/out/other"
DIR_BED="/home/yunzhang/CAGE_project/out/bed"

SAMPLE_NAME="CAGE_VRSY_HELA_SPIKE_01P"

DIR_PHIX='/home/yunzhang/CAGE_project/phix/phix'
DIR_HG19='/home/yunzhang/CAGE_project/hg19'
DIR_r64='/home/yunzhang/CAGE_project/yeast'
DIR_rDNA='/home/enri/glob/DATA/rDNA/humanrDNA'
DIR_BARCODES='/home/yunzhang/CAGE_project'

echo Description
echo Mapping against PhiX
echo Splitting by barcodes, quality filtering and trimming
echo Mapping against rDNA
echo Mapping against mm10
echo IN PROGRESS...
echo $SAMPLE_NAME

echo Mapping to PhiX
# bowtie map data to phix index, output map and unmapped reads
bowtie -S -t $DIR_PHIX -q $DIR_DATA/$INP_FILE --un $DIR_OUT/$SAMPLE_NAME.unPhiX > $DIR_OUT/$SAMPLE_NAME.PhiX_mapped 

echo Splitting by barcodes 
# match barcodes from 5 end, no mismatches allowed. Only select unPhiX as input?, only map to BC3
cat $DIR_OUT/$SAMPLE_NAME".unPhiX"  | fastx_barcode_splitter.pl --bcfile $DIR_BARCODES/barcodes.txt --bol --mismatches 0 --prefix $DIR_OUT/$SAMPLE_NAME. --suffix ".txt" > $DIR_OUT/out_barcode.txt

echo Quality filtering
# select reads with quality score higher than 30, at least 50%. -Q 33 ? 
fastq_quality_filter -Q 33 -q 30 -p 50 -i $DIR_OUT/$SAMPLE_NAME".BC1.txt" > $DIR_OUT/$SAMPLE_NAME".BC1_qfilter"
fastq_quality_filter -Q 33 -q 30 -p 50 -i $DIR_OUT/$SAMPLE_NAME".BC2.txt" > $DIR_OUT/$SAMPLE_NAME".BC2_qfilter"
fastq_quality_filter -Q 33 -q 30 -p 50 -i $DIR_OUT/$SAMPLE_NAME".BC3.txt" > $DIR_OUT/$SAMPLE_NAME".BC3_qfilter"
fastq_quality_filter -Q 33 -q 30 -p 50 -i $DIR_OUT/$SAMPLE_NAME".BC4.txt" > $DIR_OUT/$SAMPLE_NAME".BC4_qfilter"

echo Trimming out linkers and echoP15
# first 12 bases to keep, last 36 bases to keep, why?, -Q33 ?
fastx_trimmer -Q33 -f 12 -l 36 -i $DIR_OUT/$SAMPLE_NAME".BC1_qfilter" > $DIR_OUT/$SAMPLE_NAME".BC1_qfilter_trim"
fastx_trimmer -Q33 -f 12 -l 36 -i $DIR_OUT/$SAMPLE_NAME".BC2_qfilter" > $DIR_OUT/$SAMPLE_NAME".BC2_qfilter_trim"
fastx_trimmer -Q33 -f 12 -l 36 -i $DIR_OUT/$SAMPLE_NAME".BC3_qfilter" > $DIR_OUT/$SAMPLE_NAME".BC3_qfilter_trim"
fastx_trimmer -Q33 -f 12 -l 36 -i $DIR_OUT/$SAMPLE_NAME".BC4_qfilter" > $DIR_OUT/$SAMPLE_NAME".BC4_qfilter_trim"

echo Mapping to the rDNA 
# only report high quality matches, 1 alignment per read, try best, launch 6 parallel search threads ?  
# Input qualities are ASCII chars equal to the Phred quality plus 33 ?  
# 2 mismatches permitted in "seed", seed length 25, max permitted mismatches number
bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_rDNA -q $DIR_OUT/$SAMPLE_NAME".BC1_qfilter_trim" --un $DIR_OUT/$SAMPLE_NAME".BC1_rDNA_unAl" > $DIR_OUT/$SAMPLE_NAME".BC1_rDNA_mapped"

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_rDNA -q $DIR_OUT/$SAMPLE_NAME".BC2_qfilter_trim" --un $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_mapped"

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_rDNA -q $DIR_OUT/$SAMPLE_NAME".BC3_qfilter_trim" --un $DIR_OUT/$SAMPLE_NAME".BC3_rDNA_unAl" > $DIR_OUT/$SAMPLE_NAME".BC3_rDNA_mapped"

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_rDNA -q $DIR_OUT/$SAMPLE_NAME".BC4_qfilter_trim" --un $DIR_OUT/$SAMPLE_NAME".BC4_rDNA_unAl" > $DIR_OUT/$SAMPLE_NAME".BC4_rDNA_mapped"

echo Mapping to the Hg19 reference genome
bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_HG19 -q $DIR_OUT/$SAMPLE_NAME".BC1_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC1_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC1_hg19_mapped"

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_HG19 -q $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC2_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_hg19_mapped"

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_HG19 -q $DIR_OUT/$SAMPLE_NAME".BC3_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC3_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC3_hg19_mapped"

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_HG19 -q $DIR_OUT/$SAMPLE_NAME".BC4_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC4_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC4_hg19_mapped"

echo Mapping to the r64 reference genome
bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_r64 -q $DIR_OUT/$SAMPLE_NAME".BC1_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC1_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC1_r64_mapped"

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_r64 -q $DIR_OUT/$SAMPLE_NAME".BC2_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC2_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC2_r64_mapped"

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_r64 -q $DIR_OUT/$SAMPLE_NAME".BC3_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC3_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC3_r64_mapped"

bowtie -S -t --best -k 1 -y -p 6 --phred33-quals --chunkmbs 64 -n 2 -l 25 -e 70 $DIR_r64 -q $DIR_OUT/$SAMPLE_NAME".BC4_rDNA_unAl" --un $DIR_OUT/$SAMPLE_NAME".BC4_hg19_unAl" > $DIR_OUT/$SAMPLE_NAME".BC4_r64_mapped"