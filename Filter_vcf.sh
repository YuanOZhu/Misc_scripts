#!/bin/bash

##Author: ZHU O. Yuan (Genome Institute of Singapore)
##Script name: Filter_vcf.sh
##Usage: Filter_vcf.sh
#This bash script loops through all lofreq vcf files in working directory and filters for freq>10% and qual>1000
#modify as required

for filename in ./*vcf; do
    A="$(cut -d '.' -f2 <<< $filename)"
    SAMPLE="$(cut -d'/' -f2 <<< $A)"
    grep -v 'AF=0.0' $filename | awk '{if($6 > 1000){print $1"\t"$2}}' > $SAMPLE.filtered.vcf 
done
