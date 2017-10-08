#!/bin/bash
for each in $( yum list |awk '{print $1}' |rl.pl); 
do  
echo yum  -y install $each; 
yum  -y install $each; 
done 
