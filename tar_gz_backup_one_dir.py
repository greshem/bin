#!/usr/bin/python
#repl 
import glob
import os;
if not os.path.isdir("__back_dir"):
    os.mkdir("__back_dir");

for file in glob.glob("*.tar.gz"):
    if " " in file:
        next;

    back_dir=file.replace(".tar.gz", "");
    if  os.path.isdir(back_dir):
        print """mv {dir}   __back_dir; 
mv {tar_gz} __back_dir """.format( dir=back_dir,  tar_gz=file );

    #if os.path.isdir(file) and  :
    #    print(file)
    #elif os.path.isfile(file)  file.endswith("tar.gz"):
    #    print "File:   {0}".format(file);
