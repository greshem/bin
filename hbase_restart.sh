
bash /tmp3/linux_src/hbase-1.0.0/bin/stop-hbase.sh

bash /tmp3/linux_src/hbase-1.0.0/bin/start-hbase.sh 

/tmp3/linux_src/hbase-1.0.0/bin/hbase-daemon.sh start thrift	--threadpool -m 200 -w 500

