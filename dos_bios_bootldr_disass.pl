#!/usr/bin/perl 

our $bin_file = shift;
if(! defined($bin_file))
{
	$bin_file="BOOTLDR";
}

print <<EOF
perl /root/develop_perl/disasm.pl   -b 16 $bin_file \> ${bin_file}_perl_dissasm.asm
udcli  -16 		\<  $bin_file  					\> ${bin_file}_udcli.asm
#nasm
	ndisasm -i  -b 16 $bin_file   \> ${bin_file}_nasm.asm 
#objdump    
	objdump -b binary -D -m   i8086  $bin_file \> 			${bin_file}_objdump.asm 
EOF
;

