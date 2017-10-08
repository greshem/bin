#!/usr/bin/perl
use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);

for (glob("*.cpio"))
{
	$dir=$_;
	$dir=~s/\.cpio$//g;
	print "mkdir $g_pwd/$dir \n";
	print "cd    $g_pwd/$dir \n";
	print "cpio -ivmd << ../$_ \n";
}
