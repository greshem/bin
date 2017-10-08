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
#-A 	让ida自动运行，不需要人工干预。也就是在处理的过程中不会弹出交互窗口，但是如果从来没有使用过ida那么许可协议的窗口无论你是否使用这个参数都将会显示。

#-B     batch mode. IDA will generate .IDB and .ASM files automatically
#-B 参数指定批量模式，等效于-A –c –Sanylysis.idc.在分析完成后会自动生成相关的数据库和asm代码。并且在最后关闭ida，以保存新的数据库。
#-c     disassemble a new file (delete the old database)
#-c 	参数会删除所有与参数中指定的文件相关的数据库，并且生成一个新的数据库。

#-S     scirpt
#-S 参数用于指定ida在分析完数据之后执行的idc脚本，该选项和参数之间没有空格，并且搜索目录为ida目录下的idc文件夹。

#-x     do not create segmentation, (used in pair with Dump database command), this switch affects EXE and COM format files only.

#-b#### loading address (hex)




idaq -c -A -S"dumpfunc.idc arg1 arg2 arg3" E:\test.dll
idag -A -Smyscript.idc input_file

#==========================================================================
ida_idc_脚本\award450
IDA -A -x -a -p80686p -bF000 -Saward450.idc %1
IDA -bF000 mainbios.bin
IDA -A -x -a -p80686p -bF000 -Saward450.idc mainbios.bin

