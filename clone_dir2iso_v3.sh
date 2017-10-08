#!/bin/bash
#clone
#/tmp/可能存在临时的真的有用的文件。 
#整个过程可能会出处理
if [  ! $# -eq  1 ];then
	echo "Usage: $0 dir";
	exit -1;
fi

dir=$1 ;
outfile=$(echo $dir |sed 's/\//_/g' );
 echo  mkisofs -J -r -hide-rr-moved -hide-joliet-trans-tbl -V backup_$(basename $(pwd))_$(/bin/date +%Y_%m_%d)  -o  ${outfile}_$(/bin/date +%Y_%m_%d).iso $dir 
 mkisofs -J -r -hide-rr-moved  -joliet-long -hide-joliet-trans-tbl -V backup_$(basename $(pwd))_$(/bin/date +%Y_%m_%d)  -o  ${outfile}_$(/bin/date +%Y_%m_%d).iso $dir 
if [ ! $? -eq 0 ];then 
	echo "mkisofs error\n";
	exit 1;
fi
echo "mkiso success"

#&&  
#cdrecord -eject -v speed=8 dev='/dev/scd0'   -data /tmp/backup_*_$(/bin/date +%Y_%m_%d).iso 
#&& 
#rm -f /tmp/backup*.iso
