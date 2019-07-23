use warnings;
use strict;

##Author: ZHU O. Yuan (Genome Institute of Singapore)
##Script name: 00_sample_vcf_to_consensus.pl
##Usage: perl 00_sample_vcf_to_consensus.pl ref.fa sample.coverage sample.vcf

##This script takes in reference sequence, blanks out bases with low coverage, and updates bases where VCF indicates a freq>0.5 SNP

#Obtains reference sequence from ref.fasta
my$ref=""; 
open (REF, "$ARGV[0]") or die;
while (my $line = <REF>) {
    chomp $line;
    if($line =~ /^>/){}
    else{$ref=$ref.$line;}
}close(REF);
#print "$ref\n";

#Masks low coverage bases <10x as 'N'
my@lala=split('',$ref);
open (SAM, "$ARGV[1]") or die; #
while (my $line = <SAM>) {
    chomp $line;
    if($line =~ /^\|ref_HBV/){
	my@data=split('\t',$line);
	my@pos=split(':',$data[0]);
	if($data[1] < 10){
	    $lala[$pos[1]-1]="N";
	}
    }
}close (SAM);

#Updates base calls where SNP identified has frequency >0.5
open (VCF, "$ARGV[2]") or die;
while (my $line = <VCF>) {
    chomp $line;
    if ($line =~ /^#/) {}
    else{
	my@data=split('\t',$line);
	my@allele=split(';',$data[7]);
	my@freq=split('=',$allele[1]);
	if($freq[1] > 0.5){
	    if($lala[$data[1]-1] eq $data[3]){
		$lala[$data[1]-1] = $data[4];
	    }
	    else{print "ERROR\n";}
	}
    }
}close (VCF);

#prints out consensus sequence header and sequence
my@header=split('\.',$ARGV[1]);
my@id=split('\/',$header[0]);
print ">$id[1]\n";
for(my$a=0;$a<@lala;$a++){
    print $lala[$a];
}
print "\n";
