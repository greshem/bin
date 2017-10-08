#!/usr/bin/perl
use Cwd;
use File::Copy::Recursive;
use List::Util qw(shuffle);


if(grep(/dump/, @ARGV))
{
	@array=grep {!/dump/} @ARGV;
	my $cmd=join(" ", @array);
	dump_cmd_depth_ten($cmd);
	die("#$0 ����dump ��� \n");
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
		print "#Debug: chdir ", $_, "Ŀ¼\n";
		print "cd $_ \n";
		chdir($_);
		logger("��  $_ Ŀ¼ִ�� $cmd ����\n");
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
	logger("ִ������: $cmd_str\n");
	system($cmd_str);
	#if($?>>8 ne 0)
	if($? ne 0)
	{
		my $pwd=getcwd();
		printf(" $pwd ִ������\n");
		die("������: $cmd_str ִ��ʧ��\n");
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


#��־��ƽ̨����������ϵͳ��
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

