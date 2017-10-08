import glob
import os;
for file in glob.glob("*"):
    if os.path.isdir(file) and  os.path.isdir(file+"/.git/")  :
        print "mv %s  %s  "%(file,   "git_linux_src");
