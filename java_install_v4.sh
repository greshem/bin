#!/bin/bash
if [ ! -d  j2sdk1.4.2/ ];then
	./j2sdk-1.4.2-03-linux-i586.bin
fi
#./j2sdk1.4.2.sh
#cd j2sdk1.4.2_12/
CLASSPATH="/tmp2/j2sdk1.4.2/jre/lib/rt.jar:."
JAVA_HOME="/tmp2/j2sdk1.4.2/"
PATH=$PATH:"/tmp2/j2sdk1.4.2/bin"
export PATH CLASSPATH JAVA_HOME
