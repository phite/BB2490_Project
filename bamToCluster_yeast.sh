#!/bin/bash -l

. /usr/share/Modules/init/sh

module load bioinfo-tools
module load BEDTools
module load samtools
DIR_PAR='/home/enri/glob/tools/paraclu-9'
DIR_BAMS='/home/enri/glob/DATA/out/bams/yeast'

DIR_OUT='/home/enri/glob/DATA/out/paraclu/yeast'


echo "Merging .bam files..."
#cat $DIR_BAM/*s.bam > all.bam
samtools merge $DIR_BAMS/*s.bam > all.bam

echo "All bam into bed"
samtools sort all.bam alls
samtools index alls.bam
bamToBed -i alls.bam > alls.bed

echo "BED into minus and positive"
perl divBed_02.pl

echo "CTSS counts: postive strand"
groupBy -i allp.bed -g 1,2 -c 6 -o count > $DIR_OUT/ctss_pos

echo "CTSS counts: negative strand"
groupBy -i allm.bed -g 1,3 -c 6 -o count > $DIR_OUT/ctss_neg

echo "CTSS output to paraclu format"
awk -F "\t" '{print$1"\t""+""\t"$2"\t"$3}' < $DIR_OUT/ctss_pos > $DIR_OUT/ctss_pos_4P
awk -F "\t" '{print$1"\t""-""\t"$2"\t"$3}' < $DIR_OUT/ctss_neg > $DIR_OUT/ctss_neg_4P

echo "Sorting the neg prior paraclu clustering"
sort -k3n $DIR_OUT/ctss_neg_4P > $DIR_OUT/ctss_neg_4Ps

echo "Paraclu clustering"
$DIR_PAR/./paraclu 30 $DIR_OUT/ctss_pos_4P > $DIR_OUT/par_pos_30
$DIR_PAR/./paraclu 30 $DIR_OUT/ctss_neg_4Ps > $DIR_OUT/par_neg_30

echo "Paraclu-cut"
$DIR_PAR/./paraclu-cut.sh -d 2 -l 100 $DIR_OUT/par_pos_30 > $DIR_OUT/par_pos_30_2_100
$DIR_PAR/./paraclu-cut.sh -d 2 -l 100 $DIR_OUT/par_neg_30 > $DIR_OUT/par_neg_30_2_100

echo "Combined clusters and create BED file"
cat $DIR_OUT/par_pos_30_2_100 $DIR_OUT/par_neg_30_2_100 > $DIR_OUT/par_30_2_100
awk -F "\t" '{print$1"\t"$3"\t"$4"\t""par_30_2_100""\t"$5"\t"$2}' < $DIR_OUT/par_30_2_100 > $DIR_OUT/par_30_2_100.bed

echo "No of clusters paraclu 30: positive strand"
awk '{print$1}' < $DIR_OUT/par_pos_30 | wc -l

echo "No of clusters paraclu 30: negative strand"
awk '{print$1}' < $DIR_OUT/par_neg_30 | wc -l

echo "No of clusters paraclu 30 2 100: positive strand"
awk '{print$1}' < $DIR_OUT/par_pos_30_2_100 | wc -l

echo "No of clusters paraclu 30 2 100: negative strand"
awk '{print$1}' <$DIR_OUT/par_neg_30_2_100 | wc -l

echo "DONE" 
