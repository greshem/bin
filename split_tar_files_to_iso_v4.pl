#! /usr/bin/perl -w

##
#20100125. 
#添加中途截断的功能。命令行的第一个参数就是 截断的字符， 第二个字符 dump  
###########################################
# 添加日志单元， 只用用print 的地方代替DEBUG 就可以实现日志记录的功能了
# log4perl unit Begin.
# qianzj add with  addLogUnitToPerl.pl
###########################################
#use strict;
use POSIX qw(strftime);
use Log::Log4perl qw(:easy);

#日志文件的产生的模式 有下面两种可以选择。 
#log4perl.appender.Logfile.mode = create
#log4perl.appender.Logfile.mode = append
#这个可以不加
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
#isofile 文件的大小。 
###########
my $segmentFile=$ARGV[0]; 
my $isofile_size= 1024*1024*(4000+200);
#当前累计文件的大小。 
my $current_size;
#其实的ISO_*  的数字默认是1 
my $number=0;
#当前DVD的里面的文件。 
my @isofile;
#全局获取到的TAR文件。 
my @global_list;

# Traverse desired filesystems
#获取所有的 tar 文件。 
File::Find::find({wanted => \&wanted, bydepth=>1}, '.');
my @tmpAll=sort @global_list;
#生成列表。 
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
#获取所有的tar 文件。 
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
#对所有的tar 文件进行 分割成 iso 的文件。 
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
