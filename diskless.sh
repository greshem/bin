#!/bin/sh






start() {
	dhcpd
	service xinetd start
	service portmap start
	service nfs start
	
	}	



stop() {
	kill $(pidof dhcpd)
	service xinetd stop
	service portmap start
	service nfs start
 	}	


restart() {
	stop
	start
}	

reload() {
	echo "reload will append later"
	}	

rhstatus() {
	echo "rhstatus will append later" 
}	



# Check that we can write to it... so non-root users stop here



case "$1" in
  start)
  	start
	;;
  stop)
  	stop
	;;
  restart)
  	restart
	;;
  reload)
  	reload
	;;
  status)
  	rhstatus
	;;
  condrestart)
  	[ -f /var/lock/subsys/smb ] && restart || :
	;;
  *)
	echo $"Usage: $0 {start|stop|restart|reload|status|condrestart}"
	exit 1
esac

exit $?
