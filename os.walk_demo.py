#!/usr/bin/python
import os;
import sys;

for  root,dirs,files in os.walk("/root/bin/"):
     print ("depth=1 %s"%root);

#sys.exit(-1);
for  root,dirs,files in os.walk("/root/bin/"):
    #dirs 
    for each in  files:
        print  ("%s/%s"%(root, each));
