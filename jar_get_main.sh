#!/bin/bash
#2011_02_10 add by greshem
# 对于 依赖其他 jar 包才可以运行起来的jar 包这里没有做处理, 
# 例如会对 lucene-2.0.0 的demo 包产生误判， 因为 用了 lucene-core-2.0.0.jar，包 
# 之后所有的都没有问题了. 

foo ()
{
	$in=$1;
	for each in $(cat $in  ); 
	do 
		 echo $each;  
	done 
}
########################################################################
#mainloop 

if [ !  $# -eq 1 ];then
	echo "Usage: ", $0 , "in";
	exit 
fi

in=$1;

for each in $(jar -tf $in|grep class$)
do
	#echo "#".$each
	class=$(echo $each |sed 's/\//./g' |sed 's/\.class//g' );
	#echo -n  "java -classpath "$in "   ";
	 if java -classpath $in  $class 2>&1 |grep -i main > /dev/null ;then
		#echo "#" $class " #no main";
        touch /dev/null
		touch /dev/null
	 else
		echo "java -classpath "$in " "$class;
		echo "java -classpath "$in " "$class >>   /tmp/jar_cmdline_.log
	fi
done


