#!/usr/bin/perl
#Դ����ͻ��ͻ��ϵ�һ���. 
print "#Դ����ͻ��ͻ��ϵ�һ��, �����ķ�ʽ.\n";

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
			print "objdump -d -S -C  $_  > $_.s		# ���������� demangle \n";
			print "#gdb ��Ӧ��������\n";
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
#�߼�ʹ�ü��� �ο� "������Ϣ_nm_addr2line_readelf_dwarf_�ڴ��ַ�к���Ϣ.txt" �ĵ�.
/bin/dwarf_debug_elf.pl #ok 
nm --extern-only --defined-only -v --print-file-name /usr/share/diskplat/diskplat

objdump -b binary -D -m   i8086  			BOOTLDR 	#dos ��rom �ķ�����  bios 
objdump -b binary -D -m   i8086 -M intel  	BOOTLDR 	#intel���  flavor
objdump -b binary -D -m   i8086 -M att  	BOOTLDR 	#AT&T ���
objdump -b binary -D -m   i8086 -M att   	PRECFG  	#AT&T ���

objdump -b binary -D -m   	x86-64  BOOTLDR    	#Disassemble in 64bit mode
objdump -b binary -D -m  	i386    BOOTLDR    	#Disassemble in 32bit mode
objdump -b binary -D -m 	i8086   BOOTLDR    	#Disassemble in 16bit mode

#linux-2.6.26/Documentation/exception.txt �ĵ�.
objdump --disassemble --section=.text vmlinux 			#��.
objdump --disassemble --section=.fixup vmlinux
objdump --full-contents --section=__ex_table vmlinux

objdump -d  /usr/bin/gcov  --show-raw-insn       #Display hex alongside symbolic disassembly

objdump -S   /bin/ls 						#     intermix source code ������. 
objdum -l   /bin/ls 			#--line-numbers   

objdump -F  /usr/share/diskplat/diskplat  			#  -F, --file-offsets       

gdb disassmb  /m   main 		#��� intermix

objdump -S -l  -M intel /usr/share/diskplat/diskplat 		#
objdump -S -l  -M intel ./diskplat 		#


EOF
;
}
