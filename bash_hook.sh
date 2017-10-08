#!/bin/bash
if [ !   -f /etc/sysconfig/bash-prompt-xterm ] ;then
cat >  /etc/sysconfig/bash-prompt-xterm  <<EOF
echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}"; echo -ne "\007"; echo $(pwd)>> /root/bash_pwd
EOF
echo  
