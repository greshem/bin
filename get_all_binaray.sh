#!/bin/bash

for each in $(find -type f |xargs file  |grep ELF |awk -F:  '{print $1}' )
do
echo chmod 777 $each
done
