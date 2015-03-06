#!/bin/bash -l

. /usr/share/Modules/init/sh

module load bioinfo-tools
module load BEDTools
module list

filelist_human="CAGE_VRSY_HELA_SPIKE_01P.BC3_hg19_mapped.bed CAGE_VRSY_HELA_SPIKE_1P.BC2_hg19_mapped.bed" filelist_yeast="CAGE_VRSY_HELA_SPIKE_01P.BC3_r64_mapped.bed CAGE_VRSY_HELA_SPIKE_1P.BC2_r64_mapped.bed"
DIR_DATA="/home/enri/glob/DATA/out/bed"
DIR_PAR="/home/enri/glob/DATA/out/paraclu"
DIR_OUT="/home/enri/glob/DATA/out/bed_intersect/all"
for mfile in $filelist_human
do 
  
    STRING="File in progress: "${mfile}
    echo $STRING
    
    intersectBed -a $DIR_PAR/human/par_30_2_100.bed -b $DIR_DATA/${mfile} -c -s > $DIR_OUT/${mfile}_counts
    echo "CTSS intersecteBED done"

done

for mfile in $filelist_yeast
do 
  
    STRING="File in progress: "${mfile}
    echo $STRING
    
    intersectBed -a $DIR_PAR/yeast/par_30_2_100.bed -b $DIR_DATA/${mfile} -c -s > $DIR_OUT/${mfile}_counts
    echo "CTSS intersecteBED done"

done

