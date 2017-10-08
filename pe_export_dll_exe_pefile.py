#!/usr/bin/python
import pefile;
import sys;
p='ntfs.sys';
print "#Deal with file %s\n"%sys.argv[1];
a=pefile.PE(sys.argv[1]);
print a;
