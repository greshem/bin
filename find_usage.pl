#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#2011_02_09_14:33:31 add by greshem
1. ��ȡ������ļ��µ��ļ�. 
	touch -t 0711211201.05 test
	find . -newer test -prin
2. argc  ����.
	find . -type f -exec ls -l {} \; 
3. ��ӡ��С
	find -type f -print "%i %p\n" 
4. Ѱ��Ȩ�� perm 
	find . -perm -4444 -perm /222 ! -perm /111
5. mtime n ������
	find -type f -mtime -4  #4�� ���ڵ�. 
	find -type f -mtime +4  #4 ��   ֮ǰ��. 
	find -type f -mtime -0.001  #immediate find log 
	find  /  -type f   \( -path  /sys -o -path /proc  \) -prune -o -mtime -0.001 	#find all log

6.  
find -type  f -size +100000k  #find big file

find . -type d -maxdepth 1 -mindepth 1	#_cur_dir_subdir,_expect_self.
find . -type d -maxdepth 2 -mindepth 2
find . -type d -maxdepth 3 -mindepth 3
find . -type d -maxdepth 4 -mindepth 4

#7.  not 
find -type f   -not  -empty  #�ǿ�
find -type f     	 -empty  #���ļ�

8. 
find . -name '*.[oda]' -type f -exec rm -f {} +

9.  Ŀ¼���ļ� ת��. 
for each in $(find . -type f); 
do 
echo   /bin/utf8_to_gb2312.sh  $each \> /tmp/tmp; 
echo mv /tmp/tmp $each ; 
done
