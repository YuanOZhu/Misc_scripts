# Misc_scripts

### HBV_quasispecies_sfs.py
A script that takes in lofreq vcf and gatk coverage files. 
Summarizes base conservation across multiple HBV viral populations in an additive manner.\
Assumes all sequences are aligned. Only works on genotypes B and C (ref length = 3215bp).\
Outputs matrix for observed A/C/G/T counts.

### Sample_vcf_to_consensus.pl
A script that takes in\
ref.fasta\
sample.coverage\
sample.vcf\
and outputs consensus sequence for bases >10X depth

### Extract_gene.pl
A script that takes in\
multiple alignment .fasta\
start position of gene\
end position of gene\
gene name\
and outputs gene sequences for all aligned samples

### Xgene_restructure.pl
Same as Extract_gene.pl but hardcoded for X gene due to arbitrary breakpoing in the X gene to linearize circular genome\
Entirely dependent on version of reference genome used.

### Fasta_to_geneAA.pl
Usage: perl Fasta_to_geneAA.pl aligned.gene.fa > aligned.gene.aa\
This script converts ORF DNA sequence to protein sequence\
Input must be in frame and exactly encompass ORF region

### Sfs_sorted.pl
Usage: perl Sfs_sorted.pl aligned.fa > sfs.out\
This script summarizes and outputs counts of all observed bases for variable sites only

### Pairwise_diff.pl
Usage: perl Pairwise_diff.pl samples.fa missing_character > out.txt\
This script counts base differences between any 2 sequences ignoring -/N as specified

### Filter_vcf.sh
Simple bash script to loop through all vcf files in working directory and filter as required

### Reformat_reference.pl
Usage: perl reformat_reference.pl GenoBGenoCsubtypes_geno8.fa > reformat_reference.out\
Hardcoded script to reformat reference sequences from NCBI as needed 

