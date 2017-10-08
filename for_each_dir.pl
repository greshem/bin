#!/usr/bin/perl
use Cwd;
use File::Copy::Recursive;
use List::Util qw(shuffle);


if(grep(/dump/, @ARGV))
{
	@array=grep {!/dump/} @ARGV;
	my $cmd=join(" ", @array);
	dump_cmd_depth_ten($cmd);
	die("#$0 命令dump 完成 \n");
}

$cmd=join(" ", @ARGV);
my $pwd=getcwd();
my @dirs=grep {-d } glob("$pwd/*");

if(grep/rand$/, @ARGV)
{
	@dirs=shuffle(@dirs);
}

	@dirs=shuffle(@dirs);
for(@dirs)
{
	if ( -d $_)
	{
		print "#Debug: chdir ", $_, "目录\n";
		print "cd $_ \n";
		chdir($_);
		logger("在  $_ 目录执行 $cmd 命令\n");
		$cmd=~s/^\s+//g;
		$cmd=~s/\s+$//g;
		if($cmd=~/^make$|nmake.*makefile.vc$/)
		{
			system_exec_must_success_or_die($cmd);
		}
		else
		{
			system("$cmd");
		}
		print "$cmd\n";	
	}
}

sub system_exec_must_success_or_die($)
{
	(my $cmd_str)=@_;
	logger("执行命令: $cmd_str\n");
	system($cmd_str);
	#if($?>>8 ne 0)
	if($? ne 0)
	{
		my $pwd=getcwd();
		printf(" $pwd 执行命令\n");
		die("命令行: $cmd_str 执行失败\n");
	}
}



sub dump_cmd_depth_ten($)
{
	(my $cmd)=@_;
	my $second;
	my $first;
	for $first (0..10)
	{
		for $each (0..$first)
		{
			print "for_each_dir.pl ";
			$second=$each;
		}
		#print "####".$second."\n";
		print get_path_depth($second);
		print "$cmd > /dev/null \n";
	}
}

sub get_path_depth($)
{
	(my $depth)=@_;
	my $ret_str;
	for(0..$depth)
	{
		$ret_str.="../";
	}	
	return $ret_str;
}


#日志跨平台在两个操作系统上
sub logger($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, ">>  d:\\log\\for_each_dir.log");
	}
	else
	{
		open(FILE, ">>  /var/log/for_each_dir.log");
	}

		print FILE $log_str;
		close(FILE);
}

