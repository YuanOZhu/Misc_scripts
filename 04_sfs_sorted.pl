use warnings;
use strict;
use Data::Dumper;
###summarizes variable sites only ignoring missing -
##perl 03_sfs_sorted.pl inputRaxML.phy.reduced.nuh19.fasta > 03_sfs_sorted.nuh19.out

my@pileup=();
open(my$fi,$ARGV[0]) or die;
while(my$line=<$fi>){
    chomp $line;
    if($line =~ /^>/){} #names dont matter
    else{
	my@loca=split('',$line);
	for(my$a=0;$a<@loca;$a++){
	    if(defined $pileup[$a]{$loca[$a]}){
		$pileup[$a]{$loca[$a]}++;
	    }
	    else{
		$pileup[$a]{$loca[$a]}=1;
	    }
	}
    }
}close($fi);

for(my$c=0;$c<@pileup;$c++){
    my$pos=$c+1;
    print "$pos";
    foreach my $key (sort {$pileup[$c]{$b} <=> $pileup[$c]{$a}} keys %{$pileup[$c]}){
	print "\t$key:";
	printf "$pileup[$c]{$key}";
    }
    print "\n";
}
