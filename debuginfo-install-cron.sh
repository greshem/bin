#!/bin/bash
for each in $(rpm -qa --qf "%{name}\n" |/bin/rl.pl |tail -n 20 )
do
/usr/bin/debuginfo-install -y  $each
done
