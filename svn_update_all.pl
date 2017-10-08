#!/usr/bin/perl
#2011_02_21_18:46:02 add by greshem 现在只添加本地的 CO 的命令 之后 再添加通过网络CO 的命令 的建设. 

use File::Basename;
#print basename("/root/linux/bbb"); #结果是. bbb

$username=shift;

logger("#################################################\n");
sub get_ip()
{
	open(PIPE, "ifconfig |") or die("open ifconfig cmd failuer\n");
	for(<PIPE>)
	{
		if($_=~/192.168.0.234/)
		{
			return "192.168.0.234";
		}
		if($_=~/192.168.1.73/)
		{
			return "192.168.1.73";
		}

	}
}
$ip=get_ip();
#$ip="192.168.0.234";
#$ip="192.168.1.73";

sub update_in_win()
{
	print "cd c:\\bin\n";
	print "svn update\n";
	chdir("c:\\bin");
	system("svn update");
	for $each (grep { -d } glob("E:\\svn_working_path\\*"))
	{
		$each=~s/\\/\\\\/g;
		print "cd $each\n";
		print "svn update\n";
		chdir($each);
		system("svn update");	
	}
}
if($^O=~/win32/i)
{
	update_in_win();
	die("win udpate success\n");
}

for (glob("/home/svn/*") )
{
	if( -d $_)
	{
		print "#".$_,"\n";
		$url=$_;
		$url=~s/\/home//g;
		#print "svn co http://192.168.0.234/".$url."\t". basename($_)." \n";
		$name=basename($_);
		print "echo cd \~/$name/\n";	
		if(check_today_svn_commit("~/$name"))
		{
			logger("$name 今天有更新过\n");
			print "touch  \~/$name/\n";	
		}

		print "cd \~/$name/\n";	
		print "echo svn update\n";
		print "svn update\n";
		#chdir("~/$name/");
		#system("svn update");
	}
}

@path=qw(~/90_develop_wxwidgets/  ~/netware_emulator/   ~/rich_netclone2/  ~/rich_addvalue2/ ~/rich_addvalue3/);
for (@path)
{
		print "echo cd $_/\n";	
		if(check_today_svn_commit($_))
		{	
			print "touch  $_/\n";	
		}
		print "cd $_/\n";	
		print "echo svn update\n";
		print "svn update\n";
}

sub check_today_svn_commit($)
{
	use POSIX qw(strftime);
	#svn log  -l 10
	(my $dir)=@_;
	$dir=~s/^~/\/root/g;
	logger("$dir 开始处理 svn log \n");
	if(! -d $dir)
	{
		logger("PANIC: $dir 目录不存在\n");
		return ;
	}
	chdir($dir);
	system("svn update\n");	
	my $yyyymmdd= POSIX::strftime('%Y-%m-%d',localtime(time()));
	open(PIPE, "svn log -l 10 |" ) or die("open svn log pipe error\n");
	for(<PIPE>)
	{
		if($_=~/$yyyymmdd/)
		{
			
			logger("用utime touch $dir\n");
			utime(time(), time(), $dir);
			return 1;
		}
	}
	return undef;
}

#日志跨平台在两个操作系统上
sub logger($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, ">>  d:\\log\\svn_update_all.log");
	}
	else
	{
		open(FILE, ">>  /var/log/svn_update_all.log");
	}

		print FILE $log_str;
		close(FILE);
}

