#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#2012_05_24   ������   add by greshem
 #�ĵ������� <<windows_�ں�������������������_start_type.txt>> 
start 0  boot	 #boot acpi pci mountmgr ftdisk ��.
start 1	system   #beep fs_rec null
start 2 auto
start 3 manual
start 4 disabled

type  1		#�ں˼��豸��������
type  2		#�ļ�ϵͳ����o
type  4		#�������������������̡������������ȣ�
type  8		#�ļ�ϵͳʶ����������ʶ�������ȷ��ʹ�õ��ļ�ϵͳ��
type 16		#win32������������������У����������������ִ���ļ�������������
type 32 	#win32������Ϊ����������У��������������ִ���ļ������������̣�
type 272	#win32������������������У�ͬʱ����������潻���������û����룬�������������localsystem����ϵͳ�ʻ�����
type 288	#win32�����Թ���������У�ͬʱ����������潻���������û����룬�������������localsystem����ϵͳ�ʻ�����
########################################################################
richboot type 1  start 0  group "NDIS Wrappter"
richndis type 1  start 0 group "NDIS"
richdisk  type 1 start 0 group "SCSI miniport"
1. 	sc qc disk
2.  E1000 winaoe ��ע���.

