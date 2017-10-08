#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
"gcc_约束_详解_.htm_内联_inline.txt"
IOIC
(指令):output: input: 注释(说明一下  不受影响的寄存器 有那些,  )

"movl %1, %%eax;\\n\\r"
                         "movl %%eax, %0;"
                         :"=r"(b)      /* 输出 */    
                         :"r"(a)       /* 输入 */
                         :"%eax");     /* 不受影响的寄存器 */

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
m Use the variable’s memory location.
o Use an offset memory location.
V Use only a direct memory location.
i Use an immediate integer value.
n Use an immediate integer value with a known value.
g Use any register or memory location available. 


