#!/usr/bin/perl 
#2011_08_24_10:49:31   ������   add by greshem
#use strict;
use DBI;

#project_id=28 �� ���ͻ����ع�  ��Ŀ��id��..
#������ �Լ���ip ��mysql �������Ŀͻ��� �ο� bin/mysql_usage.pl
my $query = " select *  from dotp_tasks   where task_project=28 ";

my $dbh = DBI->connect (
    "dbi:mysql:database=dotproject:host=192.168.1.32;",
    "root", "q**************n",
    { RaiseError => 1, PrintError => 0 },
  );

my $s_q = $dbh->prepare($query);
$s_q->execute();

#����@data ��ʲô�ṹ, ��phpmyadmin�ο����ݽṹ.
#���� 

while(  my @data = $s_q->fetchrow_array())
{
	print join("|", @data)."\n";
}
