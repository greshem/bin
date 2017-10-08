#!/bin/sh
#ssh_withpaswd -W123456 192.168.3.189 find /opt/qianlong/syscfg > all_dir
if [ ! -f /bin/ssh_withpasswd ];then
	echo "ssh_withpasswd not exists "
	echo "you cat get it from 200" 
	echo "do as such scp 192.168.3.200:/bin/ssh_withpasswd /bin/ "
	exit 1
fi
if [ $# != 3 ];then
	echo Usage $0 ip username passwd
	exit 1
fi
ip=$1;
username=$2
passwd=$3
echo "get file list"
ssh_withpasswd -W$passwd $username@$ip find /opt/qianlong/syscfg/user2 -type f > all_file
if [ ! $?  -eq 0 ];then
echo "密码错误或者服务器不能连接"
exit -1
fi
echo "get directory list"
ssh_withpasswd -W$passwd  $username@$ip find /opt/qianlong/syscfg/user2 -type d > all_dir
if [ ! $?  -eq 0 ];then
echo "密码错误"
fi

echo "begin to mkdir "
for each in $(cat all_dir)
do
mkdir -p $each
done

for each_file in $(cat all_file)
do
 echo "file $each_file"
 ssh_withpasswd -W$passwd  $username@$ip  cat $each_file > $each_file
done
rm -f all_file all_dir
