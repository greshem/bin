#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#centos 5.5 
#1.  ��Ŀ�ŵ� ���Ŀ¼.
/usr/src/redhat/SOURCES/
Ȼ����back_dir.pl  ֮�� ���ݾͿ�����. 

2.  rpmbuild -ba package.spec  һ��ʼֻ���ѹ ��ԭ�����µ��ļ�, 
	�����ļ����޸Ĳ��ᱻ,  ����� tar.gz �����ǵ�. 

3. 
Դ��Ŀ¼: 
/usr/src/redhat/SRPMS/diskplat-16.06-16.src.rpm
������Ŀ¼: 
/usr/src/redhat/RPMS/i386/diskplat-16.06-16.i386.rpm


