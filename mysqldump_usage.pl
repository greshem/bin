#!/usr/bin/perl
use File::Basename;
for $each (grep {-d } (glob("/var/lib/mysql/*")))
{
	
	$basename=basename($each);
	print "mysqldump   -ppassword   --skip-extended-insert     --add-drop-table    $basename     >   $basename.sql \n";
}

for $each (grep {-d } (glob("/var/lib/mysql/*")))
{
	
	$basename=basename($each);
	print "mysql   -ppassword    $basename  <     $basename.sql \n";
}

print <<EOF
mysqldump --skip-extended-insert -ppassword    glance  > glance.sql
mysqldump   -ppassword    --add-drop-database  --add-drop-table     -B phabricator_*  > all.sql

EOF
;

