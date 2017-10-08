#!/usr/bin/perl
#源代码和汇编就会混合到一起的. 
print "#源代码和汇编就会混合到一起, 反汇编的方式.\n";

#get_cur_dir_elf();
common();

########################################################################
sub get_cur_dir_elf()
{
	for( grep { -f } glob("*"))
	{
		if(is_elf_file($_))
		{
			print "objdump -d -S  $_ | c++filt > $_.s\n";
			print "objdump -d -S -C  $_  > $_.s		# 函数名解码 demangle \n";
			print "#gdb 对应的命令是\n";
			print " disassemble  /m  main \n";
		}
	}
}
sub is_elf_file($)
{
	(my $filename)=@_;
	open(PIPE, "file $filename|") or die("open pipe error\n");
	for(<PIPE>)
	{
		if($_=~/ELF.*LSB.*executable/)
		{
			return 1;
		}
	}
	return undef;
}
#==========================================================================
sub common()
{
	print <<EOF
#高级使用技巧 参看 "符号信息_nm_addr2line_readelf_dwarf_内存地址行号信息.txt" 文档.
/bin/dwarf_debug_elf.pl #ok 
nm --extern-only --defined-only -v --print-file-name /usr/share/diskplat/diskplat

objdump -b binary -D -m   i8086  			BOOTLDR 	#dos 的rom 的反编译  bios 
objdump -b binary -D -m   i8086 -M intel  	BOOTLDR 	#intel风格  flavor
objdump -b binary -D -m   i8086 -M att  	BOOTLDR 	#AT&T 风格
objdump -b binary -D -m   i8086 -M att   	PRECFG  	#AT&T 风格

objdump -b binary -D -m   	x86-64  BOOTLDR    	#Disassemble in 64bit mode
objdump -b binary -D -m  	i386    BOOTLDR    	#Disassemble in 32bit mode
objdump -b binary -D -m 	i8086   BOOTLDR    	#Disassemble in 16bit mode

#linux-2.6.26/Documentation/exception.txt 文档.
objdump --disassemble --section=.text vmlinux 			#段.
objdump --disassemble --section=.fixup vmlinux
objdump --full-contents --section=__ex_table vmlinux

objdump -d  /usr/bin/gcov  --show-raw-insn       #Display hex alongside symbolic disassembly

objdump -S   /bin/ls 						#     intermix source code 代码混合. 
objdum -l   /bin/ls 			#--line-numbers   

objdump -F  /usr/share/diskplat/diskplat  			#  -F, --file-offsets       

gdb disassmb  /m   main 		#混合 intermix

objdump -S -l  -M intel /usr/share/diskplat/diskplat 		#
objdump -S -l  -M intel ./diskplat 		#


EOF
;
}
