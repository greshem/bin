#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
用chmlib-0.40 版本 
iso_copy_out_to_desktop.pl "sdb1:\_x_file\_root__2010_07_01.iso\\chm_choose\\src\\chmlib-0.40.tar.gz"


/root/chmlib/chmlib-0.40/src
make 就可以了
注意 src 目录下有可执行的文件 32位的 make clean 的时候 并不能 把他们清空掉, 64bit 下面会遇到问题, 需要把他们一一删除.   
到了src 目录 执行下面的命令. 
gcc enum_chmLib.c -o enum_chmLib -lchm -L.libs/ -lpthread
gcc enumdir_chmLib.c -o enum_chmLib  -lchm -L.libs/ -lpthread
gcc extract_chmLib.c -o extract_chmLib  -lchm -L.libs/ -lpthread
gcc chm_http.c -o chm_http -lchm -L.libs/ -lpthread
gcc test_chmLib.c -o test_chmLib -lchm -L.libs/ -lpthread


#2011_11_04_19:02:46   星期五   add by greshem
到今天的版本  f13下编译成功 可以运行没有什么问题. 
