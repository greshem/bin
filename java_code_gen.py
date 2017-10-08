#!/usr/bin/python
import sys, os

if len(sys.argv)!=2:
    print "Usage: %s  input_name ";
    sys.exit(-1);
name=sys.argv[1];
#print(name);


DATA="""
class {TEMPLATE}
{{
    public static void main(String args[])
    {{
        String s="{TEMPLATE}";
        System.out.println(s);
    }}
}}""".format(TEMPLATE=name);


fh = open("./%s.java"%name, 'a')
fh.write("%s\n"%( DATA) )
fh.close();

print "#run as follow";
print "javac %s.java\n"%(name);
print "java  %s\n"%(name);

