dd if=/dev/zero of=/home/output bs=1 count=0 seek=80G
#ls
du  /home/output
loopdev=`losetup -f`
echo $loopdev 

#losetup $loopdev /home/output
losetup $loopdev /home/output 
pvcreate $loopdev
vgcreate cinder-volumes $loopdev
pvscan

systemctl  restart cinder-api 

