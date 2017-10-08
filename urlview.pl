#!/usr/bin/perl 
use HTML::LinkExtractor;
open(FILE, $ARGV[0])or die("open file error\n");

my $LX = new HTML::LinkExtractor();
#$/='';
$/=undef;
my $html=(<FILE>);
#print $html;
$LX->parse(\$html);
for my $link (@{$LX->links})
{
	print $link->{href},"\n";
}

