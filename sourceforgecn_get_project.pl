#!/usr/bin/perl
# Time-stamp: "2000-10-02 14:48:15 MDT"
#
# Parse the given HTML file(s) and dump the parse tree
# Usage:
#  htmltree -D3 -w file1 file2 file3
#    -D[number]  sets HTML::TreeBuilder::Debug to that figure.
#    -w  turns on $tree->warn(1) for the new tree

require 5;
use strict;
use LWP::UserAgent;

my $warn;

BEGIN { # We have to set debug level before we use HTML::TreeBuilder.
  $HTML::TreeBuilder::DEBUG = 0; # default debug level
  $warn = 0;
  while(@ARGV) {   # lameo switch parsing
    if($ARGV[0] =~ m<^-D(\d+)$>s) {
      $HTML::TreeBuilder::DEBUG = $1;
      print "Debug level $HTML::TreeBuilder::DEBUG\n";
      shift @ARGV;
    } elsif ($ARGV[0] =~ m<^-w$>s) {
      $warn = 1;
      shift @ARGV;
    } else {
      last;
    }
  }
}

use HTML::TreeBuilder;
my $browser=LWP::UserAgent->new();
my $file;
my $url;
#foreach my $file (grep( -f $_, @ARGV)) {
my $url_header="http://www.sourceforgecn.net/Projects";
my $url_tail="/".substr($ARGV[0],0,1)."/".substr($ARGV[0],0,2)."/".$ARGV[0];
print $url=$url_header.$url_tail,"\n";
#exit -1;
my $response = $browser->get($url);
my $content= $response->content;
open(FD,">INDEX");
print FD $content;
close FD;
  print
    "=" x 78, "\n",
    "Parsing $file...\n";

  my $h = HTML::TreeBuilder->new;
  $h->ignore_unknown(0);
  $h->warn($warn);
  #$h->parse_file($content);
  $h->parse($content);
foreach my $a ($h->find_by_tag_name('span'))
{
	#my $href=$a->attr('href');
	print $a->content_list,"\n";
	#use URI;
	#print URI->new_abs($href,"http://www.baidu.com"),"\n";
}
  #print "- "x 39, "\n";
  #$h->dump();
  $h = $h->delete(); # nuke it!
  print "\n\n";

exit;
__END__
