#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#Ӳ���ϵ�.
watch *(int*)0x22cbc0

p/x *0x22cb70@64 #64λ�ķ�ʽ��ӡ ĳ�ε�ַ.
x/64w 0x22cb70   #
p/x *0x22cb70@64 #
x/64w 0x22cb70	 #

x /10i  ��ַ # ��ӡ�����ַ֮���  10 ��ָ��.

x/3uh 0x54320 ���ڴ��ַ0x54320��ȡ���ݣ�h��ʾ��˫�ֽ�Ϊһ����λ��3��ʾ���������λ��u��ʾ��ʮ��������ʾ��

x ��ʮ�����Ƹ�ʽ��ʾ������
d ��ʮ���Ƹ�ʽ��ʾ������
u ��ʮ�����Ƹ�ʽ��ʾ�޷������͡�
o ���˽��Ƹ�ʽ��ʾ������
t �������Ƹ�ʽ��ʾ������
a ��ʮ�����Ƹ�ʽ��ʾ������
c ���ַ���ʽ��ʾ������
f ����������ʽ��ʾ������
########��С
# b byte|halfword  word |   w word  | giant 8bytyp

#~/lmyunit/numerical_math/math_demo/matrix/GeneralizedInversionSingularValue.cpp
#�����double �ľ��� ������� g ����ʾ giant 8���ֽڵ�. 
x /20gf  &a 

