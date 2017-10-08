#!/bin/bash
#clone
#/tmp/���ܴ�����ʱ��������õ��ļ��� 
#�������̿��ܻ������
if [  ! $# -eq  1 ];then
	echo "Usage: $0 dir";
	exit -1;
fi

dir=$1 ;
mkisofs -J -r -hide-rr-moved -hide-joliet-trans-tbl -V backup_$(basename $(pwd))_$(/bin/date +%Y_%m_%d)  -o  /tmp/${dir}_$(/bin/date +%Y_%m_%d).iso $dir 
#&&  
#cdrecord -eject -v speed=8 dev='/dev/scd0'   -data /tmp/backup_*_$(/bin/date +%Y_%m_%d).iso 
#&& 
#rm -f /tmp/backup*.iso
