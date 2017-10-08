#!/usr/bin/python
VERSION=\
"""2.12.2
2.12.1
2.12.0
2.11.11
2.11.8
2.11.7
2.11.6
2.11.5
2.11.4
2.11.2
2.11.1
2.11.0
2.11.11
2.11.8
2.11.7
2.11.6
2.11.5
2.11.4
2.11.2
2.11.1
2.11.0
2.10.6
2.10.5
2.10.4
2.10.3
2.10.2
2.10.1"""
for each in   VERSION.split("\n"):
    print """wget https://downloads.lightbend.com/scala/{0}/scala-{0}.tgz""".format(each);


DATA="""
"""
print DATA; 
