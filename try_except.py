#!/usr/bin/python 

try:
    print each;
except: 
    info=sys.exc_info()
    print info[0],":",info[1]
    LOG.error("%s:%s"%(info[0], info[1]));


def method_2()
    try:
        f = open(file, 'r')
        words = f.read()
        f.close()
    except Exception, e:
        print "Exception: %s" % e
