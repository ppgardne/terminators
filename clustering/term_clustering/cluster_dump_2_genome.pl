#!/usr/bin/perl

$cluster_map = shift @ARGV;
$cluster_dump = shift @ARGV;

open CM, $cluster_map;

$count = 1;
while(<CM>){
	chomp;
	$_ =~ /(\w+)\..*/;
	$map{$count} = $1;
#	print $map{$count};
	$count++;
}

close CM;

open CD, $cluster_dump;

while(<CD>){
#	print;
	chomp;
	@cl = split "\t";
	print "$map{shift(@cl)}";
	foreach $entry (@cl){
		print "\t", $map{$entry};
	}
	print "\n";
}
