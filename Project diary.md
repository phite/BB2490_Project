##2015-02-20 Fri
Project Start

Discuss project topic, plan and diaries with Enrichetta and Macro

###Project plan
-  **1st week:**  go through the CAGE data pipeline

-  **2nd week:**  start data analysis

-----------------------------

##2015-02-23 Mon

Read through data processing pipeline from Enrichetta
[Pipeline.pdf](https://github.com/phite/BB2490_Project/blob/master/Pipeline.pdf)

-------------------------------

##2015-02-24 Tue

Get more detailed information about data processing part of pipeline.

An additional step: map reads to a black list which contains identical sequence of human and yeast transcriptome.

Get raw data shared from Macro

------------------------------

##2015-02-25 Wed

Read and change [script](https://github.com/phite/BB2490_Project/blob/master/pipeline/SCR_MM_mapping_01.sh) written by Enrichetta

Practice the Data processing of CAGE_01yeast data using shell commands.

-------------------------------

##2015-02-27 Fri

Meeting with Enrichetta and Marco.

Discuss questions of running script and the problem of creating blacklist.

Receive codes [chop](https://github.com/phite/BB2490_Project/blob/master/pipeline/chop_seq.py) and [merge](https://github.com/phite/BB2490_Project/blob/master/pipeline/merge.py) from Marco

-------------------------------

##2015-03-01 Sun

Prepare presentation for seminar in 03/03.

Run batch script for CAGE_1yeast data overnight.

Improve and complete the [pipeline](https://github.com/phite/BB2490_Project/blob/master/Pipeline.doc)

-------------------------------

##2015-03-03 Tue

Describe problems and exchange experiences in seminar.

Run preprocessing pipeline for both samples ([script_01P](https://github.com/phite/BB2490_Project/blob/master/pipeline/SCR_MM_mapping_01.sh) and [script_1P](https://github.com/phite/BB2490_Project/blob/master/pipeline/SCR_MM_mapping_1.sh)) using two blacklists.

Results: [log_01P](https://github.com/phite/BB2490_Project/blob/master/pipeline/log_01P.out) and [log_1P](https://github.com/phite/BB2490_Project/blob/master/pipeline/log_1P.out)

-------------------------------

##2015-03-05 Thu

Receive codes for step 2-4 in the [pipeline](https://github.com/phite/BB2490_Project/blob/master/Pipeline.doc):
[samToBED](https://github.com/phite/BB2490_Project/blob/master/pipeline/samToBED.sh),
[bamToCluster_yeast](https://github.com/phite/BB2490_Project/blob/master/pipeline/bamToCluster_yeast.sh),
[bamToCluster_human](https://github.com/phite/BB2490_Project/blob/master/pipeline/bamToCluster_human.sh) and
[bedI](https://github.com/phite/BB2490_Project/blob/master/pipeline/bedI.sh)

-------------------------------

##2015-03-06 Fri

Meeting with Enrichetta and Marco.

We discussed the small results difference after running preprocessing.

Also, we try to figure out a method to normalize human read counts according to the dynamic range of yeast read counts.

-------------------------------

##2015-03-09 Mon

Think about a normalization method using mean of logarithm of yeast read counts to adjust human counts.

Seminar about how to prepare poster and poster presentation.

Discuss normalization methods with Olof and receive and related [article](http://www.nature.com/nbt/journal/v32/n9/full/nbt.2931.html) from him.

-------------------------------

##2015-03-10 Tue

Receive read count result from Enrichetta:
[human_count](https://github.com/phite/BB2490_Project/blob/master/read_count/CAGE_VRSY_HELA_SPIKE_01P_1P_hg19_counts.bed) and 
[yeast_count](https://github.com/phite/BB2490_Project/blob/master/read_count/CAGE_VRSY_HELA_SPIKE_01P_1P_r64_counts.bed)

Perform a quick analysis and try to normalize read counts in R:
[normalization.R](https://github.com/phite/BB2490_Project/blob/master/read_count/normalization.R)

[Result](https://github.com/phite/BB2490_Project/blob/master/read_count/normalized_human.bed)

-------------------------------

##2015-03-11 Wed

Receive codes for TPM normalization from Enrichetta. Add them in [normalization.R](https://github.com/phite/BB2490_Project/blob/master/read_count/normalization.R).






 