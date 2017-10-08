#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#硬件断点.
watch *(int*)0x22cbc0

p/x *0x22cb70@64 #64位的方式打印 某段地址.
x/64w 0x22cb70   #
p/x *0x22cb70@64 #
x/64w 0x22cb70	 #

x /10i  地址 # 打印这个地址之后的  10 条指令.

x/3uh 0x54320 从内存地址0x54320读取内容，h表示以双字节为一个单位，3表示输出三个单位，u表示按十六进制显示。

x 按十六进制格式显示变量。
d 按十进制格式显示变量。
u 按十六进制格式显示无符号整型。
o 按八进制格式显示变量。
t 按二进制格式显示变量。
a 按十六进制格式显示变量。
c 按字符格式显示变量。
f 按浮点数格式显示变量。
########大小
# b byte|halfword  word |   w word  | giant 8bytyp

#~/lmyunit/numerical_math/math_demo/matrix/GeneralizedInversionSingularValue.cpp
#定义的double 的矩阵 用下面的 g 来表示 giant 8个字节的. 
x /20gf  &a 

