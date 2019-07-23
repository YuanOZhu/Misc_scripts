use warnings;
use strict;
use Data::Dumper;

##Author: ZHU O. Yuan (Genome Institute of Singapore)
##Script name: Fasta_to_geneAA.pl
##Usage: perl Fasta_to_geneAA.pl aligned.gene.fa > aligned.gene.aa
#This script converts ORF DNA sequence to protein sequence
#Input must be in frame and exactly encompass ORF region

#Intiate dictionaries to translate DNA to amino acid
my%trans=("Ala"=>"A","Arg"=>"R","Asn"=>"N","Asp"=>"D","Cys"=>"C","Gln"=>"Q","Glu"=>"E","Gly"=>"G","His"=>"H","Ile"=>"I","Leu"=>"L","Lys"=>"K","Met"=>"M","Phe"=>"F","Pro"=>"P","Ser"=>"S","Stop"=>"*","Thr"=>"T","Trp"=>"W","Tyr"=>"Y","Val"=>"V");
my%AAcode=("TTT"=>"Phe","TTC"=>"Phe","TTA"=>"Leu","TTG"=>"Leu","CTT"=>"Leu","CTC"=>"Leu","CTA"=>"Leu","CTG"=>"Leu","ATT"=>"Ile","ATC"=>"Ile","ATA"=>"Ile","ATG"=>"Met","GTT"=>"Val","GTC"=>"Val","GTA"=>"Val","GTG"=>"Val","TCT"=>"Ser","TCC"=>"Ser","TCA"=>"Ser","TCG"=>"Ser","CCT"=>"Pro","CCC"=>"Pro","CCA"=>"Pro","CCG"=>"Pro","ACT"=>"Thr","ACC"=>"Thr","ACA"=>"Thr","ACG"=>"Thr","GCT"=>"Ala","GCC"=>"Ala","GCA"=>"Ala","GCG"=>"Ala","TAT"=>"Tyr","TAC"=>"Tyr","TAA"=>"Stop","TAG"=>"Stop","CAT"=>"His","CAC"=>"His","CAA"=>"Gln","CAG"=>"Gln","AAT"=>"Asn","AAC"=>"Asn","AAA"=>"Lys","AAG"=>"Lys","GAT"=>"Asp","GAC"=>"Asp","GAA"=>"Glu","GAG"=>"Glu","TGT"=>"Cys","TGC"=>"Cys","TGA"=>"Stop","TGG"=>"Trp","CGT"=>"Arg","CGC"=>"Arg","CGA"=>"Arg","CGG"=>"Arg","AGT"=>"Ser","AGC"=>"Ser","AGA"=>"Arg","AGG"=>"Arg","GGT"=>"Gly","GGC"=>"Gly","GGA"=>"Gly","GGG"=>"Gly");

#Initiate global variables
my$ORFstart=1;
my$strain="";

#subroutine to translate DNA to amino acid
#returns "-" if codon sequence not found usually due to N
sub DNAtoAA {
    my($ele)=@_;
    my@DNA=split('',$ele);
    my$AA="";
    for(my$a=0;$a<@DNA;$a+=3){
	my$codon=$DNA[$a].$DNA[$a+1].$DNA[$a+2];
	if(defined $AAcode{$codon}){
	    $AA=$AA.$trans{$AAcode{$codon}};
	}
	else{$AA=$AA."-";}
    }
    return $AA;
}

#main routine to submit each DNA sequence for translation
#and print final amino acid sequence
open(my$fi,$ARGV[0]) or die;
while(my$line=<$fi>){
    chomp $line;
    if($line =~ /^>/){$strain=$line;}
    else{
	my$ORFend=length($line);
	my$orfAA=DNAtoAA($line);
	print "$strain\n$orfAA\n"; 
    }
}close($fi);
