use warnings;
use strict;
use Data::Dumper;

##Author: ZHU O. Yuan (Genome Institute of Singapore)
##Script name: 01_extract_gene.pl
##Usage: perl 01_extract_gene.pl consensus.multialigned.fasta startpos endpos gene-name > out.fasta
#This script extracts relevant portion of sequence from reference
#eg. perl 01_extract_gene.pl aligned.fasta 487 3018 P > aligned.P-gene.fasta 

open(my$fi,$ARGV[0]) or die;
while(my$line=<$fi>){
    chomp $line;
    if($line =~ /^>/){print $line."_".$ARGV[3]."\n";}
    else{
	my$length=$ARGV[2]-$ARGV[1]+1;
	my$string=substr($line,$ARGV[1]-1,$length);
	print "$string\n";
    }
}close($fi);
