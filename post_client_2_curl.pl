#!/usr/bin/perl
use File::Basename;
$file=shift or die("Usage: $0 filelist\n");
open(FILE, $file) or die("open file error\n");
$post_str;
$website;
$toFile;
for(<FILE>)
{
	chomp;
	if($_=~/^http/)
	{
		$website=$_;	
		$toFile=basename($website);
		$toFile=~s/php$|asp$|cgi$/html/g;
	}
	
	elsif($_=~/=/)
	{
		$post_str.=$_;
		$post_str.="&";
	}
	elsif($_!~/^\s*$/)
	{
		$post_str.=$_;
		$post_str.="=";
		$post_str.="&";
	}
}
close(FILE);

print "curl -d \"";
print $post_str;
print "\"   $website -o $toFile\n";
