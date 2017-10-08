#! /usr/bin/perl -w

##
#20100125. 
#�����;�ضϵĹ��ܡ������еĵ�һ���������� �ضϵ��ַ��� �ڶ����ַ� dump  
###########################################
# �����־��Ԫ�� ֻ����print �ĵط�����DEBUG �Ϳ���ʵ����־��¼�Ĺ�����
# log4perl unit Begin.
# qianzj add with  addLogUnitToPerl.pl
###########################################
#use strict;
use POSIX qw(strftime);
use Log::Log4perl qw(:easy);

#��־�ļ��Ĳ�����ģʽ ���������ֿ���ѡ�� 
#log4perl.appender.Logfile.mode = create
#log4perl.appender.Logfile.mode = append
#������Բ���
#log4perl.appender.Logfile.recreate_pid_write = /tmp/test.pid
sub logInit($)
{
	(my $logfile)=@_;
	if(! $logfile)
	{
		$logfile="logdefault.log";
	}
	my $conf = qq{
	log4perl.category                  = DEBUG, Logfile
	log4perl.appender.Logfile          = Log::Log4perl::Appender::File
	log4perl.appender.Logfile.recreate = 1
	log4perl.appender.Logfile.recreate_check_signal = USR1
	log4perl.appender.Logfile.mode = create
	log4perl.appender.Logfile.filename = $logfile
	log4perl.appender.Logfile.layout = Log::Log4perl::Layout::PatternLayout
	log4perl.appender.Logfile.layout.ConversionPattern = %d %F{1} %L> %m%n
	};

	Log::Log4perl->init(\$conf);
}
$now= strftime("%Y%d%m", localtime(time()));
use File::Basename;
$name= basename($0);
logInit("/var/log/".$name."_".$now.".log");
###########################################
# log4perl unit END;
# qianzj add with  addLogUnitToPerl.pl
###########################################
#use strict;
use File::Find ();
use File::Copy;
use Cwd;
use List::MoreUtils qw(after);

use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;
sub wanted;

###########
#isofile �ļ��Ĵ�С�� 
###########
my $segmentFile=$ARGV[0]; 
my $isofile_size= 1024*1024*(4000+200);
#��ǰ�ۼ��ļ��Ĵ�С�� 
my $current_size;
#��ʵ��ISO_*  ������Ĭ����1 
my $number=0;
#��ǰDVD��������ļ��� 
my @isofile;
#ȫ�ֻ�ȡ����TAR�ļ��� 
my @global_list;

# Traverse desired filesystems
#��ȡ���е� tar �ļ��� 
File::Find::find({wanted => \&wanted, bydepth=>1}, '.');
my @tmpAll=sort @global_list;
#�����б� 
my @tmp;
if($segmentFile)
{
	@tmp=after{$_ =~ /$segmentFile/} @tmpAll;
}
else
{
	@tmp=@tmpAll;
}
	gen_iso_from(@tmp);
if(grep (/dump/, @ARGV)	)
{
	print map{$_.="\n"} (@tmp);
}
exit;

######################################################################################################################
######################################################################################################################
#��ȡ���е�tar �ļ��� 
sub wanted {
    #print $name,"\n";
    my ($dev,$ino,$mode,$nlink,$uid,$gid);
    my $orgine_file;
    my $tofile;
    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) ;
    #if( -T $_ &&  (-M $_ < 7 ) && ($name=~/root\/[^.]/)  && ($name !~/linux_src/) && ($name !~/perl\/cpan/))
    #if( -T $_ &&   (-M $_ < 7 ) ) 
     #if(-T $_)
    if(/chm$/ && -f )
    { 
	push(@global_list,$name);
	
	#print $tofile;
    }
}
######################################################################################################################
#�����е�tar �ļ����� �ָ�� iso ���ļ��� 
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

	
}
