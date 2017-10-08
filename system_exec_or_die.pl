sub my_system($)
{
	(my $cmd_str)=@_;
	logger("执行命令: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die("命令行: $cmd_str 执行失败\n");
	}
}


sub my_die($)
{
	(my $log_str)=@_;
	$log_str="错误:".$log_str;
	logger($log_str);
	die($log_str);
}


#最简单的.
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /tmp/all.log") or warn("open all.log error\n");
	print $log_str;
	print FILE $log_str;
	close(FILE);
}

#system_exec_must_success_or_die("ifconfig");

