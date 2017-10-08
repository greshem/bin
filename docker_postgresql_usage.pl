#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

docker run --name=postgresql -d \
-e 'DB_NAME=gitlabhq_production' -e 'DB_USER=gitlab' -e 'DB_PASS=password' \
-v /home/username/opt/postgresql/data:/var/lib/postgresql \
sameersbn/postgresql:9.4   -p 10022:22 
