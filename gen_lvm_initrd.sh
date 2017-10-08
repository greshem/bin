#!/bin/sh
#####
#mkinitrd -v initrd_$(uname -r).img --with=dm-mirror --with=ata_piix --with=libata --with=sd_mod --with=scsi_mod --with=ahci --with=usb-storage --with=sd_mod --with=sg --with=sr_mod --with=b44 $(uname -r)
mkinitrd -v initrd_my.img --with=dm-mirror --with=ata_piix --with=libata --with=sd_mod --with=scsi_mod --with=ahci --with=usb-storage --with=sd_mod --with=sg --with=sr_mod --with=b44 $(uname -r)
#cp /sbin/lvm.static ./
#ln -s lvm.static  lvm 
#####################
#append last to init
###############################
#/bin/mkinitrd2.sh to generate a initrd image 
#to append as last
mkdir dir
cd dir	

cpio -i < ../initrd_my.img
######
cat >> init <<EOF
mkdmnod
echo Scanning logical volumes
lvm vgscan --ignorelockingfailure
echo Activating logical volumes
lvm vgchange -ay --ignorelockingfailure VolGroup00
EOF

####################################
find ./ |cpio -o -c > ../initrd_my.img
###########
#mkinitrd --nocompress test.initrd 2.6.9-42.ELsmp --with=ahci --with=dm-mirror --with=ata_piix --with=libata --with=sd_mod --with=scsi_mod
