#!/usr/bin/perl

print "#粘贴 shellcode 的代码到下面的文件中去, \n";
print "/root/develop_perl/shellcode_to_binfile.pl\n";
print "然后再进行反编译\n";

for (glob("/tmp/*.bin"))
{
	print "objdump -b binary -D -m i386 ".$_."  -M intel \n";
	print "hexdump -C $_ \n";
}
