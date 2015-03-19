##2015-02-20 Fri
Project Start

Discuss project topic, plan and diaries with Enrichetta and Macro

Project idea [presentation](https://github.com/phite/BB2490_Project/blob/master/cage_presentation.pdf)

###Project plan
-  **1st week:**  go through the CAGE data pipeline

-  **2nd week:**  build up a blacklist

-  **3nd week:**  data normalization and analysis

-  **4nd week:**  prepare for the poster session

-----------------------------

##2015-02-23 Mon

Read through data processing pipeline from Enrichetta
[Pipeline.pdf](https://github.com/phite/BB2490_Project/blob/master/Pipeline.pdf)

-------------------------------

##2015-02-24 Tue

Get more detailed information about data processing part of pipeline.

An additional step: map reads to a black list which contains identical sequence of human and yeast genome.

Get raw data shared from Macro.

------------------------------

##2015-02-25 Wed

Read, edit and correct errors in [script](https://github.com/phite/BB2490_Project/blob/master/pipeline/SCR_MM_mapping_01.sh) written by Enrichetta.

Practice the Data processing of CAGE_01yeast data using shell commands.

-------------------------------

##2015-02-27 Fri

Meeting with Enrichetta and Marco in SciLifeLab.

Discuss problems of running script and creating blacklist.

Receive codes [chop](https://github.com/phite/BB2490_Project/blob/master/pipeline/chop_seq.py) and [merge](https://github.com/phite/BB2490_Project/blob/master/pipeline/merge.py) from Marco, which are used for creating blacklist.

-------------------------------

##2015-03-01 Sun

Prepare presentation for seminar in 03/03.

Run batch script for CAGE_1yeast data overnight.

Improve and complete the [pipeline](https://github.com/phite/BB2490_Project/blob/master/Pipeline.doc)

-------------------------------

##2015-03-03 Tue

Describe problems and exchange experiences in seminar. [Presentation](https://github.com/phite/BB2490_Project/blob/master/CAGE_presentation_3.3.pdf)

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

Meeting with Enrichetta and Marco in SciLifeLab.

We discussed the small difference in results after running preprocessing.

Also, we try to figure out a method to normalize human read counts according to the dynamic range of yeast read counts.

-------------------------------

##2015-03-09 Mon

Think about a [normalization method](https://github.com/phite/BB2490_Project/blob/master/read_count/Normalization_Yunzhang.docx) using mean of logarithm of yeast read counts to adjust human counts.

Seminar about how to prepare the poster and the poster session.

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

Receive codes for TPM normalization from Enrichetta. Rearrange and add them in [normalization.R](https://github.com/phite/BB2490_Project/blob/master/read_count/normalization.R).

-------------------------------

##2015-03-12 Thu

Try R package [TCC](http://master.bioconductor.org/packages/release/bioc/html/TCC.html) to analyse read count.

Try various methods to normalize data.

Use boxplot of Relative Log Expression (RLE) from R package [AgiMicroRna](http://www.bioconductor.org/packages/release/bioc/html/AgiMicroRna.html) to evaluate different normalization methods.


-------------------------------

##2015-03-13 Fri

Study the normalization method used by Marco from R package [DESeq](http://master.bioconductor.org/packages/release/bioc/html/DESeq.html)

-------------------------------

##2015-03-15 Sun

Make a draft of poster.

-------------------------------

##2015-03-17 Tue

Continue working on poster.

Meeting with Enrichetta and Macro in Karolinska Huddinge.

Discuss normalization methods, poster structure and layout.

-------------------------------

##2015-03-18 Wed

Finish evaluating the three methods we used to normalize read count and create boxplots.

Meeting with Enrichetta and Macro in SciLifeLab.

Discuss last details in poster.

Complete final version of the [poster](https://github.com/phite/BB2490_Project/blob/master/CAGE-data-analysis-of-HeLa-yeast-spike-in.pdf)




 