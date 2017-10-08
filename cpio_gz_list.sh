#!/bin/bash
if [ ! $# -eq 1 ];then
	echo "Usage: $0 file.img.gz"
	exit 0
fi

gzip -d $1 -c |cpio -t 
