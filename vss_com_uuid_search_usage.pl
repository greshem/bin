#!/usr/bin/perl
#2012_01_31_17:51:38   ���ڶ�   add by greshem

$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#׼�� ������ ��  windows/system32/�� ���е�dll �� dump �� ʮ��  , hexdump name.dll > name.dll.hexdump
#�ú���  �ı��ķ�ʽ���� grep
  IPicture
  7BF80980-BF32-101A-8BBB-00AA00300CAB
  grep -i "7bf8" | grep bf32  ipicture  ���ҵ�uuid 
########################################################################
	IVssAsync
  	C7B98A22-222D-4e62-B875-1A44980634AF    
  	grep -i c7b9  |grep -i 222d
���ȷ�������� ����3��dll
swprv.dll    vssapi.dll  vss_ps.dll 
swprv.dll.hexdump:0007d60 398a c000 724f e3d8 8a22 c7b9 222d 4e62
vssapi.dll.hexdump:000f2d0 0065 0000 8a22 c7b9 222d 4e62 75b8 441a
vss_ps.dll.hexdump:0001130 1011 0002 5a2f 8a22 c7b9 222d 4e62 75b8


########################################################################
vssadmin list writers

д�������: 'Microsoft Writer (Service State)' #vssapi.dll
д����� Id: {e38c2e3c-d4fb-4f4d-9550-fcafda8aae9a}
д������� Id: {813dbd39-9487-4682-8461-0ad082c7226a}
״̬: [1] �ȶ�

д�������: 'WMI Writer'		#./wbem/wmisvc.dll
д����� Id: {a6ad56c2-b509-4e6c-bb19-49d8f43532f0}
д������� Id: {756abcec-00a5-47dc-817e-1fa85b966f1a}
״̬: [1] �ȶ�

д�������: 'MSDEWriter'		#vssvc.exe
д����� Id: {f8544ac1-0611-4fa5-b04b-f7ee00b03277}
д������� Id: {26b8e280-3055-4952-8634-e8905438d74e}
״̬: [1] �ȶ�

д�������: 'Microsoft Writer (Bootable State)' #vssapi.dll
д����� Id: {f2436e37-09f5-41af-9b2a-4ca2435dbfd5}
д������� Id: {7956cd4d-85da-4e42-9bfb-2f6fb62d5d12}
״̬: [1] �ȶ�
