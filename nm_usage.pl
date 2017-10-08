#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#
 readelf  -s /usr/share/diskplat/diskplat

根据 符号大小 排列符号  便于 关注 那些是  重要的符号. 
	nm  -S --size-sort -l       /usr/sbin/nwconn 
	nm  -S --size-sort -l  /usr/share/diskplat/diskplat

未定义的符号
 	nm -u 	/usr/sbin/nwconn 
	nm -u  /usr/share/diskplat/diskplat


# print all symbols   
	objdump  -t /usr/share/diskplat/diskplat |c++filt
 	readelf -s  /usr/share/diskplat/diskplat
