#!/bin/bash

yum install xinetd
yum install rsh rsh-server 

sed '/disable/{s/.*/disable = no/}' /etc/xinetd.d/rsh  		-i
sed '/disable/{s/.*/disable = no/}' /etc/xinetd.d/rexec  		-i
sed '/disable/{s/.*/disable = no/}' /etc/xinetd.d/rlogin  	-i

lsof -i:512
lsof -i:513
lsof -i:514

if ! grep rlogin /etc/securetty ;then

#as say in /etc/pam.d/rsh header 
	cat >> /etc/securetty <<EOF
rsh
rlogin
rexec
EOF

fi


sed  '/pam_securetty/{s/^/#/}' /etc/pam.d/rsh -i 
sed  '/pam_securetty/{s/^/#/}' /etc/pam.d/rlogin -i 
sed  '/pam_securetty/{s/^/#/}' /etc/pam.d/rexec -i

service xinetd restart

#ERROR: localhost login: pam_securetty(remote:auth): access denied: tty 'pts/6' is not secure !
#
cat  >> /etc/securetty <<EOF
pts/1
pts/2
pts/3
pts/4
pts/5
pts/5
pts/6


EOF
