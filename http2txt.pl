#!/usr/bin/perl
use LWP;
use Data::Dumper;
use HTML::FormatText;
use HTML::Parse;
use HTML::TreeBuilder;
	#$tree = HTML::TreeBuilder->new->parse_file("test.html");


print $ascii;
die "Usage: $0 url ...\n" unless @ARGV;

for $url (@ARGV)
{
	$ua=LWP::UserAgent->new();
	$res=$ua->request(HTTP::Request->new(GET=>$url));
	if ($res->is_success)
	{
		#print $res->title,"\n";
		#print $res->content,"\n";
		#print $res->header();
		#$html=parse_htmlfile($ARGV[0]);
		$html=HTML::TreeBuilder->new->parse($res->content);
		$formatter=HTML::FormatText->new(leftmargin=>0, rightmargin=>50);
		$ascii=$formatter->format($html);
		print $ascii;
		#print Dumper $res;
	}
	else
	{
		print $res->status_line, "\n";
	}
}
