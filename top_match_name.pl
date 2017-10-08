#!/usr/bin/perl
use strict;;
my $pattern=shift or die("Usage: $0 proc_pattern\n");

my @tmp=`pgrep $pattern`;
my $pids_str=get_pid_str_array(@tmp);


print "#pgrep $pattern \n";
system("pgrep $pattern  -l ");

print  "#=================================\n";
print  "top -p $pids_str \n";
#thread 
print  "top -p $pids_str -H \n";
print " top -b  -n 1   -p $pids_str  > ${pattern}_\$(/bin/getTodayTime.sh) \n";

#==========================================================================
# 1 2 3 4 5 组合成 1,2,3,4,5  这样的字符串. 
sub get_pid_str_array($)
{
	(my @pids)=@_;
	my $cmd;
	for (@tmp)
	{
		chomp;
		$cmd.=$_;
		$cmd.=",";
	}
	$cmd=~s/,$//g;

	return $cmd;
}
