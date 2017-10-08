#!/bin/bash
if [ ! $# eq 2 ];then
	echo "Usage" $0, "file_or_dev"
fi
dosfsck -n -v $1
