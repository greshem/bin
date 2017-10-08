#!/usr/bin/perl
use Cwd;
use POSIX 'strftime';

sub getTodayStr()
{
	my $today=POSIX::strftime('%Y_%m_%d',localtime(time()));
	return $today;
}

sub getPrevDayStr()
{
	my $next_day=POSIX::strftime('%Y_%m_%d',localtime(time()-3600*24) );
	return $next_day;
}
sub getNextDayStr()
{
	my $next_day=POSIX::strftime('%Y_%m_%d',localtime(time()+3600*24) );
	return $next_day;
}

sub getNextMondayStr()
{
	my $next_day=POSIX::strftime('%Y_%m_%d',localtime(time()+3600*24*3) );
	return $next_day;
}
sub getNowTime()
{
	my $cur_time;
	if($^O=~/win/i)
	{
		$cur_time=POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));

	}
	else
	{
    	$cur_time=POSIX::strftime('%Y-%m-%d-%T',localtime(time()));
	}
    return $cur_time;
}

sub getYesterdayWeekday()
{
    my $yesterday;
	if($^O=~/win/i)
	{
		$yesterday=POSIX::strftime('%Y-%m-%d-%H:%M:%S_%A',localtime(time() - 3600*24 ));

	}
	else
	{	
		$yesterday=POSIX::strftime('%Y-%m-%d_%T_%A',     localtime(time()-3600*24));
	}
    return $yesterday;
}

sub getTodayWeekday()
{
    my $today;

	if($^O=~/win/i)
	{
		$today=POSIX::strftime('%Y-%m-%d-%H:%M:%S_%A',localtime(time()));

	}
	else
	{
		$today =POSIX::strftime('%Y-%m-%d_%T_%A',localtime(time()));
	}

    return $today;
}

sub get_username_by_mac()
{
	if($^O=~/win/i)
	{
		open(PIPE, "getmac |") or die("open ipconfig cmd failuer\n");
	}
	else
	{
		open(PIPE, "ifconfig |") or die("open ifconfig cmd failuer\n");
	}

    for(<PIPE>)
    {
        if($_=~/DC-0E-A1-1C-8D-A1/)
        {
            return "_greshem";
        }

        if($_=~/192.168.1.62| 192.168.1.74/)
        {
            return "_黄海波";
        }
        if($_=~/192.168.1.130/)
        {
            return "_耿二彬";
        }
    }
	return "_greshem";
}

sub get_signaturename_by_mac()
{
	if($^O=~/win/i)
	{
    	open(PIPE, "getmac |") or die("open ifconfig cmd failuer\n");
	}
	else
	{
    	open(PIPE, "ifconfig |") or die("open ifconfig cmd failuer\n");
	}
    for(<PIPE>)
    {
        if($_=~/DC-0E-A1-1C-8D-A1/)
        {
            return "greshem";
        }
        if($_=~/192.168.1.62/)
        {
            return "huanghaibo";
        }
        if($_=~/192.168.1.130/)
        {
            return "gengerbin";
        }
    }
	return "greshem";
}

########################################################################
#生成名字的 工厂 
sub filename_factory()
{
	my $hour=POSIX::strftime('%H',localtime(time()));
	my $week_day = POSIX::strftime('%A',localtime(time()));#fixme 为什么%u返回的不是5而是%u

	my $filename;
	if($hour ge "18")
	{
		if("星期五" =~/$week_day/)
		{
			$filename = getNextMondayStr();
		}
		else
		{
			$filename = getNextDayStr();
		}
	}
	else
	{
		$filename = getTodayStr();
	}
    $filename .= get_username_by_mac();  
    $filename.= "_todo.txt";
	logger("获取todo文件名为:".$filename."\n");
    return $filename
}

sub get_summary_filename()
{
	my $filename = getTodayStr();
   	$filename .= get_username_by_mac();  
   	$filename.= "_周总结.txt";
	logger("获取的周总结名为:".$filename."\n");
   	return $filename
}

sub get_code_review_filename()
{
	my $filename = getTodayStr();
    $filename.= "_CodeReview";
	$filename .= get_username_by_mac();
	$filename .=  ".txt";

	my $file_number = 0;
	while(1)	#一直判断，当文件名不存在则退出，返回文件名
	{	
		if(-e $filename)
		{
			
			$filename = getTodayStr();
			$filename.= "_CodeReview_";
			$filename .= $file_number;
			$filename.=get_username_by_mac();
			$filename .=".txt";
			$file_number ++;
		}
		else
		{
			last;
		}
	}
	logger("获取代码审核的文件名为：".$filename."\n");
    return $filename
}

sub get_done_filename()
{
	my $filename = getTodayStr();
    $filename.= "_done.txt";
	logger("获取done文件名为:".$filename."\n");
    return $filename
}
###################################################
sub create_diary_file()
{
	open(FILE, ">>".filename_factory()) or die("create file error\n");
	

	print FILE  "#".getTodayWeekday();
	print FILE  " add by ".get_signaturename_by_mac()."\n";
	close(FILE);
	return filename_factory();
}
sub create_week_summary()
{
	my $week_day = POSIX::strftime('%A',localtime(time()));
	if("星期五" =~/$week_day/)
	{
		open(FILE, ">>".get_summary_filename()) or die("create file error\n");
		print FILE  "#".getTodayWeekday();
		print FILE  " add by ".get_signaturename_by_mac()."\n";
		close(FILE);
	}
	else
	{
		logger("不是周五，不用创建周总结\n");
	}
}
sub create_done_file()
{
	open(FILE, ">>".get_done_filename()) or die("create file error\n");
	print FILE  "#".getYesterdayWeekday();
	print FILE  " add by ".get_signaturename_by_mac()."\n";

	print FILE  "#".getTodayWeekday();
	print FILE  " add by ".get_signaturename_by_mac()."\n";
	close(FILE);
}
sub create_code_review_file()
{
	open(FILE, ">>".get_code_review_filename()) or die("create file error\n");
	print FILE  "#".getTodayWeekday();
	print FILE  " add by ".get_signaturename_by_mac()."\n";
	print FILE "项目名称：\n";
	print FILE "修改前版本号：r\n";
	print FILE "修改后版本号：r\n";
	print FILE "审核人: \n";
	print FILE "被审核人: 	".get_signaturename_by_mac()."\n";
	print FILE "文件:		\n";
	print FILE "原因_修改意见:\n";
	print FILE "修改后:		\n";
}
#$filename = get_filename();
sub logger($)
{
	if($^O=~/win/i)
	{
		if( ! -d "d:\\log")
		{
			mkdir("d:\\log");
		}

		(my $log_str)=@_;
		open(FILE, ">> d:\\log\\create_a_new_file.log");
		print FILE $log_str;
		close(FILE);
	}
	else
	{
		(my $log_str)=@_;
		open(FILE, ">> /var/log/create_a_new_file.log");
		print FILE $log_str;
		close(FILE);
	}
}

########################################################################
#mainloop 
my $pwd = getcwd();
if($pwd =~/日志/)
{
	logger("\n操作路径中为".$pwd." \n");
	$today = create_diary_file();
	link_2_today($today);	
	create_week_summary();
}
elsif($pwd =~ /审核/)
{

	logger("\n操作路径中为".$pwd." \n");
	create_code_review_file()
}
elsif($pwd =~ /桌面|desktop/i)
{
	logger("\n操作路径中为".$pwd." \n");
	create_done_file();
}
else
{
	logger("\n操作路径中为".$pwd." \n");
	$today=create_diary_file();
	link_2_today($today);	
}

########################################################################
#在windows 下没有意义.
sub link_2_today($)
{
	(my $link)=@_;
	#link($link, "today.txt");
	#unlink("today.txt");
	#system("ln -s $link  today.txt \n");
}
