#!/usr/bin/perl 
#2011_08_24_10:49:31   星期三   add by greshem
#use strict;
use DBI;

#project_id=28 是 广告客户端重构  项目的id号..
#如何添加 自己的ip 到mysql 服务器的客户度 参考 bin/mysql_usage.pl
my $query = " select *  from dotp_tasks   where task_project=28 ";

my $dbh = DBI->connect (
    "dbi:mysql:database=dotproject:host=192.168.1.32;",
    "root", "q**************n",
    { RaiseError => 1, PrintError => 0 },
  );

my $s_q = $dbh->prepare($query);
$s_q->execute();

#具体@data 是什么结构, 用phpmyadmin参考数据结构.
#或者 

while(  my @data = $s_q->fetchrow_array())
{
	print join("|", @data)."\n";
}
