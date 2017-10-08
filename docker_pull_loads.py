#!/usr/bin/python
#coding=utf-8
import json;

def   seg_str():
    import commands

    #server="192.168.166.7";
    server="192.168.1.5";
	
    # curl http://127.0.0.1:5001/v2/_catalog 
    print("curl -s   http://%s:5001/v2/_catalog   "%server);
    #output = commands.getoutput ("curl -s   http://192.168.1.5:5001/v2/_catalog   ")
    output = commands.getoutput ("curl -s   http://%s:5001/v2/_catalog   "%server)
    #print "|%s|"%(output );
    a=json.loads(output);
    for each in a['repositories']:
	print " docker pull  -a   %s:5001/%s"%(server,each);	

seg_str();
print "HTTPS error  as follow ";
print "/etc/sysconfig/docker  " ;
print " INSECURE_REGISTRY='--insecure-registry   192.168.1.5:5001   ' ";

