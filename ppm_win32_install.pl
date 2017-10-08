#!/usr/bin/perl

if($^O=~/win32/i)
{
}
else
{
	die(" ppm not support  linux\n");
}


open(PIPE, "ppm search Win32|") or die("open file error\n");
#open(PIPE, "ppm search a|") or die("open file error\n");

for(<PIPE>)
{
	if(/\S+\s+(\S+)/)
	{
		print $1."\n";
		system("ppm install $1");
		logger("ppm install $1\n");
	}
}
########################################################################
open(PIPE, "ppm search win32|") or die("open file error\n");

for(<PIPE>)
{
	if(/\S+\s+(\S+)/)
	{
		print"ppm install ". $1."\n";
		system("ppm install $1");
	}
}


sub logger($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, ">> d:\\log\\ppm_win32_install.log");
	}
	else
	{
		open(FILE, ">> /var/log/ppm_win32_install.log");
	}

		print FILE $log_str;
		close(FILE);
}
#logger("this is a logger\n");
