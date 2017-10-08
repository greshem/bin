#!/usr/bin/env perl

use strict;
use warnings;
#use FindBin qw/$Bin/;
#use lib "$Bin/../lib";
use Net::GitHub::V3;
use Data::Dumper;
my $keyword=shift or die("Usage: perl $0  keywords \n");

my $gh = Net::GitHub::V3->new();
my $search = $gh->search;

my %data = $search->repositories({
    q => $keyword,
    per_page => 100,
});
map { print $_->{url} . "\n" } @{$data{items}};

while ($search->has_next_page) {
    sleep 13; # 5 queries max per minute
    %data = $search->next_page;
    map { print $_->{url} . "\n" } @{$data{items}};
    for( @{$data{items}} )
    {
        logger( $_->{url}."\n");
    }
}

sub logger($)
{

    my $log_time = POSIX::strftime('%Y-%m-%d %T',localtime(time()));

	(my $log_str)=@_;
	open(FILE, ">> /tmp/datasets.log") or warn("open all.log error\n");
	print FILE 	$log_time.":".$log_str;
	print STDOUT $log_time.":".$log_str;
	close(FILE);
}

1;
print "#please run: python github_conflict_clone.py ";
