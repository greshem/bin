#!/bin/bash
for each in $(dir -1 |grep wav$); 
do 
echo lame -V2 $each ${each%%wav}mp3; 
done 
