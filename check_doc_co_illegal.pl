#!/usr/bin/perl
use POSIX 'strftime';
use File::Copy;

$g_file_exists = 0;
$g_file_mof = 0;

my $pid = fork();
print "pid=", $pid,"\n";

if($pid)
{
	print "父进程\n";
	exit(0);
}
else
{
	print ("子进程\n");
}
setpgrp;

while ( 1 == 1 )
{
	system("cd ~/doc_collaboration && svn update");	
   	@member = qw/钱忠杰 黄海波 耿二彬/;
	my $week_day = POSIX::strftime('%u',localtime(time));
	if("12345" =~ /$week_day/)
	{
		foreach(@member)
		{
    	   	check_befor_work($_);
       		check_after_work($_);
		}
	}
	sleep(60);
}
########################################################################
sub check_befor_work($)
{
	(my $member) = @_;
	my $check_time = "10:00:00";
	my $local_time = POSIX::strftime('%T',localtime(time));
	
	if(($local_time gt $check_time) && ($g_file_exists < 3))
    {
		check_diary_is_created($member);
 		$g_file_exists++;
	}
	if($check_time gt $local_time)
	{
		$g_file_exists = 0;	
	}
}

sub check_after_work($)
{
	(my $member) = @_;
	my $check_time = "18:30:00";#六点半检查六点是否创建
	my $local_time = POSIX::strftime('%T',localtime(time));

 	if(($local_time gt $check_time) && ($g_file_mof < 3))
    { 
		check_weekly_summary_is_created($member);
		check_diary_is_svn($member);
		$g_file_mof++;
    }
	if($check_time gt $local_time)
	{
		$g_file_mof = 0;
	}
}


sub get_todo_filename($)
{
	(my $member) = @_;
	my $filename = getTodayStr()."_";
    $filename .= $member;
    $filename.= "_todo.txt";
	return $filename;
}

sub get_weekly_summary_filename($)
{
	(my $member) = @_;
	my $filename = getTodayStr()."_";
    $filename .= $member;
    $filename.= "_周总结.txt";
	
	return $filename;
}



#***************************************************************************
# Description	有$month比没有的 获取的目录更深一层
# @param 	
# @return 	
# @notice: 
#***************************************************************************/
sub get_dir_path()
{	
	my $month = POSIX::strftime('%Y%m\/',localtime(time()));
	my @array;

	my $dir_with_month = `echo ~\/doc_collaboration\/日志\/$month`;
	my $dir_without_month = `echo ~\/doc_collaboration\/日志\/`;
	
	chomp($dir_with_month);
	chomp($dir_without_month);
	push @array ,$dir_with_month;
	push @array ,$dir_without_month;
	return @array;
}

#***************************************************************************
# Description	
# @param 	
# @return 	
# @notice get_todo_filename不能放到for循环里去，否则传人的参数不是$member fixme
#***************************************************************************/
sub get_diary_filenames($)
{
	(my $member )= @_;
	my $todo_filename = get_todo_filename($member);
	my @full_filename;
	my @arr_dir = get_dir_path();
	for(@arr_dir)
	{
		$dir = $_;
		$dir .= $todo_filename;
		push @full_filename, $dir;
	}
	return @full_filename;
}

sub check_diary_is_created($)
{
	(my $member )= @_;
	my @diary_filename = get_diary_filenames($member);
	
	for(@diary_filename)
	{
		if(-f $_)
		{
			write_to_log(" $member OK 上午十点前已经创建好了日志!");
			return ;
		}
	}
	
	write_to_log(" $member NOT OK 上午十点前还没有创建日志!");
}

#***************************************************************************
# Description	得到的目录路径有俩个，但只需要含有月份的路径，所以shift(@arr_dir)
# @param 	
# @return 	
#***************************************************************************/
sub check_weekly_summary_is_created($)
{
	(my $member) = @_;
	my $week_day = POSIX::strftime('%u',localtime(time));
	
	my @arr_dir = get_dir_path();
	my $dir = shift (@arr_dir);

	#if($week_day =~/4/) #只有周五才判断是否有周总结
	if("5" =~/$week_day/)
	{
		my $filename_summary = $dir;
		$filename_summary .= get_weekly_summary_filename($member);
		
		if(-f $filename_summary) 
   		{   
			write_to_log(" $member OK 周五下午六点前已经创建了周总结!");
   		}   
   		else
   		{ 
			write_to_log(" $member NOT OK 周五下午六点前还没有创建了周总结!");
   		}	
	}	
}

sub check_diary_is_svn($)
{	
	(my $member) = @_;
	my @filename = get_diary_filenames($member);
	for(@filename)
	{	
		my $mtime = (stat($_))[9];
		my $sys_time = POSIX::strftime('%T',localtime($mtime));

		if($sys_time gt "18:00:00")
		{
			write_to_log(" $member OK 下午六点后日志已经提交了 !");
			return ;
		}
	}
	write_to_log(" $member NOT OK 下午六点后日志还没有提交 !");
}


########################################################################
sub getTodayStr()
{
    use POSIX 'strftime';
    $hour=POSIX::strftime('%H',localtime(time()));
    $today=POSIX::strftime('%Y%m%d',localtime(time()));

    return $today;
}

########################################################################
sub write_to_log($)
{
	(my $file_contents) = @_;
	my $yyyymm = POSIX::strftime('%Y%m',localtime(time()));
	my $log_file = "/var/log/check_illegal_".$yyyymm."_log.txt";

	open(FILE,">>$log_file") or die("file open error\n");
	my $log_time = POSIX::strftime('%Y-%m-%d %T',localtime(time()));
    print FILE "$log_time $file_contents \n";
    close(FILE);
}

