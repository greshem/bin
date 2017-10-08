#!/bin/sh
set -x 
for each in $( find  . |grep py$)
do
iconv -c -f utf8 -t gb2312 $1  $each > /tmp/tmp
mv /tmp/tmp $each
done
