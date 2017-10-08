#!/usr/bin/perl
use Cwd;
use POSIX 'strftime';
$name=shift or die("Usage: $0 soruce_name \n");
create_file($name);
sub create_file($)
{
	(my  $name)=@_;
	print ("#create   ${name}_源码_分析_todo.txt \n");
	open(FILE, ">${name}_源码_分析_todo.txt") or die("create file error\n");
	

	print FILE  "#".getTodayWeekday();
	print FILE  " add by greshem\n";
	print FILE  $name."_源码_分析\n";
	close(FILE);
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

