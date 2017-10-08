#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
UnitLib.lib 	 公共库_影响所有程序_
SrvPlat 	 通用服务平台
LogSrv.dll 	 通用认证服务器
EmptyDll.dll 	 通用认证接口
QlSrvCheck.dll 	 通用港股认证接口
ValueDll.dll 	 通用权值计算接口
DataSrv.dll 	 通用数据服务器
InfoSrv.dll 	 通用资讯服务器
UpdateSrv.dll 	 通用升级服务器
NetDCD.dll 	 通用转码接口
UserSystem.dll 	 通用用户管理系统接口
SrvControl.exe 	 通用服务配置工具
UpdateMan.exe 	 通用升级配置工具
DataResume.exe 	 通用数据恢复工具
Monitor.exe 	 通用服务器监控程序
QsHkReg.dll 	 通用券商港股认证接口
AppendDataSrv.dll 	 多市场数据服务器
NetDCD2.dll 	 多市场转码机
UserRegBF.dll 	 基于文件的用户身份认证接口
UserSystemQS.dll 	 基于券商的用户管理系统
UserSystemBM.dll 	 基于内存的用户管理系统
HTAppInfo.dll 	 华泰附加资讯接口
 	 #==========================================================================

