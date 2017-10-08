#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__


Docker engine
docker run -d --name SomeContainerNameIPAM \
           -p 8181:80 \
           -e MYSQL_DB_HOSTNAME=Welcome1 \
           -e MYSQL_DB_USERNAME=admin \
           -e MYSQL_DB_PASSWORD=Password1 \
           -e MYSQL_DB_NAME=exampleDB \
           -e MYSQL_DB_PORT=3306 \
           rafpe/docker-phpipam
