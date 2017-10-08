#!/usr/bin/perl

foreach (<DATA>)
{
	print $_;
}
__DATA__

1. 	main 线程
2.  IOCM_DetectEncryLockThread 	#锁检测
3.  CLN_ConnectServerThread 	#
4.	PXEWorkerThread				# 
5.  MsgServerListenThread		# 
6.	CScanSocketTimer 
7.  CReadKeyTimer 
8.	CDbcpSrvThread	 
9. 	IOCM_AcceptClientConnectThread	
10.	SAT_AcceptServerConnectThread  
11. BootpServiceThread  		#dhcpd 服务器线程.
12. TftpServiceThread
13. PXEServiceThread 			#define PXE_SERVICE_PORT 4011
14. ClientUdpThread
15. PXEBootThread				#define     PXE_IO_PORT         47138
16. INTER_VDiskSyncThread 
17. NDSM_AcceptClientConnectThread
18. RecvParamThread				#经常有线程出来. 

