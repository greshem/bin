
echo  mkinitrd -v my_initrd_$(uname -r).img  -with=aoe --with=dm-mirror --with=ata_piix --with=libata --with=sd_mod --with=scsi_mod --with=ahci --with=usb-storage --with=sd_mod --with=sg --with=sr_mod --with=b44 --with=mptbase --with=mptscsih --with=mptspi  --with=BusLogic    $(uname -r)
mkinitrd -v my_initrd_$(uname -r).img --with=dm-mirror --with=ata_piix --with=libata --with=sd_mod --with=scsi_mod --with=ahci --with=usb-storage --with=sd_mod --with=sg --with=sr_mod --with=b44 --with=mptbase --with=mptscsih --with=mptspi  --with=BusLogic    $(uname -r)
