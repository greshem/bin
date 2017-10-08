#!/usr/bin/perl
use POSIX qw(strftime);
$time=strftime("%Y_%m_%d_%T", localtime(time()));
$file=shift or die("usage $ARGV[0] file");
open(FILE, $file) or die("open file error\n"); 
@lines=(<FILE>);
close(FILE);
open(OUTPUT, ">".$file) or die("rewrite file fail");
if($file=~/\.c$|\.cpp$/)
{
	print OUTPUT "//".$time."modify by qzj\n"; 
}
elsif($file=~/\.sh$|\.pl$/)
{
	print OUTPUT "\#".$time."modify by qzj\n"; 
}
print OUTPUT @lines;
