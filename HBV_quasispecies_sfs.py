#!/usr/bin/env
import os
import sys
import glob
import re
import numpy as np
from numpy import genfromtxt
from collections import Counter

##Usage: python3 02_quasi_species_conserved.py B-C.ref.fasta > file.out

#Author: Yuan O Zhu 2019 Jan
#site conservation including quasispecies information
#designed for HBV genotype B and C sequences
#for all positions if covered > 1000x include snp info % 
#requires a reference fasta file, all references aligned
#requires lofreq vcf and gatk coverage

###########Example GATK Coverage file###########
#Locus  Total_Depth     Average_Depth_sample    Depth_for_AHH22000_B
#|ref_HBVB_non-ambiguous|:1     873323  873323.00       873323
#|ref_HBVB_non-ambiguous|:2     913942  913942.00       913942
#|ref_HBVB_non-ambiguous|:3     921502  921502.00       921502
#|ref_HBVB_non-ambiguous|:4     927652  927652.00       927652
#|ref_HBVB_non-ambiguous|:5     932636  932636.00       932636
#|ref_HBVB_non-ambiguous|:6     939558  939558.00       939558
#|ref_HBVB_non-ambiguous|:7     945870  945870.00       945870
#|ref_HBVB_non-ambiguous|:8     952291  952291.00       952291
#|ref_HBVB_non-ambiguous|:9     963463  963463.00       963463

###########Example lofreq vcf##############
#|ref_HBVB_non-ambiguous|       3147    .       A       G       26220   PASS    DP=2406;AF=0.563175;SB=0;DP4=283,0,1355,0
#|ref_HBVB_non-ambiguous|       3147    .       A       T       49314   PASS    DP=2406;AF=0.317539;SB=0;DP4=283,0,764,0
#|ref_HBVB_non-ambiguous|       3148    .       G       A       49314   PASS    DP=2483;AF=0.026178;SB=0;DP4=34,0,65,0
#|ref_HBVB_non-ambiguous|       3148    .       G       T       49314   PASS    DP=2483;AF=0.947644;SB=0;DP4=34,0,2353,0
#|ref_HBVB_non-ambiguous|       3149    .       T       G       12592   PASS    DP=2495;AF=0.314228;SB=0;DP4=1684,0,784,0
#|ref_HBVB_non-ambiguous|       3152    .       G       A       266     PASS    DP=2497;AF=0.018823;SB=0;DP4=2449,0,47,0
#|ref_HBVB_non-ambiguous|       3157    .       A       T       4040    PASS    DP=2490;AF=0.143775;SB=0;DP4=2101,0,358,0
#|ref_HBVB_non-ambiguous|       3159    .       G       A       5198    PASS    DP=2481;AF=0.145506;SB=0;DP4=2117,0,361,0
#|ref_HBVB_non-ambiguous|       3194    .       G       C       640     PASS    DP=2288;AF=0.039773;SB=1;DP4=2039,152,84,7
#|ref_HBVB_non-ambiguous|       3195    .       T       C       203     PASS    DP=2273;AF=0.024197;SB=0;DP4=2057,160,51,4

#stores fasta file in dictionary
def initialize_references(reffile):
    header = ""
    sequence = ""
    with open(reffile) as fp:
        line = fp.readline()
        while line:
            stripped = line.rstrip('\n')
            if ">" not in stripped:
                sequence = sequence + stripped
            else:
                if(header != ""):
                    ref_sequences[header] = sequence
                header = stripped
                sequence = ""
            line = fp.readline()
    ref_sequences[header] = sequence
    fp.close()

def convert_base(base):
    if (base == "A"):
        return 0
    if (base == "C"):
        return 1
    if (base == "G"):
        return 2
    if (base == "T"):
        return 3
    
#loop through each coverage file to count covered sites (>1000x)
def summarize_coverage(my_cov):
    for pos, cov in enumerate(my_cov):
        if (pos>0) :
            if (int(cov) > 1000):
                if pos in cov_count:
                    cov_count[pos] += 1
                else:
                    cov_count[pos] = 1
#loop through each vcf file to count frequencies of ref or alt base
def summarize_vcf(vcffile,genotype):
    sampleseq = ref_sequences[genotype] #sequence of this genotype
    samplesnps = genfromtxt(vcffile[0], delimiter="\t",dtype=str)[:,1] #list of snp positions
    counter = 1 #counts snp position
    for x in sampleseq: #for every base in sequence
        if (float(my_cov[int(counter)]) > 1000): #if well covered (>1000)
            if counter not in vcf_count: #if not already created in vcf_count 
                vcf_count[int(counter)] = [0,0,0,0] #create list
            vcf_count[int(counter)][convert_base(x)] += 1 #update list
        counter += 1 #go to next base
    with open(vcffile[0], 'r') as f: #moving into actual vcf file
        for line in f:
            if (line.startswith('#')) == False: #ignore header lines
                data = line.split("\t")
                freq = re.split(';|\n|=',data[7]) #split data
                if ((int(freq[1]) > 1000) and (int(data[5]) > 1000)): #if snp is well covered and high qual
                    #if data[1] not in vcf_count: #if position data doesnt exist
                    #    vcf_count[int(data[1])] = [0,0,0,0] #create list
                    vcf_count[int(data[1])][convert_base(data[4])] += float(freq[3]) #add count alt base
                    vcf_count[int(data[1])][convert_base(data[3])] -= float(freq[3]) #add count ref base

###store all provided reference sequences
ref_sequences={}
#user provide fasta of references
initialize_references(sys.argv[1])
###stores base counts in dictionary
vcf_count={} 
###stores coverage at every base in total population in dictionary
cov_count={}
for filename in os.listdir("./"):
    if filename.endswith(".coverage"):
        ###for every coverage file
        coveragefile = filename 
        ###imports cov file coverage column as numpy array (for speed)
        my_cov = genfromtxt(coveragefile, delimiter="\t", dtype=str)[:,3]
        summarize_coverage(my_cov)
        ###for matching vcf file
        sample = filename.split(".")[0]
        genotype = ">" + sample.split("_")[1]
        vcffile = glob.glob(filename.split(".")[0] + "*.vcf")
        summarize_vcf(vcffile,genotype)

#print out sliding windows of 24 bases and conservation score
for x in range(1,3216):
    print(x, end="\t")
    print(*vcf_count[x],sep="\t")
