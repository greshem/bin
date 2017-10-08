import glob
import os;
import  itertools;


for file in  itertools.chain(   glob.glob("*.tar.gz"), \
                                glob.glob("*.tgz")  \
                            ):
    print "echo tar -xzf  %s"%file;
    print "tar -xzf  %s"%file;


for file in  itertools.chain(   glob.glob("*.tar.bz2"), \
                                glob.glob("*.tbz"), \
                                glob.glob("*.tar.bz") \
                            ):
    print "echo tar -xjf  %s"%file;
    print "tar -xjf  %s"%file;
