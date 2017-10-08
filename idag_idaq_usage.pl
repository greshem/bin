#!/usr/bin/perl
use strict;
my $input = shift or warn("Usage: $0 input.exe   \n");
if(! defined($input))
{
	usage();
}
else
{
	print  "idaq -A -B  $input \n";

}

my $each;
for $each (glob("*.exe"))
{
	print "idaq -A -B  $each\n";
	print "idag -A -B  $each\n";
}
for $each (glob("*.dll"))
{
	print "idaq -A -B  $each\n";
	print "idag -A -B  $each\n";
}

for $each (glob("*.sys"))
{
	print "idaq -A -B  $each\n";
	print "idag -A -B  $each\n";
}


sub usage()
{
	for(<DATA>)
	{
		print $_;
	}	
}
__DATA__
#-c -A 
#-a     disable auto analysis

#-A     autonomous mode. IDA will not display dialog boxes. Designed to be used together with -S switch.
#-A 	��ida�Զ����У�����Ҫ�˹���Ԥ��Ҳ�����ڴ���Ĺ����в��ᵯ���������ڣ������������û��ʹ�ù�ida��ô���Э��Ĵ����������Ƿ�ʹ�����������������ʾ��

#-B     batch mode. IDA will generate .IDB and .ASM files automatically
#-B ����ָ������ģʽ����Ч��-A �Cc �CSanylysis.idc.�ڷ�����ɺ���Զ�������ص����ݿ��asm���롣���������ر�ida���Ա����µ����ݿ⡣
#-c     disassemble a new file (delete the old database)
#-c 	������ɾ�������������ָ�����ļ���ص����ݿ⣬��������һ���µ����ݿ⡣

#-S     scirpt
#-S ��������ָ��ida�ڷ���������֮��ִ�е�idc�ű�����ѡ��Ͳ���֮��û�пո񣬲�������Ŀ¼ΪidaĿ¼�µ�idc�ļ��С�

#-x     do not create segmentation, (used in pair with Dump database command), this switch affects EXE and COM format files only.

#-b#### loading address (hex)




idaq -c -A -S"dumpfunc.idc arg1 arg2 arg3" E:\test.dll
idag -A -Smyscript.idc input_file

#==========================================================================
ida_idc_�ű�\award450
IDA -A -x -a -p80686p -bF000 -Saward450.idc %1
IDA -bF000 mainbios.bin
IDA -A -x -a -p80686p -bF000 -Saward450.idc mainbios.bin

