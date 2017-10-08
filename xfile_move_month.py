import time;
def get_cur_month():
    return time.strftime("_xfile_%Y_%m",time.localtime())

import glob
import os;
for file in glob.glob("*"):
    if os.path.isfile(file):
        print "mv    {0} {1} ".format(file, get_cur_month());
