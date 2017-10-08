#!/usr/bin/perl 
#===============================================================================
#         FILE:  get_today_tar_gz.pl
#        USAGE:  ./get_today_tar_gz.pl  
#  DESCRIPTION:  
#       AUTHOR:  YOUR NAME (), 
#      CREATED:  2011年06月27日 22时36分29秒
#===============================================================================

use strict;
use warnings;

my $each;
sub get_all_targz()
{
	my @targz;
	@targz= grep {-f } glob("*.tar.gz");
	return @targz;
}
sub get_today_svn()
{
	my @today_targz;
	for  $each (glob("*.tar.gz"))
	{
		if( -M $each <= 1)
		{
			#print "cp -a -r ". $each." /root/ \n";	
			push(@today_targz, $each);
		}
	}
	return @today_targz;
}

sub mkdir_svn_working_path()
{
	my $path= "e:\\svn_working_path";
	if(! -d $path )
	{
		mkdir ($path);
	}	
}
sub extract_targz_to_dir($$) 
{
	(my $targz, my $dest_dir)=@_;
	(my $suffix_dir)=($targz=~/(.*).tar.gz/);
	if( ! -f $targz)
	{
		print ("$targz 文件不存在\n");
	}
	my $final_dir=$dest_dir."\\\\".$suffix_dir;
	if(! -d  $final_dir)
	{
		$final_dir=$dest_dir;
	}
	print ("#解压命令是 \"c:\\Program Files\\winrar\\winrar.exe\" x $targz $final_dir");
	system(" \"c:\\Program Files\\winrar\\winrar.exe\" x $targz $final_dir");

}


#extract_bin_targz();
mkdir_svn_working_path();
extract_targz_to_dir("bin.tar.gz", "c:\\");
my @today_targz;

my $mode=shift; #默认只解压今天的.
if(defined($mode))
{
	@today_targz=get_all_targz();
}
else
{
	@today_targz=get_today_svn();
}

for(@today_targz)
{
	extract_targz_to_dir($_,  "e:\\svn_working_path\\");
}
