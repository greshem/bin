#!/usr/bin/perl
#2011_02_20_07:06:10 add by greshem
foreach (<DATA>)
{
	print $_;
}
__DATA__

svnadmin create /home/svn/test
svnserve -d -r /home/svn/ 
svn co svn://localhost/svn/test  #not ok 
svn co svn://localhost/test  	#ok 


svnserve -d -r /home/svn/
#��Ӧֻ���� linux �� 
svn co file:///home/svn/netware_emulator/ netware_emulator

��һ��������� �ͻ��˵�ʱ�� ��Ҫ ��һ��������. 
