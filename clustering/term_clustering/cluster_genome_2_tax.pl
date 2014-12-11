#!/usr/bin/perl

use Bio::Taxon;

$acc_tax_map = shift @ARGV;
$level = shift @ARGV;
$clus = shift @ARGV;

$dbh = Bio::DB::Taxonomy->new(-source => 'flatfile',	
				 -directory => '/lustre/scratch110/sanger/lb14/term_tabs/taxdump/idx',
				 -nodesfile => '/lustre/scratch110/sanger/lb14/term_tabs/taxdump/nodes.dmp',
				 -namesfile => '/lustre/scratch110/sanger/lb14/term_tabs/taxdump/names.dmp');

open ACC2TAX, $acc_tax_map;
while (<ACC2TAX>){
	chomp;
	@line = split "\t";
	$acc2tax{$line[0]} = $line[1];
	$tax2acc{$line[1]} = $line[0];
}
close ACC2TAX;

@temp = keys(%tax2acc);
$id_array{'base'} = \@temp;

@hierarchy = ('base','species','genus','family','order','class','phylum');

foreach $id (@{$id_array{'base'}}){
	$node = $dbh->get_taxon(-taxonid => $id);
	while($node->rank ne $level){
		if(!defined($node->ancestor)){
			print STDERR "no order for $id!\n";
			$undef = 1;
			last;
		}
		$node = $node->ancestor;
		$undef = 0;
	}
	$order{$id} = $node->id if(!$undef);
	$count{$node->id}++ if (!$undef);
}

open CD, $clus;

while (<CD>){
	chomp;
	@cl = split "\t";
	print $order{$acc2tax{shift(@cl)}};
	foreach $entry (@cl){
		print "\t", $order{$acc2tax{shift(@cl)}};
	}
	print "\n";
}
