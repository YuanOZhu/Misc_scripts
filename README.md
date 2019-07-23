# Misc_scripts

HBV_quasispecies_sfs.py\
A script that takes in lofreq vcf and gatk coverage files. Summarizes base conservation across multiple HBV viral populations in an additive manner. Assumes all sequences are aligned. Only works on genotypes B and C (ref length = 3215bp). Outputs matrix for observed A/C/G/T counts.

Sample_vcf_to_consensus.pl\
A script that takes in\
ref.fasta\
sample.coverage\
sample.vcf\
and outputs consensus sequence for bases >10X depth
