find $1  -type f  |sed 's/.*\(\..\{1,5\}\)/\1/g' |sed -ne '/^.\{1,5\}$/p' |sort |uniq -c |sort -n|tail > __error__ 

#tar -tjf $1  |sed 's/.*\(\..\{1,5\}\)/\1/g' |sed -ne '/^.\{1,5\}$/p' |sort |uniq -c |sort -n |tail >__error__


cat __error__ |stat_prog_lang.pl
exit $?
