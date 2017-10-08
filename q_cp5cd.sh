for ((i=1;i<=5;i++))
do
 while [ 1 -eq 1 ]
  do
  mount -t iso9660 /dev/cdrom /mnt/cdrom 
 
  if [ $? -eq 0 ];then
    echo "the $i th is ready "
    break 
  else 
   echo "the $i cd is not ready"
   echo "please insert it" 
   sleep 10
 fi
 
 done
cp /dev/cdrom $i.iso
eject 
done
