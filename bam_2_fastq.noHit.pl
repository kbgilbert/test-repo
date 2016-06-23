#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;

my @script_info = "
##########################################################################################
#	Script opens .bam file (ie unmapped.bam from TOPHAT) and re-formats the reads that don't
#	map to fastq format
#	Output format: 
#	\@HW-ST997:516:C3J5WACXX:2:2308:17553:54616
#	TTTTACTAAAAATATAGTTCAGGGCTTTAGGCACCATCAATT
#	+
#	#1=DDFFFHHHHHJJJJIJJJJJJJJJJIIIJJIIJJJJGEHJJJHIHII
##########################################################################################
    \nYou did not provide enough information...  Usage: perl script_name.pl [OPTIONS]
    -b\t.bam file
    -o\toutput file\n\n";

my (%opt, $bam, $outfile);
getopts('b:o:', \%opt);
&var_check();

open (BAM, $bam) || die "Cannot open $bam: $!\n\n";
open (OUT, ">$outfile") || die "Cannot open outfile: $outfile: $!\n\n";

open BAM, "samtools view -f 4 $bam |";
while (my $line = <BAM>) {
	chomp $line;
	
	my @split = split(/\t/, $line);
	my $hit = $split[1];
	next if ($hit != 4);
	my $name = $split[0];
	my $seq = $split[9];
	my $qual = $split[10];
	
	print OUT "@" . "$name\n";
	print OUT "$seq\n";
	print OUT "+\n";
	print OUT "$qual\n";
}
close BAM;
close OUT;
exit;

sub var_check {
	if ($opt{'b'}) {
		$bam = $opt{'b'};
	} else {
		&var_error();
	}
	if ($opt{'o'}) {
		$outfile = $opt{'o'};
	} else {
		&var_error();
	}
}

sub var_error {
	print "@script_info";
	exit 0;
}
