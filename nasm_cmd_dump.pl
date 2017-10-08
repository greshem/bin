#!/usr/bin/perl
#2011_03_18_13:53:06   星期五   add by greshem

@all_file= glob("*.asm");
push(@all_file, glob("*.s"));
for (@all_file)
{
	($name)=($_=~/(.*)(.asm|.s)/);

	print "nasm -o $name.o -f elf32 $_\n";
	print "nasm  -o $name.o -f elf64 $_\n"; 
	print "#nasm -hf 更多的文件格式\n";
	print "nasm -w+orphan-labels -w+macro-params -i../inc/ -O99v -f bin -D__LINUX__ -D__KERNEL__=24 -D__SYSCALL__=__S_KERNEL__ -D__OPTIMIZE__=__O_SIZE__ -D__ELF__ -D__ELF_MACROS__ factor.asm \n";

	#-gstabs
}

__DATA__
	print "as -o $name.o $_\n";
	print "as -gstabs -o $name.o $_\n";

