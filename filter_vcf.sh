#!/bin/bash

for filename in ./*vcf; do
    A="$(cut -d '.' -f2 <<< $filename)"
    SAMPLE="$(cut -d'/' -f2 <<< $A)"
    grep -v 'AF=0.0' $filename | awk '{if($6 > 1000){print $1"\t"$2}}' > $SAMPLE.filtered.vcf 
done
