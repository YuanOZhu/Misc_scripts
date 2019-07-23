use warnings;
use strict;
use Data::Dumper;
#this script extracts relevant portion of sequence from reference
#perl script.pl infile startpos endpos genename > outfile
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
