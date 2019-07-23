use warnings;
use strict;
use Data::Dumper;
#perl 04_codons_sfs.pl 04_AHB280.fa > 04_codons_sfs.out

my%trans=("Ala"=>"A","Arg"=>"R","Asn"=>"N","Asp"=>"D","Cys"=>"C","Gln"=>"Q","Glu"=>"E","Gly"=>"G","His"=>"H","Ile"=>"I","Leu"=>"L","Lys"=>"K","Met"=>"M","Phe"=>"F","Pro"=>"P","Ser"=>"S","Stop"=>"*","Thr"=>"T","Trp"=>"W","Tyr"=>"Y","Val"=>"V");
my%AAcode=("TTT"=>"Phe","TTC"=>"Phe","TTA"=>"Leu","TTG"=>"Leu","CTT"=>"Leu","CTC"=>"Leu","CTA"=>"Leu","CTG"=>"Leu","ATT"=>"Ile","ATC"=>"Ile","ATA"=>"Ile","ATG"=>"Met","GTT"=>"Val","GTC"=>"Val","GTA"=>"Val","GTG"=>"Val","TCT"=>"Ser","TCC"=>"Ser","TCA"=>"Ser","TCG"=>"Ser","CCT"=>"Pro","CCC"=>"Pro","CCA"=>"Pro","CCG"=>"Pro","ACT"=>"Thr","ACC"=>"Thr","ACA"=>"Thr","ACG"=>"Thr","GCT"=>"Ala","GCC"=>"Ala","GCA"=>"Ala","GCG"=>"Ala","TAT"=>"Tyr","TAC"=>"Tyr","TAA"=>"Stop","TAG"=>"Stop","CAT"=>"His","CAC"=>"His","CAA"=>"Gln","CAG"=>"Gln","AAT"=>"Asn","AAC"=>"Asn","AAA"=>"Lys","AAG"=>"Lys","GAT"=>"Asp","GAC"=>"Asp","GAA"=>"Glu","GAG"=>"Glu","TGT"=>"Cys","TGC"=>"Cys","TGA"=>"Stop","TGG"=>"Trp","CGT"=>"Arg","CGC"=>"Arg","CGA"=>"Arg","CGG"=>"Arg","AGT"=>"Ser","AGC"=>"Ser","AGA"=>"Arg","AGG"=>"Arg","GGT"=>"Gly","GGC"=>"Gly","GGA"=>"Gly","GGG"=>"Gly");

#my@ORFstart=(26,5134,5162);my@ORFend=(5137,7155,5503);
#my@orfname=("ORF1","ORF2","ORF3");my@strain=();

#sub DNAtoAA {
#    my($ele)=@_;
#    my@DNA=split('',$ele);
#    my$AA="";
#    for(my$a=0;$a<@DNA;$a+=3){
#	my$codon=$DNA[$a].$DNA[$a+1].$DNA[$a+2];
#	$AA=$AA.$trans{$AAcode{$codon}};
#    }
#    return $AA;
#}

open(my$fi,$ARGV[0]) or die;
while(my$line=<$fi>){
    chomp $line;
    if($line =~ /^>/){}#{@strain=split('\.',$line);}
    else{
	for(my$b=0;$b<@ORFstart;$b++){
	    my$orf=substr($line,($ORFstart[$b]-1),($ORFend[$b]-$ORFstart[$b]+1));
	    #my@orfAA=split('',DNAtoAA($orf));
	    my@DNA=split('',$orf);
	    for(my$a=0;$a<@DNA;$a+=3){
		my$pos=$a+$ORFstart[$b];my$pos2=$pos+1;my$pos3=$pos2+1;
		my$codon=$DNA[$a].$DNA[$a+1].$DNA[$a+2];
		my$AA=$trans{$AAcode{$codon}};
		print "$orfname[$b]\t$pos\t$DNA[$a]\t$codon\t1\t$AA\n";
		print "$orfname[$b]\t$pos2\t$DNA[$a+1]\t$codon\t2\t$AA\n";
		print "$orfname[$b]\t$pos3\t$DNA[$a+2]\t$codon\t3\t$AA\n";
#	    print "$strain[0]"."_".$orfname[$b]."\n$orfAA\n";
	    }
	}
    }
}close($fi);
