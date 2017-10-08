#!/bin/bash
if [ ! $# -eq 1 ];then
echo "Usage $0 file"
exit -1
fi
#objdump -D -b binary -m i386 $1
objdump  -D -b   binary -m i8086  -M intel $1
