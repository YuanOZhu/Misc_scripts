use warnings;
use strict;
#perl ref.fasta .coverage .vcf

my$ref="";
open (REF, "$ARGV[0]") or die;
while (my $line = <REF>) {
    chomp $line;
    if($line =~ /^>/){}
    else{$ref=$ref.$line;}
}close(REF);
#print "$ref\n";

my@lala=split('',$ref);
#open(NOUT, '>>', $ARGV[2]);
open (SAM, "$ARGV[1]") or die; #
while (my $line = <SAM>) {
    chomp $line;
    if($line =~ /^\|ref_HBV/){
	my@data=split('\t',$line);
	my@pos=split(':',$data[0]);
	if($data[1] < 10){
	    $lala[$pos[1]-1]="N";
	}#print"$pos[1]\t";}
    }
}close (SAM);

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

my@header=split('\.',$ARGV[1]);
my@id=split('\/',$header[0]);
print ">$id[1]\n";
for(my$a=0;$a<@lala;$a++){
    print $lala[$a];
}
print "\n";
