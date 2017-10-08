#!/usr/bin/perl
#readme 最后使用的时候， 注意  使用 logInit($0.".log");
#create 方式 变成 append 方式。 
use Term::ANSIColor ; 
$file=shift or die("Usage: $0 file.pl\n");



$line=`file $file`;
if($line !~ /perl/)
{
	print color("bold red");
	warn("$file not perl file \n");
	print color("reset");
	exit(-1);
}

if($file=~/log_/)
{
	die("have add Log4perl unit\n");

}
###
#提取名字
if($file=~/pl$/)
{
	($name)=($file=~/(.*)\.pl/);
}
else
{
	$name=$file;
}

##
$name.="_log";
##处理掉版本号。 
if($name=~/(.*)_v(\d+)$/i)
{
	$ver=$2;
	$ver++;
	$nameVer=$2."_v".$1;
}
else
{
	$nameVer=$name;
	$nameVer.="_v1";
}
#######
#最后添加上.pl
$nameVer.=".pl";
############################
$Done=0;;
open(FILE, $file) or die("open file error\n");

open(OUTPUT, ">".$nameVer) or die("create output file error\n");

for(<FILE>)
{
	select OUTPUT;
	print $_;
	if(!/^#/ && $Done==0 )
	{
		PrintLog();
		$Done=1;
	}
	
}

PrintLog_Lable:
	PrintLog();


sub PrintLog()
{
	while(<DATA>)
	{
	print $_;
	}
}
	


__DATA__
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
	log4perl.appender.Logfile.mode = append
	log4perl.appender.Logfile.filename = $logfile
	log4perl.appender.Logfile.layout = Log::Log4perl::Layout::PatternLayout
	log4perl.appender.Logfile.layout.ConversionPattern = %d %F{1} %L> %m%n
	};

	Log::Log4perl->init(\$conf);
}
$now= strftime("%Y%d%m", localtime(time()));
logInit("/var/log/".$0."_".$now.".log");
###########################################
# log4perl unit END;
# qianzj add with  addLogUnitToPerl.pl
###########################################
