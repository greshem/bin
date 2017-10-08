if  echo $1 |grep gz >/dev/null;then
tar -tzf $1  |awk -F\/   '{print $1}' |uniq  >__temp_uniq__
cat __temp_uniq__ | wc -l > __temp_wc__
a=$(cat __temp_wc__);
rm -f __temp_wc__
cat __temp_uniq__
rm __temp_uniq__    
exit $a
else

tar -tjf $1  |awk -F\/   '{print $1}' |uniq  >__temp_uniq__
cat __temp_uniq__ |wc -l > __temp_wc__
a=$(cat __temp_wc__);
rm -f __temp_wc__
cat __temp_uniq__
rm __temp_uniq__    
exit $a

fi


