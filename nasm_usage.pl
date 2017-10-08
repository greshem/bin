#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

汇编：
GAS：
as –o program.o program.s

NASM：
nasm –f elf –o program.o program.asm

链接: 对于两种汇编器通用:
ld –o program program.o

在使用外部 C 库时的链接方法: 
ld --dynamic-linker /lib/ld-linux.so.2 -lc -o program program.o


#nasm+ gcc 
nasm -f elf64(elf32) hello.asm                  (注意这里使用elf64还是elf32要看操作系统的位数来决定)
gcc -o hello hello.o
./hello
