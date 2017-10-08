#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Getopt::Std;
use Image::Size;
#my $length;
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
	
#$a= $ua->head("http://www.baidu.com/s?wd=$ARGV[0]");
my ($a,  $len, $b, $c, $d)= $ua->head($ARGV[0]) or die "error $!\n";

	print print $ARGV[0], "   #Length:", int($a->{_headers}->{'content-length'}/1024),"K\n";
	print  "last modify", $a->{_headers}->{'last-modified'},"\n";
	#print "Length:", $a->{_headers}->{'Content-Length'},"\n";
	#print "Length:", $a->header('Content-Length'),"\n";
	


#if ($ua->is_success) {
#		print "(failed!!! ".$response->code.")\n";
#}
	
#my $htm =  $response->content;
#my $newurl = $response->base;
#open(FILE,">output.html");
#print FILE $a->content();
#close FILE;

