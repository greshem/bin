#!/usr/bin/perl
foreach (<DATA>)
{
    print $_; 
}
__DATA__
(1).��������а�װ��ϵͳ�󣬹ر������ϵͳ���������ϵͳ�����ÿ�ѡ��Edit virtual machine settings�������öԻ���.

(2)����ѡ��Add...��ť���Serial �豸��Ȼ������Serial ����, �����ܵ�����ΪWinDbg ����ʱ��Ҫ�õ��� 
�ܵ�����\\.\pipe\vndbg, �����Լ�����, 
Ҳ����ʹ��Ĭ�ϵ����� \\.\pipe\com_1

(3)���ú�Ӳ�����ӷ�ʽ������������е�ϵͳ����ӵ���������,Vista ֮ǰ��ϵͳͨ���޸�boot.ini �ļ�ʵ�֣�
/debug ��ʾ���ں˵������棬/debugport=com1 ��ʾ���ô���1 ͨ�ţ�/baudrate=115200 ���ô���1 �Ĳ�����Ϊ115200��
���ú������������������е�ϵͳ����ѡ�������˵���ʱͣ����������������ͨ������������WinDbg, 
boot.ini �ļ������������£�(boot.iniΪC�̸�Ŀ¼��һ�������ļ�)
[boot loader]
timeout=30
default=multi(0)disk(0)rdisk(0)partition(1)\WINDOWS
[operating systems]
multi(0)disk(0)rdisk(0)partition(1)\WINDOWS="Microsoft Windows XP Professional" /noexecute=optin /fastdetect
multi(0)disk(0)rdisk(0)partition(1)\WINDOWS="Microsoft Windows XP Professional" /noexecute=optin 			/debug /debugport=com1 /baudrate=115200

(4).���ú������������������е�ϵͳ����ѡ�������˵���ʱͣ��������������������WinDbg, 
ͨ���˵����ں˵������ӶԻ������������ڲ˵���ѡ��symbol file path���ڵ����ĶԻ�����д��
"srv*D:/Symbols*http://msdl.microsoft.com/download/symbols;d:\\symbols2" ,���ڲ˵���ѡ��
#��Ӧ _NT_SYMBOL_PATH ��������, 
kernel debugging���ڵ����ĶԻ��������ò�����Ϊ115200��portΪ\\.\pipe\vndgb, 
kernel debugging���ڵ����ĶԻ��������ò�����Ϊ115200��portΪ\\.\pipe\com_1, 
ͬʱ��ѡreconnect��pipe��Ȼ��ȷ����WinDbg ��Ὺʼ�ȴ�����,

��ʱ�����������ѡ����������һ����ܿ���WinDbg ����ʾ���������������Ϣ, 
#==========================================================================
#vmx ���Բο�, 
root\develop_network\app_img\app_rtiosrv\*.vmx
