#!/usr/bin/perl
# dell r710 的服务器 的配置.  用了raid 

$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#http://www.lsi.com/support/Pages/Download-Results.aspx?keyword=MegaCli
#选择相应版本的安装包
#下载之后解压，
unzip CSA1.5-MegaCli_REL80571.zip
cd MegaCLI/MegaCli_Linux
rpm -ivh MegaCli-8.05.71-1.noarch.rpm

安装完成
ln -s /opt/MegaRAID/MegaCli/MegaCli64 /usr/bin/
默认安装在/opt下面，建立软链到/usr/bin

#===============================
# MegaCli64常用参数介绍 
MegaCli64 -adpCount # 【显示适配器个数】
MegaCli64 -AdpGetTime -aALL # 【显示适配器时间】
MegaCli64 -AdpAllInfo -aAll #    【显示所有适配器信息】
MegaCli64 -LDInfo -LALL -aAll #   【显示所有逻辑磁盘组信息】
MegaCli64 -PDList -aAll   # 【显示所有的物理信息】
MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL |grep "Charger Status" # 【查看充电状态】
MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL	# 【显示BBU状态信息】
MegaCli64 -AdpBbuCmd -GetBbuCapacityInfo -aALL #【显示BBU容量信息】
MegaCli64 -AdpBbuCmd -GetBbuDesignInfo -aALL   # 【显示BBU设计参数】
MegaCli64 -AdpBbuCmd -GetBbuProperties -aALL    # 【显示当前BBU属性】
MegaCli64 -cfgdsply -aALL   # 【显示Raid卡型号，Raid设置，Disk相关信息】

#磁带状态的变化，从拔盘，到插盘的过程中。 
#Device         |Normal|Damage|Rebuild|Normal
#Virtual Drive     |Optimal|Degraded|Degraded|Optimal
#Physical Drive     |Online|Failed ?> Unconfigured|Rebuild|Online

看几个示例：
MegaCli64 -PDList -aALL
#这是用来看物理硬盘的信息的

MegaCli64 -LDPDInfo -aall
#这是用来看逻辑设备(我把LD称之为Logical Device)和物理硬盘之间的关系的

MegaCli64 -CfgLdAdd -r(0|1|5) [E:S, E:S, ...] -aN
#这是用来建立新的raid 0,1,5的虚拟设备的命令

MegaCli64 -LDBI -ProgDsply -LALL -aALL
#这是用来看raid的building进度的
#
一般在linux下用MegaCli64来维护dell机器的raid。也可以在windows下用：
%SystemRoot%\system32\GAMSERV\megacli -adpeventlog -getevents -f d:\%computername%_nvram.log -aall  （要装Mylex Global Array Manager软件）

