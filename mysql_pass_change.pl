#!/usr/bin/perl 
#
#
$sql_file="/tmp/tmp_sql_tmp";
open(FILE, ">".$sql_file ) or die("create  $sql_file error ");
print FILE <<EOF
use mysql;
UPDATE user SET password=PASSWORD('password') WHERE user='root';
flush privileges;
EOF
;

print <<EOF
# exec as follow  change mysql password 
mysql -p  < /tmp/tmp_sql_tmp


 mysql -proot     -e "use mysql; UPDATE user SET password=PASSWORD('password') WHERE user='root';   flush privileges; "
 mysql -ppassword -e "use mysql; UPDATE user SET password=PASSWORD('root') WHERE user='root';   flush privileges; "

EOF
;
