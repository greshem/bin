#最简单的.
sub logger_simplest($)
{

    $log_time = POSIX::strftime('%Y-%m-%d %T',localtime(time()));

	(my $log_str)=@_;
	open(FILE, ">> /tmp/all.log") or warn("open all.log error\n");
	print FILE 	$log_time.":".$log_str;
	print STDOUT $log_time.":".$log_str;
	close(FILE);
}

#windows 下 最简单的, 到d:\\log 目录
sub logger_windows($)
{
	if(! -d ("d:\\log"))
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\name.log") or warn("open name.log error\n");
	print FILE $log_str;
	close(FILE);
}

#日志跨平台在两个操作系统上
sub logger_two_os_platform($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, ">>  d:\\log\\vim_plug_install.log");
	}
	else
	{
		open(FILE, ">>  /var/log/vim_plug_install.log");
	}

		print FILE $log_str;
		close(FILE);
}

#日志字符串时间
sub logger_time_str($)
{
	(my $log_str) = @_;
    
	open(FILE,">>all.log") or die("file open error\n");

	my $log_time;
	if($^O=~/win/i)
	{
		use POSIX 'strftime';
		$log_time=POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));
	}
	else
	{
		$log_time = POSIX::strftime('%Y-%m-%d %T',localtime(time()));
	}
    print FILE "$log_time $log_str\n";
    close(FILE);
}

#输出的文件名在变化
sub logger_to_daily_log($)
{
	(my $log_str) = @_;
	my $yyyymm= POSIX::strftime('%Y%m',localtime(time()));
	my $log_file = "/var/log/name".$yyyymm."_log.txt";
	open(FILE, ">> $log_file") or warn("open file $log_file error $!\n");	
	print FILE "$log_time $log_str\n";
    close(FILE);


}

logger_simplest("this is a logger\n");
