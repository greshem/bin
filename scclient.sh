#!/bin/sh
#qianlong service scripts
PROG=scclient
PROG_PATH=/opt/qianlong/service/market/
ret_val=
. /etc/init.d/functions
function restart
{ 
	echo "Restarting $PROG "
         stop
	start
}
function start
{
	cd $PROG_PATH
         #./$PROG 2>&1 >/dev/null
	echo -n "Staring $PROG"
         daemon ./$PROG 
	echo 
}
function stop
{
	echo "PROG   stop"
        kill $(pidof $PROG) 2>&1 >/dev/null 2>&1 >/dev/null	
        ps -A |grep $PROG
        if [  $? -eq 1 ];then
	  echo "success"
	else
          echo "something goes wrong ,you have to kill the $PROG by you self"
	fi
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
