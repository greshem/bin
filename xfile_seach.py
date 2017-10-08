#!/usr/bin/python
import os
import sys

import commands
# ifconfg =commands.getoutput(" ifconfig -a ");

if len(sys.argv) != 2:
    print "Usage: %s input_file" % (sys.argv[0])
    sys.exit(-1)

if not os.path.isdir("/root/eden_cache/"):
    print "/root/eden_cache/ not exits "
    sys.exit(-1)
else:
    pass
    # print "/root/eden_cache/  exits ";


os.chdir("/root/eden_cache/")
output = commands.getoutput('perl  /root/eden_cache/search_file.pl %s  ' % (sys.argv[1]))
for each in output.split("\n"):
    print each
