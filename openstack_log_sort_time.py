import os;
import glob;
import time;

#print type(ret);
ret=[];
ret.extend( glob.glob("/var/log/nova/*log")   )
ret.extend( glob.glob("/var/log/glance/*log") );
ret.extend( glob.glob("/var/log/neutron/*log") );
ret.extend( glob.glob("/var/log/horizon/*log" ) );
ret.extend( glob.glob("/var/log/httpd/*log" ) );




def cmp_with_mtime(a,b):
	a_mtime = os.path.getmtime(a) ;
	b_mtime = os.path.getmtime(b) ;
	return cmp(b_mtime, a_mtime);

ret.sort( cmp_with_mtime);

for each in ret:
	print "%s->%s"%(each, int (time.time()-os.path.getmtime(each))  ) ;
	
