#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
UnitLib.lib 	 ������_Ӱ�����г���_
SrvPlat 	 ͨ�÷���ƽ̨
LogSrv.dll 	 ͨ����֤������
EmptyDll.dll 	 ͨ����֤�ӿ�
QlSrvCheck.dll 	 ͨ�ø۹���֤�ӿ�
ValueDll.dll 	 ͨ��Ȩֵ����ӿ�
DataSrv.dll 	 ͨ�����ݷ�����
InfoSrv.dll 	 ͨ����Ѷ������
UpdateSrv.dll 	 ͨ������������
NetDCD.dll 	 ͨ��ת��ӿ�
UserSystem.dll 	 ͨ���û�����ϵͳ�ӿ�
SrvControl.exe 	 ͨ�÷������ù���
UpdateMan.exe 	 ͨ���������ù���
DataResume.exe 	 ͨ�����ݻָ�����
Monitor.exe 	 ͨ�÷�������س���
QsHkReg.dll 	 ͨ��ȯ�̸۹���֤�ӿ�
AppendDataSrv.dll 	 ���г����ݷ�����
NetDCD2.dll 	 ���г�ת���
UserRegBF.dll 	 �����ļ����û������֤�ӿ�
UserSystemQS.dll 	 ����ȯ�̵��û�����ϵͳ
UserSystemBM.dll 	 �����ڴ���û�����ϵͳ
HTAppInfo.dll 	 ��̩������Ѷ�ӿ�
 	 #==========================================================================

