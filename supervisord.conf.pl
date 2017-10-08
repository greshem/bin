#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
[supervisord]
nodaemon=true
logfile=/var/log/supervisord/supervisord.log

[program:LatestRecommend]
command=sh ./LatestRecommend-service/web_server/run.sh
