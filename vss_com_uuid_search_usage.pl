#!/usr/bin/perl
#2012_01_31_17:51:38   星期二   add by greshem

$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#准备 工作是 把  windows/system32/中 所有的dll 都 dump 成 十六  , hexdump name.dll > name.dll.hexdump
#让后按照  文本的方式进行 grep
  IPicture
  7BF80980-BF32-101A-8BBB-00AA00300CAB
  grep -i "7bf8" | grep bf32  ipicture  查找的uuid 
########################################################################
	IVssAsync
  	C7B98A22-222D-4e62-B875-1A44980634AF    
  	grep -i c7b9  |grep -i 222d
最后确定出来是 下面3个dll
swprv.dll    vssapi.dll  vss_ps.dll 
swprv.dll.hexdump:0007d60 398a c000 724f e3d8 8a22 c7b9 222d 4e62
vssapi.dll.hexdump:000f2d0 0065 0000 8a22 c7b9 222d 4e62 75b8 441a
vss_ps.dll.hexdump:0001130 1011 0002 5a2f 8a22 c7b9 222d 4e62 75b8


########################################################################
vssadmin list writers

写入程序名: 'Microsoft Writer (Service State)' #vssapi.dll
写入程序 Id: {e38c2e3c-d4fb-4f4d-9550-fcafda8aae9a}
写入程序范例 Id: {813dbd39-9487-4682-8461-0ad082c7226a}
状态: [1] 稳定

写入程序名: 'WMI Writer'		#./wbem/wmisvc.dll
写入程序 Id: {a6ad56c2-b509-4e6c-bb19-49d8f43532f0}
写入程序范例 Id: {756abcec-00a5-47dc-817e-1fa85b966f1a}
状态: [1] 稳定

写入程序名: 'MSDEWriter'		#vssvc.exe
写入程序 Id: {f8544ac1-0611-4fa5-b04b-f7ee00b03277}
写入程序范例 Id: {26b8e280-3055-4952-8634-e8905438d74e}
状态: [1] 稳定

写入程序名: 'Microsoft Writer (Bootable State)' #vssapi.dll
写入程序 Id: {f2436e37-09f5-41af-9b2a-4ca2435dbfd5}
写入程序范例 Id: {7956cd4d-85da-4e42-9bfb-2f6fb62d5d12}
状态: [1] 稳定
