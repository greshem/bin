#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

1.系统
8080，80 用于tomcat和apache的端口。
22 ssh的端口


#--------------------------------------------------------------------------
2.Web UI
用于访问和监控Hadoop系统运行状态
Daemon	缺省端口	配置参数
HDFS	Namenode	50070	dfs.http.address
Datanodes			50075	dfs.datanode.http.address
Secondarynamenode	50090	dfs.secondary.http.address
Backup/Checkpoint node*	50105	dfs.backup.http.address
MR	Jobracker		50030	mapred.job.tracker.http.address
Tasktrackers		50060	mapred.task.tracker.http.address
HBase	HMaster		60010	hbase.master.info.port
HRegionServer		60030	hbase.regionserver.info.port
* hadoop 0.21以后代替secondarynamenode .


#--------------------------------------------------------------------------
3.内部端口
Daemon	缺省端口	配置参数	协议	用于
Namenode		9000	fs.default.name	IPC: ClientProtocol	Filesystem metadata operations.
Datanode		50010	dfs.datanode.address	Custom Hadoop Xceiver: DataNodeand DFSClient	DFS data transfer
Datanode		50020	dfs.datanode.ipc.address	IPC:InterDatanodeProtocol,ClientDatanodeProtocol

ClientProtocol	Block metadata operations and recovery
Backupnode		50100	dfs.backup.address	同 namenode	HDFS Metadata Operations
Jobtracker		9001	mapred.job.tracker	IPC:JobSubmissionProtocol,InterTrackerProtocol	Job submission, task tracker heartbeats.
Tasktracker		127.0.0.1:0*	mapred.task.tracker.report.address	IPC:TaskUmbilicalProtocol	和 child job 通信

* 绑定到未用本地端口

#--------------------------------------------------------------------------
 4.相关产品端口
产品	服务	缺省端口	参数	范围	协议	说明
HBase	Master	60000	hbase.master.port	External	TCP	IPC
Master			60010	hbase.master.info.port	External	TCP	HTTP
RegionServer	60020	hbase.regionserver.port	External	TCP	IPC
RegionServer	60030	hbase.regionserver.info.port	External	TCP	HTTP
HQuorumPeer		2181	hbase.zookeeper.property.clientPort	TCP	HBase-managed ZK mode
HQuorumPeer		2888	hbase.zookeeper.peerport	TCP	HBase-managed ZK mode
HQuorumPeer		3888	hbase.zookeeper.leaderport	TCP	HBase-managed ZK mode
REST Service	8080	hbase.rest.port	External	TCP
ThriftServer	9090	Pass -p <port> on CLI	External	TCP
Avro server		9090	Pass –port <port> on CLI	External	TCP

#--------------------------------------------------------------------------
Hive	Metastore	9083	External	TCP
HiveServer		10000	External	TCP

#--------------------------------------------------------------------------
Sqoop	Metastore	16000	sqoop.metastore.server.port	External	TCP

#--------------------------------------------------------------------------
ZooKeeper	Server	2181	clientPort	External	TCP	Client port
Server		2888	X in server.N=host:X:Y	Internal	TCP	Peer
Server		3888	Y in server.N=host:X:Y	Internal	TCP	Peer
Server		3181	X in server.N=host:X:Y	Internal	TCP	Peer
Server		4181	Y in server.N=host:X:Y	Internal	TCP	Peer

#--------------------------------------------------------------------------
Hue		Server	8888	External	TCP

#--------------------------------------------------------------------------
Beeswax Server		8002	Internal
Beeswax Metastore	8003	Internal


#--------------------------------------------------------------------------
Oozie	Oozie Server	11000	OOZIE_HTTP_PORT in oozie-env.sh	External	TCP	HTTP
Oozie Server	11001	OOZIE_ADMIN_PORT in oozie-env.sh	localhost	TCP	Shutdown port

#--------------------------------------------------------------------------
5.YARN(Hadoop 2.0)缺省端口
产品	服务	缺省端口	配置参数	协议
Hadoop YARN		ResourceManager	8032	yarn.resourcemanager.address	TCP
ResourceManager		8030	yarn.resourcemanager.scheduler.address	TCP
ResourceManager		8031	yarn.resourcemanager.resource-tracker.address	TCP
ResourceManager		8033	yarn.resourcemanager.admin.address	TCP
ResourceManager		8088	yarn.resourcemanager.webapp.address	TCP
NodeManager			8040	yarn.nodemanager.localizer.address	TCP
NodeManager			8042	yarn.nodemanager.webapp.address	TCP
NodeManager			8041	yarn.nodemanager.address	TCP
MapReduce JobHistory Server	10020	mapreduce.jobhistory.address	TCP
MapReduce JobHistory Server	19888	mapreduce.jobhistory.webapp.address	TCP

#--------------------------------------------------------------------------
6.第三方产品端口
ganglia用于监控Hadoop和HBase运行情况。kerberos是一种网络认证协议，相应软件由麻省理工开发。
产品	服务	安全	缺省端口	协议	访问	配置
Ganglia	ganglia-gmond	8649	UDP/TCP	Internal
ganglia-web	80	TCP	External	通过 Apache httpd
Kerberos	KRB5 KDC Server	Secure	88	UDP*/TCP	External	[kdcdefaults] 或 [realms]段下的kdc_ports 和 kdc_tcp_ports
KRB5 Admin Server	Secure	749	TCP	Internal	 Kdc.conf 文件：[realms]段kadmind_

