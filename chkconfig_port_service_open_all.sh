
for each in $(chkconfig --list |awk '{print $1}'  |sed 's/://g'  ); 
do 
echo chkconfig --level 3 $each  on ; 
echo chkconfig --level 5 $each  on ; 
done
