#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#֧�� text �ıȶ�
diff -Nur
#֧�ֶ�����
diff -Naur

#2) patch  �ں˲��� ����
diff -uNr linux-2.6.xxx linux-2.6.xxx.1 > diff.patch
#����
cp diff.patch linux-2.6.xxx/.
cd linux-2.6.xxx
patch -p1 < diff.patc

#case
cd john-1.7.9/
cat ../john-1.7.9-jumbo-7.diff  | patch -p1 
cd src && make linux-x86-any 
