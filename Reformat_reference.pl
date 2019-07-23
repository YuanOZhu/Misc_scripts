use warnings;
use strict;
use Data::Dumper;

##Author: ZHU O. Yuan (Genome Institute of Singapore)
##Script name: Reformat_reference.pl
##Usage: perl reformat_reference.pl GenoBGenoCsubtypes_geno8.fa > reformat_reference.out
#hardcoded script to reformat reference sequences from NCBI as needed 

my$strain="";
open(my$fi,$ARGV[0]) or die;
while(my$line=<$fi>){
    chomp $line;
    if($line =~ /^>/){$strain=$line;}
    else{
	    my$new=substr($line,1395,length($line)-1396).substr($line,0,1396);
	    print "$strain\n$new\n";
    }
}close($fi);
