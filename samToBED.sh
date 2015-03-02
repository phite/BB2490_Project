#!/bin/bash


module load bioinfo-tools
module load samtools
module load BEDTools
module list

DIR_DATA='/home/yunzhang/CAGE_project/out/other'
DIR_OUT='/home/yunzhang/CAGE_project/out/bam'
DIR_BAMS='/home/yunzhang/CAGE_project/out/bams'
DIR_BED='/home/yunzhang/CAGE_project/out/bed'
filelist="CAGE_VRSY_HELA_SPIKE_01P.BC3_hg19_mapped CAGE_VRSY_HELA_SPIKE_1P.BC2_hg19_mapped CAGE_VRSY_HELA_SPIKE_01P.BC3_r64_mapped CAGE_VRSY_HELA_SPIKE_1P.BC2_r64_mapped"

for mfile in $filelist
do

    STRING="File in progress: "${mfile}
    echo $STRING

    echo "Converting SAM to BAM"
    samtools view -Sb $DIR_DATA/${mfile} > $DIR_OUT/${mfile}.bam
    echo "Filtering BAM file"

    samtools view -b -q 20 $DIR_OUT/${mfile}.bam -o $DIR_OUT/${mfile}q.bam
    echo "q20Filtered"

    echo "Sorting filtered BAM file"
    samtools sort $DIR_OUT/${mfile}q.bam $DIR_BAMS/${mfile}s
    echo "SORTED"

    echo "Indexing BAM file"
    samtools index $DIR_BAMS/${mfile}s.bam
    echo "INDEXED"

    echo "Converting to BED"
    bamToBed -i $DIR_BAMS/${mfile}s.bam > $DIR_BED/${mfile}.bed
    echo "Converted to BED"

done

