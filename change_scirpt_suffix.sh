get_all_script.pl  |xargs file |grep perl     |awk -F:  '{print $1}' |grep -v pl$ |sed 's/\(.*\)/cp \1 \1.pl/g' 
get_all_script.pl  |xargs file |grep python   |awk -F:  '{print $1}' |grep -v py$ |sed 's/\(.*\)/cp \1 \1.py/g'  
get_all_script.pl  |xargs file |grep Bourne   |awk -F:  '{print $1}' |grep -v sh$ |sed 's/\(.*\)/cp \1 \1.sh/g'  
h
