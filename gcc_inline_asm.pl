#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
"gcc_Լ��_���_.htm_����_inline.txt"
IOIC
(ָ��):output: input: ע��(˵��һ��  ����Ӱ��ļĴ��� ����Щ,  )

"movl %1, %%eax;\\n\\r"
                         "movl %%eax, %0;"
                         :"=r"(b)      /* ��� */    
                         :"r"(a)       /* ���� */
                         :"%eax");     /* ����Ӱ��ļĴ��� */

#==========================================================================
a Use the %eax, %ax, or %al registers.
b Use the %ebx, %bx, or %bl registers.
c Use the %ecx, %cx, or %cl registers.
d Use the %edx, %dx, or $dl registers.
S Use the %esi or %si registers.
D Use the %edi or %di registers.
r Use any available general-purpose register.
q Use either the %eax, %ebx, %ecx, or %edx register.
A Use the %eax and the %edx registers for a 64-bit value.
f Use a floating-point register.
t Use the first (top) floating-point register.
u Use the second floating-point register.
m Use the variable��s memory location.
o Use an offset memory location.
V Use only a direct memory location.
i Use an immediate integer value.
n Use an immediate integer value with a known value.
g Use any register or memory location available. 


