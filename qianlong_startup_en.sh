while [ 1 ]
do
  /bin/change_root_passwd_en.sh 
 if [ $? -eq 0 ];then
  break;
 fi
done
#######################################
while [ 1 ]
do
echo "root passwd"
 /bin/setup_en.sh
 if [ $? -eq 0 ];then
  break;
 fi

done
#######################################
echo "setup_en"
/bin/user_add_en.sh
 if [ $? -eq 0 ];then
  break;
 fi


echo "user add "

