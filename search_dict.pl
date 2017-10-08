#!/usr/bin/perl
use strict;
use Encode qw(from_to);
use DB_File;
my %word_meaning;
my $dict="/root/mydict_21shiji/21shiji.dict";
my $txt_file="21shijishuangxiangcidian.txt";
my @tmp;
my $tmp_str;
my $in_word;

$in_word=$ARGV[0];
from_to($in_word, "gb2312", "utf8");
if ( ! -f $dict)
{
	die(" $dict  have exist, will not create \n");
}
else
{
	tie  %word_meaning , "DB_File", $dict, O_RDWR, 0666, $DB_HASH or die "cannot open file \n";
	if($word_meaning{$in_word})
	{
		$tmp_str=$word_meaning{$in_word};
		from_to($tmp_str, "utf8", "gb2312");
		$tmp_str=~s/\\n/\n/g;
		$tmp_str=~s/>/>\n/g;
		print $ARGV[0], "-->", $tmp_str,"\n";
	}
	else
	{
		print "have no such word\n"
	}
	untie %word_meaning;
}

