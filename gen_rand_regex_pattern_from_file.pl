#!/usr/bin/perl
sub get_regex_patterns_array()
{
	my @pattern_array;
	open(FILE, "gen_makefile_from_file_latest.pl") or die("open file error\n");
	for(<FILE>)
	{
		if($_=~/\$line=.*\/(.*)\//)
		{
			#print $1."\n";;
			my $pattern=$1;
			$pattern=~s/\^//g;
			$pattern=~s/\\/\\\\/g;
			$pattern=~s/\\\\s/\\s/g;
			$pattern=~s/\\\\\(/\\\(/g;
			$pattern=~s/\.hpp/\\\\\\.hpp/g;
			$pattern=~s/\.cpp/\\\\\\.cpp/g;
			$pattern=~s/\.h/\\\\\\.h/g;
			#print $pattern."\n";;
			push(@pattern_array, $pattern);
		}
	}
	return @pattern_array;
}

my @array=get_regex_patterns_array();

use String::Random;
my @save_lines;
for(@array)
{
	$foo = new String::Random;
	$rand_str= $foo->randregex("$_");
	
	$rand_str=~s/\\\./\./g;
	logger("正则表达式是 $_\n");
	logger("对应的随机字符串是  $rand_str\n");
	push(@save_lines, $rand_str);
	print  $rand_str;
}

save_to_file(@save_lines);

sub save_to_file(@)
{
	(my @lines)=@_;
	open(OUTPUT, "> /tmp/tmp.cpp") or die("open file error\n");
	for(@lines)
	{
		print OUTPUT  $_."\n";
	}
	close(OUTPUT);
}
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> all.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

