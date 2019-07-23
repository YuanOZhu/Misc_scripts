use warnings;
use strict;
use Data::Dumper;
#this script extracts the first 18bp of the reference and attaches it to the end so the x gene sequence is complete

open(my$fi,$ARGV[0]) or die;
while(my$line=<$fi>){
    chomp $line;
    if($line =~ /^>/){print "$line\n";}
    else{
	my$string=substr($line,2769-1,length($line)-2769+1).substr($line,0,15);
	print "$string\n";
    }
}close($fi);
