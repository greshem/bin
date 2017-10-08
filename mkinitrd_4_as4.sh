#echo mkinitrd -v --with=dm-mirror --with=ata_piix --with=libata --with=sd_mod --with=scsi_mod --with=ahci --with=usb-storage --with=sd_mod --with=sg --with=sr_mod --with=b44 --with=mptbase --with=mptscsih --with=mptspi  --with=BusLogic    my_initrd_3.6.9-67.img 2.6.9-67.ELsmp	
mkinitrd -v initrd_2.6.9.img --with=dm-mirror  --with=libata --with=sd_mod --with=scsi_mod --with=usb-storage --with=sd_mod --with=sg --with=sr_mod --with=b44 --with=sata_nv 2.6.9

#--with=BusLogic  

#--with=ahci 
#--with=mptbase --with=mptscsih --with=mptspi 
#--with=ata_piix 
#sd_mod                 20033  3 
#scsi_mod              146193  2 libata,sd_mod
