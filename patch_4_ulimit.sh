#!/bin/sh
if ! grep ulimit /etc/bashrc;then
echo  ulimit -n 65535 >> /etc/bashrc
echo  ulimit -c 1000 >> /etc/bashrc
fi
