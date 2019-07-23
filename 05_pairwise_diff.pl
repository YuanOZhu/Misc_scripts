use warnings;
use strict;
use Data::Dumper;
#counts base differences between any 2 sequences ignoring -

my@strains=();my%sequences=();my$strain="";
open(my$fj,$ARGV[0]) or die;
while(my$line=<$fj>){
    chomp $line;
    if($line =~ /^>/){$strain=$line;}
    else{$sequences{$strain}=$line;push(@strains,$strain);}
}close($fj);

for(my$s=0;$s<@strains;$s++){
    for(my$t=$s+1;$t<@strains;$t++){
	my@seq1=split('',$sequences{$strains[$s]});
	my@seq2=split('',$sequences{$strains[$t]});
	my$length=@seq1;
	my$diff=0;
	for(my$a=0;$a<@seq1;$a++){
	    my$pos=$a+1;
	    if(($seq1[$a] ne "-")&&($seq2[$a] ne "-")){
		if($seq1[$a] ne $seq2[$a]){
		    $diff++;
		}
	    }
	}
	my$pdiff=$diff/$length;
	print "$pdiff\n";
    }
}
