#!/usr/bin/python
import re;
import os;
import sys;



def is_module_exist(module):
    reg_mod="\[.*%s.*\]"%(module);
    print "REGRX:%s "%(reg_mod);
    pat_module = re.compile(reg_mod)
    f=open("/etc/rsyncd.conf", "r");
    lines=f.readlines();
    for line in lines:
        if re.search(pat_module, line):
            print "#LINE %s"%(line);
            print "module %s  already exists"%(module);
            f.close();
            return 1;
    return None


def append_module(name,abs_path):
    f=open("/etc/rsyncd.conf", "a+"); 
    str="""
[%s]                   
path = %s
comment =  %s_data
"""%(name, abs_path, name);
    f.write(str);
    f.close();
    

########################################################################
if len(sys.argv) !=2:
    print "Usage: %s  input_dir "%(sys.argv[0]);
    sys.exit(0);
module=sys.argv[1];
name=None;
if module[-1]=='/':
    name=os.path.basename(os.path.dirname(module));
else:
    name=os.path.basename(module);
    

print "NAME: %s"%(name);
if module[0] != "/":
    print "input_dir %s is not abs "%(module);
    sys.exit(1);

if is_module_exist(name):
    sys.exit(0);
else:
    print "#begin to append %s "%(name);
    append_module(name, module);
    
