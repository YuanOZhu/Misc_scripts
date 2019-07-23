#!/bin/bash

REF=/mnt/projects/zhuy/ecoli_pop_gen/00_All_references/

for filename in ./*R1*fastq.gz; do
    A="$(cut -d'_' -f1 <<< $filename)"
    SAMPLE="$(cut -d'/' -f2 <<< $A)"
    #mkdir $SAMPLE
    #qsub -pe OpenMP 32 -l mem_free=48G,h_rt=48:00:00 -cwd -V -b y -o $SAMPLE.o -e $SAMPLE.e -N $SAMPLE.trim
    qsub -pe OpenMP 8 -l mem_free=16G,h_rt=4:00:00 -cwd -V -b y -o $SAMPLE.o -e $SAMPLE.e -N $SAMPLE.trim java -jar /mnt/software/bin/trimmomatic-0.30.jar PE -phred33 $SAMPLE*R1*fastq.gz $SAMPLE*R2*fastq.gz $SAMPLE.trimmed.R1.fastq.gz $SAMPLE.trimmed.R1.unpaired.fastq.gz $SAMPLE.trimmed.R2.fastq.gz $SAMPLE.trimmed.R2.unpaired.fastq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 
    #ILLUMINACLIP:TruSeq3-PE.fa LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    #qsub -pe OpenMP 32 -l mem_free=48G,h_rt=48:00:00 -cwd -V -b y -o $SAMPLE.o -e $SAMPLE.e -N $SAMPLE.RNAseq bash Yuan_RNAseq.sh $SAMPLE
    #bash Yuan_RNAseq.sh $SAMPLE
done
