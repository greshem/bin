#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
rpm -qa --qf "%{name}"  						#���е�����
rpm -qa --qf "%{name}\t\t\t%{summary}\n" 		#���еļ��
rpm -qa --qf "%{name} %{group}\n" 				#���е��� 
rpm -q gcc --qf "%{name} %{summary}\n"		#һ������Ľ���.
rpm -ivh --force test.rpm 					#ǿ�ư�װ.
rpm -ivh --nodeps test.rpm 					#û��������ϵ��װ.
