#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
��chmlib-0.40 �汾 
iso_copy_out_to_desktop.pl "sdb1:\_x_file\_root__2010_07_01.iso\\chm_choose\\src\\chmlib-0.40.tar.gz"


/root/chmlib/chmlib-0.40/src
make �Ϳ�����
ע�� src Ŀ¼���п�ִ�е��ļ� 32λ�� make clean ��ʱ�� ������ ��������յ�, 64bit �������������, ��Ҫ������һһɾ��.   
����src Ŀ¼ ִ�����������. 
gcc enum_chmLib.c -o enum_chmLib -lchm -L.libs/ -lpthread
gcc enumdir_chmLib.c -o enum_chmLib  -lchm -L.libs/ -lpthread
gcc extract_chmLib.c -o extract_chmLib  -lchm -L.libs/ -lpthread
gcc chm_http.c -o chm_http -lchm -L.libs/ -lpthread
gcc test_chmLib.c -o test_chmLib -lchm -L.libs/ -lpthread


#2011_11_04_19:02:46   ������   add by greshem
������İ汾  f13�±���ɹ� ��������û��ʲô����. 
