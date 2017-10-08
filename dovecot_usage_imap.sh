set -x 
yum install squirrelmail
service httpd restart

getenforce 
setenforce 0
iptables -L
iptables -F

service httpd restart 

yum install -y   dovecot*
rpm -ql devecot-mysql
rpm -ql dovecot-mysql
yum install -y  dovecot



log_file="/etc/dovecot/conf.d/10-logging.conf"
#debug_log_path =  /tmp/dovecet.log
sed  -i '/debug_log_path/{s/.*/debug_log_path =\/tmp\/dovecet.log /g}'   $log_file; 

#auth_verbose = yes
sed  -i '/auth_verbose/{s/.*/  auth_verbose =yes  /g}'   $log_file; 

#auth_debug = yes
sed  -i '/auth_debug/{s/.*/  auth_debug =yes  /g}'   $log_file; 


#auth_debug_passwords = yes
sed  -i '/auth_debug_passwords/{s/.*/  auth_debug_passwords =yes  /g}'   $log_file; 

#mail_debug_ = yes
sed  -i '/mail_debug/{s/.*/  mail_debug =yes  /g}'   $log_file; 

#systemctl  restart  dovecot   #这种方式 启动 会导致没有日志 
dovecot  

lsof -i:143

lsof -p $(pgrep dovecot) -P  |grep LISTEN

ip=$(perl /root/bin/get_ip.pl) 
echo  "https://$ip/webmail/src/configtest.php"
#cat /tmp/do
