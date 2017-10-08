#!/usr/bin/perl
use File::Copy::Recursive qw(pathmk dirmove pathrm pathempty );
use File::Basename;
$dir=shift or die("Usage: $0\n");
if( -d $dir)
{
	rmrf($dir);
}
else
{
	die " $dir not directory\n";
}
sub rmrf($)
{
	($in)=@_;
	pathempty($in);
	pathrm($in);
}
