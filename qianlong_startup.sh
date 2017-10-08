#!/bin/bash
#change root passwd 
while [ 1 ]
do
  /bin/change_root_passwd.sh 
 if [ $? -eq 0 ];then
  break;
 fi
done
######################################
#add qianlong user. 
echo "user add "
while [ 1 ]
do
/bin/user_add.sh
 if [ $? -eq 0 ];then
  break;
 fi
done

######################################
# slave or master 

echo "slave or master"
while [ 1 ]
do
	/bin/slave_or_master.sh
	if [ $? -eq 0 ];then
  		break;
 	fi

done
######################################
#net card setting. 
while [ 1 ]
do
echo "net card settting "
 /bin/setup.sh
 if [ $? -eq 0 ];then
  break;
 fi
done

service network restart 
