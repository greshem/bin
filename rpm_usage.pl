#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
rpm -qa --qf "%{name}"  						#所有的名字
rpm -qa --qf "%{name}\t\t\t%{summary}\n" 		#所有的简介
rpm -qa --qf "%{name} %{group}\n" 				#所有的组 
rpm -q gcc --qf "%{name} %{summary}\n"		#一个软件的介绍.
rpm -ivh --force test.rpm 					#强制安装.
rpm -ivh --nodeps test.rpm 					#没有依赖关系安装.
