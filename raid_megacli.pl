#!/usr/bin/perl
# dell r710 �ķ����� ������.  ����raid 

$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#http://www.lsi.com/support/Pages/Download-Results.aspx?keyword=MegaCli
#ѡ����Ӧ�汾�İ�װ��
#����֮���ѹ��
unzip CSA1.5-MegaCli_REL80571.zip
cd MegaCLI/MegaCli_Linux
rpm -ivh MegaCli-8.05.71-1.noarch.rpm

��װ���
ln -s /opt/MegaRAID/MegaCli/MegaCli64 /usr/bin/
Ĭ�ϰ�װ��/opt���棬����������/usr/bin

#===============================
# MegaCli64���ò������� 
MegaCli64 -adpCount # ����ʾ������������
MegaCli64 -AdpGetTime -aALL # ����ʾ������ʱ�䡿
MegaCli64 -AdpAllInfo -aAll #    ����ʾ������������Ϣ��
MegaCli64 -LDInfo -LALL -aAll #   ����ʾ�����߼���������Ϣ��
MegaCli64 -PDList -aAll   # ����ʾ���е�������Ϣ��
MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL |grep "Charger Status" # ���鿴���״̬��
MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL	# ����ʾBBU״̬��Ϣ��
MegaCli64 -AdpBbuCmd -GetBbuCapacityInfo -aALL #����ʾBBU������Ϣ��
MegaCli64 -AdpBbuCmd -GetBbuDesignInfo -aALL   # ����ʾBBU��Ʋ�����
MegaCli64 -AdpBbuCmd -GetBbuProperties -aALL    # ����ʾ��ǰBBU���ԡ�
MegaCli64 -cfgdsply -aALL   # ����ʾRaid���ͺţ�Raid���ã�Disk�����Ϣ��

#�Ŵ�״̬�ı仯���Ӱ��̣������̵Ĺ����С� 
#Device         |Normal|Damage|Rebuild|Normal
#Virtual Drive     |Optimal|Degraded|Degraded|Optimal
#Physical Drive     |Online|Failed ?> Unconfigured|Rebuild|Online

������ʾ����
MegaCli64 -PDList -aALL
#��������������Ӳ�̵���Ϣ��

MegaCli64 -LDPDInfo -aall
#�����������߼��豸(�Ұ�LD��֮ΪLogical Device)������Ӳ��֮��Ĺ�ϵ��

MegaCli64 -CfgLdAdd -r(0|1|5) [E:S, E:S, ...] -aN
#�������������µ�raid 0,1,5�������豸������

MegaCli64 -LDBI -ProgDsply -LALL -aALL
#����������raid��building���ȵ�
#
һ����linux����MegaCli64��ά��dell������raid��Ҳ������windows���ã�
%SystemRoot%\system32\GAMSERV\megacli -adpeventlog -getevents -f d:\%computername%_nvram.log -aall  ��ҪװMylex Global Array Manager�����

