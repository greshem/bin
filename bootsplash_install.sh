pum bootsplash
mount -t nfs 192.168.3.189:/usr/source/as5.0 /nfs -o nolock
cp /nfs/config_2.6.20_1 /root/linux_src/linux-2.6.20/.config
patch -p1 </root/linux_src/bootsplash-3.1.6-2.6.20.diff
mkdir -p /etc/bootsplash/themes/nature/
tar -xjvf /root/linux_src/bootsplash-nature.tar.bz2 -C /etc/bootsplash/themes/nature/
tar -xjvf /root/bootsplash-3.0.7.tar.bz2
make -C /root/linux_src/bootsplash-3.0.7/Utilities/
tar -xjvf /root/linux_src/bootsplash-3.0.7.tar.bz2 -C /root/linux_src/
cp /root/linux_src/bootsplash-3.0.7/Utilities/splash /bin
splash -s -f /etc/bootsplash/themes/nature/config/bootsplash-1024x768.cfg >>/boot/initrd.splash

/sbin/splash -s -u -n /etc/bootsplash/themes/current/config/bootsplash-640x480.cfg
/sbin/splash -s -u -n bootsplash-640x480.cfg
/sbin/splash -s -u -n bootsplash-640x480_qianlong.cfg
/sbin/splash -s -f bootsplash-640x480_qianlong.cfg
PATH=$PATH:/sbin:/usr/sbin
