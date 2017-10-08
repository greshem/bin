ssh host21  bash /tmp3/linux_src/hbase-1.0.0/bin/stop-hbase.sh
ssh host21  bash /tmp3/linux_src/hadoop-2.6.0/sbin/stop-all.sh

ssh host73  bash /tmp3/linux_src/hbase-1.0.0/bin/stop-hbase.sh
ssh host73  bash /tmp3/linux_src/hadoop-2.6.0/sbin/stop-all.sh


ssh host73  poweroff
ssh host74  poweroff
ssh host75  poweroff

ssh host89  poweroff

ssh host23  poweroff
ssh host22  poweroff
ssh host21  poweroff
