#!/bin/sh
echo $#
SAMBA_CONF=/etc/samba/smb.conf
if [ ! $#  -eq 1 ];then
 echo [USAGE]: $0 absolute_share_dir
   exit -1
fi
if [ ! -f $SAMBA_CONF ];then
 echo [ERROR]:$SAMBA_CONF does not exists!
 exit -1 
else
  sed -i '/^\ *security/{s/.*/security = share/g}' $SAMBA_CONF
fi

if [ ! -d $1 ];then
echo [ERROR]:$1 does not exists 
 exit -1
fi
if echo $1 |grep ^\/;then
 name=$(echo $1|sed 's/\//_/g')
 echo $name
 if ! grep $name $SAMBA_CONF ;then
  echo "[$1]" |sed 's/\//_/g'>>$SAMBA_CONF
  echo "path= $1" >> $SAMBA_CONF
  #        path = /mnt/sdb1/my_project/lonldwt版本
  echo "        writeable  = yes ">>$SAMBA_CONF
  echo "        browseable = yes ">>$SAMBA_CONF
  echo "        guest ok   = yes ">>$SAMBA_CONF
  echo "        public     = yes ">>$SAMBA_CONF
  echo "		case sensitive = yes ">>  $SAMBA_CONF

  service smb restart
 else
 echo  $name  have exports by samba
 fi
else
 echo [ERROR]:not the absolute_dir
fi
