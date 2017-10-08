#!/bin/bash
if [ ! $# -eq 1 ];then
	echo "Usage " $0  dev;
	exit 
fi
dev=$1;
dd if=$dev of=${dev}_MBR_$(/bin/getTimeNow.sh) bs=512 count=1
#echo dd if=$dev of=$(basename ${dev})_MBR bs=512 count=1
dd if=$dev of=${dev}_MBR_bak bs=512 count=1 skip=1
#echo dd if=$dev of=$(basename ${dev})_MBR_bak bs=512 count=1 skip=1
