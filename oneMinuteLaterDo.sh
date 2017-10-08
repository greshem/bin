#!/bin/bash
echo $@ 
at now+1minutes <<EOF
echo $(pwd) >> /var/log/oneMinutesLog.log

echo $@ >> /var/log/oneMinutesLog.log
$@
EOF
