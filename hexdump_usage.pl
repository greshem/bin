#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
1. xxd file 
xxd ISO-8859_text.reg 

2. �����湦�ܵ�ͬ  -C ��ѡ���ס�� hexdump  /etc/passwd -C 
3. �༭16 ���� ��ͨ�� hexedit 
yum install hexedit 

################
1. hexdump 
2. 
.���ַ����Ƹ�ʽ��ʾ�ļ�����
# od -t a sparse_file

.��ASCII��ʽ��ʾ�ļ�������
# od -c sparse_file

.�԰˽��Ƹ�ʽ��ʾ�ļ�������
# od  sparse_file

��ʮ�����Ƹ�ʽ��ʾ�ļ������� (������������ͬ��ֻ��ƫ������ͬ)
# od -A x sparse_file

xxd  Ĭ�Ͼ��ǣ� �ܱ�׼�ĸ�ʽ��
hexdump  ��XXDһ���� Ĭ��������Ǳ�׼��ʽ�� 

1. windows ������ hexplorer
2. fshred  �Ĺ��ߣ� MFC ���ĵ��Ľ��棬 
#==========================================================================
od, hdump, hexdump, bpe, hexed, beav.

bvi #bin ��vi �༭��.

