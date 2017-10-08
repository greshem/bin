#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#nasm
	ndisasm -i  -b 16 /tftpboot/gpxe_bootldr_4444_23569  > /tmp/tmp.asm  

#objdump 
	objdump -b binary -D -m   i8086  			BOOTLDR 	#dos µÄrom µÄ·´±àÒë 


/root/develop_perl/disasm.pl -b 16 -a   /tftpboot/gpxe_bootldr_4444_23569  > /tmp/tmp.asm           


