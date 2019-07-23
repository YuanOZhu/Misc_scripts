use warnings;
use strict;
use Data::Dumper;
#perl reformat_reference.pl GenoBGenoCsubtypes_geno8.fa > reformat_reference.out

#my%list=("|ref_HBVB_non-ambiguous|"=>1,"AY033073NetherlandsB4"=>1,"AY033072NetherlandsB4"=>1);
my$strain="";
open(my$fi,$ARGV[0]) or die;
while(my$line=<$fi>){
    chomp $line;
    if($line =~ /^>/){$strain=$line;}
    else{
#	if(!defined $list{$strain}){
	    my$new=substr($line,1395,length($line)-1396).substr($line,0,1396);
	    print "$strain\n$new\n";
#	}
#	else{print "$strain\n$line\n";}
    }
}close($fi);
