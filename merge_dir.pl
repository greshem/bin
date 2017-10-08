#!/usr/bin/perl
#

use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);


my $input_dir=shift  or die("Usage; $0  input_dir  dest_dir \n");
my $dest_dir=shift or die ("Usage; $0  input_dir  dest_dir \n");

for (grep { -f $_} ( glob("$input_dir/*")))
{
	$filename=basename($_);
	if( -f $dest_dir."/".$filename )
	{
		print "cat  $_ >>  $dest_dir/$filename \n";
	}
	else
	{
		print "cp $_ $dest_dir \n";
	}
}
