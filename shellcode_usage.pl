#!/usr/bin/perl

print "#ճ�� shellcode �Ĵ��뵽������ļ���ȥ, \n";
print "/root/develop_perl/shellcode_to_binfile.pl\n";
print "Ȼ���ٽ��з�����\n";

for (glob("/tmp/*.bin"))
{
	print "objdump -b binary -D -m i386 ".$_."  -M intel \n";
	print "hexdump -C $_ \n";
}
