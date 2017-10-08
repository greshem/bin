#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

system ("taskkill /f /im explorer.exe");
system("start explorer");

taskkill /f /im cmd.exe

taskkill /f /im explorer.exe
start explorer

tasklist 
netstat -aon

