#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#
 readelf  -s /usr/share/diskplat/diskplat

���� ���Ŵ�С ���з���  ���� ��ע ��Щ��  ��Ҫ�ķ���. 
	nm  -S --size-sort -l       /usr/sbin/nwconn 
	nm  -S --size-sort -l  /usr/share/diskplat/diskplat

δ����ķ���
 	nm -u 	/usr/sbin/nwconn 
	nm -u  /usr/share/diskplat/diskplat


# print all symbols   
	objdump  -t /usr/share/diskplat/diskplat |c++filt
 	readelf -s  /usr/share/diskplat/diskplat
