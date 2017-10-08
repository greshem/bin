#!/bin/sh
if [ ! $# -eq 1 ] ;then
 echo "Usage: $0 host_ip ,now exit"
 echo "Help: to make ssh the computer without the password"
  exit -3
fi
RSA_PUB=/root/.ssh/id_rsa.pub
RSA=/root/.ssh/id_rsa
############################################################
if [  ! -f $RSA_PUB ];then
  echo "the rsa file maybe not correct ,you should create it now "
  ssh-keygen -t rsa
fi
############################################################
scp $RSA_PUB root@$1:/root/.ssh/temp
ssh root@$1 "cat  /root/.ssh/temp >>/root/.ssh/authorized_keys"
#scp $RSA_PUB root@$1:/root/.ssh/authorized_keys
if [ $? -eq 0 ];then
 echo "success ,you can ssh $1 without the passwd"
fi
