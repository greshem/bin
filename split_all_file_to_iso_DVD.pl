#! /usr/bin/perl -w
    eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell

use strict;
use File::Find ();
use File::Copy;
use Cwd;
# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;
sub wanted;


#		    K	M	
my $isofile_size= 1024*1024*(4000+460);
my $current_size;
my $number=1;
my @isofile;
my @global_list;
#my $AGE_OF_etc_passwd = -M '/etc/passwd';
 my $day=7;

my $pwd=getcwd."/";
my $pwd2;

File::Find::find({wanted => \&wanted, bydepth=>1}, '.');
my @tmp=sort @global_list;
gen_iso_from(@tmp);
#	print (@global_list);
exit;


sub wanted 
{
    #print $name,"\n";
    my ($dev,$ino,$mode,$nlink,$uid,$gid);
    my $orgine_file;
    my $tofile;
    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) ;
    #if( -T $_ &&  (-M $_ < 7 ) && ($name=~/root\/[^.]/)  && ($name !~/linux_src/) && ($name !~/perl\/cpan/))
    #if( -T $_ &&   (-M $_ < 7 ) ) 
     #if(-T $_)
    if(-f $_)
    { 
	push(@global_list,$name);	
	#print $tofile;
    }
}


#***************************************************************************
# Description	从文件列表里面 切割文件列表,分割成给dvd 用的 dvd 列表.
# @param 		文件列表 array 	
# @return 	
#***************************************************************************/
sub gen_iso_from()
{
	my (@list)=@_;
	
	for(@list)
	{
		$current_size+=-s $_;
		push(@isofile, $_);
		if($current_size > $isofile_size)
		{
			print "ISO_",$number,"\n";
			
			print "filesize =".int($current_size/1024/1024)."M","  filenumber ".scalar(@isofile),"\n";
			open(FILE_OUTPUT,">".$pwd."ISO_".$number) or die "open file error\n";
			#map{print FILE_OUTPUT $_,"\n"} @isofile;
			for(sort @isofile)
			{	
				print FILE_OUTPUT $_,"\n";
			}
			close(FILE_OUTPUT);
			$number++;
			@isofile="";
			$current_size=0;
		}
	}
	print "ISO_",$number,"\n";
	
	print "filesize =".int($current_size/1024/1024)."M","  filenumber ".scalar(@isofile),"\n";
	open(FILE_OUTPUT,">".$pwd."ISO_".$number) or die "open file error\n";
	#map{print FILE_OUTPUT $_,"\n"} @isofile;
	for(sort @isofile)
	{	
		print FILE_OUTPUT $_,"\n";
	}
	close(FILE_OUTPUT);
	print "# mvToISO_v2.pl  把文件 mv 到对应的目录\n";
}
