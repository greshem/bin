#!/usr/bin/python
import glob
import os;

def get_host_ip():
    import commands
    cmd_line = commands.getoutput ('hostname -I ')
    output=cmd_line.split();
    ip= filter(lambda x:  x.startswith("192.168") , output); 
    assert(len(ip) !=0);
    return ip;

def is_static(if_cfg):
    import re;
    all_the_text = open(if_cfg).read( )     
    pattern=re.compile('BOOTPROTO.*static');
    match=pattern.search(all_the_text)
    if match: 
        return 1;
    return None;

def append_static_lines(cfg_file, ip):
    os.system("sed 's/ONBOOT=no/#ONBOOT=no/g'  -i  %s "%cfg_file );

    fh = open(cfg_file, 'a')
    string="""
ONBOOT=yes
BOOTPROTO=static
IPADDR=%s
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS=8.8.8.8
NM_CONTROLLED="no"
"""%(ip);
    fh.write("%s\n"%( string) )
    fh.close(); 


for file in  filter(lambda x: x!=None and not x.endswith("lo"), map (lambda x: x  if os.path.isfile(x) else None, glob.glob("/etc/sysconfig/network-scripts/ifcfg-*"))):
    print file;
    if  is_static(file):
        print "STATIC: %s skip now "%file;
        next;
    ip=get_host_ip()[0];
    append_static_lines(file,  ip);
