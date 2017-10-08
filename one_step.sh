#!/bin/bash
RPM_PATH="/root/richtech-scripts_rpm/richtech-scirpts-1.0.1/"

cp *.sh  $RPM_PATH
cp *.pl $RPM_PATH
cp *.sh  /bin/
cp *.pl /bin/


gzip -f   /root/richtech-scripts_rpm/richtech-scirpts-1.0.1/*.pl 
	
cd  /root/richtech-scripts_rpm/
make
	


cd /tmp2/f13_distribution_x86_64/
createrepo -g repodata/Fedora-13-comps.xml /tmp2/f13_distribution_x86_64
mkisofs -r -N -L -d -J -T -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot  -V "richtech_full_disk" -boot-load-size 4 -boot-info-table  -o /tmp/as5.iso $(pwd)
