#!/bin/sh
#qianlong service scripts
PROG=SrvPlat
#PROG_PATH=/opt/qianlong/program/market
PROG_PATH=/opt/qianlong/service/market
ret_val=
. /etc/init.d/functions

function restart
{ 
	echo "srvplat  restart now"
         stop
	start
}
function start
{

	echo -n "Starting srvplat   "
	cd 	$PROG_PATH/
	daemon	./srvplat
	echo
}
function stop
{
	echo "srvplat   stop"
        kill $(pgrep srvplat)	
}

case  "$1" in 
 restart|restar |resta|rest |res |re)
       restart
        ;;
 start|star|sta)
       start
       ;;
 stop|sto |st |s)
       stop
        ;;
 *)
      echo "Usage: $0 restart;start;stop"
        ;;
esac
#/opt/qianlong/service/market
