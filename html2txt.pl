#!/usr/bin/perl
use HTML::FormatText;
use HTML::Parse;
$input_path=shift or die("Usage: $0 input_file|input_dir\n");

if(-d $input_path)
{
	@array=grep { -f } glob($input_path."/*.html");
	my @tmp=grep { -f } glob($input_path."/*.htm");
	push(@array, @tmp);
	for(@array)
	{
		if($_=~/[html|htm]$/)
		{
			print "处理 $_\n";
			html_2_txt_one_file($_);
		}
		else
		{
			print "不处理 $_\n";
		}
	}
}
else
{
	html_2_txt_one_file($input_path)
}

sub html_2_txt_one_file($)
{
	(my $input)=@_;
	my $html=parse_htmlfile($input);
	(my $txt)=($input=~/(.*)\.[html|htm]/);
	$formatter=HTML::FormatText->new(leftmargin=>0, rightmargin=>200);
	$ascii=$formatter->format($html);
	open(FILE, ">".$txt.".txt") or die("create file $txt .txt 失败\n");
	print FILE $ascii;
	close(FILE);
}
