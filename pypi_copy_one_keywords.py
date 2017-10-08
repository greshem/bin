#!/usr/bin/python 
import glob;
import os;
def get_pypi_name_from_file(output):
    for  each in open(output).readlines():
        if not os.path.isdir("%s_output"%output):
            os.mkdir("%s_output"%output);
        if not  '(' in each:
            continue;
            
        array=each.split();
        #print each;
        if(len(array)>0):
            print  "cp  -a -r /tmp3/pypi/%s %s_output/"%(array[0].lower(), output);
        
print "search pypy_index_* ";

for each in glob.glob("pypi_index_*"):
    if os.path.isfile(each):
        if each.endswith(".pl") or each.endswith(".py"):
            print "FFFF %s "%(each);
            continue;
        get_pypi_name_from_file(each);
        #print "mkdir  %s_output"%(each);
        #print  each;
    


