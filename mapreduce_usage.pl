#!/usr/bin/perl

foreach (<DATA>)
{
	print $_;
}
__DATA__

#hadoop 
hadoop fs -mkdir /tmp/ 
hadoop fs -put /etc/passwd /tmp/
hadoop jar /tmp3/linux_src/hadoop-2.6.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar  wordcount  /tmp/passwd  /tmp/bb

#hadoop distcp  hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_mt/pt=2015-10-01   hdfs://192.168.1.21:9000/tmp/

#hbase 
#hbase org.apache.hadoop.hbase.mapreduce.RowCounter   scrapy 
#hbase  org.apache.hadoop.hbase.mapreduce.CopyTable  --new.name=tiebaBak  Crawledtieba > tieba

hbase org.apache.hadoop.hbase.PerformanceEvaluation sequentialWrite 1 
hbase org.apache.hadoop.hbase.PerformanceEvaluation  sequentialRead 1
hbase org.apache.hadoop.hbase.PerformanceEvaluation randomWrite 1
hbase org.apache.hadoop.hbase.PerformanceEvaluation randomRead 1


hbase org.apache.hadoop.hbase.mapreduce.RowCounter TestTable
