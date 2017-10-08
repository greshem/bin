#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#centos 5.5 
#1.  项目放到 这个目录.
/usr/src/redhat/SOURCES/
然后用back_dir.pl  之后 备份就可以了. 

2.  rpmbuild -ba package.spec  一开始只会解压 比原来的新的文件, 
	所以文件的修改不会被,  外面的 tar.gz 被覆盖掉. 

3. 
源码目录: 
/usr/src/redhat/SRPMS/diskplat-16.06-16.src.rpm
二进制目录: 
/usr/src/redhat/RPMS/i386/diskplat-16.06-16.i386.rpm


