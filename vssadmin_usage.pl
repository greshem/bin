#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
1. #Ҫ���ñ���C�̵ľ�Ӱ�������ܣ����ҽ��þ�ĸ������浽E���ϣ���Ӱ�����洢�ռ�Ĵ�С����Ϊ900mb
vssadmin add shadowstorage /for=c: /on=e: /maxsize=900mb 
2. # ��C�̽��þ�Ӱ����������ִ������ (windows 7�в�֧�ָ�����)
vssadmin delete shadowstorage /for=c:
3. # �鿴C�̾�Ӱ�����洢����
vssadmin list shadowstorage /for=c:
4.  ΪC���ϵĹ����ļ���������
vssadmin create shadow /for=c:
vssadmin create shadow /for=c: /autoretry=6 #�������ʧ�ܾͻ���60��֮������ִ�п��մ�������
5.  ɾ����Ӱ ���ϵĿ���.
vssadmin delete shadows /for=C: /oldest
#ɾ��ĳ��id �ľ�Ӱ
vssadmin delete shadows /shadow={3a9bdea8-88f8-488a-b7d6-19c519ea6dfc}
6. �鿴C�̵ľ�Ӱ
vssadmin list shadow /for=c:
7.���ٻָ���
vssadmin revert shadow /shadow={3a9bdea8-88f8-488a-b7d6-19c519ea6dfc}

