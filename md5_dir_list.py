#!/usr/bin/python
import os;
import hashlib;
hash_all=dict();
for root,dirs,files in os.walk("/root/bin"):
    for each in files:
        abs_path="%s/%s"%(root,each);
        b=hashlib.md5(abs_path);  
        md5_hex=b.hexdigest();
        hash_all[md5_hex]=abs_path;

for each in hash_all.keys():
    print "MD5:%s -> PATH: %s"%(each, hash_all[each]);
