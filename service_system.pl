sub logger_simplest($)
{
	(my $log_str)=@_;
	open(FILE, ">> /tmp/all.log") or warn("open all.log error\n");
	print FILE 	$log_str;
	print STDOUT $log_str;
	close(FILE);
}



$str=join("\t", @ARGV);

logger_simplest("this is a logger,  |$str| \n");
