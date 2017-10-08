#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Getopt::Std;
use Image::Size;
use File::Basename;
if (scalar(@ARGV) != 1)
{
	die("Usage: lwp_2_firefox.pl url\n");
}
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;

my @ns_headers = (
   'User-Agent' => 'Mozilla/4.05 [en] (X11; U;Linux 2.6.20 32 i686', 
   'Accept' => 'image/gif, image/x-xbitmap, image/jpeg, 
        image/pjpeg, image/png, */*',
   'Accept-Charset' => 'iso-8859-1,*,utf-8',
   'Accept-Language' => 'en-US',
  );
	
my $response = $ua->get($ARGV[0], @ns_headers);

unless ($response->is_success) {
		print "(failed!!! ".$response->code.")\n";}
	
my $htm =  $response->content;

open(JPG,">".basename($ARGV[0]));
print JPG  $response->content;
print "file save as ", basename($ARGV[0]),"\n";
