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
#对应只能在 linux 用 
svn co file:///home/svn/netware_emulator/ netware_emulator

进一步的网络的 客户端的时候 需要 进一步的配置. 
