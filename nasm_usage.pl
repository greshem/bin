#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

��ࣺ
GAS��
as �Co program.o program.s

NASM��
nasm �Cf elf �Co program.o program.asm

����: �������ֻ����ͨ��:
ld �Co program program.o

��ʹ���ⲿ C ��ʱ�����ӷ���: 
ld --dynamic-linker /lib/ld-linux.so.2 -lc -o program program.o


#nasm+ gcc 
nasm -f elf64(elf32) hello.asm                  (ע������ʹ��elf64����elf32Ҫ������ϵͳ��λ��������)
gcc -o hello hello.o
./hello
