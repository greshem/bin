echo hadoop dfsadmin -safemode leave

bash /tmp3/linux_src/hbase-1.0.0/bin/stop-hbase.sh
bash /tmp3/linux_src/hadoop-2.6.0/sbin/stop-all.sh

bash /tmp3/linux_src/hadoop-2.6.0/sbin/start-all.sh 
bash /tmp3/linux_src/hbase-1.0.0/bin/start-hbase.sh 

for each in $(cat /tmp3/linux_src/hadoop-2.6.0/etc/hadoop/slaves)
do
ssh $each "bash /tmp3/linux_src/hadoop-2.6.0/sbin/mr-jobhistory-daemon.sh  start historyserver"
done

/tmp3/linux_src/hbase-1.0.0/bin/hbase-daemon.sh start thrift       --threadpool -m 1000  -w 1000
#/tmp3/linux_src/hbase-1.0.0/bin/hbase-daemon.sh start thrift2      --threadpool -m 1000  -w 1000
/tmp3/linux_src/hbase-1.0.0/bin/hbase-daemon.sh start thrift2      --threadpool -m 1000  -w 1000

#hadoop  dfsadmin -setBalancerBandwidth 524288000  
#/tmp3/linux_src/hadoop-2.6.0/sbin/start-balancer.sh   -threshold 10 
