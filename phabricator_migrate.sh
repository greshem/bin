#!/bin/bash
qa=139.196.170.125

scp -P2222  $qa:/etc/my.cnf   /etc/my.cnf  
scp -P2222  $qa:/etc/php.ini   /etc/php.ini 
scp -P2222  $qa:/etc/httpd/conf.d/phabricator.conf   /etc/httpd/conf.d/phabricator.conf 


service mariadb restart 
mysql <<EOF
use mysql;
UPDATE user SET password=PASSWORD('password') WHERE user='root';
EOF

ssh -p2222    $qa " cd  /var/lib/mysql  &&  mysqldump   -ppassword    --add-drop-database  --add-drop-table     -B phabricator_*  > /tmp/all.sql  " 
ssh -p2222    $qa " gzip    /tmp/all.sql  " 

scp -P2222    $qa:/tmp/all.sql.gz   /tmp/ 
gzip -d   /tmp/all.sql.gz 

mysql -ppassword  <  /tmp/all.sql 



scp -P2222    $qa:/var/www/html/*.tar.gz    /var/www/html/
cd /mnt/dir/repo/  && /root/bin/extract_all_tar.pl  |sh 




yum install php-mysql php-mbstring php-posix php-gd tzdata* pygments python-pygments


/var/www/html/phabricator/bin/config    set   phabricator.base-uri    "http://192.168.1.73/" 




/var/www/html/phabricator/bin/phd restart
#mkdir /var/lib/re
mkdir -p  /mnt/dir/repo
scp -P2222    $qa:/mnt/dir/repo/*.tar.gz    /mnt/dir/repo/ 

mkdir -p  "/tmp3/phabricator_file_disk"
chmod 777  "/tmp3/phabricator_file_disk"
scp  -r -P2222    $qa:/mnt/dir/phabricator_file_disk/*    /tmp3/phabricator_file_disk
