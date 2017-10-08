#!/usr/bin/perl
for(1..100)
{
	my $a=1+ int (rand(5));
	my $b=6+ int (rand(5));

	dothing:
	print "$a + $b = "; 
	my $answer=<STDIN>;
	if($answer=~/^\d+$/)
	{
	}
	else
	{
		print "输入 不是数字\n";
		goto dothing;
	}
	#print $answer."\n"; 
	if($answer ==  ($a+$b))
	{
		print "OK\n";
	}
	else
	{
	logger( "ERROR!   错误 $a+$b= ".($a+$b).". \n");
	}
}

sub logger($)
{
	(my $log_str)=@_;

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

	open(FILE, ">> math_test.pl.log") or warn("open all.log error\n");
	print 		"$log_time:   $log_str \n";
	print FILE 	"$log_time:   $log_str \n";
	close(FILE);
}

