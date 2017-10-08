#!/usr/bin/perl
#readme ���ʹ�õ�ʱ�� ע��  ʹ�� logInit($0.".log");
#create ��ʽ ��� append ��ʽ�� 
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
#��ȡ����
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
##������汾�š� 
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
#��������.pl
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
