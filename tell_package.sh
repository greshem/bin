if  echo $1 |grep gz ;then
tar -tzf $1  |sed 's/.*\(\..\{1,5\}\)/\1/g' |sed -ne '/^.\{1,5\}$/p' |sort |uniq -c |sort -n|tail > __error__ 
else

tar -tjf $1  |sed 's/.*\(\..\{1,5\}\)/\1/g' |sed -ne '/^.\{1,5\}$/p' |sort |uniq -c |sort -n >__error__
fi

if egrep -w '\.h|\.cpp|\.hh|\.hpp|\.pp|\.c|\.cc' __error__  ;
then 
	echo c_cpp; 
fi
