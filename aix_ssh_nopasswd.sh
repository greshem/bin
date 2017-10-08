#!/bin/sh
if [ ! $# -eq 1 ] ;then
 echo "Usage: $0 host_ip ,now exit"
 echo "Help: to make ssh the computer without the password"
  exit -3
fi
RSA_PUB=/.ssh/id_rsa.pub
RSA=/.ssh/id_rsa
############################################################
if [  ! -f $RSA_PUB ];then
  echo "the rsa file maybe not correct ,you should create it now "
  ssh-keygen -t rsa
fi
##
LANG=C       cat /.ssh/id_rsa.pub | ssh $1 cat '>>' /.ssh/authorized_keys
