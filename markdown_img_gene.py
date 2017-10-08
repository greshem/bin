import glob
import os;
import sys;



import sys, os
if len(sys.argv)!=2:
    print "Usage: %s  input_name ";
    sys.exit(-1);
name=sys.argv[1];

import os
if not  os.path.isdir(name):
    sys.exit(-1);


pics=[ ".gif", ".png", ".jpeg", ".jpg", ".bmp", ".gdib", ".emf", ".icb", ".ico", ".pbm", ".pcd", ".pcx", ".pgm", ".ppm", ".psd", ".psp", ".rle", ".sgi", ".tga", ".tif", ];

for file in glob.glob("%s/*"%name):
    suffix=os.path.splitext(file)[1] 
    #print suffix;
    
    if os.path.isfile(file) and  suffix.lower()  in pics:
        basename=os.path.basename(file)
        basename.replace(suffix, "");
        print "![%s](%s)"%(basename,file);

        #print "File:   {0}".format(file);



