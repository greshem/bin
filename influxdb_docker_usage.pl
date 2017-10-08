#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

docker run -d -p 8083:8083 -p 8086:8086 -e ADMIN_USER="root" -e INFLUXDB_INIT_PWD="q******************************n" -e PRE_CREATE_DB="db1;db2;db3" tutum/influxdb:latest

