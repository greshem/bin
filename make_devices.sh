#!/bin/sh

#Compiled by Matthias S. Benkmann.
#(The comments were taken mostly from devices.txt.)

#This file is a more or less complete listing of all devices you can create
#under Linux. They are listed as mknod(1) commands (see manpage) most of
#which are commented. It is expected that you go through this file and
#activate the mknod lines for the devices you want to create.

#ATTENTION! By default, the old-style pty masters and slaves are not
#created. It is assumed that you configure your kernel with Unix98 pty support
#and mount the devpts file system with `mount -t devpts devpts /dev/pts' (or
#place an entry in /etc/fstab )
#If you want to use old-style ptys, you have to enable the creation of the 
#respective devices below (search for "Pseudo-TTY").

#Note: The absence of ptys will not prevent you from booting successfully
#or working at the console, so it is not critical to decide which type of
#ptys you want right now. 
#However applications like xterm and ssh need ptys, so 
#eventually you will have to activate either old-style or Unix98 ptys.

#############################################################################
# The following section contains some preparatory code. 
# If you're in a hurry, skip the next 100 lines to get to the device list.
#############################################################################


#Following are the groups used for the devices. The group is relevant when a 
#device is group-readable and/or group-writeable. In that case a setgid <group>
#program can access the respective device files even when started by a 
#non-root user.
#In the following assignments, the left side lists the groups as they are
#used in this file and the right file lists the corresponding group as defined
#on the system (usually in /etc/group).

audio=audio
cdrom=disk
system=sys
console=tty
dialout=dialout
disk=disk
floppy=floppy
ibcs2=root
mouse=root
game=$mouse
private=root
public=root
readable=root
video=root
obscure=root
symlinks=root
generic=disk
vcs=tty
tty=tty
kmem=kmem
printer=lp
tape=tape

#The following is a list of all group names used on the left side of 
#the above assignment block.
#If you add a new group above, don't forget to add it here, too.

groups='audio cdrom system console dialout disk floppy ibcs2 mouse
     game private public readable video obscure symlinks generic
     vcs tty kmem printer tape'

set -u  #treat unset variables as error

#Delete all devices whose creation is enabled, so that they are re-created
#properly (mknod does not have a -f option). Devices that are not enabled
#will NOT be deleted, so disabling a device and re-running make_devices
#will NOT remove that device.

sh -c "`sed -n $'s/^[ \t]*''mknod -m $MODE \([^ ]*\) .*/rm -f \1/p' $0`"

#Test if group name resolution works and if not, fall back to manual
#resolution using /etc/group.
#Do not use `id -gn root 2>/dev/null` because /dev/null might not exist yet.

if [ "`id -gn root 2>&1`" != "root" ]; then
  getgid() {
    line=`grep ^$1: /etc/group` || { echo $1 ; return 1; }
    echo "$line" | cut -d : -f 3
  }

  echo 1>&2 'NOTICE: Resolving group names using /etc/group'

  for g in $groups ; 
  do
    eval $g=`getgid ${!g}`
  done	 
fi


#############################################################################
#                                                                           #
#              T H E    B I G    D E V I C E    L I S T                     #
#                                                                           #
#############################################################################

#############################################################################
GROUP=$console ; MODE=620
#############################################################################

#****************************************************************************
#                         TTY devices
#****************************************************************************

    # Current virtual console
mknod -m $MODE tty0 c 4 0 ; chgrp $GROUP tty0

    # First virtual console
mknod -m $MODE tty1 c 4 1 ; chgrp $GROUP tty1
mknod -m $MODE tty2 c 4 2 ; chgrp $GROUP tty2
mknod -m $MODE tty3 c 4 3 ; chgrp $GROUP tty3
mknod -m $MODE tty4 c 4 4 ; chgrp $GROUP tty4
mknod -m $MODE tty5 c 4 5 ; chgrp $GROUP tty5
mknod -m $MODE tty6 c 4 6 ; chgrp $GROUP tty6
mknod -m $MODE tty7 c 4 7 ; chgrp $GROUP tty7
mknod -m $MODE tty8 c 4 8 ; chgrp $GROUP tty8
    # mknod -m $MODE tty9 c 4 9 ; chgrp $GROUP tty9
    # mknod -m $MODE tty10 c 4 10 ; chgrp $GROUP tty10
    # mknod -m $MODE tty11 c 4 11 ; chgrp $GROUP tty11
    # mknod -m $MODE tty12 c 4 12 ; chgrp $GROUP tty12
    # mknod -m $MODE tty13 c 4 13 ; chgrp $GROUP tty13
    # mknod -m $MODE tty14 c 4 14 ; chgrp $GROUP tty14
    # mknod -m $MODE tty15 c 4 15 ; chgrp $GROUP tty15
    # mknod -m $MODE tty16 c 4 16 ; chgrp $GROUP tty16
    # mknod -m $MODE tty17 c 4 17 ; chgrp $GROUP tty17
    # mknod -m $MODE tty18 c 4 18 ; chgrp $GROUP tty18
    # mknod -m $MODE tty19 c 4 19 ; chgrp $GROUP tty19
    # mknod -m $MODE tty20 c 4 20 ; chgrp $GROUP tty20
    # mknod -m $MODE tty21 c 4 21 ; chgrp $GROUP tty21
    # mknod -m $MODE tty22 c 4 22 ; chgrp $GROUP tty22
    # mknod -m $MODE tty23 c 4 23 ; chgrp $GROUP tty23
    # mknod -m $MODE tty24 c 4 24 ; chgrp $GROUP tty24
    # mknod -m $MODE tty25 c 4 25 ; chgrp $GROUP tty25
    # mknod -m $MODE tty26 c 4 26 ; chgrp $GROUP tty26
    # mknod -m $MODE tty27 c 4 27 ; chgrp $GROUP tty27
    # mknod -m $MODE tty28 c 4 28 ; chgrp $GROUP tty28
    # mknod -m $MODE tty29 c 4 29 ; chgrp $GROUP tty29
    # mknod -m $MODE tty30 c 4 30 ; chgrp $GROUP tty30
    # mknod -m $MODE tty31 c 4 31 ; chgrp $GROUP tty31
    # mknod -m $MODE tty32 c 4 32 ; chgrp $GROUP tty32
    # mknod -m $MODE tty33 c 4 33 ; chgrp $GROUP tty33
    # mknod -m $MODE tty34 c 4 34 ; chgrp $GROUP tty34
    # mknod -m $MODE tty35 c 4 35 ; chgrp $GROUP tty35
    # mknod -m $MODE tty36 c 4 36 ; chgrp $GROUP tty36
    # mknod -m $MODE tty37 c 4 37 ; chgrp $GROUP tty37
    # mknod -m $MODE tty38 c 4 38 ; chgrp $GROUP tty38
    # mknod -m $MODE tty39 c 4 39 ; chgrp $GROUP tty39
    # mknod -m $MODE tty40 c 4 40 ; chgrp $GROUP tty40
    # mknod -m $MODE tty41 c 4 41 ; chgrp $GROUP tty41
    # mknod -m $MODE tty42 c 4 42 ; chgrp $GROUP tty42
    # mknod -m $MODE tty43 c 4 43 ; chgrp $GROUP tty43
    # mknod -m $MODE tty44 c 4 44 ; chgrp $GROUP tty44
    # mknod -m $MODE tty45 c 4 45 ; chgrp $GROUP tty45
    # mknod -m $MODE tty46 c 4 46 ; chgrp $GROUP tty46
    # mknod -m $MODE tty47 c 4 47 ; chgrp $GROUP tty47
    # mknod -m $MODE tty48 c 4 48 ; chgrp $GROUP tty48
    # mknod -m $MODE tty49 c 4 49 ; chgrp $GROUP tty49
    # mknod -m $MODE tty50 c 4 50 ; chgrp $GROUP tty50
    # mknod -m $MODE tty51 c 4 51 ; chgrp $GROUP tty51
    # mknod -m $MODE tty52 c 4 52 ; chgrp $GROUP tty52
    # mknod -m $MODE tty53 c 4 53 ; chgrp $GROUP tty53
    # mknod -m $MODE tty54 c 4 54 ; chgrp $GROUP tty54
    # mknod -m $MODE tty55 c 4 55 ; chgrp $GROUP tty55
    # mknod -m $MODE tty56 c 4 56 ; chgrp $GROUP tty56
    # mknod -m $MODE tty57 c 4 57 ; chgrp $GROUP tty57
    # mknod -m $MODE tty58 c 4 58 ; chgrp $GROUP tty58
    # mknod -m $MODE tty59 c 4 59 ; chgrp $GROUP tty59
    # mknod -m $MODE tty60 c 4 60 ; chgrp $GROUP tty60
    # mknod -m $MODE tty61 c 4 61 ; chgrp $GROUP tty61
    # mknod -m $MODE tty62 c 4 62 ; chgrp $GROUP tty62
    # 63rd virtual console
    # mknod -m $MODE tty63 c 4 63 ; chgrp $GROUP tty63


#****************************************************************************
#                         Alternate TTY devices
#****************************************************************************

    # System console
mknod -m $MODE console c 5 1 ; chgrp $GROUP console

#****************************************************************************
#                         Universal frame buffer
#****************************************************************************

    # First frame buffer
    # mknod -m $MODE fb0 c 29 0 ; chgrp $GROUP fb0
    # Second frame buffer
    # mknod -m $MODE fb1 c 29 1 ; chgrp $GROUP fb1
    # ...
    # 32nd frame buffer 
    # mknod -m $MODE fb31 c 29 31 ; chgrp $GROUP fb31



#############################################################################
GROUP=$console ; MODE=666
#############################################################################

#****************************************************************************
#                         Alternate TTY devices
#****************************************************************************

    # Current TTY device
mknod -m $MODE tty c 5 0 ; chgrp $GROUP tty



#############################################################################
GROUP=$vcs ; MODE=660
#############################################################################

#****************************************************************************
#                         Virtual console capture devices
#****************************************************************************

    # Current vc text contents
    # mknod -m $MODE vcs c 7 0 ; chgrp $GROUP vcs

    # tty1 text contents
    # mknod -m $MODE vcs1 c 7 1 ; chgrp $GROUP vcs1
    # mknod -m $MODE vcs2 c 7 2 ; chgrp $GROUP vcs2
    # mknod -m $MODE vcs3 c 7 3 ; chgrp $GROUP vcs3
    # mknod -m $MODE vcs4 c 7 4 ; chgrp $GROUP vcs4
    # mknod -m $MODE vcs5 c 7 5 ; chgrp $GROUP vcs5
    # mknod -m $MODE vcs6 c 7 6 ; chgrp $GROUP vcs6
    # mknod -m $MODE vcs7 c 7 7 ; chgrp $GROUP vcs7
    # mknod -m $MODE vcs8 c 7 8 ; chgrp $GROUP vcs8
    # ...
    # tty63 text contents
    # mknod -m $MODE vcs63 c 7 63 ; chgrp $GROUP vcs63

    # Current vc text/attribute contents
    # mknod -m $MODE vcsa c 7 128 ; chgrp $GROUP vcsa

    # tty1 text/attribute contents
    # mknod -m $MODE vcsa1 c 7 129 ; chgrp $GROUP vcsa1
    # mknod -m $MODE vcsa2 c 7 130 ; chgrp $GROUP vcsa2
    # mknod -m $MODE vcsa3 c 7 131 ; chgrp $GROUP vcsa3
    # mknod -m $MODE vcsa4 c 7 132 ; chgrp $GROUP vcsa4
    # mknod -m $MODE vcsa5 c 7 133 ; chgrp $GROUP vcsa5
    # mknod -m $MODE vcsa6 c 7 134 ; chgrp $GROUP vcsa6
    # mknod -m $MODE vcsa7 c 7 135 ; chgrp $GROUP vcsa7
    # mknod -m $MODE vcsa8 c 7 136 ; chgrp $GROUP vcsa8
    # ...
    # tty63 text/attribute contents 
    # mknod -m $MODE vcsa63 c 7 191 ; chgrp $GROUP vcsa63

#############################################################################
GROUP=$tty ; MODE=666
#############################################################################

#****************************************************************************
#                         Alternate TTY devices
#****************************************************************************

    # PTY master multiplex
mknod -m $MODE ptmx c 5 2 ; chgrp $GROUP ptmx




#############################################################################
GROUP=$disk ; MODE=660
#############################################################################

#****************************************************************************
#                         RAM disk
#****************************************************************************

    # First RAM disk
mknod -m $MODE ram0 b 1 0 ; chgrp $GROUP ram0
    # Second RAM disk
mknod -m $MODE ram1 b 1 1 ; chgrp $GROUP ram1
    # mknod -m $MODE ram2 b 1 2 ; chgrp $GROUP ram2
    # mknod -m $MODE ram3 b 1 3 ; chgrp $GROUP ram3
    # ...

    # Initial RAM disk {2.6} 
    # mknod -m $MODE initrd b 1 250 ; chgrp $GROUP initrd

#****************************************************************************
#                         Slow memory ramdisk
#****************************************************************************

    # Slow memory ramdisk 
    # mknod -m $MODE slram b 35 0 ; chgrp $GROUP slram

#****************************************************************************
#                         Zorro II ramdisk
#****************************************************************************

    # Zorro II ramdisk 
    # mknod -m $MODE z2ram b 37 0 ; chgrp $GROUP z2ram

#****************************************************************************
#                         Loopback devices
#****************************************************************************

    # First loopback device
mknod -m $MODE loop0 b 7 0 ; chgrp $GROUP loop0
    # Second loopback device 
mknod -m $MODE loop1 b 7 1 ; chgrp $GROUP loop1
    # ...

#****************************************************************************
#                         MFM, RLL and IDE hard disk/CD-ROM interface
#****************************************************************************

    # First MFM/RLL/IDE disk whole disk (or CD-ROM)
mknod -m $MODE hda b 3 0 ; chgrp $GROUP hda
    # First partition on hda
mknod -m $MODE hda1 b 3 1 ; chgrp $GROUP hda1
    # Second partition on hda
mknod -m $MODE hda2 b 3 2 ; chgrp $GROUP hda2
mknod -m $MODE hda3 b 3 3 ; chgrp $GROUP hda3
mknod -m $MODE hda4 b 3 4 ; chgrp $GROUP hda4
mknod -m $MODE hda5 b 3 5 ; chgrp $GROUP hda5
mknod -m $MODE hda6 b 3 6 ; chgrp $GROUP hda6
mknod -m $MODE hda7 b 3 7 ; chgrp $GROUP hda7
    # ...

    # Second MFM/RLL/IDE disk whole disk (or CD-ROM)
mknod -m $MODE hdb b 3 64 ; chgrp $GROUP hdb
    # First partition on hdb
mknod -m $MODE hdb1 b 3 65 ; chgrp $GROUP hdb1
    # Second partition on hdb
mknod -m $MODE hdb2 b 3 66 ; chgrp $GROUP hdb2
mknod -m $MODE hdb3 b 3 67 ; chgrp $GROUP hdb3
mknod -m $MODE hdb4 b 3 68 ; chgrp $GROUP hdb4
mknod -m $MODE hdb5 b 3 69 ; chgrp $GROUP hdb5
mknod -m $MODE hdb6 b 3 70 ; chgrp $GROUP hdb6
mknod -m $MODE hdb7 b 3 71 ; chgrp $GROUP hdb7
    # ...

    # Third IDE disk whole disk (or CD-ROM)
    # mknod -m $MODE hdc b 22 0 ; chgrp $GROUP hdc
    # First partition on hdc
    # mknod -m $MODE hdc1 b 22 1 ; chgrp $GROUP hdc1
    # Second partition on hdc
    # mknod -m $MODE hdc2 b 22 2 ; chgrp $GROUP hdc2
    # ...

    # Fourth IDE disk whole disk (or CD-ROM)
    # mknod -m $MODE hdd b 22 64 ; chgrp $GROUP hdd
    # First partition on hdd
    # mknod -m $MODE hdd1 b 22 65 ; chgrp $GROUP hdd1
    # Second partition on hdd
    # mknod -m $MODE hdd2 b 22 66 ; chgrp $GROUP hdd2
    # ...

    # Fifth IDE disk whole disk (or CD-ROM)
    # mknod -m $MODE hde b 33 0 ; chgrp $GROUP hde
    # First partition on hde
    # mknod -m $MODE hde1 b 33 1 ; chgrp $GROUP hde1
    # Second partition on hde
    # mknod -m $MODE hde2 b 33 2 ; chgrp $GROUP hde2
    # ...

    # Sixth IDE disk whole disk (or CD-ROM)
    # mknod -m $MODE hdf b 33 64 ; chgrp $GROUP hdf
    # First partition on hdf
    # mknod -m $MODE hdf1 b 33 65 ; chgrp $GROUP hdf1
    # Second partition on hdf
    # mknod -m $MODE hdf2 b 33 66 ; chgrp $GROUP hdf2
    # ...

    # Seventh IDE disk whole disk (or CD-ROM)
    # mknod -m $MODE hdg b 34 0 ; chgrp $GROUP hdg
    # First partition on hdg
    # mknod -m $MODE hdg1 b 34 1 ; chgrp $GROUP hdg1
    # Second partition on hdg
    # mknod -m $MODE hdg2 b 34 2 ; chgrp $GROUP hdg2
    # ...

    # Eighth IDE disk whole disk (or CD-ROM) 
    # mknod -m $MODE hdh b 34 64 ; chgrp $GROUP hdh
    # First partition on hdh
    # mknod -m $MODE hdh1 b 34 65 ; chgrp $GROUP hdh1
    # Second partition on hdh
    # mknod -m $MODE hdh2 b 34 66 ; chgrp $GROUP hdh2
    # ...

#****************************************************************************
#                         SCSI disk devices (0-15)
#****************************************************************************

    # First SCSI disk whole disk
mknod -m $MODE sda b 8 0 ; chgrp $GROUP sda
    # First partition on sda
mknod -m $MODE sda1 b 8 1 ; chgrp $GROUP sda1
    # Second partition on sda
mknod -m $MODE sda2 b 8 2 ; chgrp $GROUP sda2
mknod -m $MODE sda3 b 8 3 ; chgrp $GROUP sda3
mknod -m $MODE sda4 b 8 4 ; chgrp $GROUP sda4
mknod -m $MODE sda5 b 8 5 ; chgrp $GROUP sda5
mknod -m $MODE sda6 b 8 6 ; chgrp $GROUP sda6
mknod -m $MODE sda7 b 8 7 ; chgrp $GROUP sda7
    # ...

    # Second SCSI disk whole disk
mknod -m $MODE sdb b 8 16 ; chgrp $GROUP sdb
    # First partition on sdb
mknod -m $MODE sdb1 b 8 17 ; chgrp $GROUP sdb1
    # Second partition on sdb
mknod -m $MODE sdb2 b 8 18 ; chgrp $GROUP sdb2
mknod -m $MODE sdb3 b 8 19 ; chgrp $GROUP sdb3
mknod -m $MODE sdb4 b 8 20 ; chgrp $GROUP sdb4
mknod -m $MODE sdb5 b 8 21 ; chgrp $GROUP sdb5
mknod -m $MODE sdb6 b 8 22 ; chgrp $GROUP sdb6
mknod -m $MODE sdb7 b 8 23 ; chgrp $GROUP sdb7
    # ...

    # Third SCSI disk whole disk
    # mknod -m $MODE sdc b 8 32 ; chgrp $GROUP sdc
    # First partition on sdc
    # mknod -m $MODE sdc1 b 8 33 ; chgrp $GROUP sdc1
    # Second partition on sdc
    # mknod -m $MODE sdc2 b 8 34 ; chgrp $GROUP sdc2
    # mknod -m $MODE sdc3 b 8 35 ; chgrp $GROUP sdc3
    # mknod -m $MODE sdc4 b 8 36 ; chgrp $GROUP sdc4
    # mknod -m $MODE sdc5 b 8 37 ; chgrp $GROUP sdc5
    # mknod -m $MODE sdc6 b 8 38 ; chgrp $GROUP sdc6
    # mknod -m $MODE sdc7 b 8 39 ; chgrp $GROUP sdc7
    # ...

    # mknod -m $MODE sdd b 8 48 ; chgrp $GROUP sdd
    # mknod -m $MODE sdd1 b 8 49 ; chgrp $GROUP sdd1
    # ...
    
    # mknod -m $MODE sde b 8 64 ; chgrp $GROUP sde
    # mknod -m $MODE sde1 b 8 65 ; chgrp $GROUP sde1
    # ...

    # mknod -m $MODE sdf b 8 80 ; chgrp $GROUP sdf
    # mknod -m $MODE sdf1 b 8 81 ; chgrp $GROUP sdf1
    # ...
    
    # ...
    
    # Sixteenth SCSI disk whole disk 
    # mknod -m $MODE sdp b 8 240 ; chgrp $GROUP sdp
    # First partition on sdp
    # mknod -m $MODE sdp1 b 8 241 ; chgrp $GROUP sdp1
    # Second partition on sdp
    # mknod -m $MODE sdp2 b 8 242 ; chgrp $GROUP sdp2
    # ...
    # mknod -m $MODE sdp15 b 8 255 ; chgrp $GROUP sdp15

#****************************************************************************
#                         Parallel port IDE disk devices
#****************************************************************************

    # First parallel port IDE disk
    # mknod -m $MODE pda b 45 0 ; chgrp $GROUP pda
    # First partition on pda
    # mknod -m $MODE pda1 b 45 1 ; chgrp $GROUP pda1
    # ...

    # Second parallel port IDE disk
    # mknod -m $MODE pdb b 45 16 ; chgrp $GROUP pdb
    # First partition on pdb
    # mknod -m $MODE pdb1 b 45 17 ; chgrp $GROUP pdb1
    # ...

    # Third parallel port IDE disk
    # mknod -m $MODE pdc b 45 32 ; chgrp $GROUP pdc
    # First partition on pdc
    # mknod -m $MODE pdc1 b 45 33 ; chgrp $GROUP pdc1
    # ...

    # Fourth parallel port IDE disk 
    # mknod -m $MODE pdd b 45 48 ; chgrp $GROUP pdd
    # First partition on pdd
    # mknod -m $MODE pdd1 b 45 49 ; chgrp $GROUP pdd1
    # ...

#****************************************************************************
#                         Parallel port ATAPI disk devices
#****************************************************************************

    # First parallel port ATAPI disk
    # mknod -m $MODE pf0 b 47 0 ; chgrp $GROUP pf0
    # Second parallel port ATAPI disk
    # mknod -m $MODE pf1 b 47 1 ; chgrp $GROUP pf1
    # Third parallel port ATAPI disk
    # mknod -m $MODE pf2 b 47 2 ; chgrp $GROUP pf2
    # Fourth parallel port ATAPI disk 
    # mknod -m $MODE pf3 b 47 3 ; chgrp $GROUP pf3

#****************************************************************************
#                         Metadisk (RAID) devices
#****************************************************************************

    # First metadisk group
    # mknod -m $MODE md0 b 9 0 ; chgrp $GROUP md0
    # Second metadisk group 
    # mknod -m $MODE md1 b 9 1 ; chgrp $GROUP md1
    # mknod -m $MODE md2 b 9 2 ; chgrp $GROUP md2
    # ...

#****************************************************************************
#                         DPT I2O SmartRaid V controller
#****************************************************************************

    # First DPT I2O adapter
    # mknod -m $MODE dpti0 c 151 0 ; chgrp $GROUP dpti0
    # Second DPT I2O adapter 
    # mknod -m $MODE dpti1 c 151 1 ; chgrp $GROUP dpti1
    # ...

#****************************************************************************
#                         8-bit MFM/RLL/IDE controller
#****************************************************************************

    # First XT disk whole disk
    # mknod -m $MODE xda b 13 0 ; chgrp $GROUP xda
    # First partition on xda
    # mknod -m $MODE xda1 b 13 1 ; chgrp $GROUP xda1
    # Second partition on xda
    # mknod -m $MODE xda2 b 13 2 ; chgrp $GROUP xda2
    # ...

    # Second XT disk whole disk 
    # mknod -m $MODE xdb b 13 64 ; chgrp $GROUP xdb
    # First partition on xdb
    # mknod -m $MODE xdb1 b 13 65 ; chgrp $GROUP xdb1
    # Second partition on xdb
    # mknod -m $MODE xdb2 b 13 66 ; chgrp $GROUP xdb2
    # ...
    
    # mknod -m $MODE xdc b 13 128 ; chgrp $GROUP xdc
    # mknod -m $MODE xdc1 b 13 129 ; chgrp $GROUP xdc1
    # ...

    # mknod -m $MODE xdd b 13 192 ; chgrp $GROUP xdd
    # mknod -m $MODE xdd1 b 13 193 ; chgrp $GROUP xdd1
    # ...

#****************************************************************************
#                         BIOS harddrive callback support {2.6}
#****************************************************************************

    # First BIOS harddrive whole disk
    # mknod -m $MODE dos_hda b 14 0 ; chgrp $GROUP dos_hda
    # First partition on dos_hda
    # mknod -m $MODE dos_hda1 b 14 1 ; chgrp $GROUP dos_hda1
    # ...
    
    # Second BIOS harddrive whole disk
    # mknod -m $MODE dos_hdb b 14 64 ; chgrp $GROUP dos_hdb
    # First partition on dos_hdb
    # mknod -m $MODE dos_hdb1 b 14 65 ; chgrp $GROUP dos_hdb1
    # ...
    
    # Third BIOS harddrive whole disk
    # mknod -m $MODE dos_hdc b 14 128 ; chgrp $GROUP dos_hdc
    # First partition on dos_hdc
    # mknod -m $MODE dos_hdc1 b 14 129 ; chgrp $GROUP dos_hdc1
    # ...
    
    # Fourth BIOS harddrive whole disk 
    # mknod -m $MODE dos_hdd b 14 192 ; chgrp $GROUP dos_hdd
    # First partition on dos_hdd
    # mknod -m $MODE dos_hdd1 b 14 193 ; chgrp $GROUP dos_hdd1
    # ...

#****************************************************************************
#                         ROM/flash memory card
#****************************************************************************

    # First ROM card (rw)
    # mknod -m $MODE rom0 b 31 0 ; chgrp $GROUP rom0
    # ...
    # Eighth ROM card (rw)
    # mknod -m $MODE rom7 b 31 7 ; chgrp $GROUP rom7

    # First ROM card (ro)
    # mknod -m $MODE rrom0 b 31 8 ; chgrp $GROUP rrom0
    # ...
    # Eighth ROM card (ro)
    # mknod -m $MODE rrom7 b 31 15 ; chgrp $GROUP rrom7

    # First flash memory card (rw)
    # mknod -m $MODE flash0 b 31 16 ; chgrp $GROUP flash0
    # ...
    # Eighth flash memory card (rw)
    # mknod -m $MODE flash7 b 31 23 ; chgrp $GROUP flash7

    # First flash memory card (ro)
    # mknod -m $MODE rflash0 b 31 24 ; chgrp $GROUP rflash0
    # ...
    # Eighth flash memory card (ro) 
    # mknod -m $MODE rflash7 b 31 31 ; chgrp $GROUP rflash7


#****************************************************************************
#                         MCA ESDI hard disk
#****************************************************************************

    # First ESDI disk whole disk
    # mknod -m $MODE eda b 36 0 ; chgrp $GROUP eda
    # First partition on eda
    # mknod -m $MODE eda1 b 36 1 ; chgrp $GROUP eda1
    # ...

    # Second ESDI disk whole disk 
    # mknod -m $MODE edb b 36 64 ; chgrp $GROUP edb
    # First partition on edb
    # mknod -m $MODE edb1 b 36 65 ; chgrp $GROUP edb1
    # ...

#****************************************************************************
#                         Network block devices
#****************************************************************************
# A Network Block Device is somehow similar to a loopback
# device: If you read from it, it sends packet accross
# network asking server for data. If you write to it, it
# sends packet telling server to write. It could be used
# to mounting filesystems over the net, swapping over
# the net, implementing block device in userland etc.
#****************************************************************************

    # First network block device
    # mknod -m $MODE nb0 b 43 0 ; chgrp $GROUP nb0
    # Second network block device 
    # mknod -m $MODE nb1 b 43 1 ; chgrp $GROUP nb1
    # mknod -m $MODE nb2 b 43 2 ; chgrp $GROUP nb2
    # ...

#****************************************************************************
#                         Arla network file system
#****************************************************************************

    # Arla XFS 
    # mknod -m $MODE xfs0 c 103 0 ; chgrp $GROUP xfs0

#****************************************************************************
#                         Syquest EZ135 parallel port removable drive
#****************************************************************************

    # Parallel EZ135 drive, whole disk 
    # mknod -m $MODE eza b 40 0 ; chgrp $GROUP eza

#****************************************************************************
#                         Flash Translatio Layer (FTL) filesystems
#****************************************************************************

    # FTL on first Memory Technology Device
    # mknod -m $MODE ftla b 44 0 ; chgrp $GROUP ftla
    # FTL on second Memory Technology Device
    # mknod -m $MODE ftlb b 44 16 ; chgrp $GROUP ftlb
    # FTL on third Memory Technology Device
    # mknod -m $MODE ftlc b 44 32 ; chgrp $GROUP ftlc
    # ...
    # FTL on 16th Memory Technology Device  
    # mknod -m $MODE ftlp b 44 240 ; chgrp $GROUP ftlp

#****************************************************************************
#                         Generic PDA filesystem device
#****************************************************************************
# The pda devices are used to mount filesystems on
# remote pda's (basically slow handheld machines with
# proprietary OS's and limited memory and storage
# running small fs translation drivers) through serial /
# IRDA / parallel links.
# NAMING CONFLICT WITH Parallel port IDE disk devices (major 45 b)
# -- PROPOSED REVISED NAME /dev/rpda0 etc
#****************************************************************************

    # First PDA device
    # mknod -m $MODE pda0 b 59 0 ; chgrp $GROUP pda0
    # Second PDA device 
    # mknod -m $MODE pda1 b 59 1 ; chgrp $GROUP pda1
    # ...

#****************************************************************************
#                         NAND Flash Translation Layer filesystem
#****************************************************************************

    # First NFTL layer
    # mknod -m $MODE nftla b 93 0 ; chgrp $GROUP nftla
    # Second NFTL layer
    # mknod -m $MODE nftlb b 93 16 ; chgrp $GROUP nftlb
    # ...
    # 16th NTFL layer 
    # mknod -m $MODE nftlp b 93 240 ; chgrp $GROUP nftlp

#****************************************************************************
#                         IBM S/390 DASD block storage
#****************************************************************************

    # First DASD device, major
    # mknod -m $MODE dasd0 b 95 0 ; chgrp $GROUP dasd0
    # First DASD device, block 1
    # mknod -m $MODE dasd0a b 95 1 ; chgrp $GROUP dasd0a
    # First DASD device, block 2
    # mknod -m $MODE dasd0b b 95 2 ; chgrp $GROUP dasd0b
    # First DASD device, block 3
    # mknod -m $MODE dasd0c b 95 3 ; chgrp $GROUP dasd0c

    # Second DASD device, major
    # mknod -m $MODE dasd1 b 95 4 ; chgrp $GROUP dasd1
    # Second DASD device, block 1
    # mknod -m $MODE dasd1a b 95 5 ; chgrp $GROUP dasd1a
    # Second DASD device, block 2
    # mknod -m $MODE dasd1b b 95 6 ; chgrp $GROUP dasd1b
    # Second DASD device, block 3 
    # mknod -m $MODE dasd1c b 95 7 ; chgrp $GROUP dasd1c
    
    # Third DASD device, major
    # ...

#****************************************************************************
#                         IBM S/390 VM/ESA minidisk
#****************************************************************************

    # First VM/ESA minidisk
    # mknod -m $MODE msd0 b 96 0 ; chgrp $GROUP msd0
    # Second VM/ESA minidisk 
    # mknod -m $MODE msd1 b 96 1 ; chgrp $GROUP msd1
    # ...

#****************************************************************************
#                         JavaStation flash disk
#****************************************************************************

    # JavaStation flash disk 
    # mknod -m $MODE jsfd b 99 0 ; chgrp $GROUP jsfd

#****************************************************************************
#                         "Double" compressed disk
#****************************************************************************

    # First compressed disk
    # mknod -m $MODE double0 b 19 0 ; chgrp $GROUP double0
    # ...
    # Eighth compressed disk
    # mknod -m $MODE double7 b 19 7 ; chgrp $GROUP double7

    # Mirror of first compressed disk
    # mknod -m $MODE cdouble0 b 19 128 ; chgrp $GROUP cdouble0
    # ...
    # Mirror of eighth compressed disk 
    # mknod -m $MODE cdouble7 b 19 135 ; chgrp $GROUP cdouble7

#****************************************************************************
#                         PPDD encrypted disk driver
#****************************************************************************

    # First encrypted disk
    # mknod -m $MODE ppdd0 b 92 0 ; chgrp $GROUP ppdd0
    # First partition on ppdd0
    # mknod -m $MODE ppdd01 b 92 1 ; chgrp $GROUP ppdd01
    # ...
    
    # Second encrypted disk 
    # mknod -m $MODE ppdd1 b 92 16 ; chgrp $GROUP ppdd1
    # mknod -m $MODE ppdd11 b 92 17 ; chgrp $GROUP ppdd11
    # ...
    
    # Third encrypted disk
    # ...




#############################################################################
GROUP=$generic ; MODE=660
#############################################################################

#****************************************************************************
#                         Parallel port generic ATAPI interface
#****************************************************************************

    # First parallel port ATAPI device
    # mknod -m $MODE pg0 c 97 0 ; chgrp $GROUP pg0
    # Second parallel port ATAPI device
    # mknod -m $MODE pg1 c 97 1 ; chgrp $GROUP pg1
    # Third parallel port ATAPI device
    # mknod -m $MODE pg2 c 97 2 ; chgrp $GROUP pg2
    # Fourth parallel port ATAPI device 
    # mknod -m $MODE pg3 c 97 3 ; chgrp $GROUP pg3

#****************************************************************************
#                         Generic SCSI access
#****************************************************************************

    # First generic SCSI device
    # mknod -m $MODE sg0 c 21 0 ; chgrp $GROUP sg0
    # Second generic SCSI device 
    # mknod -m $MODE sg1 c 21 1 ; chgrp $GROUP sg1
    # mknod -m $MODE sg2 c 21 2 ; chgrp $GROUP sg2
    # mknod -m $MODE sg3 c 21 3 ; chgrp $GROUP sg3
    # ...




#############################################################################
GROUP=$cdrom ; MODE=660
#############################################################################

#****************************************************************************
#                         SCSI CD-ROM devices
#****************************************************************************
    
    # First SCSI CD-ROM
mknod -m $MODE scd0 b 11 0 ; chgrp $GROUP scd0
    # Second SCSI CD-ROM
mknod -m $MODE scd1 b 11 1 ; chgrp $GROUP scd1
    # ...
    
    # Alternative names for SCSI CD-ROMs (_hard_ links)
ln -fn scd0 sr0 ; chgrp $GROUP sr0
ln -fn scd1 sr1 ; chgrp $GROUP sr1
    # ...

#****************************************************************************
#                         SCSI media changer
#****************************************************************************

    # First SCSI media changer
    # mknod -m $MODE sch0 c 86 0 ; chgrp $GROUP sch0
    # Second SCSI media changer 
    # mknod -m $MODE sch1 c 86 1 ; chgrp $GROUP sch1
    # ...

#****************************************************************************
#                         Packet writing for CD/DVD devices
#****************************************************************************

    # First packet-writing module
    # mknod -m $MODE pktcdvd0 b 97 0 ; chgrp $GROUP pktcdvd0
    # Second packet-writing module 
    # mknod -m $MODE pktcdvd1 b 97 1 ; chgrp $GROUP pktcdvd1
    # ...

#****************************************************************************
#                         MSCDEX CD-ROM callback support {2.6}
#****************************************************************************

    # First MSCDEX CD-ROM
    # mknod -m $MODE dos_cd0 b 12 0 ; chgrp $GROUP dos_cd0
    # Second MSCDEX CD-ROM 
    # mknod -m $MODE dos_cd1 b 12 1 ; chgrp $GROUP dos_cd1
    # ...

#****************************************************************************
#                         GoldStar CD-ROM
#****************************************************************************

    # GoldStar CD-ROM 
    # mknod -m $MODE gscd b 16 0 ; chgrp $GROUP gscd

#****************************************************************************
#                         First Matsushita (Panasonic/SoundBlaster) CD-ROM
#****************************************************************************

    # Panasonic CD-ROM controller 0 unit 0
    # mknod -m $MODE sbpcd0 b 25 0 ; chgrp $GROUP sbpcd0
    # Panasonic CD-ROM controller 0 unit 1
    # mknod -m $MODE sbpcd1 b 25 1 ; chgrp $GROUP sbpcd1
    # Panasonic CD-ROM controller 0 unit 2
    # mknod -m $MODE sbpcd2 b 25 2 ; chgrp $GROUP sbpcd2
    # Panasonic CD-ROM controller 0 unit 3 
    # mknod -m $MODE sbpcd3 b 25 3 ; chgrp $GROUP sbpcd3

#****************************************************************************
#                         Second Matsushita (Panasonic/SoundBlaster) CD-ROM
#****************************************************************************

    # Panasonic CD-ROM controller 1 unit 0
    # mknod -m $MODE sbpcd4 b 26 0 ; chgrp $GROUP sbpcd4
    # Panasonic CD-ROM controller 1 unit 1
    # mknod -m $MODE sbpcd5 b 26 1 ; chgrp $GROUP sbpcd5
    # Panasonic CD-ROM controller 1 unit 2
    # mknod -m $MODE sbpcd6 b 26 2 ; chgrp $GROUP sbpcd6
    # Panasonic CD-ROM controller 1 unit 3 
    # mknod -m $MODE sbpcd7 b 26 3 ; chgrp $GROUP sbpcd7

#****************************************************************************
#                         Third Matsushita (Panasonic/SoundBlaster) CD-ROM
#****************************************************************************

    # Panasonic CD-ROM controller 2 unit 0
    # mknod -m $MODE sbpcd8 b 27 0 ; chgrp $GROUP sbpcd8
    # Panasonic CD-ROM controller 2 unit 1
    # mknod -m $MODE sbpcd9 b 27 1 ; chgrp $GROUP sbpcd9
    # Panasonic CD-ROM controller 2 unit 2
    # mknod -m $MODE sbpcd10 b 27 2 ; chgrp $GROUP sbpcd10
    # Panasonic CD-ROM controller 2 unit 3 
    # mknod -m $MODE sbpcd11 b 27 3 ; chgrp $GROUP sbpcd11

#****************************************************************************
#                         Fourth Matsushita (Panasonic/SoundBlaster) CD-ROM
#****************************************************************************

    # Panasonic CD-ROM controller 3 unit 0
    # mknod -m $MODE sbpcd12 b 28 0 ; chgrp $GROUP sbpcd12
    # Panasonic CD-ROM controller 3 unit 1
    # mknod -m $MODE sbpcd13 b 28 1 ; chgrp $GROUP sbpcd13
    # Panasonic CD-ROM controller 3 unit 2
    # mknod -m $MODE sbpcd14 b 28 2 ; chgrp $GROUP sbpcd14
    # Panasonic CD-ROM controller 3 unit 3
    # mknod -m $MODE sbpcd15 b 28 3 ; chgrp $GROUP sbpcd15

#****************************************************************************
#                         Aztech/Orchid/Okano/Wearnes CD-ROM
#****************************************************************************

    # Aztech CD-ROM 
    # mknod -m $MODE aztcd b 29 0 ; chgrp $GROUP aztcd

#****************************************************************************
#                         Philips LMS CM-205 CD-ROM
#****************************************************************************

    # Philips LMS CM-205 CD-ROM 
    # mknod -m $MODE cm205cd b 30 0 ; chgrp $GROUP cm205cd

#****************************************************************************
#                         Philips LMS CM-206 CD-ROM
#****************************************************************************

    # Philips LMS CM-206 CD-ROM 
    # mknod -m $MODE cm206cd b 32 0 ; chgrp $GROUP cm206cd

#****************************************************************************
#                         Parallel port ATAPI CD-ROM devices
#****************************************************************************

    # First parallel port ATAPI CD-ROM
    # mknod -m $MODE pcd0 b 46 0 ; chgrp $GROUP pcd0
    # Second parallel port ATAPI CD-ROM
    # mknod -m $MODE pcd1 b 46 1 ; chgrp $GROUP pcd1
    # Third parallel port ATAPI CD-ROM
    # mknod -m $MODE pcd2 b 46 2 ; chgrp $GROUP pcd2
    # Fourth parallel port ATAPI CD-ROM 
    # mknod -m $MODE pcd3 b 46 3 ; chgrp $GROUP pcd3

#****************************************************************************
#                         Hitachi CD-ROM (under development)
#****************************************************************************

    # Hitachi CD-ROM 
    # mknod -m $MODE hitcd b 20 0 ; chgrp $GROUP hitcd

#****************************************************************************
#                         Sony CDU-31A/CDU-33A CD-ROM
#****************************************************************************

    # Sony CDU-31a CD-ROM 
    # mknod -m $MODE sonycd b 15 0 ; chgrp $GROUP sonycd

#****************************************************************************
#                         Optics Storage CD-ROM
#****************************************************************************

    # Optics Storage CD-ROM 
    # mknod -m $MODE optcd b 17 0 ; chgrp $GROUP optcd

#****************************************************************************
#                         Sanyo CD-ROM
#****************************************************************************

    # Sanyo CD-ROM 
    # mknod -m $MODE sjcd b 18 0 ; chgrp $GROUP sjcd

#****************************************************************************
#                         Mitsumi proprietary CD-ROM
#****************************************************************************

    # Mitsumi CD-ROM 
    # mknod -m $MODE mcd b 23 0 ; chgrp $GROUP mcd

#****************************************************************************
#                         Sony CDU-535 CD-ROM
#****************************************************************************

    # Sony CDU-535 CD-ROM 
    # mknod -m $MODE cdu535 b 24 0 ; chgrp $GROUP cdu535

#****************************************************************************
#                         MicroSolutions BackPack parallel port CD-ROM
#****************************************************************************

    # BackPack CD-ROM 
    # mknod -m $MODE bpcd b 41 0 ; chgrp $GROUP bpcd




#############################################################################
GROUP=$dialout ; MODE=660
#############################################################################

#****************************************************************************
#                         TTY devices
#****************************************************************************

    # First UART serial port
mknod -m $MODE ttyS0 c 4 64 ; chgrp $GROUP ttyS0
mknod -m $MODE ttyS1 c 4 65 ; chgrp $GROUP ttyS1
mknod -m $MODE ttyS2 c 4 66 ; chgrp $GROUP ttyS2
mknod -m $MODE ttyS3 c 4 67 ; chgrp $GROUP ttyS3
    # ...
    # 192nd UART serial port 
    # mknod -m $MODE ttyS191 c 4 255 ; chgrp $GROUP ttyS191

#****************************************************************************
#                         Device independent PPP interface
#****************************************************************************

    # Device independent PPP interface 
    # mknod -m $MODE ppp c 108 0 ; chgrp $GROUP ppp    

#****************************************************************************
#                         isdn4linux virtual modem
#****************************************************************************

    # First virtual modem
    # mknod -m $MODE ttyI0 c 43 0 ; chgrp $GROUP ttyI0
    # Second virtual modem
    # mknod -m $MODE ttyI1 c 43 1 ; chgrp $GROUP ttyI1
    # ...
    # 64th virtual modem 
    # mknod -m $MODE ttyI63 c 43 63 ; chgrp $GROUP ttyI63

#****************************************************************************
#                         isdn4linux ISDN BRI driver
#****************************************************************************

    # First virtual B channel raw data
    # mknod -m $MODE isdn0 c 45 0 ; chgrp $GROUP isdn0
    # mknod -m $MODE isdn1 c 45 1 ; chgrp $GROUP isdn1
    # ...
    # 64th virtual B channel raw data
    # mknod -m $MODE isdn63 c 45 63 ; chgrp $GROUP isdn63

    # First channel control/debug
    # mknod -m $MODE isdnctrl0 c 45 64 ; chgrp $GROUP isdnctrl0
    # mknod -m $MODE isdnctrl1 c 45 65 ; chgrp $GROUP isdnctrl1
    # ...
    # 64th channel control/debug
    # mknod -m $MODE isdnctrl63 c 45 127 ; chgrp $GROUP isdnctrl63

    # First SyncPPP device
    # mknod -m $MODE ippp0 c 45 128 ; chgrp $GROUP ippp0
    # mknod -m $MODE ippp1 c 45 129 ; chgrp $GROUP ippp1
    # ...
    # 64th SyncPPP device
    # mknod -m $MODE ippp63 c 45 191 ; chgrp $GROUP ippp63

    # ISDN monitor interface 
    # mknod -m $MODE isdninfo c 45 255 ; chgrp $GROUP isdninfo

#****************************************************************************
#                         USB serial converters
#****************************************************************************

    # First USB serial converter
    # mknod -m $MODE ttyUSB0 c 188 0 ; chgrp $GROUP ttyUSB0
    # Second USB serial converter 
    # mknod -m $MODE ttyUSB1 c 188 1 ; chgrp $GROUP ttyUSB1
    # ...

#****************************************************************************
#                         ACM USB modems
#****************************************************************************

    # First ACM modem
    # mknod -m $MODE ttyACM0 c 166 0 ; chgrp $GROUP ttyACM0
    # Second ACM modem 
    # mknod -m $MODE ttyACM1 c 166 1 ; chgrp $GROUP ttyACM1
    # ...

#****************************************************************************
#                         Dialogic GammaLink fax driver
#****************************************************************************

    # GammaLink channel 0
    # mknod -m $MODE gfax0 c 158 0 ; chgrp $GROUP gfax0
    # GammaLink channel 1 
    # mknod -m $MODE gfax1 c 158 1 ; chgrp $GROUP gfax1
    # ...

#****************************************************************************
#                         Telephony for Linux
#****************************************************************************

    # First telephony device
    # mknod -m $MODE phone0 c 100 0 ; chgrp $GROUP phone0

    # Second telephony device 
    # mknod -m $MODE phone1 c 100 1 ; chgrp $GROUP phone1

#****************************************************************************
#                         Spellcaster DataComm/BRI ISDN card
#****************************************************************************

    # First DataComm card
    # mknod -m $MODE dcbri0 c 52 0 ; chgrp $GROUP dcbri0
    # Second DataComm card
    # mknod -m $MODE dcbri1 c 52 1 ; chgrp $GROUP dcbri1
    # Third DataComm card
    # mknod -m $MODE dcbri2 c 52 2 ; chgrp $GROUP dcbri2
    # Fourth DataComm card 
    # mknod -m $MODE dcbri3 c 52 3 ; chgrp $GROUP dcbri3

#****************************************************************************
#                         Radio Tech BIM-XXX-RS232 radio modem
#****************************************************************************

    # First BIM radio modem
    # mknod -m $MODE bimrt0 c 163 0 ; chgrp $GROUP bimrt0
    # Second BIM radio modem 
    # mknod -m $MODE bimrt1 c 163 1 ; chgrp $GROUP bimrt1
    # ...

#****************************************************************************
#                         Chase Research AT/PCI-Fast serial card
#****************************************************************************

    # AT/PCI-Fast board 0, port 0
    # mknod -m $MODE ttyCH0 c 164 0 ; chgrp $GROUP ttyCH0
    # ...
    # AT/PCI-Fast board 0, port 15
    # mknod -m $MODE ttyCH15 c 164 15 ; chgrp $GROUP ttyCH15

    # AT/PCI-Fast board 1, port 0
    # mknod -m $MODE ttyCH16 c 164 16 ; chgrp $GROUP ttyCH16
    # ...
    # AT/PCI-Fast board 1, port 15
    # mknod -m $MODE ttyCH31 c 164 31 ; chgrp $GROUP ttyCH31

    # AT/PCI-Fast board 2, port 0
    # mknod -m $MODE ttyCH32 c 164 32 ; chgrp $GROUP ttyCH32
    # ...
    # AT/PCI-Fast board 2, port 15
    # mknod -m $MODE ttyCH47 c 164 47 ; chgrp $GROUP ttyCH47

    # AT/PCI-Fast board 3, port 0
    # mknod -m $MODE ttyCH48 c 164 48 ; chgrp $GROUP ttyCH48
    # ...
    # AT/PCI-Fast board 3, port 15 
    # mknod -m $MODE ttyCH63 c 164 63 ; chgrp $GROUP ttyCH63

#****************************************************************************
#                         Cyclades serial card
#****************************************************************************

    # First Cyclades port
    # mknod -m $MODE ttyC0 c 19 0 ; chgrp $GROUP ttyC0
    # ...
    # 32nd Cyclades port 
    # mknod -m $MODE ttyC31 c 19 31 ; chgrp $GROUP ttyC31

#****************************************************************************
#                         Moxa Intellio serial card
#****************************************************************************

    # First Moxa port
    # mknod -m $MODE ttyMX0 c 172 0 ; chgrp $GROUP ttyMX0
    # Second Moxa port
    # mknod -m $MODE ttyMX1 c 172 1 ; chgrp $GROUP ttyMX1
    # ...
    # 128th Moxa port
    # mknod -m $MODE ttyMX127 c 172 127 ; chgrp $GROUP ttyMX127

    # Moxa control port 
    # mknod -m $MODE moxactl c 172 128 ; chgrp $GROUP moxactl

#****************************************************************************
#                         Chase serial card
#****************************************************************************

    # First Chase port
    # mknod -m $MODE ttyH0 c 17 0 ; chgrp $GROUP ttyH0
    # Second Chase port 
    # mknod -m $MODE ttyH1 c 17 1 ; chgrp $GROUP ttyH1
    # mknod -m $MODE ttyH2 c 17 2 ; chgrp $GROUP ttyH2
    # ...

#****************************************************************************
#                         Digiboard serial card
#****************************************************************************

    # First Digiboard port
    # mknod -m $MODE ttyD0 c 22 0 ; chgrp $GROUP ttyD0
    # Second Digiboard port 
    # mknod -m $MODE ttyD1 c 22 1 ; chgrp $GROUP ttyD1
    # mknod -m $MODE ttyD2 c 22 2 ; chgrp $GROUP ttyD2
    # ...

#****************************************************************************
#                         Stallion serial card
#****************************************************************************

    # Stallion port 0 card 0
    # mknod -m $MODE ttyE0 c 24 0 ; chgrp $GROUP ttyE0
    # Stallion port 1 card 0
    # mknod -m $MODE ttyE1 c 24 1 ; chgrp $GROUP ttyE1
    # ...
    # Stallion port 63 card 0
    # mknod -m $MODE ttyE63 c 24 63 ; chgrp $GROUP ttyE63

    # Stallion port 0 card 1
    # mknod -m $MODE ttyE64 c 24 64 ; chgrp $GROUP ttyE64
    # Stallion port 1 card 1
    # mknod -m $MODE ttyE65 c 24 65 ; chgrp $GROUP ttyE65
    # ...
    # Stallion port 63 card 1
    # mknod -m $MODE ttyE127 c 24 127 ; chgrp $GROUP ttyE127

    # Stallion port 0 card 2
    # mknod -m $MODE ttyE128 c 24 128 ; chgrp $GROUP ttyE128
    # Stallion port 1 card 2
    # mknod -m $MODE ttyE129 c 24 129 ; chgrp $GROUP ttyE129
    # ...
    # Stallion port 63 card 2
    # mknod -m $MODE ttyE191 c 24 191 ; chgrp $GROUP ttyE191

    # Stallion port 0 card 3
    # mknod -m $MODE ttyE192 c 24 192 ; chgrp $GROUP ttyE192
    # Stallion port 1 card 3 
    # mknod -m $MODE ttyE193 c 24 193 ; chgrp $GROUP ttyE193
    # ...
    # Stallion port 63 card 3
    # mknod -m $MODE ttyE255 c 24 255 ; chgrp $GROUP ttyE255

#****************************************************************************
#                         Stallion serial card - card programming
#****************************************************************************

    # First Stallion card I/O memory
    # mknod -m $MODE staliomem0 c 28 0 ; chgrp $GROUP staliomem0
    # Second Stallion card I/O memory
    # mknod -m $MODE staliomem1 c 28 1 ; chgrp $GROUP staliomem1
    # Third Stallion card I/O memory
    # mknod -m $MODE staliomem2 c 28 2 ; chgrp $GROUP staliomem2
    # Fourth Stallion card I/O memory 
    # mknod -m $MODE staliomem3 c 28 3 ; chgrp $GROUP staliomem3

#****************************************************************************
#                         Specialix serial card
#****************************************************************************

    # First Specialix port
    # mknod -m $MODE ttyX0 c 32 0 ; chgrp $GROUP ttyX0
    # Second Specialix port 
    # mknod -m $MODE ttyX1 c 32 1 ; chgrp $GROUP ttyX1
    # mknod -m $MODE ttyX2 c 32 2 ; chgrp $GROUP ttyX2
    # ...

#****************************************************************************
#                         Comtrol Rocketport serial card
#****************************************************************************

    # First Rocketport port
    # mknod -m $MODE ttyR0 c 46 0 ; chgrp $GROUP ttyR0
    # Second Rocketport port 
    # mknod -m $MODE ttyR1 c 46 1 ; chgrp $GROUP ttyR1
    # ...

#****************************************************************************
#                         Technology Concepts serial card
#****************************************************************************

    # First TCL port
    # mknod -m $MODE ttyT0 c 148 0 ; chgrp $GROUP ttyT0
    # Second TCL port 
    # mknod -m $MODE ttyT1 c 148 1 ; chgrp $GROUP ttyT1
    # ...

#****************************************************************************
#                         SDL RISCom serial card
#****************************************************************************

    # First RISCom port
    # mknod -m $MODE ttyL0 c 48 0 ; chgrp $GROUP ttyL0
    # Second RISCom port 
    # mknod -m $MODE ttyL1 c 48 1 ; chgrp $GROUP ttyL1
    # ...

#****************************************************************************
#                         Hayes ESP serial card
#****************************************************************************

    # First ESP port
    # mknod -m $MODE ttyP0 c 57 0 ; chgrp $GROUP ttyP0
    # Second ESP port 
    # mknod -m $MODE ttyP1 c 57 1 ; chgrp $GROUP ttyP1
    # ...

#****************************************************************************
#                         Computone IntelliPort II serial card
#****************************************************************************

    # IntelliPort II board 0, port 0
    # mknod -m $MODE ttyF0 c 71 0 ; chgrp $GROUP ttyF0
    # IntelliPort II board 0, port 1
    # mknod -m $MODE ttyF1 c 71 1 ; chgrp $GROUP ttyF1
    # ...
    # IntelliPort II board 0, port 63
    # mknod -m $MODE ttyF63 c 71 63 ; chgrp $GROUP ttyF63

    # IntelliPort II board 1, port 0
    # mknod -m $MODE ttyF64 c 71 64 ; chgrp $GROUP ttyF64
    # IntelliPort II board 1, port 1
    # mknod -m $MODE ttyF65 c 71 65 ; chgrp $GROUP ttyF65
    # ...
    # IntelliPort II board 1, port 63
    # mknod -m $MODE ttyF127 c 71 127 ; chgrp $GROUP ttyF127

    # IntelliPort II board 2, port 0
    # mknod -m $MODE ttyF128 c 71 128 ; chgrp $GROUP ttyF128
    # IntelliPort II board 2, port 1
    # mknod -m $MODE ttyF129 c 71 129 ; chgrp $GROUP ttyF129
    # ...
    # IntelliPort II board 2, port 63
    # mknod -m $MODE ttyF191 c 71 191 ; chgrp $GROUP ttyF191

    # IntelliPort II board 3, port 0
    # mknod -m $MODE ttyF192 c 71 192 ; chgrp $GROUP ttyF192
    # IntelliPort II board 3, port 1
    # mknod -m $MODE ttyF193 c 71 193 ; chgrp $GROUP ttyF193
    # ...
    # IntelliPort II board 3, port 63 
    # mknod -m $MODE ttyF255 c 71 255 ; chgrp $GROUP ttyF255

#****************************************************************************
#                         Computone IntelliPort II serial card - control devices
#****************************************************************************

    # Loadware device for board 0
    # mknod -m $MODE ip2ipl0 c 73 0 ; chgrp $GROUP ip2ipl0
    # Status device for board 0
    # mknod -m $MODE ip2stat0 c 73 1 ; chgrp $GROUP ip2stat0

    # Loadware device for board 1
    # mknod -m $MODE ip2ipl1 c 73 4 ; chgrp $GROUP ip2ipl1
    # Status device for board 1
    # mknod -m $MODE ip2stat1 c 73 5 ; chgrp $GROUP ip2stat1

    # Loadware device for board 2
    # mknod -m $MODE ip2ipl2 c 73 8 ; chgrp $GROUP ip2ipl2
    # Status device for board 2
    # mknod -m $MODE ip2stat2 c 73 9 ; chgrp $GROUP ip2stat2

    # Loadware device for board 3
    # mknod -m $MODE ip2ipl3 c 73 12 ; chgrp $GROUP ip2ipl3
    # Status device for board 3 
    # mknod -m $MODE ip2stat3 c 73 13 ; chgrp $GROUP ip2stat3

#****************************************************************************
#                         Specialix IO8+ serial card
#****************************************************************************

    # First IO8+ port, first card
    # mknod -m $MODE ttyW0 c 75 0 ; chgrp $GROUP ttyW0
    # Second IO8+ port, first card
    # mknod -m $MODE ttyW1 c 75 1 ; chgrp $GROUP ttyW1
    # ...
    # mknod -m $MODE ttyW7 c 75 7 ; chgrp $GROUP ttyW7

    # First IO8+ port, second card 
    # mknod -m $MODE ttyW8 c 75 8 ; chgrp $GROUP ttyW8
    # ...

#****************************************************************************
#                         PAM Software's multimodem boards - alternate devices
#****************************************************************************

    # First ISI port
    # mknod -m $MODE ttyM0 c 79 0 ; chgrp $GROUP ttyM0
    # Second ISI port 
    # mknod -m $MODE ttyM1 c 79 1 ; chgrp $GROUP ttyM1
    # ...

#****************************************************************************
#                         Comtrol VS-1000 serial controller
#****************************************************************************

    # First VS-1000 port
    # mknod -m $MODE ttyV0 c 105 0 ; chgrp $GROUP ttyV0
    # Second VS-1000 port 
    # mknod -m $MODE ttyV1 c 105 1 ; chgrp $GROUP ttyV1
    # ...


#****************************************************************************
#                         Specialix RIO serial card
#****************************************************************************

    # First RIO port
    # mknod -m $MODE ttySR0 c 154 0 ; chgrp $GROUP ttySR0
    # ...
    # 256th RIO port 
    # mknod -m $MODE ttySR255 c 154 255 ; chgrp $GROUP ttySR255

    # 257th RIO port
    # mknod -m $MODE ttySR256 c 156 0 ; chgrp $GROUP ttySR256
    # ...
    # 512th RIO port 
    # mknod -m $MODE ttySR511 c 156 255 ; chgrp $GROUP ttySR511

#****************************************************************************
#                         SmartIO serial card
#****************************************************************************

    # First SmartIO port
    # mknod -m $MODE ttySI0 c 174 0 ; chgrp $GROUP ttySI0
    # Second SmartIO port 
    # mknod -m $MODE ttySI1 c 174 1 ; chgrp $GROUP ttySI1

#****************************************************************************
#                         COMX synchronous serial card
#****************************************************************************

    # COMX channel 0
    # mknod -m $MODE comx0 c 88 0 ; chgrp $GROUP comx0
    # COMX channel 1 
    # mknod -m $MODE comx1 c 88 1 ; chgrp $GROUP comx1
    # ...

#****************************************************************************
#                         COSA/SRP synchronous serial card
#****************************************************************************

    # 1st board, 1st channel
    # mknod -m $MODE cosa0c0 c 117 0 ; chgrp $GROUP cosa0c0
    # 1st board, 2nd channel
    # mknod -m $MODE cosa0c1 c 117 1 ; chgrp $GROUP cosa0c1
    # ...

    # 2nd board, 1st channel
    # mknod -m $MODE cosa1c0 c 117 16 ; chgrp $GROUP cosa1c0
    # 2nd board, 2nd channel 
    # mknod -m $MODE cosa1c1 c 117 17 ; chgrp $GROUP cosa1c1
    # ...

#****************************************************************************
#                         Encapsulated PPP
#****************************************************************************

    # First PPP over Ethernet
    # mknod -m $MODE pppox0 c 144 0 ; chgrp $GROUP pppox0
    # ...
    # 64th PPP over Ethernet 
    # mknod -m $MODE pppox63 c 144 63 ; chgrp $GROUP pppox63

#****************************************************************************
#                         Alternate TTY devices
#****************************************************************************

    # Callout device for ttyS0
    # mknod -m $MODE cua0 c 5 64 ; chgrp $GROUP cua0
    # mknod -m $MODE cua1 c 5 65 ; chgrp $GROUP cua1
    # mknod -m $MODE cua2 c 5 66 ; chgrp $GROUP cua2
    # mknod -m $MODE cua3 c 5 67 ; chgrp $GROUP cua3
    # ...
    # Callout device for ttyS191 
    # mknod -m $MODE cua191 c 5 255 ; chgrp $GROUP cua191

#****************************************************************************
#                         Chase serial card - alternate devices
#****************************************************************************

    # Callout device for ttyH0
    # mknod -m $MODE cuh0 c 18 0 ; chgrp $GROUP cuh0
    # Callout device for ttyH1 
    # mknod -m $MODE cuh1 c 18 1 ; chgrp $GROUP cuh1
    # ...

#****************************************************************************
#                         Cyclades serial card - alternate devices
#****************************************************************************

    # Callout device for ttyC0
    # mknod -m $MODE cub0 c 20 0 ; chgrp $GROUP cub0
    # ...
    # Callout device for ttyC31 
    # mknod -m $MODE cub31 c 20 31 ; chgrp $GROUP cub31

#****************************************************************************
#                         Digiboard serial card - alternate devices
#****************************************************************************

    # Callout device for ttyD0
    # mknod -m $MODE cud0 c 23 0 ; chgrp $GROUP cud0
    # Callout device for ttyD1 
    # mknod -m $MODE cud1 c 23 1 ; chgrp $GROUP cud1
    # ...

#****************************************************************************
#                         Stallion serial card - alternate devices
#****************************************************************************

    # Callout device for ttyE0
    # mknod -m $MODE cue0 c 25 0 ; chgrp $GROUP cue0
    # Callout device for ttyE1
    # mknod -m $MODE cue1 c 25 1 ; chgrp $GROUP cue1
    # ...
    # Callout device for ttyE64
    # mknod -m $MODE cue64 c 25 64 ; chgrp $GROUP cue64
    # Callout device for ttyE65
    # mknod -m $MODE cue65 c 25 65 ; chgrp $GROUP cue65
    # ...
    # Callout device for ttyE128
    # mknod -m $MODE cue128 c 25 128 ; chgrp $GROUP cue128
    # Callout device for ttyE129
    # mknod -m $MODE cue129 c 25 129 ; chgrp $GROUP cue129
    # ...
    # Callout device for ttyE192
    # mknod -m $MODE cue192 c 25 192 ; chgrp $GROUP cue192
    # Callout device for ttyE193 
    # mknod -m $MODE cue193 c 25 193 ; chgrp $GROUP cue193
    # ...

#****************************************************************************
#                         Specialix serial card - alternate devices
#****************************************************************************

    # Callout device for ttyX0
    # mknod -m $MODE cux0 c 33 0 ; chgrp $GROUP cux0
    # Callout device for ttyX1 
    # mknod -m $MODE cux1 c 33 1 ; chgrp $GROUP cux1
    # ...

#****************************************************************************
#                         isdn4linux virtual modem - alternate devices
#****************************************************************************

    # Callout device for ttyI0
    # mknod -m $MODE cui0 c 44 0 ; chgrp $GROUP cui0
    # ...
    # Callout device for ttyI63 
    # mknod -m $MODE cui63 c 44 63 ; chgrp $GROUP cui63

#****************************************************************************
#                         Comtrol Rocketport serial card - alternate devices
#****************************************************************************

    # Callout device for ttyR0
    # mknod -m $MODE cur0 c 47 0 ; chgrp $GROUP cur0
    # Callout device for ttyR1 
    # mknod -m $MODE cur1 c 47 1 ; chgrp $GROUP cur1
    # ...

#****************************************************************************
#                         SDL RISCom serial card - alternate devices
#****************************************************************************

    # Callout device for ttyL0
    # mknod -m $MODE cul0 c 49 0 ; chgrp $GROUP cul0
    # Callout device for ttyL1 
    # mknod -m $MODE cul1 c 49 1 ; chgrp $GROUP cul1
    # ...

#****************************************************************************
#                         Hayes ESP serial card - alternate devices
#****************************************************************************

    # Callout device for ttyP0
    # mknod -m $MODE cup0 c 58 0 ; chgrp $GROUP cup0
    # Callout device for ttyP1 
    # mknod -m $MODE cup1 c 58 1 ; chgrp $GROUP cup1
    # ...

#****************************************************************************
#                         Computone IntelliPort II serial card - alternate devices
#****************************************************************************

    # Callout device for ttyF0
    # mknod -m $MODE cuf0 c 72 0 ; chgrp $GROUP cuf0
    # Callout device for ttyF1
    # mknod -m $MODE cuf1 c 72 1 ; chgrp $GROUP cuf1
    # ...

#****************************************************************************
#                         Specialix IO8+ serial card - alternate devices
#****************************************************************************

    # Callout device for ttyW0
    # mknod -m $MODE cuw0 c 76 0 ; chgrp $GROUP cuw0
    # Callout device for ttyW1
    # mknod -m $MODE cuw1 c 76 1 ; chgrp $GROUP cuw1
    # ...
    # Callout device for ttyW8 
    # mknod -m $MODE cuw8 c 76 8 ; chgrp $GROUP cuw8

#****************************************************************************
#                         Comtrol VS-1000 serial controller - alternate devices
#****************************************************************************

    # First VS-1000 port
    # mknod -m $MODE cuv0 c 106 0 ; chgrp $GROUP cuv0
    # Second VS-1000 port 
    # mknod -m $MODE cuv1 c 106 1 ; chgrp $GROUP cuv1
    # ...

#****************************************************************************
#                         PAM Software's multimodem boards
#****************************************************************************

    # Callout device for ttyM0
    # mknod -m $MODE cum0 c 113 0 ; chgrp $GROUP cum0
    # Callout device for ttyM1 
    # mknod -m $MODE cum1 c 113 1 ; chgrp $GROUP cum1
    # ...

#****************************************************************************
#                         Technology Concepts serial card - alternate devices
#****************************************************************************

    # Callout device for ttyT1 
    # mknod -m $MODE cut0 c 149 0 ; chgrp $GROUP cut0
    # Callout device for ttyT2
    # mknod -m $MODE cut1 c 149 1 ; chgrp $GROUP cut1

#****************************************************************************
#                         Specialix RIO serial card - alternate devices
#****************************************************************************

    # Callout device for ttySR0
    # mknod -m $MODE cusr0 c 155 0 ; chgrp $GROUP cusr0
    # ...
    # Callout device for ttySR255 
    # mknod -m $MODE cusr255 c 155 255 ; chgrp $GROUP cusr255

#****************************************************************************
#                         IrCOMM devices (IrDA serial/parallel emulation)
#****************************************************************************

    # First IrCOMM device
    # mknod -m $MODE ircomm0 c 161 0 ; chgrp $GROUP ircomm0
    # Second IrCOMM device
    # mknod -m $MODE ircomm1 c 161 1 ; chgrp $GROUP ircomm1
    # ...

    # First IrLPT device
    # mknod -m $MODE irlpt0 c 161 16 ; chgrp $GROUP irlpt0
    # Second IrLPT device 
    # mknod -m $MODE irlpt1 c 161 17 ; chgrp $GROUP irlpt1
    # ...

#****************************************************************************
#                         Chase Research AT/PCI-Fast serial card - alternate devices
#****************************************************************************

    # Callout device for ttyCH0
    # mknod -m $MODE cuch0 c 165 0 ; chgrp $GROUP cuch0
    # ...
    # Callout device for ttyCH63 
    # mknod -m $MODE cuch63 c 165 63 ; chgrp $GROUP cuch63

#****************************************************************************
#                         ACM USB modems - alternate devices
#****************************************************************************

    # Callout device for ttyACM0
    # mknod -m $MODE cuacm0 c 167 0 ; chgrp $GROUP cuacm0
    # Callout device for ttyACM1 
    # mknod -m $MODE cuacm1 c 167 1 ; chgrp $GROUP cuacm1
    # ...

#****************************************************************************
#                         Moxa Intellio serial card - alternate devices
#****************************************************************************

    # Callout device for ttyMX0
    # mknod -m $MODE cumx0 c 173 0 ; chgrp $GROUP cumx0
    # Callout device for ttyMX1
    # mknod -m $MODE cumx1 c 173 1 ; chgrp $GROUP cumx1
    # ...
    # Callout device for ttyMX127 
    # mknod -m $MODE cumx127 c 173 127 ; chgrp $GROUP cumx127

#****************************************************************************
#                         SmartIO serial card - alternate devices
#****************************************************************************

    # Callout device for ttySI0
    # mknod -m $MODE cusi0 c 175 0 ; chgrp $GROUP cusi0
    # Callout device for ttySI1 
    # mknod -m $MODE cusi1 c 175 1 ; chgrp $GROUP cusi1
    # ...

#****************************************************************************
#                         USB serial converters - alternate devices
#****************************************************************************

    # Callout device for ttyUSB0
    # mknod -m $MODE cuusb0 c 189 0 ; chgrp $GROUP cuusb0
    # Callout device for ttyUSB1 
    # mknod -m $MODE cuusb1 c 189 1 ; chgrp $GROUP cuusb1
    # ...






#############################################################################
GROUP=$floppy ; MODE=660
#############################################################################

#****************************************************************************
#                         Floppy disks
#****************************************************************************

    # Controller 0, drive 0, autodetect
mknod -m $MODE fd0 b 2 0 ; chgrp $GROUP fd0
    # Controller 0, drive 1, autodetect
mknod -m $MODE fd1 b 2 1 ; chgrp $GROUP fd1 
    # Controller 0, drive 2, autodetect
    # mknod -m $MODE fd2 b 2 2 ; chgrp $GROUP fd2
    # Controller 0, drive 3, autodetect
    # mknod -m $MODE fd3 b 2 3 ; chgrp $GROUP fd3

    # Controller 1, drive 0, autodetect
    # mknod -m $MODE fd4 b 2 128 ; chgrp $GROUP fd4
    # Controller 1, drive 1, autodetect
    # mknod -m $MODE fd5 b 2 129 ; chgrp $GROUP fd5
    # Controller 1, drive 2, autodetect
    # mknod -m $MODE fd6 b 2 130 ; chgrp $GROUP fd6
    # Controller 1, drive 3, autodetect
    # mknod -m $MODE fd7 b 2 131 ; chgrp $GROUP fd7

    # To specify format, add to the autodetect device number:
    # (1) Autodetectable format
    # (2) Autodetectable format in a Double Density (720K) drive only
    # (3) Autodetectable format in a High Density (1440K) drive only
    
    # +4   = /dev/fd?d360        5.25"  360K in a 360K  drive(1)
    # mknod -m $MODE fd0d360 b 2 4 ; chgrp $GROUP fd0d360
    # mknod -m $MODE fd1d360 b 2 5 ; chgrp $GROUP fd1d360
    # ...
    # mknod -m $MODE fd7d360 b 2 135 ; chgrp $GROUP fd7d360

    # +20  = /dev/fd?h360        5.25"  360K in a 1200K drive(1)
    # mknod -m $MODE fd0h360 b 2 20 ; chgrp $GROUP fd0h360
    # mknod -m $MODE fd1h360 b 2 21 ; chgrp $GROUP fd1h360
    # ...
    # mknod -m $MODE fd7h360 b 2 151 ; chgrp $GROUP fd7h360

    # +48  = /dev/fd?h410        5.25"  410K in a 1200K drive
    # mknod -m $MODE fd0h410 b 2 48 ; chgrp $GROUP fd0h410
    # mknod -m $MODE fd1h410 b 2 49 ; chgrp $GROUP fd1h410
    # ...
    # mknod -m $MODE fd7h410 b 2 179 ; chgrp $GROUP fd7h410

    # +64  = /dev/fd?h420        5.25"  420K in a 1200K drive
    # mknod -m $MODE fd0h420 b 2 64 ; chgrp $GROUP fd0h420
    # mknod -m $MODE fd1h420 b 2 65 ; chgrp $GROUP fd1h420
    # ...
    # mknod -m $MODE fd7h420 b 2 195 ; chgrp $GROUP fd7h420

    # +24  = /dev/fd?h720        5.25"  720K in a 1200K drive
    # mknod -m $MODE fd0h720 b 2 24 ; chgrp $GROUP fd0h720
    # mknod -m $MODE fd1h720 b 2 25 ; chgrp $GROUP fd1h720
    # ...
    # mknod -m $MODE fd7h720 b 2 155 ; chgrp $GROUP fd7h720

    # +80  = /dev/fd?h880        5.25"  880K in a 1200K drive(1)
    # mknod -m $MODE fd0h880 b 2 80 ; chgrp $GROUP fd0h880
    # mknod -m $MODE fd1h880 b 2 81 ; chgrp $GROUP fd1h880
    # ...
    # mknod -m $MODE fd7h880 b 2 211 ; chgrp $GROUP fd7h880

    # +8   = /dev/fd?h1200       5.25" 1200K in a 1200K drive(1)
    # mknod -m $MODE fd0h1200 b 2 8 ; chgrp $GROUP fd0h1200
    # mknod -m $MODE fd1h1200 b 2 9 ; chgrp $GROUP fd1h1200
    # ...
    # mknod -m $MODE fd7h1200 b 2 139 ; chgrp $GROUP fd7h1200

    # +40  = /dev/fd?h1440       5.25" 1440K in a 1200K drive(1)
    # mknod -m $MODE fd0h1440 b 2 40 ; chgrp $GROUP fd0h1440
    # mknod -m $MODE fd1h1440 b 2 41 ; chgrp $GROUP fd1h1440
    # ...
    # mknod -m $MODE fd7h1440 b 2 171 ; chgrp $GROUP fd7h1440

    # +56  = /dev/fd?h1476       5.25" 1476K in a 1200K drive
    # mknod -m $MODE fd0h1476 b 2 56 ; chgrp $GROUP fd0h1476
    # mknod -m $MODE fd1h1476 b 2 57 ; chgrp $GROUP fd1h1476
    # ...
    # mknod -m $MODE fd7h1476 b 2 187 ; chgrp $GROUP fd7h1476

    # +72  = /dev/fd?h1494       5.25" 1494K in a 1200K drive
    # mknod -m $MODE fd0h1494 b 2 72 ; chgrp $GROUP fd0h1494
    # mknod -m $MODE fd1h1494 b 2 73 ; chgrp $GROUP fd1h1494
    # ...
    # mknod -m $MODE fd7h1494 b 2 203 ; chgrp $GROUP fd7h1494

    # +92  = /dev/fd?h1600       5.25" 1600K in a 1200K drive(1)
    # mknod -m $MODE fd0h1600 b 2 92 ; chgrp $GROUP fd0h1600
    # mknod -m $MODE fd1h1600 b 2 93 ; chgrp $GROUP fd1h1600
    # ...
    # mknod -m $MODE fd7h1600 b 2 223 ; chgrp $GROUP fd7h1600

    # +12  = /dev/fd?u360        3.5"   360K Double Density(2)
    # mknod -m $MODE fd0u360 b 2 12 ; chgrp $GROUP fd0u360
    # mknod -m $MODE fd1u360 b 2 13 ; chgrp $GROUP fd1u360
    # ...
    # mknod -m $MODE fd7u360 b 2 143 ; chgrp $GROUP fd7u360

    # +16  = /dev/fd?u720        3.5"   720K Double Density(1)
    # mknod -m $MODE fd0u720 b 2 16 ; chgrp $GROUP fd0u720
    # mknod -m $MODE fd1u720 b 2 17 ; chgrp $GROUP fd1u720
    # ...
    # mknod -m $MODE fd7u720 b 2 147 ; chgrp $GROUP fd7u720

    # +120 = /dev/fd?u800        3.5"   800K Double Density(2)
    # mknod -m $MODE fd0u800 b 2 120 ; chgrp $GROUP fd0u800
    # mknod -m $MODE fd1u800 b 2 121 ; chgrp $GROUP fd1u800
    # ...
    # mknod -m $MODE fd7u800 b 2 251 ; chgrp $GROUP fd7u800

    # +52  = /dev/fd?u820        3.5"   820K Double Density
    # mknod -m $MODE fd0u820 b 2 52 ; chgrp $GROUP fd0u820
    # mknod -m $MODE fd1u820 b 2 53 ; chgrp $GROUP fd1u820
    # ...
    # mknod -m $MODE fd7u820 b 2 183 ; chgrp $GROUP fd7u820

    # +68  = /dev/fd?u830        3.5"   830K Double Density
    # mknod -m $MODE fd0u830 b 2 68 ; chgrp $GROUP fd0u830
    # mknod -m $MODE fd1u830 b 2 69 ; chgrp $GROUP fd1u830
    # ...
    # mknod -m $MODE fd7u830 b 2 199 ; chgrp $GROUP fd7u830

    # +84  = /dev/fd?u1040       3.5"  1040K Double Density(1)
    # mknod -m $MODE fd0u1040 b 2 84 ; chgrp $GROUP fd0u1040
    # mknod -m $MODE fd1u1040 b 2 85 ; chgrp $GROUP fd1u1040
    # ...
    # mknod -m $MODE fd7u1040 b 2 215 ; chgrp $GROUP fd7u1040

    # +88  = /dev/fd?u1120       3.5"  1120K Double Density(1)
    # mknod -m $MODE fd0u1120 b 2 88 ; chgrp $GROUP fd0u1120
    # mknod -m $MODE fd1u1120 b 2 89 ; chgrp $GROUP fd1u1120
    # ...
    # mknod -m $MODE fd7u1120 b 2 219 ; chgrp $GROUP fd7u1120

    # +28  = /dev/fd?u1440       3.5"  1440K High Density(1)
    # mknod -m $MODE fd0u1440 b 2 28 ; chgrp $GROUP fd0u1440
    # mknod -m $MODE fd1u1440 b 2 29 ; chgrp $GROUP fd1u1440
    # ...
    # mknod -m $MODE fd7u1440 b 2 159 ; chgrp $GROUP fd7u1440

    # +124 = /dev/fd?u1600       3.5"  1600K High Density(1)
    # mknod -m $MODE fd0u1600 b 2 124 ; chgrp $GROUP fd0u1600
    # mknod -m $MODE fd1u1600 b 2 125 ; chgrp $GROUP fd1u1600
    # ...
    # mknod -m $MODE fd7u1600 b 2 255 ; chgrp $GROUP fd7u1600

    # +44  = /dev/fd?u1680       3.5"  1680K High Density(3)
    # mknod -m $MODE fd0u1680 b 2 44 ; chgrp $GROUP fd0u1680
    # mknod -m $MODE fd1u1680 b 2 45 ; chgrp $GROUP fd1u1680
    # ...
    # mknod -m $MODE fd7u1680 b 2 175 ; chgrp $GROUP fd7u1680

    # +60  = /dev/fd?u1722       3.5"  1722K High Density
    # mknod -m $MODE fd0u1722 b 2 60 ; chgrp $GROUP fd0u1722
    # mknod -m $MODE fd1u1722 b 2 61 ; chgrp $GROUP fd1u1722
    # ...
    # mknod -m $MODE fd7u1722 b 2 191 ; chgrp $GROUP fd7u1722

    # +76  = /dev/fd?u1743       3.5"  1743K High Density
    # mknod -m $MODE fd0u1743 b 2 76 ; chgrp $GROUP fd0u1743
    # mknod -m $MODE fd1u1743 b 2 77 ; chgrp $GROUP fd1u1743
    # ...
    # mknod -m $MODE fd7u1743 b 2 207 ; chgrp $GROUP fd7u1743

    # +96  = /dev/fd?u1760       3.5"  1760K High Density
    # mknod -m $MODE fd0u1760 b 2 96 ; chgrp $GROUP fd0u1760
    # mknod -m $MODE fd1u1760 b 2 97 ; chgrp $GROUP fd1u1760
    # ...
    # mknod -m $MODE fd7u1760 b 2 227 ; chgrp $GROUP fd7u1760

    # +116 = /dev/fd?u1840       3.5"  1840K High Density(3)
    # mknod -m $MODE fd0u1840 b 2 116 ; chgrp $GROUP fd0u1840
    # mknod -m $MODE fd1u1840 b 2 117 ; chgrp $GROUP fd1u1840
    # ...
    # mknod -m $MODE fd7u1840 b 2 247 ; chgrp $GROUP fd7u1840

    # +100 = /dev/fd?u1920       3.5"  1920K High Density(1)
    # mknod -m $MODE fd0u1920 b 2 100 ; chgrp $GROUP fd0u1920
    # mknod -m $MODE fd1u1920 b 2 101 ; chgrp $GROUP fd1u1920
    # ...
    # mknod -m $MODE fd7u1920 b 2 231 ; chgrp $GROUP fd7u1920

    # +32  = /dev/fd?u2880       3.5"  2880K Extra Density(1)
    # mknod -m $MODE fd0u2880 b 2 32 ; chgrp $GROUP fd0u2880
    # mknod -m $MODE fd1u2880 b 2 33 ; chgrp $GROUP fd1u2880
    # ...
    # mknod -m $MODE fd7u2880 b 2 163 ; chgrp $GROUP fd7u2880

    # +104 = /dev/fd?u3200       3.5"  3200K Extra Density
    # mknod -m $MODE fd0u3200 b 2 104 ; chgrp $GROUP fd0u3200
    # mknod -m $MODE fd1u3200 b 2 105 ; chgrp $GROUP fd1u3200
    # ...
    # mknod -m $MODE fd7u3200 b 2 235 ; chgrp $GROUP fd7u3200

    # +108 = /dev/fd?u3520       3.5"  3520K Extra Density
    # mknod -m $MODE fd0u3520 b 2 108 ; chgrp $GROUP fd0u3520
    # mknod -m $MODE fd1u3520 b 2 109 ; chgrp $GROUP fd1u3520
    # ...
    # mknod -m $MODE fd7u3520 b 2 239 ; chgrp $GROUP fd7u3520

    # +112 = /dev/fd?u3840       3.5"  3840K Extra Density(1)
    # mknod -m $MODE fd0u3840 b 2 112 ; chgrp $GROUP fd0u3840
    # mknod -m $MODE fd1u3840 b 2 113 ; chgrp $GROUP fd1u3840
    # ...
    # mknod -m $MODE fd7u3840 b 2 243 ; chgrp $GROUP fd7u3840

    # +36  = /dev/fd?CompaQ      Compaq 2880K drive; obsolete?
    # mknod -m $MODE fd0CompaQ b 2 36 ; chgrp $GROUP fd0CompaQ
    # mknod -m $MODE fd1CompaQ b 2 37 ; chgrp $GROUP fd1CompaQ
    # ...
    # mknod -m $MODE fd7CompaQ b 2 167 ; chgrp $GROUP fd7CompaQ




#############################################################################
GROUP=$ibcs2 ; MODE=660
#############################################################################

#****************************************************************************
#                         iBCS-2 compatibility devices
#****************************************************************************

    # Socket access
    # mknod -m $MODE socksys c 30 0 ; chgrp $GROUP socksys

    # SVR3 local X interface
    # mknod -m $MODE spx c 30 1 ; chgrp $GROUP spx

    # iBCS-2 requires /dev/nfsd to be a link to /dev/socksys, 
    # and /dev/X0R to be a link to /dev/null.
    # ln -sfn null X0R ; chgrp $GROUP X0R
    # ln -sfn socksys nfsd ; chgrp $GROUP nfsd





#############################################################################
GROUP=$kmem ; MODE=640
#############################################################################

#****************************************************************************
#                         Memory devices
#****************************************************************************

    # Physical memory access
mknod -m $MODE mem c 1 1 ; chgrp $GROUP mem

    # Kernel virtual memory access
mknod -m $MODE kmem c 1 2 ; chgrp $GROUP kmem

#############################################################################
GROUP=$kmem ; MODE=660
#############################################################################

    # I/O port access
mknod -m $MODE port c 1 4 ; chgrp $GROUP port




#############################################################################
GROUP=$printer ; MODE=660
#############################################################################

#****************************************************************************
#                         Raw parallel ports
#****************************************************************************

    # First parallel port
mknod -m $MODE parport0 c 99 0 ; chgrp $GROUP parport0
    # Second parallel port 
mknod -m $MODE parport1 c 99 1 ; chgrp $GROUP parport1
    # mknod -m $MODE parport2 c 99 2 ; chgrp $GROUP parport2
    # ...

#****************************************************************************
#                         Parallel printer devices
#****************************************************************************

    # Parallel printer on parport0
mknod -m $MODE lp0 c 6 0 ; chgrp $GROUP lp0
    # Parallel printer on parport1 
mknod -m $MODE lp1 c 6 1 ; chgrp $GROUP lp1
    # mknod -m $MODE lp2 c 6 2 ; chgrp $GROUP lp2
    # ...



#############################################################################
GROUP=$mouse ; MODE=660
#############################################################################

#****************************************************************************
#                         Non-serial mice
#****************************************************************************

    # Logitech bus mouse
    # mknod -m $MODE logibm c 10 0 ; chgrp $GROUP logibm

    # PS/2-style mouse port
mknod -m $MODE psaux c 10 1 ; chgrp $GROUP psaux

    # Microsoft Inport bus mouse
    # mknod -m $MODE inportbm c 10 2 ; chgrp $GROUP inportbm

    # ATI XL bus mouse
    # mknod -m $MODE atibm c 10 3 ; chgrp $GROUP atibm

    # Amiga mouse (68k/Amiga)
    # mknod -m $MODE amigamouse c 10 4 ; chgrp $GROUP amigamouse

    # J-mouse
    # mknod -m $MODE jbm c 10 4 ; chgrp $GROUP jbm

    # Atari mouse
    # mknod -m $MODE atarimouse c 10 5 ; chgrp $GROUP atarimouse

    # Sun mouse
    # mknod -m $MODE sunmouse c 10 6 ; chgrp $GROUP sunmouse

    # Second Amiga mouse
    # mknod -m $MODE amigamouse1 c 10 7 ; chgrp $GROUP amigamouse1

    # Simple serial mouse driver
    # mknod -m $MODE smouse c 10 8 ; chgrp $GROUP smouse

    # IBM PC-110 digitizer pad
    # mknod -m $MODE pc110pad c 10 9 ; chgrp $GROUP pc110pad

    # Apple Desktop Bus mouse
    # mknod -m $MODE adbmouse c 10 10 ; chgrp $GROUP adbmouse



#############################################################################
GROUP=$game ; MODE=660
#############################################################################    

#****************************************************************************
#                         Joystick
#****************************************************************************

    # First analog joystick
    # mknod -m $MODE js0 c 15 0 ; chgrp $GROUP js0
    # Second analog joystick
    # mknod -m $MODE js1 c 15 1 ; chgrp $GROUP js1
    # ...

    # First digital joystick
    # mknod -m $MODE djs0 c 15 128 ; chgrp $GROUP djs0
    # Second digital joystick 
    # mknod -m $MODE djs1 c 15 129 ; chgrp $GROUP djs1
    # ...



#############################################################################
GROUP=$private ; MODE=600
#############################################################################

#****************************************************************************
#                         Kernel profiling interface
#****************************************************************************

    # Profiling control device
    # mknod -m $MODE profile c 192 0 ; chgrp $GROUP profile

    # Profiling device for CPU 0
    # mknod -m $MODE profile0 c 192 1 ; chgrp $GROUP profile0
    # Profiling device for CPU 1 
    # mknod -m $MODE profile1 c 192 2 ; chgrp $GROUP profile1
    # ...

#****************************************************************************
#                         SYSTRAM SCRAMNet mirrored-memory network
#****************************************************************************

    # First SCRAMNet device
    # mknod -m $MODE scramnet0 c 146 0 ; chgrp $GROUP scramnet0
    # Second SCRAMNet device 
    # mknod -m $MODE scramnet1 c 146 1 ; chgrp $GROUP scramnet1
    # ...

#****************************************************************************
#                         VMware virtual network control
#****************************************************************************

    # 1st virtual network
    # mknod -m $MODE vnet0 c 119 0 ; chgrp $GROUP vnet0
    # 2nd virtual network 
    # mknod -m $MODE vnet1 c 119 1 ; chgrp $GROUP vnet1
    # ...

#****************************************************************************
#                         ENskip kernel encryption package
#****************************************************************************

    # Communication with ENskip kernel module 
    # mknod -m $MODE enskip c 64 0 ; chgrp $GROUP enskip

#****************************************************************************
#                         Coda network file system
#****************************************************************************

    # Coda cache manager 
    # mknod -m $MODE cfs0 c 67 0 ; chgrp $GROUP cfs0

#****************************************************************************
#                         CAPI 2.0 interface
#****************************************************************************

    # Control device
    # mknod -m $MODE capi20 c 68 0 ; chgrp $GROUP capi20

    # First CAPI 2.0 application
    # mknod -m $MODE capi20.00 c 68 1 ; chgrp $GROUP capi20.00
    # Second CAPI 2.0 application
    # mknod -m $MODE capi20.01 c 68 2 ; chgrp $GROUP capi20.01
    # ...
    # 19th CAPI 2.0 application 
    # mknod -m $MODE capi20.19 c 68 20 ; chgrp $GROUP capi20.19

#****************************************************************************
#                         I2C bus interface
#****************************************************************************

    # First I2C adapter
    # mknod -m $MODE i2c-0 c 89 0 ; chgrp $GROUP i2c-0
    # Second I2C adapter 
    # mknod -m $MODE i2c-1 c 89 1 ; chgrp $GROUP i2c-1
    # ...

#****************************************************************************
#                         IP filter
#****************************************************************************

    # Filter control device/log file
    # mknod -m $MODE ipl c 95 0 ; chgrp $GROUP ipl

    # NAT control device/log file
    # mknod -m $MODE ipnat c 95 1 ; chgrp $GROUP ipnat

    # State information log file
    # mknod -m $MODE ipstate c 95 2 ; chgrp $GROUP ipstate

    # Authentication control device/log file 
    # mknod -m $MODE ipauth c 95 3 ; chgrp $GROUP ipauth

#****************************************************************************
#                         Raw keyboard device
#****************************************************************************
# The raw keyboard device is used on Linux/SPARC only.
#****************************************************************************

    # Raw keyboard device 
    # mknod -m $MODE kbd c 11 0 ; chgrp $GROUP kbd

#****************************************************************************
#                         Raw block device interface
#****************************************************************************

    # Raw I/O control device
    # mknod -m $MODE raw c 162 0 ; chgrp $GROUP raw
    # First raw I/O device
    # mknod -m $MODE raw1 c 162 1 ; chgrp $GROUP raw1
    # Second raw I/O device 
    # mknod -m $MODE raw2 c 162 2 ; chgrp $GROUP raw2
    # ...

#****************************************************************************
#                         Non-SCSI scanners
#****************************************************************************

    # Genius 4500 handheld scanner 
    # mknod -m $MODE gs4500 c 16 0 ; chgrp $GROUP gs4500

#****************************************************************************
#                         Netlink support
#****************************************************************************

    # First Ethertap device
    # mknod -m $MODE tap0 c 36 16 ; chgrp $GROUP tap0

    # 16th Ethertap device 
    # mknod -m $MODE tap15 c 36 31 ; chgrp $GROUP tap15

#****************************************************************************
#                         sf firewall package
#****************************************************************************

    # Communication with sf kernel module 
    # mknod -m $MODE firewall c 59 0 ; chgrp $GROUP firewall

#****************************************************************************
#                         YARC PowerPC PCI coprocessor card
#****************************************************************************

    # First YARC card
    # mknod -m $MODE yppcpci0 c 66 0 ; chgrp $GROUP yppcpci0
    # Second YARC card 
    # mknod -m $MODE yppcpci1 c 66 1 ; chgrp $GROUP yppcpci1
    # ...




#############################################################################
GROUP=$public ; MODE=666
#############################################################################

#****************************************************************************
#                         Memory devices
#****************************************************************************

    # Null device
mknod -m $MODE null c 1 3 ; chgrp $GROUP null

    # Null byte source
mknod -m $MODE zero c 1 5 ; chgrp $GROUP zero

    # Returns ENOSPC on write
mknod -m $MODE full c 1 7 ; chgrp $GROUP full



#############################################################################
GROUP=$readable ; MODE=444
#############################################################################

#****************************************************************************
#                         Memory devices
#****************************************************************************

    # Nondeterministic random number gen.
mknod -m $MODE random c 1 8 ; chgrp $GROUP random

    # Faster, less secure random number gen.
mknod -m $MODE urandom c 1 9 ; chgrp $GROUP urandom

    # Asyncronous I/O notification interface
    # mknod -m $MODE aio c 1 10 ; chgrp $GROUP aio

#****************************************************************************
#                         ComScire Quantum Noise Generator
#****************************************************************************

    # ComScire Quantum Noise Generator 
    # mknod -m $MODE qng c 77 0 ; chgrp $GROUP qng






#############################################################################
GROUP=$symlinks
#############################################################################

ln -sfn /proc/self/fd fd ; chgrp $GROUP fd
ln -sfn fd/0 stdin ; chgrp $GROUP stdin
ln -sfn fd/1 stdout ; chgrp $GROUP stdout
ln -sfn fd/2 stderr ; chgrp $GROUP stderr
    
    # ln -sfn /proc/kcore core ; chgrp $GROUP core
    
    # ln -sfn ram0 ramdisk; chgrp $GROUP ramdisk
    # ln -sf qft0 ftape ; chgrp $GROUP ftape
    # ln -sf video0 bttv0 ; chgrp $GROUP bttv0
    # ln -sf radio0 radio ; chgrp $GROUP radio
    
    




#############################################################################
GROUP=$tape ; MODE=660
#############################################################################

#****************************************************************************
#                         SCSI tape devices
#****************************************************************************

    # First SCSI tape, mode 0
    # mknod -m $MODE st0 c 9 0 ; chgrp $GROUP st0
    # Second SCSI tape, mode 0
    # mknod -m $MODE st1 c 9 1 ; chgrp $GROUP st1
    # ...

    # First SCSI tape, mode 1
    # mknod -m $MODE st0l c 9 32 ; chgrp $GROUP st0l
    # Second SCSI tape, mode 1
    # mknod -m $MODE st1l c 9 33 ; chgrp $GROUP st1l
    # ...

    # First SCSI tape, mode 2
    # mknod -m $MODE st0m c 9 64 ; chgrp $GROUP st0m
    # Second SCSI tape, mode 2
    # mknod -m $MODE st1m c 9 65 ; chgrp $GROUP st1m
    # ...

    # First SCSI tape, mode 3
    # mknod -m $MODE st0a c 9 96 ; chgrp $GROUP st0a
    # Second SCSI tape, mode 3
    # mknod -m $MODE st1a c 9 97 ; chgrp $GROUP st1a
    # ...

    # First SCSI tape, mode 0, no rewind
    # mknod -m $MODE nst0 c 9 128 ; chgrp $GROUP nst0
    # Second SCSI tape, mode 0, no rewind
    # mknod -m $MODE nst1 c 9 129 ; chgrp $GROUP nst1
    # ...

    # First SCSI tape, mode 1, no rewind
    # mknod -m $MODE nst0l c 9 160 ; chgrp $GROUP nst0l
    # Second SCSI tape, mode 1, no rewind
    # mknod -m $MODE nst1l c 9 161 ; chgrp $GROUP nst1l
    # ...

    # First SCSI tape, mode 2, no rewind
    # mknod -m $MODE nst0m c 9 192 ; chgrp $GROUP nst0m
    # Second SCSI tape, mode 2, no rewind
    # mknod -m $MODE nst1m c 9 193 ; chgrp $GROUP nst1m
    # ...

    # First SCSI tape, mode 3, no rewind
    # mknod -m $MODE nst0a c 9 224 ; chgrp $GROUP nst0a
    # Second SCSI tape, mode 3, no rewind 
    # mknod -m $MODE nst1a c 9 225 ; chgrp $GROUP nst1a
    # ...

#****************************************************************************
#                         QIC-02 tape
#****************************************************************************

    # QIC-11, no rewind-on-close
    # mknod -m $MODE ntpqic11 c 12 2 ; chgrp $GROUP ntpqic11
    # QIC-11, rewind-on-close
    # mknod -m $MODE tpqic11 c 12 3 ; chgrp $GROUP tpqic11

    # QIC-24, no rewind-on-close
    # mknod -m $MODE ntpqic24 c 12 4 ; chgrp $GROUP ntpqic24
    # QIC-24, rewind-on-close
    # mknod -m $MODE tpqic24 c 12 5 ; chgrp $GROUP tpqic24

    # QIC-120, no rewind-on-close
    # mknod -m $MODE ntpqic120 c 12 6 ; chgrp $GROUP ntpqic120
    # QIC-120, rewind-on-close
    # mknod -m $MODE tpqic120 c 12 7 ; chgrp $GROUP tpqic120

    # QIC-150, no rewind-on-close
    # mknod -m $MODE ntpqic150 c 12 8 ; chgrp $GROUP ntpqic150
    # QIC-150, rewind-on-close 
    # mknod -m $MODE tpqic150 c 12 9 ; chgrp $GROUP tpqic150

#****************************************************************************
#                         QIC-117 tape
#****************************************************************************

    # Unit 0, rewind-on-close
    # mknod -m $MODE qft0 c 27 0 ; chgrp $GROUP qft0
    # Unit 1, rewind-on-close
    # mknod -m $MODE qft1 c 27 1 ; chgrp $GROUP qft1
    # Unit 2, rewind-on-close
    # mknod -m $MODE qft2 c 27 2 ; chgrp $GROUP qft2
    # Unit 3, rewind-on-close
    # mknod -m $MODE qft3 c 27 3 ; chgrp $GROUP qft3

    # Unit 0, no rewind-on-close
    # mknod -m $MODE nqft0 c 27 4 ; chgrp $GROUP nqft0
    # Unit 1, no rewind-on-close
    # mknod -m $MODE nqft1 c 27 5 ; chgrp $GROUP nqft1
    # Unit 2, no rewind-on-close
    # mknod -m $MODE nqft2 c 27 6 ; chgrp $GROUP nqft2
    # Unit 3, no rewind-on-close
    # mknod -m $MODE nqft3 c 27 7 ; chgrp $GROUP nqft3

    # Unit 0, rewind-on-close, compression
    # mknod -m $MODE zqft0 c 27 16 ; chgrp $GROUP zqft0
    # Unit 1, rewind-on-close, compression
    # mknod -m $MODE zqft1 c 27 17 ; chgrp $GROUP zqft1
    # Unit 2, rewind-on-close, compression
    # mknod -m $MODE zqft2 c 27 18 ; chgrp $GROUP zqft2
    # Unit 3, rewind-on-close, compression
    # mknod -m $MODE zqft3 c 27 19 ; chgrp $GROUP zqft3

    # Unit 0, no rewind-on-close, compression
    # mknod -m $MODE nzqft0 c 27 20 ; chgrp $GROUP nzqft0
    # Unit 1, no rewind-on-close, compression
    # mknod -m $MODE nzqft1 c 27 21 ; chgrp $GROUP nzqft1
    # Unit 2, no rewind-on-close, compression
    # mknod -m $MODE nzqft2 c 27 22 ; chgrp $GROUP nzqft2
    # Unit 3, no rewind-on-close, compression
    # mknod -m $MODE nzqft3 c 27 23 ; chgrp $GROUP nzqft3

    # Unit 0, rewind-on-close, no file marks
    # mknod -m $MODE rawqft0 c 27 32 ; chgrp $GROUP rawqft0
    # Unit 1, rewind-on-close, no file marks
    # mknod -m $MODE rawqft1 c 27 33 ; chgrp $GROUP rawqft1
    # Unit 2, rewind-on-close, no file marks
    # mknod -m $MODE rawqft2 c 27 34 ; chgrp $GROUP rawqft2
    # Unit 3, rewind-on-close, no file marks
    # mknod -m $MODE rawqft3 c 27 35 ; chgrp $GROUP rawqft3

    # Unit 0, no rewind-on-close, no file marks
    # mknod -m $MODE nrawqft0 c 27 36 ; chgrp $GROUP nrawqft0
    # Unit 1, no rewind-on-close, no file marks
    # mknod -m $MODE nrawqft1 c 27 37 ; chgrp $GROUP nrawqft1
    # Unit 2, no rewind-on-close, no file marks
    # mknod -m $MODE nrawqft2 c 27 38 ; chgrp $GROUP nrawqft2
    # Unit 3, no rewind-on-close, no file marks 
    # mknod -m $MODE nrawqft3 c 27 39 ; chgrp $GROUP nrawqft3

#****************************************************************************
#                         IDE tape
#****************************************************************************

    # First IDE tape
    # mknod -m $MODE ht0 c 37 0 ; chgrp $GROUP ht0
    # Second IDE tape
    # mknod -m $MODE ht1 c 37 1 ; chgrp $GROUP ht1
    # ...

    # First IDE tape, no rewind-on-close
    # mknod -m $MODE nht0 c 37 128 ; chgrp $GROUP nht0
    # Second IDE tape, no rewind-on-close 
    # mknod -m $MODE nht1 c 37 129 ; chgrp $GROUP nht1
    # ...

#****************************************************************************
#                         Parallel port ATAPI tape devices
#****************************************************************************

    # First parallel port ATAPI tape
    # mknod -m $MODE pt0 c 96 0 ; chgrp $GROUP pt0
    # Second parallel port ATAPI tape
    # mknod -m $MODE pt1 c 96 1 ; chgrp $GROUP pt1
    # ...

    # First p.p. ATAPI tape, no rewind
    # mknod -m $MODE npt0 c 96 128 ; chgrp $GROUP npt0
    # Second p.p. ATAPI tape, no rewind 
    # mknod -m $MODE npt1 c 96 129 ; chgrp $GROUP npt1
    # ...





#############################################################################
GROUP=$tty ; MODE=666
#############################################################################

#****************************************************************************
#                         Pseudo-TTY masters
#****************************************************************************
# Pseudo-tty's are named as follows:
# * Masters are "pty", slaves are "tty";
# * the fourth letter is one of pqrstuvwxyzabcde indicating
#   the 1st through 16th series of 16 pseudo-ttys each, and
# * the fifth letter is one of 0123456789abcdef indicating
#   the position within the series.
#
# These are the old-style (BSD) PTY devices; Unix98
# devices are on major 128 and above and use the PTY
# master multiplex (/dev/ptmx) to acquire a PTY on
# demand.
#****************************************************************************

    # First PTY master
    # mknod -m $MODE ptyp0 c 2 0 ; chgrp $GROUP ptyp0
    # Second PTY master
    # mknod -m $MODE ptyp1 c 2 1 ; chgrp $GROUP ptyp1
    # mknod -m $MODE ptyp2 c 2 2 ; chgrp $GROUP ptyp2
    # mknod -m $MODE ptyp3 c 2 3 ; chgrp $GROUP ptyp3
    # mknod -m $MODE ptyp4 c 2 4 ; chgrp $GROUP ptyp4
    # mknod -m $MODE ptyp5 c 2 5 ; chgrp $GROUP ptyp5
    # mknod -m $MODE ptyp6 c 2 6 ; chgrp $GROUP ptyp6
    # mknod -m $MODE ptyp7 c 2 7 ; chgrp $GROUP ptyp7
    # mknod -m $MODE ptyp8 c 2 8 ; chgrp $GROUP ptyp8
    # mknod -m $MODE ptyp9 c 2 9 ; chgrp $GROUP ptyp9
    # mknod -m $MODE ptypa c 2 10 ; chgrp $GROUP ptypa
    # mknod -m $MODE ptypb c 2 11 ; chgrp $GROUP ptypb
    # mknod -m $MODE ptypc c 2 12 ; chgrp $GROUP ptypc
    # mknod -m $MODE ptypd c 2 13 ; chgrp $GROUP ptypd
    # mknod -m $MODE ptype c 2 14 ; chgrp $GROUP ptype
    # mknod -m $MODE ptypf c 2 15 ; chgrp $GROUP ptypf
    # mknod -m $MODE ptyq0 c 2 16 ; chgrp $GROUP ptyq0
    # mknod -m $MODE ptyq1 c 2 17 ; chgrp $GROUP ptyq1
    # mknod -m $MODE ptyq2 c 2 18 ; chgrp $GROUP ptyq2
    # mknod -m $MODE ptyq3 c 2 19 ; chgrp $GROUP ptyq3
    # mknod -m $MODE ptyq4 c 2 20 ; chgrp $GROUP ptyq4
    # mknod -m $MODE ptyq5 c 2 21 ; chgrp $GROUP ptyq5
    # mknod -m $MODE ptyq6 c 2 22 ; chgrp $GROUP ptyq6
    # mknod -m $MODE ptyq7 c 2 23 ; chgrp $GROUP ptyq7
    # mknod -m $MODE ptyq8 c 2 24 ; chgrp $GROUP ptyq8
    # mknod -m $MODE ptyq9 c 2 25 ; chgrp $GROUP ptyq9
    # mknod -m $MODE ptyqa c 2 26 ; chgrp $GROUP ptyqa
    # mknod -m $MODE ptyqb c 2 27 ; chgrp $GROUP ptyqb
    # mknod -m $MODE ptyqc c 2 28 ; chgrp $GROUP ptyqc
    # mknod -m $MODE ptyqd c 2 29 ; chgrp $GROUP ptyqd
    # mknod -m $MODE ptyqe c 2 30 ; chgrp $GROUP ptyqe
    # mknod -m $MODE ptyqf c 2 31 ; chgrp $GROUP ptyqf
    # mknod -m $MODE ptyr0 c 2 32 ; chgrp $GROUP ptyr0
    # mknod -m $MODE ptyr1 c 2 33 ; chgrp $GROUP ptyr1
    # mknod -m $MODE ptyr2 c 2 34 ; chgrp $GROUP ptyr2
    # mknod -m $MODE ptyr3 c 2 35 ; chgrp $GROUP ptyr3
    # mknod -m $MODE ptyr4 c 2 36 ; chgrp $GROUP ptyr4
    # mknod -m $MODE ptyr5 c 2 37 ; chgrp $GROUP ptyr5
    # mknod -m $MODE ptyr6 c 2 38 ; chgrp $GROUP ptyr6
    # mknod -m $MODE ptyr7 c 2 39 ; chgrp $GROUP ptyr7
    # mknod -m $MODE ptyr8 c 2 40 ; chgrp $GROUP ptyr8
    # mknod -m $MODE ptyr9 c 2 41 ; chgrp $GROUP ptyr9
    # mknod -m $MODE ptyra c 2 42 ; chgrp $GROUP ptyra
    # mknod -m $MODE ptyrb c 2 43 ; chgrp $GROUP ptyrb
    # mknod -m $MODE ptyrc c 2 44 ; chgrp $GROUP ptyrc
    # mknod -m $MODE ptyrd c 2 45 ; chgrp $GROUP ptyrd
    # mknod -m $MODE ptyre c 2 46 ; chgrp $GROUP ptyre
    # mknod -m $MODE ptyrf c 2 47 ; chgrp $GROUP ptyrf
    # mknod -m $MODE ptys0 c 2 48 ; chgrp $GROUP ptys0
    # mknod -m $MODE ptys1 c 2 49 ; chgrp $GROUP ptys1
    # mknod -m $MODE ptys2 c 2 50 ; chgrp $GROUP ptys2
    # mknod -m $MODE ptys3 c 2 51 ; chgrp $GROUP ptys3
    # mknod -m $MODE ptys4 c 2 52 ; chgrp $GROUP ptys4
    # mknod -m $MODE ptys5 c 2 53 ; chgrp $GROUP ptys5
    # mknod -m $MODE ptys6 c 2 54 ; chgrp $GROUP ptys6
    # mknod -m $MODE ptys7 c 2 55 ; chgrp $GROUP ptys7
    # mknod -m $MODE ptys8 c 2 56 ; chgrp $GROUP ptys8
    # mknod -m $MODE ptys9 c 2 57 ; chgrp $GROUP ptys9
    # mknod -m $MODE ptysa c 2 58 ; chgrp $GROUP ptysa
    # mknod -m $MODE ptysb c 2 59 ; chgrp $GROUP ptysb
    # mknod -m $MODE ptysc c 2 60 ; chgrp $GROUP ptysc
    # mknod -m $MODE ptysd c 2 61 ; chgrp $GROUP ptysd
    # mknod -m $MODE ptyse c 2 62 ; chgrp $GROUP ptyse
    # mknod -m $MODE ptysf c 2 63 ; chgrp $GROUP ptysf
    # mknod -m $MODE ptyt0 c 2 64 ; chgrp $GROUP ptyt0
    # mknod -m $MODE ptyt1 c 2 65 ; chgrp $GROUP ptyt1
    # mknod -m $MODE ptyt2 c 2 66 ; chgrp $GROUP ptyt2
    # mknod -m $MODE ptyt3 c 2 67 ; chgrp $GROUP ptyt3
    # mknod -m $MODE ptyt4 c 2 68 ; chgrp $GROUP ptyt4
    # mknod -m $MODE ptyt5 c 2 69 ; chgrp $GROUP ptyt5
    # mknod -m $MODE ptyt6 c 2 70 ; chgrp $GROUP ptyt6
    # mknod -m $MODE ptyt7 c 2 71 ; chgrp $GROUP ptyt7
    # mknod -m $MODE ptyt8 c 2 72 ; chgrp $GROUP ptyt8
    # mknod -m $MODE ptyt9 c 2 73 ; chgrp $GROUP ptyt9
    # mknod -m $MODE ptyta c 2 74 ; chgrp $GROUP ptyta
    # mknod -m $MODE ptytb c 2 75 ; chgrp $GROUP ptytb
    # mknod -m $MODE ptytc c 2 76 ; chgrp $GROUP ptytc
    # mknod -m $MODE ptytd c 2 77 ; chgrp $GROUP ptytd
    # mknod -m $MODE ptyte c 2 78 ; chgrp $GROUP ptyte
    # mknod -m $MODE ptytf c 2 79 ; chgrp $GROUP ptytf
    # mknod -m $MODE ptyu0 c 2 80 ; chgrp $GROUP ptyu0
    # mknod -m $MODE ptyu1 c 2 81 ; chgrp $GROUP ptyu1
    # mknod -m $MODE ptyu2 c 2 82 ; chgrp $GROUP ptyu2
    # mknod -m $MODE ptyu3 c 2 83 ; chgrp $GROUP ptyu3
    # mknod -m $MODE ptyu4 c 2 84 ; chgrp $GROUP ptyu4
    # mknod -m $MODE ptyu5 c 2 85 ; chgrp $GROUP ptyu5
    # mknod -m $MODE ptyu6 c 2 86 ; chgrp $GROUP ptyu6
    # mknod -m $MODE ptyu7 c 2 87 ; chgrp $GROUP ptyu7
    # mknod -m $MODE ptyu8 c 2 88 ; chgrp $GROUP ptyu8
    # mknod -m $MODE ptyu9 c 2 89 ; chgrp $GROUP ptyu9
    # mknod -m $MODE ptyua c 2 90 ; chgrp $GROUP ptyua
    # mknod -m $MODE ptyub c 2 91 ; chgrp $GROUP ptyub
    # mknod -m $MODE ptyuc c 2 92 ; chgrp $GROUP ptyuc
    # mknod -m $MODE ptyud c 2 93 ; chgrp $GROUP ptyud
    # mknod -m $MODE ptyue c 2 94 ; chgrp $GROUP ptyue
    # mknod -m $MODE ptyuf c 2 95 ; chgrp $GROUP ptyuf
    # mknod -m $MODE ptyv0 c 2 96 ; chgrp $GROUP ptyv0
    # mknod -m $MODE ptyv1 c 2 97 ; chgrp $GROUP ptyv1
    # mknod -m $MODE ptyv2 c 2 98 ; chgrp $GROUP ptyv2
    # mknod -m $MODE ptyv3 c 2 99 ; chgrp $GROUP ptyv3
    # mknod -m $MODE ptyv4 c 2 100 ; chgrp $GROUP ptyv4
    # mknod -m $MODE ptyv5 c 2 101 ; chgrp $GROUP ptyv5
    # mknod -m $MODE ptyv6 c 2 102 ; chgrp $GROUP ptyv6
    # mknod -m $MODE ptyv7 c 2 103 ; chgrp $GROUP ptyv7
    # mknod -m $MODE ptyv8 c 2 104 ; chgrp $GROUP ptyv8
    # mknod -m $MODE ptyv9 c 2 105 ; chgrp $GROUP ptyv9
    # mknod -m $MODE ptyva c 2 106 ; chgrp $GROUP ptyva
    # mknod -m $MODE ptyvb c 2 107 ; chgrp $GROUP ptyvb
    # mknod -m $MODE ptyvc c 2 108 ; chgrp $GROUP ptyvc
    # mknod -m $MODE ptyvd c 2 109 ; chgrp $GROUP ptyvd
    # mknod -m $MODE ptyve c 2 110 ; chgrp $GROUP ptyve
    # mknod -m $MODE ptyvf c 2 111 ; chgrp $GROUP ptyvf
    # mknod -m $MODE ptyw0 c 2 112 ; chgrp $GROUP ptyw0
    # mknod -m $MODE ptyw1 c 2 113 ; chgrp $GROUP ptyw1
    # mknod -m $MODE ptyw2 c 2 114 ; chgrp $GROUP ptyw2
    # mknod -m $MODE ptyw3 c 2 115 ; chgrp $GROUP ptyw3
    # mknod -m $MODE ptyw4 c 2 116 ; chgrp $GROUP ptyw4
    # mknod -m $MODE ptyw5 c 2 117 ; chgrp $GROUP ptyw5
    # mknod -m $MODE ptyw6 c 2 118 ; chgrp $GROUP ptyw6
    # mknod -m $MODE ptyw7 c 2 119 ; chgrp $GROUP ptyw7
    # mknod -m $MODE ptyw8 c 2 120 ; chgrp $GROUP ptyw8
    # mknod -m $MODE ptyw9 c 2 121 ; chgrp $GROUP ptyw9
    # mknod -m $MODE ptywa c 2 122 ; chgrp $GROUP ptywa
    # mknod -m $MODE ptywb c 2 123 ; chgrp $GROUP ptywb
    # mknod -m $MODE ptywc c 2 124 ; chgrp $GROUP ptywc
    # mknod -m $MODE ptywd c 2 125 ; chgrp $GROUP ptywd
    # mknod -m $MODE ptywe c 2 126 ; chgrp $GROUP ptywe
    # mknod -m $MODE ptywf c 2 127 ; chgrp $GROUP ptywf
    # mknod -m $MODE ptyx0 c 2 128 ; chgrp $GROUP ptyx0
    # mknod -m $MODE ptyx1 c 2 129 ; chgrp $GROUP ptyx1
    # mknod -m $MODE ptyx2 c 2 130 ; chgrp $GROUP ptyx2
    # mknod -m $MODE ptyx3 c 2 131 ; chgrp $GROUP ptyx3
    # mknod -m $MODE ptyx4 c 2 132 ; chgrp $GROUP ptyx4
    # mknod -m $MODE ptyx5 c 2 133 ; chgrp $GROUP ptyx5
    # mknod -m $MODE ptyx6 c 2 134 ; chgrp $GROUP ptyx6
    # mknod -m $MODE ptyx7 c 2 135 ; chgrp $GROUP ptyx7
    # mknod -m $MODE ptyx8 c 2 136 ; chgrp $GROUP ptyx8
    # mknod -m $MODE ptyx9 c 2 137 ; chgrp $GROUP ptyx9
    # mknod -m $MODE ptyxa c 2 138 ; chgrp $GROUP ptyxa
    # mknod -m $MODE ptyxb c 2 139 ; chgrp $GROUP ptyxb
    # mknod -m $MODE ptyxc c 2 140 ; chgrp $GROUP ptyxc
    # mknod -m $MODE ptyxd c 2 141 ; chgrp $GROUP ptyxd
    # mknod -m $MODE ptyxe c 2 142 ; chgrp $GROUP ptyxe
    # mknod -m $MODE ptyxf c 2 143 ; chgrp $GROUP ptyxf
    # mknod -m $MODE ptyy0 c 2 144 ; chgrp $GROUP ptyy0
    # mknod -m $MODE ptyy1 c 2 145 ; chgrp $GROUP ptyy1
    # mknod -m $MODE ptyy2 c 2 146 ; chgrp $GROUP ptyy2
    # mknod -m $MODE ptyy3 c 2 147 ; chgrp $GROUP ptyy3
    # mknod -m $MODE ptyy4 c 2 148 ; chgrp $GROUP ptyy4
    # mknod -m $MODE ptyy5 c 2 149 ; chgrp $GROUP ptyy5
    # mknod -m $MODE ptyy6 c 2 150 ; chgrp $GROUP ptyy6
    # mknod -m $MODE ptyy7 c 2 151 ; chgrp $GROUP ptyy7
    # mknod -m $MODE ptyy8 c 2 152 ; chgrp $GROUP ptyy8
    # mknod -m $MODE ptyy9 c 2 153 ; chgrp $GROUP ptyy9
    # mknod -m $MODE ptyya c 2 154 ; chgrp $GROUP ptyya
    # mknod -m $MODE ptyyb c 2 155 ; chgrp $GROUP ptyyb
    # mknod -m $MODE ptyyc c 2 156 ; chgrp $GROUP ptyyc
    # mknod -m $MODE ptyyd c 2 157 ; chgrp $GROUP ptyyd
    # mknod -m $MODE ptyye c 2 158 ; chgrp $GROUP ptyye
    # mknod -m $MODE ptyyf c 2 159 ; chgrp $GROUP ptyyf
    # mknod -m $MODE ptyz0 c 2 160 ; chgrp $GROUP ptyz0
    # mknod -m $MODE ptyz1 c 2 161 ; chgrp $GROUP ptyz1
    # mknod -m $MODE ptyz2 c 2 162 ; chgrp $GROUP ptyz2
    # mknod -m $MODE ptyz3 c 2 163 ; chgrp $GROUP ptyz3
    # mknod -m $MODE ptyz4 c 2 164 ; chgrp $GROUP ptyz4
    # mknod -m $MODE ptyz5 c 2 165 ; chgrp $GROUP ptyz5
    # mknod -m $MODE ptyz6 c 2 166 ; chgrp $GROUP ptyz6
    # mknod -m $MODE ptyz7 c 2 167 ; chgrp $GROUP ptyz7
    # mknod -m $MODE ptyz8 c 2 168 ; chgrp $GROUP ptyz8
    # mknod -m $MODE ptyz9 c 2 169 ; chgrp $GROUP ptyz9
    # mknod -m $MODE ptyza c 2 170 ; chgrp $GROUP ptyza
    # mknod -m $MODE ptyzb c 2 171 ; chgrp $GROUP ptyzb
    # mknod -m $MODE ptyzc c 2 172 ; chgrp $GROUP ptyzc
    # mknod -m $MODE ptyzd c 2 173 ; chgrp $GROUP ptyzd
    # mknod -m $MODE ptyze c 2 174 ; chgrp $GROUP ptyze
    # mknod -m $MODE ptyzf c 2 175 ; chgrp $GROUP ptyzf
    # mknod -m $MODE ptya0 c 2 176 ; chgrp $GROUP ptya0
    # mknod -m $MODE ptya1 c 2 177 ; chgrp $GROUP ptya1
    # mknod -m $MODE ptya2 c 2 178 ; chgrp $GROUP ptya2
    # mknod -m $MODE ptya3 c 2 179 ; chgrp $GROUP ptya3
    # mknod -m $MODE ptya4 c 2 180 ; chgrp $GROUP ptya4
    # mknod -m $MODE ptya5 c 2 181 ; chgrp $GROUP ptya5
    # mknod -m $MODE ptya6 c 2 182 ; chgrp $GROUP ptya6
    # mknod -m $MODE ptya7 c 2 183 ; chgrp $GROUP ptya7
    # mknod -m $MODE ptya8 c 2 184 ; chgrp $GROUP ptya8
    # mknod -m $MODE ptya9 c 2 185 ; chgrp $GROUP ptya9
    # mknod -m $MODE ptyaa c 2 186 ; chgrp $GROUP ptyaa
    # mknod -m $MODE ptyab c 2 187 ; chgrp $GROUP ptyab
    # mknod -m $MODE ptyac c 2 188 ; chgrp $GROUP ptyac
    # mknod -m $MODE ptyad c 2 189 ; chgrp $GROUP ptyad
    # mknod -m $MODE ptyae c 2 190 ; chgrp $GROUP ptyae
    # mknod -m $MODE ptyaf c 2 191 ; chgrp $GROUP ptyaf
    # mknod -m $MODE ptyb0 c 2 192 ; chgrp $GROUP ptyb0
    # mknod -m $MODE ptyb1 c 2 193 ; chgrp $GROUP ptyb1
    # mknod -m $MODE ptyb2 c 2 194 ; chgrp $GROUP ptyb2
    # mknod -m $MODE ptyb3 c 2 195 ; chgrp $GROUP ptyb3
    # mknod -m $MODE ptyb4 c 2 196 ; chgrp $GROUP ptyb4
    # mknod -m $MODE ptyb5 c 2 197 ; chgrp $GROUP ptyb5
    # mknod -m $MODE ptyb6 c 2 198 ; chgrp $GROUP ptyb6
    # mknod -m $MODE ptyb7 c 2 199 ; chgrp $GROUP ptyb7
    # mknod -m $MODE ptyb8 c 2 200 ; chgrp $GROUP ptyb8
    # mknod -m $MODE ptyb9 c 2 201 ; chgrp $GROUP ptyb9
    # mknod -m $MODE ptyba c 2 202 ; chgrp $GROUP ptyba
    # mknod -m $MODE ptybb c 2 203 ; chgrp $GROUP ptybb
    # mknod -m $MODE ptybc c 2 204 ; chgrp $GROUP ptybc
    # mknod -m $MODE ptybd c 2 205 ; chgrp $GROUP ptybd
    # mknod -m $MODE ptybe c 2 206 ; chgrp $GROUP ptybe
    # mknod -m $MODE ptybf c 2 207 ; chgrp $GROUP ptybf
    # mknod -m $MODE ptyc0 c 2 208 ; chgrp $GROUP ptyc0
    # mknod -m $MODE ptyc1 c 2 209 ; chgrp $GROUP ptyc1
    # mknod -m $MODE ptyc2 c 2 210 ; chgrp $GROUP ptyc2
    # mknod -m $MODE ptyc3 c 2 211 ; chgrp $GROUP ptyc3
    # mknod -m $MODE ptyc4 c 2 212 ; chgrp $GROUP ptyc4
    # mknod -m $MODE ptyc5 c 2 213 ; chgrp $GROUP ptyc5
    # mknod -m $MODE ptyc6 c 2 214 ; chgrp $GROUP ptyc6
    # mknod -m $MODE ptyc7 c 2 215 ; chgrp $GROUP ptyc7
    # mknod -m $MODE ptyc8 c 2 216 ; chgrp $GROUP ptyc8
    # mknod -m $MODE ptyc9 c 2 217 ; chgrp $GROUP ptyc9
    # mknod -m $MODE ptyca c 2 218 ; chgrp $GROUP ptyca
    # mknod -m $MODE ptycb c 2 219 ; chgrp $GROUP ptycb
    # mknod -m $MODE ptycc c 2 220 ; chgrp $GROUP ptycc
    # mknod -m $MODE ptycd c 2 221 ; chgrp $GROUP ptycd
    # mknod -m $MODE ptyce c 2 222 ; chgrp $GROUP ptyce
    # mknod -m $MODE ptycf c 2 223 ; chgrp $GROUP ptycf
    # mknod -m $MODE ptyd0 c 2 224 ; chgrp $GROUP ptyd0
    # mknod -m $MODE ptyd1 c 2 225 ; chgrp $GROUP ptyd1
    # mknod -m $MODE ptyd2 c 2 226 ; chgrp $GROUP ptyd2
    # mknod -m $MODE ptyd3 c 2 227 ; chgrp $GROUP ptyd3
    # mknod -m $MODE ptyd4 c 2 228 ; chgrp $GROUP ptyd4
    # mknod -m $MODE ptyd5 c 2 229 ; chgrp $GROUP ptyd5
    # mknod -m $MODE ptyd6 c 2 230 ; chgrp $GROUP ptyd6
    # mknod -m $MODE ptyd7 c 2 231 ; chgrp $GROUP ptyd7
    # mknod -m $MODE ptyd8 c 2 232 ; chgrp $GROUP ptyd8
    # mknod -m $MODE ptyd9 c 2 233 ; chgrp $GROUP ptyd9
    # mknod -m $MODE ptyda c 2 234 ; chgrp $GROUP ptyda
    # mknod -m $MODE ptydb c 2 235 ; chgrp $GROUP ptydb
    # mknod -m $MODE ptydc c 2 236 ; chgrp $GROUP ptydc
    # mknod -m $MODE ptydd c 2 237 ; chgrp $GROUP ptydd
    # mknod -m $MODE ptyde c 2 238 ; chgrp $GROUP ptyde
    # mknod -m $MODE ptydf c 2 239 ; chgrp $GROUP ptydf
    # mknod -m $MODE ptye0 c 2 240 ; chgrp $GROUP ptye0
    # mknod -m $MODE ptye1 c 2 241 ; chgrp $GROUP ptye1
    # mknod -m $MODE ptye2 c 2 242 ; chgrp $GROUP ptye2
    # mknod -m $MODE ptye3 c 2 243 ; chgrp $GROUP ptye3
    # mknod -m $MODE ptye4 c 2 244 ; chgrp $GROUP ptye4
    # mknod -m $MODE ptye5 c 2 245 ; chgrp $GROUP ptye5
    # mknod -m $MODE ptye6 c 2 246 ; chgrp $GROUP ptye6
    # mknod -m $MODE ptye7 c 2 247 ; chgrp $GROUP ptye7
    # mknod -m $MODE ptye8 c 2 248 ; chgrp $GROUP ptye8
    # mknod -m $MODE ptye9 c 2 249 ; chgrp $GROUP ptye9
    # mknod -m $MODE ptyea c 2 250 ; chgrp $GROUP ptyea
    # mknod -m $MODE ptyeb c 2 251 ; chgrp $GROUP ptyeb
    # mknod -m $MODE ptyec c 2 252 ; chgrp $GROUP ptyec
    # mknod -m $MODE ptyed c 2 253 ; chgrp $GROUP ptyed
    # mknod -m $MODE ptyee c 2 254 ; chgrp $GROUP ptyee
    # 256th PTY master 
    # mknod -m $MODE ptyef c 2 255 ; chgrp $GROUP ptyef

#****************************************************************************
#                         Pseudo-TTY slaves
#****************************************************************************

    # First PTY slave
    # mknod -m $MODE ttyp0 c 3 0 ; chgrp $GROUP ttyp0
    # Second PTY slave
    # mknod -m $MODE ttyp1 c 3 1 ; chgrp $GROUP ttyp1
    # mknod -m $MODE ttyp2 c 3 2 ; chgrp $GROUP ttyp2
    # mknod -m $MODE ttyp3 c 3 3 ; chgrp $GROUP ttyp3
    # mknod -m $MODE ttyp4 c 3 4 ; chgrp $GROUP ttyp4
    # mknod -m $MODE ttyp5 c 3 5 ; chgrp $GROUP ttyp5
    # mknod -m $MODE ttyp6 c 3 6 ; chgrp $GROUP ttyp6
    # mknod -m $MODE ttyp7 c 3 7 ; chgrp $GROUP ttyp7
    # mknod -m $MODE ttyp8 c 3 8 ; chgrp $GROUP ttyp8
    # mknod -m $MODE ttyp9 c 3 9 ; chgrp $GROUP ttyp9
    # mknod -m $MODE ttypa c 3 10 ; chgrp $GROUP ttypa
    # mknod -m $MODE ttypb c 3 11 ; chgrp $GROUP ttypb
    # mknod -m $MODE ttypc c 3 12 ; chgrp $GROUP ttypc
    # mknod -m $MODE ttypd c 3 13 ; chgrp $GROUP ttypd
    # mknod -m $MODE ttype c 3 14 ; chgrp $GROUP ttype
    # mknod -m $MODE ttypf c 3 15 ; chgrp $GROUP ttypf
    # mknod -m $MODE ttyq0 c 3 16 ; chgrp $GROUP ttyq0
    # mknod -m $MODE ttyq1 c 3 17 ; chgrp $GROUP ttyq1
    # mknod -m $MODE ttyq2 c 3 18 ; chgrp $GROUP ttyq2
    # mknod -m $MODE ttyq3 c 3 19 ; chgrp $GROUP ttyq3
    # mknod -m $MODE ttyq4 c 3 20 ; chgrp $GROUP ttyq4
    # mknod -m $MODE ttyq5 c 3 21 ; chgrp $GROUP ttyq5
    # mknod -m $MODE ttyq6 c 3 22 ; chgrp $GROUP ttyq6
    # mknod -m $MODE ttyq7 c 3 23 ; chgrp $GROUP ttyq7
    # mknod -m $MODE ttyq8 c 3 24 ; chgrp $GROUP ttyq8
    # mknod -m $MODE ttyq9 c 3 25 ; chgrp $GROUP ttyq9
    # mknod -m $MODE ttyqa c 3 26 ; chgrp $GROUP ttyqa
    # mknod -m $MODE ttyqb c 3 27 ; chgrp $GROUP ttyqb
    # mknod -m $MODE ttyqc c 3 28 ; chgrp $GROUP ttyqc
    # mknod -m $MODE ttyqd c 3 29 ; chgrp $GROUP ttyqd
    # mknod -m $MODE ttyqe c 3 30 ; chgrp $GROUP ttyqe
    # mknod -m $MODE ttyqf c 3 31 ; chgrp $GROUP ttyqf
    # mknod -m $MODE ttyr0 c 3 32 ; chgrp $GROUP ttyr0
    # mknod -m $MODE ttyr1 c 3 33 ; chgrp $GROUP ttyr1
    # mknod -m $MODE ttyr2 c 3 34 ; chgrp $GROUP ttyr2
    # mknod -m $MODE ttyr3 c 3 35 ; chgrp $GROUP ttyr3
    # mknod -m $MODE ttyr4 c 3 36 ; chgrp $GROUP ttyr4
    # mknod -m $MODE ttyr5 c 3 37 ; chgrp $GROUP ttyr5
    # mknod -m $MODE ttyr6 c 3 38 ; chgrp $GROUP ttyr6
    # mknod -m $MODE ttyr7 c 3 39 ; chgrp $GROUP ttyr7
    # mknod -m $MODE ttyr8 c 3 40 ; chgrp $GROUP ttyr8
    # mknod -m $MODE ttyr9 c 3 41 ; chgrp $GROUP ttyr9
    # mknod -m $MODE ttyra c 3 42 ; chgrp $GROUP ttyra
    # mknod -m $MODE ttyrb c 3 43 ; chgrp $GROUP ttyrb
    # mknod -m $MODE ttyrc c 3 44 ; chgrp $GROUP ttyrc
    # mknod -m $MODE ttyrd c 3 45 ; chgrp $GROUP ttyrd
    # mknod -m $MODE ttyre c 3 46 ; chgrp $GROUP ttyre
    # mknod -m $MODE ttyrf c 3 47 ; chgrp $GROUP ttyrf
    # mknod -m $MODE ttys0 c 3 48 ; chgrp $GROUP ttys0
    # mknod -m $MODE ttys1 c 3 49 ; chgrp $GROUP ttys1
    # mknod -m $MODE ttys2 c 3 50 ; chgrp $GROUP ttys2
    # mknod -m $MODE ttys3 c 3 51 ; chgrp $GROUP ttys3
    # mknod -m $MODE ttys4 c 3 52 ; chgrp $GROUP ttys4
    # mknod -m $MODE ttys5 c 3 53 ; chgrp $GROUP ttys5
    # mknod -m $MODE ttys6 c 3 54 ; chgrp $GROUP ttys6
    # mknod -m $MODE ttys7 c 3 55 ; chgrp $GROUP ttys7
    # mknod -m $MODE ttys8 c 3 56 ; chgrp $GROUP ttys8
    # mknod -m $MODE ttys9 c 3 57 ; chgrp $GROUP ttys9
    # mknod -m $MODE ttysa c 3 58 ; chgrp $GROUP ttysa
    # mknod -m $MODE ttysb c 3 59 ; chgrp $GROUP ttysb
    # mknod -m $MODE ttysc c 3 60 ; chgrp $GROUP ttysc
    # mknod -m $MODE ttysd c 3 61 ; chgrp $GROUP ttysd
    # mknod -m $MODE ttyse c 3 62 ; chgrp $GROUP ttyse
    # mknod -m $MODE ttysf c 3 63 ; chgrp $GROUP ttysf
    # mknod -m $MODE ttyt0 c 3 64 ; chgrp $GROUP ttyt0
    # mknod -m $MODE ttyt1 c 3 65 ; chgrp $GROUP ttyt1
    # mknod -m $MODE ttyt2 c 3 66 ; chgrp $GROUP ttyt2
    # mknod -m $MODE ttyt3 c 3 67 ; chgrp $GROUP ttyt3
    # mknod -m $MODE ttyt4 c 3 68 ; chgrp $GROUP ttyt4
    # mknod -m $MODE ttyt5 c 3 69 ; chgrp $GROUP ttyt5
    # mknod -m $MODE ttyt6 c 3 70 ; chgrp $GROUP ttyt6
    # mknod -m $MODE ttyt7 c 3 71 ; chgrp $GROUP ttyt7
    # mknod -m $MODE ttyt8 c 3 72 ; chgrp $GROUP ttyt8
    # mknod -m $MODE ttyt9 c 3 73 ; chgrp $GROUP ttyt9
    # mknod -m $MODE ttyta c 3 74 ; chgrp $GROUP ttyta
    # mknod -m $MODE ttytb c 3 75 ; chgrp $GROUP ttytb
    # mknod -m $MODE ttytc c 3 76 ; chgrp $GROUP ttytc
    # mknod -m $MODE ttytd c 3 77 ; chgrp $GROUP ttytd
    # mknod -m $MODE ttyte c 3 78 ; chgrp $GROUP ttyte
    # mknod -m $MODE ttytf c 3 79 ; chgrp $GROUP ttytf
    # mknod -m $MODE ttyu0 c 3 80 ; chgrp $GROUP ttyu0
    # mknod -m $MODE ttyu1 c 3 81 ; chgrp $GROUP ttyu1
    # mknod -m $MODE ttyu2 c 3 82 ; chgrp $GROUP ttyu2
    # mknod -m $MODE ttyu3 c 3 83 ; chgrp $GROUP ttyu3
    # mknod -m $MODE ttyu4 c 3 84 ; chgrp $GROUP ttyu4
    # mknod -m $MODE ttyu5 c 3 85 ; chgrp $GROUP ttyu5
    # mknod -m $MODE ttyu6 c 3 86 ; chgrp $GROUP ttyu6
    # mknod -m $MODE ttyu7 c 3 87 ; chgrp $GROUP ttyu7
    # mknod -m $MODE ttyu8 c 3 88 ; chgrp $GROUP ttyu8
    # mknod -m $MODE ttyu9 c 3 89 ; chgrp $GROUP ttyu9
    # mknod -m $MODE ttyua c 3 90 ; chgrp $GROUP ttyua
    # mknod -m $MODE ttyub c 3 91 ; chgrp $GROUP ttyub
    # mknod -m $MODE ttyuc c 3 92 ; chgrp $GROUP ttyuc
    # mknod -m $MODE ttyud c 3 93 ; chgrp $GROUP ttyud
    # mknod -m $MODE ttyue c 3 94 ; chgrp $GROUP ttyue
    # mknod -m $MODE ttyuf c 3 95 ; chgrp $GROUP ttyuf
    # mknod -m $MODE ttyv0 c 3 96 ; chgrp $GROUP ttyv0
    # mknod -m $MODE ttyv1 c 3 97 ; chgrp $GROUP ttyv1
    # mknod -m $MODE ttyv2 c 3 98 ; chgrp $GROUP ttyv2
    # mknod -m $MODE ttyv3 c 3 99 ; chgrp $GROUP ttyv3
    # mknod -m $MODE ttyv4 c 3 100 ; chgrp $GROUP ttyv4
    # mknod -m $MODE ttyv5 c 3 101 ; chgrp $GROUP ttyv5
    # mknod -m $MODE ttyv6 c 3 102 ; chgrp $GROUP ttyv6
    # mknod -m $MODE ttyv7 c 3 103 ; chgrp $GROUP ttyv7
    # mknod -m $MODE ttyv8 c 3 104 ; chgrp $GROUP ttyv8
    # mknod -m $MODE ttyv9 c 3 105 ; chgrp $GROUP ttyv9
    # mknod -m $MODE ttyva c 3 106 ; chgrp $GROUP ttyva
    # mknod -m $MODE ttyvb c 3 107 ; chgrp $GROUP ttyvb
    # mknod -m $MODE ttyvc c 3 108 ; chgrp $GROUP ttyvc
    # mknod -m $MODE ttyvd c 3 109 ; chgrp $GROUP ttyvd
    # mknod -m $MODE ttyve c 3 110 ; chgrp $GROUP ttyve
    # mknod -m $MODE ttyvf c 3 111 ; chgrp $GROUP ttyvf
    # mknod -m $MODE ttyw0 c 3 112 ; chgrp $GROUP ttyw0
    # mknod -m $MODE ttyw1 c 3 113 ; chgrp $GROUP ttyw1
    # mknod -m $MODE ttyw2 c 3 114 ; chgrp $GROUP ttyw2
    # mknod -m $MODE ttyw3 c 3 115 ; chgrp $GROUP ttyw3
    # mknod -m $MODE ttyw4 c 3 116 ; chgrp $GROUP ttyw4
    # mknod -m $MODE ttyw5 c 3 117 ; chgrp $GROUP ttyw5
    # mknod -m $MODE ttyw6 c 3 118 ; chgrp $GROUP ttyw6
    # mknod -m $MODE ttyw7 c 3 119 ; chgrp $GROUP ttyw7
    # mknod -m $MODE ttyw8 c 3 120 ; chgrp $GROUP ttyw8
    # mknod -m $MODE ttyw9 c 3 121 ; chgrp $GROUP ttyw9
    # mknod -m $MODE ttywa c 3 122 ; chgrp $GROUP ttywa
    # mknod -m $MODE ttywb c 3 123 ; chgrp $GROUP ttywb
    # mknod -m $MODE ttywc c 3 124 ; chgrp $GROUP ttywc
    # mknod -m $MODE ttywd c 3 125 ; chgrp $GROUP ttywd
    # mknod -m $MODE ttywe c 3 126 ; chgrp $GROUP ttywe
    # mknod -m $MODE ttywf c 3 127 ; chgrp $GROUP ttywf
    # mknod -m $MODE ttyx0 c 3 128 ; chgrp $GROUP ttyx0
    # mknod -m $MODE ttyx1 c 3 129 ; chgrp $GROUP ttyx1
    # mknod -m $MODE ttyx2 c 3 130 ; chgrp $GROUP ttyx2
    # mknod -m $MODE ttyx3 c 3 131 ; chgrp $GROUP ttyx3
    # mknod -m $MODE ttyx4 c 3 132 ; chgrp $GROUP ttyx4
    # mknod -m $MODE ttyx5 c 3 133 ; chgrp $GROUP ttyx5
    # mknod -m $MODE ttyx6 c 3 134 ; chgrp $GROUP ttyx6
    # mknod -m $MODE ttyx7 c 3 135 ; chgrp $GROUP ttyx7
    # mknod -m $MODE ttyx8 c 3 136 ; chgrp $GROUP ttyx8
    # mknod -m $MODE ttyx9 c 3 137 ; chgrp $GROUP ttyx9
    # mknod -m $MODE ttyxa c 3 138 ; chgrp $GROUP ttyxa
    # mknod -m $MODE ttyxb c 3 139 ; chgrp $GROUP ttyxb
    # mknod -m $MODE ttyxc c 3 140 ; chgrp $GROUP ttyxc
    # mknod -m $MODE ttyxd c 3 141 ; chgrp $GROUP ttyxd
    # mknod -m $MODE ttyxe c 3 142 ; chgrp $GROUP ttyxe
    # mknod -m $MODE ttyxf c 3 143 ; chgrp $GROUP ttyxf
    # mknod -m $MODE ttyy0 c 3 144 ; chgrp $GROUP ttyy0
    # mknod -m $MODE ttyy1 c 3 145 ; chgrp $GROUP ttyy1
    # mknod -m $MODE ttyy2 c 3 146 ; chgrp $GROUP ttyy2
    # mknod -m $MODE ttyy3 c 3 147 ; chgrp $GROUP ttyy3
    # mknod -m $MODE ttyy4 c 3 148 ; chgrp $GROUP ttyy4
    # mknod -m $MODE ttyy5 c 3 149 ; chgrp $GROUP ttyy5
    # mknod -m $MODE ttyy6 c 3 150 ; chgrp $GROUP ttyy6
    # mknod -m $MODE ttyy7 c 3 151 ; chgrp $GROUP ttyy7
    # mknod -m $MODE ttyy8 c 3 152 ; chgrp $GROUP ttyy8
    # mknod -m $MODE ttyy9 c 3 153 ; chgrp $GROUP ttyy9
    # mknod -m $MODE ttyya c 3 154 ; chgrp $GROUP ttyya
    # mknod -m $MODE ttyyb c 3 155 ; chgrp $GROUP ttyyb
    # mknod -m $MODE ttyyc c 3 156 ; chgrp $GROUP ttyyc
    # mknod -m $MODE ttyyd c 3 157 ; chgrp $GROUP ttyyd
    # mknod -m $MODE ttyye c 3 158 ; chgrp $GROUP ttyye
    # mknod -m $MODE ttyyf c 3 159 ; chgrp $GROUP ttyyf
    # mknod -m $MODE ttyz0 c 3 160 ; chgrp $GROUP ttyz0
    # mknod -m $MODE ttyz1 c 3 161 ; chgrp $GROUP ttyz1
    # mknod -m $MODE ttyz2 c 3 162 ; chgrp $GROUP ttyz2
    # mknod -m $MODE ttyz3 c 3 163 ; chgrp $GROUP ttyz3
    # mknod -m $MODE ttyz4 c 3 164 ; chgrp $GROUP ttyz4
    # mknod -m $MODE ttyz5 c 3 165 ; chgrp $GROUP ttyz5
    # mknod -m $MODE ttyz6 c 3 166 ; chgrp $GROUP ttyz6
    # mknod -m $MODE ttyz7 c 3 167 ; chgrp $GROUP ttyz7
    # mknod -m $MODE ttyz8 c 3 168 ; chgrp $GROUP ttyz8
    # mknod -m $MODE ttyz9 c 3 169 ; chgrp $GROUP ttyz9
    # mknod -m $MODE ttyza c 3 170 ; chgrp $GROUP ttyza
    # mknod -m $MODE ttyzb c 3 171 ; chgrp $GROUP ttyzb
    # mknod -m $MODE ttyzc c 3 172 ; chgrp $GROUP ttyzc
    # mknod -m $MODE ttyzd c 3 173 ; chgrp $GROUP ttyzd
    # mknod -m $MODE ttyze c 3 174 ; chgrp $GROUP ttyze
    # mknod -m $MODE ttyzf c 3 175 ; chgrp $GROUP ttyzf
    # mknod -m $MODE ttya0 c 3 176 ; chgrp $GROUP ttya0
    # mknod -m $MODE ttya1 c 3 177 ; chgrp $GROUP ttya1
    # mknod -m $MODE ttya2 c 3 178 ; chgrp $GROUP ttya2
    # mknod -m $MODE ttya3 c 3 179 ; chgrp $GROUP ttya3
    # mknod -m $MODE ttya4 c 3 180 ; chgrp $GROUP ttya4
    # mknod -m $MODE ttya5 c 3 181 ; chgrp $GROUP ttya5
    # mknod -m $MODE ttya6 c 3 182 ; chgrp $GROUP ttya6
    # mknod -m $MODE ttya7 c 3 183 ; chgrp $GROUP ttya7
    # mknod -m $MODE ttya8 c 3 184 ; chgrp $GROUP ttya8
    # mknod -m $MODE ttya9 c 3 185 ; chgrp $GROUP ttya9
    # mknod -m $MODE ttyaa c 3 186 ; chgrp $GROUP ttyaa
    # mknod -m $MODE ttyab c 3 187 ; chgrp $GROUP ttyab
    # mknod -m $MODE ttyac c 3 188 ; chgrp $GROUP ttyac
    # mknod -m $MODE ttyad c 3 189 ; chgrp $GROUP ttyad
    # mknod -m $MODE ttyae c 3 190 ; chgrp $GROUP ttyae
    # mknod -m $MODE ttyaf c 3 191 ; chgrp $GROUP ttyaf
    # mknod -m $MODE ttyb0 c 3 192 ; chgrp $GROUP ttyb0
    # mknod -m $MODE ttyb1 c 3 193 ; chgrp $GROUP ttyb1
    # mknod -m $MODE ttyb2 c 3 194 ; chgrp $GROUP ttyb2
    # mknod -m $MODE ttyb3 c 3 195 ; chgrp $GROUP ttyb3
    # mknod -m $MODE ttyb4 c 3 196 ; chgrp $GROUP ttyb4
    # mknod -m $MODE ttyb5 c 3 197 ; chgrp $GROUP ttyb5
    # mknod -m $MODE ttyb6 c 3 198 ; chgrp $GROUP ttyb6
    # mknod -m $MODE ttyb7 c 3 199 ; chgrp $GROUP ttyb7
    # mknod -m $MODE ttyb8 c 3 200 ; chgrp $GROUP ttyb8
    # mknod -m $MODE ttyb9 c 3 201 ; chgrp $GROUP ttyb9
    # mknod -m $MODE ttyba c 3 202 ; chgrp $GROUP ttyba
    # mknod -m $MODE ttybb c 3 203 ; chgrp $GROUP ttybb
    # mknod -m $MODE ttybc c 3 204 ; chgrp $GROUP ttybc
    # mknod -m $MODE ttybd c 3 205 ; chgrp $GROUP ttybd
    # mknod -m $MODE ttybe c 3 206 ; chgrp $GROUP ttybe
    # mknod -m $MODE ttybf c 3 207 ; chgrp $GROUP ttybf
    # mknod -m $MODE ttyc0 c 3 208 ; chgrp $GROUP ttyc0
    # mknod -m $MODE ttyc1 c 3 209 ; chgrp $GROUP ttyc1
    # mknod -m $MODE ttyc2 c 3 210 ; chgrp $GROUP ttyc2
    # mknod -m $MODE ttyc3 c 3 211 ; chgrp $GROUP ttyc3
    # mknod -m $MODE ttyc4 c 3 212 ; chgrp $GROUP ttyc4
    # mknod -m $MODE ttyc5 c 3 213 ; chgrp $GROUP ttyc5
    # mknod -m $MODE ttyc6 c 3 214 ; chgrp $GROUP ttyc6
    # mknod -m $MODE ttyc7 c 3 215 ; chgrp $GROUP ttyc7
    # mknod -m $MODE ttyc8 c 3 216 ; chgrp $GROUP ttyc8
    # mknod -m $MODE ttyc9 c 3 217 ; chgrp $GROUP ttyc9
    # mknod -m $MODE ttyca c 3 218 ; chgrp $GROUP ttyca
    # mknod -m $MODE ttycb c 3 219 ; chgrp $GROUP ttycb
    # mknod -m $MODE ttycc c 3 220 ; chgrp $GROUP ttycc
    # mknod -m $MODE ttycd c 3 221 ; chgrp $GROUP ttycd
    # mknod -m $MODE ttyce c 3 222 ; chgrp $GROUP ttyce
    # mknod -m $MODE ttycf c 3 223 ; chgrp $GROUP ttycf
    # mknod -m $MODE ttyd0 c 3 224 ; chgrp $GROUP ttyd0
    # mknod -m $MODE ttyd1 c 3 225 ; chgrp $GROUP ttyd1
    # mknod -m $MODE ttyd2 c 3 226 ; chgrp $GROUP ttyd2
    # mknod -m $MODE ttyd3 c 3 227 ; chgrp $GROUP ttyd3
    # mknod -m $MODE ttyd4 c 3 228 ; chgrp $GROUP ttyd4
    # mknod -m $MODE ttyd5 c 3 229 ; chgrp $GROUP ttyd5
    # mknod -m $MODE ttyd6 c 3 230 ; chgrp $GROUP ttyd6
    # mknod -m $MODE ttyd7 c 3 231 ; chgrp $GROUP ttyd7
    # mknod -m $MODE ttyd8 c 3 232 ; chgrp $GROUP ttyd8
    # mknod -m $MODE ttyd9 c 3 233 ; chgrp $GROUP ttyd9
    # mknod -m $MODE ttyda c 3 234 ; chgrp $GROUP ttyda
    # mknod -m $MODE ttydb c 3 235 ; chgrp $GROUP ttydb
    # mknod -m $MODE ttydc c 3 236 ; chgrp $GROUP ttydc
    # mknod -m $MODE ttydd c 3 237 ; chgrp $GROUP ttydd
    # mknod -m $MODE ttyde c 3 238 ; chgrp $GROUP ttyde
    # mknod -m $MODE ttydf c 3 239 ; chgrp $GROUP ttydf
    # mknod -m $MODE ttye0 c 3 240 ; chgrp $GROUP ttye0
    # mknod -m $MODE ttye1 c 3 241 ; chgrp $GROUP ttye1
    # mknod -m $MODE ttye2 c 3 242 ; chgrp $GROUP ttye2
    # mknod -m $MODE ttye3 c 3 243 ; chgrp $GROUP ttye3
    # mknod -m $MODE ttye4 c 3 244 ; chgrp $GROUP ttye4
    # mknod -m $MODE ttye5 c 3 245 ; chgrp $GROUP ttye5
    # mknod -m $MODE ttye6 c 3 246 ; chgrp $GROUP ttye6
    # mknod -m $MODE ttye7 c 3 247 ; chgrp $GROUP ttye7
    # mknod -m $MODE ttye8 c 3 248 ; chgrp $GROUP ttye8
    # mknod -m $MODE ttye9 c 3 249 ; chgrp $GROUP ttye9
    # mknod -m $MODE ttyea c 3 250 ; chgrp $GROUP ttyea
    # mknod -m $MODE ttyeb c 3 251 ; chgrp $GROUP ttyeb
    # mknod -m $MODE ttyec c 3 252 ; chgrp $GROUP ttyec
    # mknod -m $MODE ttyed c 3 253 ; chgrp $GROUP ttyed
    # mknod -m $MODE ttyee c 3 254 ; chgrp $GROUP ttyee
    # 256th PTY slave 
    # mknod -m $MODE ttyef c 3 255 ; chgrp $GROUP ttyef




#############################################################################
GROUP=$video ; MODE=660
#############################################################################

#****************************************************************************
#                         3Dfx Voodoo Graphics device
#****************************************************************************

    # Primary 3Dfx graphics device 
    # mknod -m $MODE 3dfx c 107 0 ; chgrp $GROUP 3dfx

#****************************************************************************
#                         misc features
#****************************************************************************

    # Linux/SGI graphics device
    # mknod -m $MODE graphics c 10 146 ; chgrp $GROUP graphics

    # Linux/SGI OpenGL pipe
    # mknod -m $MODE opengl c 10 147 ; chgrp $GROUP opengl

    # Linux/SGI graphics effects device
    # mknod -m $MODE gfx c 10 148 ; chgrp $GROUP gfx
    
    # AGP Graphics Address Remapping Table
    # mknod -m $MODE agpgart c 10 175 ; chgrp $GROUP agpgart

#****************************************************************************
#                         Picture Elements ISE board
#****************************************************************************

    # First ISE board
    # mknod -m $MODE ise0 c 114 0 ; chgrp $GROUP ise0
    # Second ISE board
    # mknod -m $MODE ise1 c 114 1 ; chgrp $GROUP ise1
    # ...

    # Control node for first ISE board
    # mknod -m $MODE isex0 c 114 128 ; chgrp $GROUP isex0
    # Control node for second ISE board 
    # mknod -m $MODE isex1 c 114 129 ; chgrp $GROUP isex1
    # ...

#****************************************************************************
#                         Philips SAA7146-based audio/video card {2.6}
#****************************************************************************

    # First A/V card
    # mknod -m $MODE av0 c 111 0 ; chgrp $GROUP av0
    # Second A/V card 
    # mknod -m $MODE av1 c 111 1 ; chgrp $GROUP av1
    # ...

#****************************************************************************
#                         Quanta WinVision frame grabber {2.6}
#****************************************************************************

    # Quanta WinVision frame grabber 
    # mknod -m $MODE wvisfgrab c 26 0 ; chgrp $GROUP wvisfgrab

#****************************************************************************
#                         Matrox Meteor frame grabber {2.6}
#****************************************************************************

    # Matrox Meteor frame grabber 
    # mknod -m $MODE mmetfgrab c 40 0 ; chgrp $GROUP mmetfgrab

#****************************************************************************
#                         video4linux
#****************************************************************************

    # Video capture/overlay device
    # mknod -m $MODE video0 c 81 0 ; chgrp $GROUP video0
    # mknod -m $MODE video1 c 81 1 ; chgrp $GROUP video1
    # ...
    # mknod -m $MODE video63 c 81 63 ; chgrp $GROUP video63

    # Radio device
    # mknod -m $MODE radio0 c 81 64 ; chgrp $GROUP radio0
    # mknod -m $MODE radio1 c 81 65 ; chgrp $GROUP radio1
    # ...
    # mknod -m $MODE radio63 c 81 127 ; chgrp $GROUP radio63

    # Teletext device
    # mknod -m $MODE vtx0 c 81 192 ; chgrp $GROUP vtx0
    # mknod -m $MODE vtx1 c 81 193 ; chgrp $GROUP vtx1
    # ...
    # mknod -m $MODE vtx31 c 81 223 ; chgrp $GROUP vtx31

    # Vertical blank interrupt
    # mknod -m $MODE vbi0 c 81 224 ; chgrp $GROUP vbi0
    # mknod -m $MODE vbi1 c 81 225 ; chgrp $GROUP vbi1
    # ...
    # mknod -m $MODE vbi31 c 81 255 ; chgrp $GROUP vbi31

#****************************************************************************
#                         WiNRADiO communications receiver card
#****************************************************************************

    # First WiNRADiO card
    # mknod -m $MODE winradio0 c 82 0 ; chgrp $GROUP winradio0
    # Second WiNRADiO card 
    # mknod -m $MODE winradio1 c 82 1 ; chgrp $GROUP winradio1
    # ...

#****************************************************************************
#                         Teletext/videotext interfaces {2.6}
#****************************************************************************

    # Teletext decoder
    # mknod -m $MODE vtx c 83 0 ; chgrp $GROUP vtx

    # TV tuner on teletext interface 
    # mknod -m $MODE vttuner c 83 16 ; chgrp $GROUP vttuner

#****************************************************************************
#                         IBM Smart Capture Card frame grabber {2.6}
#****************************************************************************

    # First Smart Capture Card
    # mknod -m $MODE iscc0 c 93 0 ; chgrp $GROUP iscc0
    # Second Smart Capture Card
    # mknod -m $MODE iscc1 c 93 1 ; chgrp $GROUP iscc1
    # ...

    # First Smart Capture Card control
    # mknod -m $MODE isccctl0 c 93 128 ; chgrp $GROUP isccctl0
    # Second Smart Capture Card control 
    # mknod -m $MODE isccctl1 c 93 129 ; chgrp $GROUP isccctl1
    # ...

#****************************************************************************
#                         miroVIDEO DC10/30 capture/playback device {2.6}
#****************************************************************************

    # First capture card
    # mknod -m $MODE dcxx0 c 94 0 ; chgrp $GROUP dcxx0
    # Second capture card 
    # mknod -m $MODE dcxx1 c 94 1 ; chgrp $GROUP dcxx1
    # ...

#****************************************************************************
#                         Philips SAA5249 Teletext signal decoder {2.6}
#****************************************************************************

    # First Teletext decoder
    # mknod -m $MODE tlk0 c 102 0 ; chgrp $GROUP tlk0
    # Second Teletext decoder
    # mknod -m $MODE tlk1 c 102 1 ; chgrp $GROUP tlk1
    # Third Teletext decoder
    # mknod -m $MODE tlk2 c 102 2 ; chgrp $GROUP tlk2
    # Fourth Teletext decoder 
    # mknod -m $MODE tlk3 c 102 3 ; chgrp $GROUP tlk3

#****************************************************************************
#                         miroMEDIA Surround board
#****************************************************************************

    # First miroMEDIA Surround board
    # mknod -m $MODE srnd0 c 110 0 ; chgrp $GROUP srnd0
    # Second miroMEDIA Surround board 
    # mknod -m $MODE srnd1 c 110 1 ; chgrp $GROUP srnd1
    # ...




#############################################################################
GROUP=$audio ; MODE=660
#############################################################################

#****************************************************************************
#                         Open Sound System (OSS)
#****************************************************************************

    # Mixer control
    # mknod -m $MODE mixer c 14 0 ; chgrp $GROUP mixer
    # Second soundcard mixer control
    # mknod -m $MODE mixer1 c 14 16 ; chgrp $GROUP mixer1

    # Audio sequencer
    # mknod -m $MODE sequencer c 14 1 ; chgrp $GROUP sequencer
    # Sequencer -- alternate device
    # mknod -m $MODE sequencer2 c 14 8 ; chgrp $GROUP sequencer2

    # Sequencer patch manager
    # mknod -m $MODE patmgr0 c 14 17 ; chgrp $GROUP patmgr0
    # Sequencer patch manager
    # mknod -m $MODE patmgr1 c 14 33 ; chgrp $GROUP patmgr1

    # First MIDI port
    # mknod -m $MODE midi00 c 14 2 ; chgrp $GROUP midi00
    # Second MIDI port
    # mknod -m $MODE midi01 c 14 18 ; chgrp $GROUP midi01
    # Third MIDI port
    # mknod -m $MODE midi02 c 14 34 ; chgrp $GROUP midi02
    # Fourth MIDI port 
    # mknod -m $MODE midi03 c 14 50 ; chgrp $GROUP midi03

    # Digital audio
    # mknod -m $MODE dsp c 14 3 ; chgrp $GROUP dsp
    # Second soundcard digital audio
    # mknod -m $MODE dsp1 c 14 19 ; chgrp $GROUP dsp1

    # Sun-compatible digital audio
    # mknod -m $MODE audio c 14 4 ; chgrp $GROUP audio
    # Second soundcard Sun digital audio
    # mknod -m $MODE audio1 c 14 20 ; chgrp $GROUP audio1

    # Sound card status information {2.6}
    # mknod -m $MODE sndstat c 14 6 ; chgrp $GROUP sndstat

    # SPARC audio control device
    # mknod -m $MODE audioctl c 14 7 ; chgrp $GROUP audioctl

#****************************************************************************
#                         MPU-401 MIDI
#****************************************************************************

    # MPU-401 data port
    # mknod -m $MODE mpu401data c 31 0 ; chgrp $GROUP mpu401data
    # MPU-401 status port 
    # mknod -m $MODE mpu401stat c 31 1 ; chgrp $GROUP mpu401stat


#****************************************************************************
#                         tclmidi MIDI driver
#****************************************************************************

    # First MIDI port, kernel timed
    # mknod -m $MODE midi0 c 35 0 ; chgrp $GROUP midi0
    # Second MIDI port, kernel timed
    # mknod -m $MODE midi1 c 35 1 ; chgrp $GROUP midi1
    # Third MIDI port, kernel timed
    # mknod -m $MODE midi2 c 35 2 ; chgrp $GROUP midi2
    # Fourth MIDI port, kernel timed
    # mknod -m $MODE midi3 c 35 3 ; chgrp $GROUP midi3

    # First MIDI port, untimed
    # mknod -m $MODE rmidi0 c 35 64 ; chgrp $GROUP rmidi0
    # Second MIDI port, untimed
    # mknod -m $MODE rmidi1 c 35 65 ; chgrp $GROUP rmidi1
    # Third MIDI port, untimed
    # mknod -m $MODE rmidi2 c 35 66 ; chgrp $GROUP rmidi2
    # Fourth MIDI port, untimed
    # mknod -m $MODE rmidi3 c 35 67 ; chgrp $GROUP rmidi3

    # First MIDI port, SMPTE timed
    # mknod -m $MODE smpte0 c 35 128 ; chgrp $GROUP smpte0
    # Second MIDI port, SMPTE timed
    # mknod -m $MODE smpte1 c 35 129 ; chgrp $GROUP smpte1
    # Third MIDI port, SMPTE timed
    # mknod -m $MODE smpte2 c 35 130 ; chgrp $GROUP smpte2
    # Fourth MIDI port, SMPTE timed 
    # mknod -m $MODE smpte3 c 35 131 ; chgrp $GROUP smpte3

#****************************************************************************
#                         Console driver speaker
#****************************************************************************

    # Speaker device file 
    # mknod -m $MODE speaker c 115 0 ; chgrp $GROUP speaker

#****************************************************************************
#                         PC speaker (OBSOLETE)
#****************************************************************************

    # Emulates /dev/mixer
    # mknod -m $MODE pcmixer c 13 0 ; chgrp $GROUP pcmixer

    # Emulates /dev/dsp (8-bit)
    # mknod -m $MODE pcsp c 13 1 ; chgrp $GROUP pcsp

    # Emulates /dev/audio
    # mknod -m $MODE pcaudio c 13 4 ; chgrp $GROUP pcaudio

    # Emulates /dev/dsp (16-bit) 
    # mknod -m $MODE pcsp16 c 13 5 ; chgrp $GROUP pcsp16

#****************************************************************************
#                         Motorola DSP 56xxx board
#****************************************************************************

    # Status information
    # mknod -m $MODE mdspstat c 101 0 ; chgrp $GROUP mdspstat

    # First DSP board I/O controls
    # mknod -m $MODE mdsp1 c 101 1 ; chgrp $GROUP mdsp1
    # ...
    # 16th DSP board I/O controls 
    # mknod -m $MODE mdsp16 c 101 16 ; chgrp $GROUP mdsp16

#****************************************************************************
#                         DSP56001 digital signal processor
#****************************************************************************

    # First DSP56001 
    # mknod -m $MODE dsp56k c 55 0 ; chgrp $GROUP dsp56k

#****************************************************************************
#                         Sony Control-A1 stereo control bus
#****************************************************************************

    # First device on chain
    # mknod -m $MODE controla0 c 87 0 ; chgrp $GROUP controla0
    # Second device on chain 
    # mknod -m $MODE controla1 c 87 1 ; chgrp $GROUP controla1
    # ...

#****************************************************************************
#                         SAM9407-based soundcard
#****************************************************************************

    # mknod -m $MODE sam0_mixer c 145 0 ; chgrp $GROUP sam0_mixer
    # mknod -m $MODE sam0_sequencer c 145 1 ; chgrp $GROUP sam0_sequencer
    # mknod -m $MODE sam0_midi00 c 145 2 ; chgrp $GROUP sam0_midi00
    # mknod -m $MODE sam0_dsp c 145 3 ; chgrp $GROUP sam0_dsp
    # mknod -m $MODE sam0_audio c 145 4 ; chgrp $GROUP sam0_audio
    # mknod -m $MODE sam0_sndstat c 145 6 ; chgrp $GROUP sam0_sndstat
    # mknod -m $MODE sam0_midi01 c 145 18 ; chgrp $GROUP sam0_midi01
    # mknod -m $MODE sam0_midi02 c 145 34 ; chgrp $GROUP sam0_midi02
    # mknod -m $MODE sam0_midi03 c 145 50 ; chgrp $GROUP sam0_midi03
    
    # mknod -m $MODE sam1_mixer c 145 64 ; chgrp $GROUP sam1_mixer
    # ...
    
    # mknod -m $MODE sam2_mixer c 145 128 ; chgrp $GROUP sam2_mixer
    # ...

    # mknod -m $MODE sam3_mixer c 145 192 ; chgrp $GROUP sam3_mixer
    # ...

#****************************************************************************
#                         Aureal Semiconductor Vortex Audio device
#****************************************************************************

    # First Aureal Vortex
    # mknod -m $MODE aureal0 c 147 0 ; chgrp $GROUP aureal0
    # Second Aureal Vortex 
    # mknod -m $MODE aureal1 c 147 1 ; chgrp $GROUP aureal1
    # ...




#############################################################################
GROUP=$system ; MODE=600
#############################################################################

#****************************************************************************
#                         Netlink support
#****************************************************************************

    # Routing, device updates, kernel to user
    # mknod -m $MODE route c 36 0 ; chgrp $GROUP route

    # enSKIP security cache control
    # mknod -m $MODE skip c 36 1 ; chgrp $GROUP skip

    # Firewall packet copies
    # mknod -m $MODE fwmonitor c 36 3 ; chgrp $GROUP fwmonitor

#****************************************************************************
#                         misc features
#****************************************************************************
    
    # Advanced Power Management BIOS
    # mknod -m $MODE apm_bios c 10 134 ; chgrp $GROUP apm_bios

    # VMWare virtual machine monitor
    # mknod -m $MODE vmmon c 10 165 ; chgrp $GROUP vmmon

    # Hardware fault trap
    # mknod -m $MODE hwtrap c 10 132 ; chgrp $GROUP hwtrap

    # External device trap
    # mknod -m $MODE exttrp c 10 133 ; chgrp $GROUP exttrp
    
    # Fancy beep device
    # mknod -m $MODE beep c 10 128 ; chgrp $GROUP beep

    # Kernel module load request {2.6}
    # mknod -m $MODE modreq c 10 129 ; chgrp $GROUP modreq

    # Watchdog timer port
    # mknod -m $MODE watchdog c 10 130 ; chgrp $GROUP watchdog

    # Machine internal temperature
    # mknod -m $MODE temperature c 10 131 ; chgrp $GROUP temperature

    # Real Time Clock
mknod -m $MODE rtc c 10 135 ; chgrp $GROUP rtc

    # SPARC OpenBoot PROM
    # mknod -m $MODE openprom c 10 139 ; chgrp $GROUP openprom

    # Berkshire Products Octal relay card
    # mknod -m $MODE relay8 c 10 140 ; chgrp $GROUP relay8

    # Berkshire Products ISO-16 relay card
    # mknod -m $MODE relay16 c 10 141 ; chgrp $GROUP relay16

    # x86 model-specific registers {2.6}
    # mknod -m $MODE msr c 10 142 ; chgrp $GROUP msr

    # PCI configuration space
    # mknod -m $MODE pciconf c 10 143 ; chgrp $GROUP pciconf

    # Non-volatile configuration RAM
    # mknod -m $MODE nvram c 10 144 ; chgrp $GROUP nvram

    # Soundcard shortwave modem control {2.6}
    # mknod -m $MODE hfmodem c 10 145 ; chgrp $GROUP hfmodem

    # Front panel LEDs
    # mknod -m $MODE led c 10 151 ; chgrp $GROUP led

    # Memory merge device
    # mknod -m $MODE mergemem c 10 153 ; chgrp $GROUP mergemem

    # Macintosh PowerBook power manager
    # mknod -m $MODE pmu c 10 154 ; chgrp $GROUP pmu

    # Vr41xx embedded touch panel
    # mknod -m $MODE vrtpanel c 10 11 ; chgrp $GROUP vrtpanel

    # Connectix Virtual PC Mouse
    # mknod -m $MODE vpcmouse c 10 13 ; chgrp $GROUP vpcmouse

    # MultiTech ISICom serial control
    # mknod -m $MODE isictl c 10 155 ; chgrp $GROUP isictl

    # Front panel LCD display
    # mknod -m $MODE lcd c 10 156 ; chgrp $GROUP lcd

    # Applicom Intl Profibus card
    # mknod -m $MODE ac c 10 157 ; chgrp $GROUP ac

    # Netwinder external button
    # mknod -m $MODE nwbutton c 10 158 ; chgrp $GROUP nwbutton

    # Netwinder debug interface
    # mknod -m $MODE nwdebug c 10 159 ; chgrp $GROUP nwdebug

    # Netwinder flash memory
    # mknod -m $MODE nwflash c 10 160 ; chgrp $GROUP nwflash

    # User-space DMA access
    # mknod -m $MODE userdma c 10 161 ; chgrp $GROUP userdma

    # System Management Bus
    # mknod -m $MODE smbus c 10 162 ; chgrp $GROUP smbus

    # Logitech Internet Keyboard
    # mknod -m $MODE lik c 10 163 ; chgrp $GROUP lik

    # Intel Intelligent Platform Management
    # mknod -m $MODE ipmo c 10 164 ; chgrp $GROUP ipmo

    # Specialix serial control
    # mknod -m $MODE specialix_sxctl c 10 167 ; chgrp $GROUP specialix_sxctl

    # Technology Concepts serial control
    # mknod -m $MODE tcldrv c 10 168 ; chgrp $GROUP tcldrv

    # Specialix RIO serial control
    # mknod -m $MODE specialix_rioctl c 10 169 ; chgrp $GROUP specialix_rioctl

    # IBM Thinkpad SMAPI
    # mknod -m $MODE smapi c 10 170 ; chgrp $GROUP smapi

    # QNX4 API IPC manager
    # mknod -m $MODE srripc c 10 171 ; chgrp $GROUP srripc

    # Semaphore clone device
    # mknod -m $MODE usemaclone c 10 172 ; chgrp $GROUP usemaclone

    # Intelligent Platform Management
    # mknod -m $MODE ipmikcs c 10 173 ; chgrp $GROUP ipmikcs

    # SPARCbook 3 microcontroller
    # mknod -m $MODE uctrl c 10 174 ; chgrp $GROUP uctrl

    # Gorgy Timing radio clock
    # mknod -m $MODE gtrsc c 10 176 ; chgrp $GROUP gtrsc

    # Serial CBM bus
    # mknod -m $MODE cbm c 10 177 ; chgrp $GROUP cbm

    # JavaStation OS flash SIMM
    # mknod -m $MODE jsflash c 10 178 ; chgrp $GROUP jsflash

    # High-speed shared-mem/semaphore service
    # mknod -m $MODE xsvc c 10 179 ; chgrp $GROUP xsvc

    # Vr41xx button input device
    # mknod -m $MODE vrbuttons c 10 180 ; chgrp $GROUP vrbuttons

    # Toshiba laptop SMM support
    # mknod -m $MODE toshiba c 10 181 ; chgrp $GROUP toshiba

    # Performance-monitoring counters
    # mknod -m $MODE perfctr c 10 182 ; chgrp $GROUP perfctr

    # Intel i8x0 random number generator
    # mknod -m $MODE intel_rng c 10 183 ; chgrp $GROUP intel_rng

    # Atomic shapshot of process state data
    # mknod -m $MODE atomicps c 10 186 ; chgrp $GROUP atomicps

    # IrNET device
    # mknod -m $MODE irnet c 10 187 ; chgrp $GROUP irnet

    # SMBus BIOS
    # mknod -m $MODE smbusbios c 10 188 ; chgrp $GROUP smbusbios

    # User space serial port control
    # mknod -m $MODE ussp_ctl c 10 189 ; chgrp $GROUP ussp_ctl

    # Mission Critical Linux crash dump facility
    # mknod -m $MODE crash c 10 190 ; chgrp $GROUP crash

    # <information missing>
    # mknod -m $MODE pcl181 c 10 191 ; chgrp $GROUP pcl181

    # NAS xbus LCD/buttons access
    # mknod -m $MODE nas_xbus c 10 192 ; chgrp $GROUP nas_xbus

    # SPARC 7-segment display
    # mknod -m $MODE d7s c 10 193 ; chgrp $GROUP d7s

    # Zero-Knowledge network shim control
    # mknod -m $MODE zkshim c 10 194 ; chgrp $GROUP zkshim
    
    # Signed executable interface
    # mknod -m $MODE sexec c 10 198 ; chgrp $GROUP sexec
    
#****************************************************************************
#                         User-mode virtual block device
#****************************************************************************

    # First user-mode block device
    # mknod -m $MODE ubd0 b 98 0 ; chgrp $GROUP ubd0
    # Second user-mode block device 
    # mknod -m $MODE ubd1 b 98 1 ; chgrp $GROUP ubd1
    # ...

#****************************************************************************
#                         Linux/SGI shared memory input queue
#****************************************************************************

    # Master shared input queue
    # mknod -m $MODE shmiq c 85 0 ; chgrp $GROUP shmiq

    # First device pushed
    # mknod -m $MODE qcntl0 c 85 1 ; chgrp $GROUP qcntl0

    # Second device pushed 
    # mknod -m $MODE qcntl1 c 85 2 ; chgrp $GROUP qcntl1






#############################################################################
GROUP=$obscure ; MODE=600
# I don't know where to put the following devices. They don't seem to be used
# much. If you need any of them, send
# me email and tell me to which group I should relocate the device with what
# permissions.
# This is the last group of this file. Unless you think you need an obscure
# device you can stop reading here.
#############################################################################

#****************************************************************************
#                         Memory Technology Device (RAM, ROM, Flash)
#****************************************************************************

    # First MTD (rw)
    # mknod -m $MODE mtd0 c 90 0 ; chgrp $GROUP mtd0
    # First MTD (ro)
    # mknod -m $MODE mtdr0 c 90 1 ; chgrp $GROUP mtdr0

    # ...

    # 16th MTD (rw)
    # mknod -m $MODE mtd15 c 90 30 ; chgrp $GROUP mtd15
    # 16th MTD (ro) 
    # mknod -m $MODE mtdr15 c 90 31 ; chgrp $GROUP mtdr15

#****************************************************************************
#                         CAN-Bus devices
#****************************************************************************

    # First CAN-Bus controller
    # mknod -m $MODE can0 c 91 0 ; chgrp $GROUP can0
    # Second CAN-Bus controller 
    # mknod -m $MODE can1 c 91 1 ; chgrp $GROUP can1
    # ...

#****************************************************************************
#                         Control and Measurement Device (comedi)
#****************************************************************************

    # First comedi device
    # mknod -m $MODE comedi0 c 98 0 ; chgrp $GROUP comedi0
    # Second comedi device 
    # mknod -m $MODE comedi1 c 98 1 ; chgrp $GROUP comedi1
    # ...
    
#****************************************************************************
#                         Solidum ???
#****************************************************************************

    # mknod -m $MODE solnp0 c 118 0 ; chgrp $GROUP solnp0
    # mknod -m $MODE solnp1 c 118 1 ; chgrp $GROUP solnp1
    # ...

    # mknod -m $MODE solnpctl0 c 118 128 ; chgrp $GROUP solnpctl0
    # mknod -m $MODE solnpctl1 c 118 129 ; chgrp $GROUP solnpctl1    
    # ...

#****************************************************************************
#                         Eracom CSA7000 PCI encryption adaptor
#****************************************************************************

    # First CSA7000
    # mknod -m $MODE ecsa0 c 168 0 ; chgrp $GROUP ecsa0
    # Second CSA7000 
    # mknod -m $MODE ecsa1 c 168 1 ; chgrp $GROUP ecsa1
    # ...

#****************************************************************************
#                         Eracom CSA8000 PCI encryption adaptor
#****************************************************************************

    # First CSA8000
    # mknod -m $MODE ecsa8-0 c 169 0 ; chgrp $GROUP ecsa8-0
    # Second CSA8000 
    # mknod -m $MODE ecsa8-1 c 169 1 ; chgrp $GROUP ecsa8-1
    # ...

#****************************************************************************
#                         AMI MegaRAC remote access controller
#****************************************************************************

    # First MegaRAC card
    # mknod -m $MODE megarac0 c 170 0 ; chgrp $GROUP megarac0
    # Second MegaRAC card 
    # mknod -m $MODE megarac1 c 170 1 ; chgrp $GROUP megarac1
    # ...

#****************************************************************************
#                         Real-Time Linux FIFOs
#****************************************************************************

    # First RTLinux FIFO
    # mknod -m $MODE rtf0 c 150 0 ; chgrp $GROUP rtf0
    # Second RTLinux FIFO 
    # mknod -m $MODE rtf1 c 150 1 ; chgrp $GROUP rtf1
    # ...    
    
#****************************************************************************
#                         General Purpose Instrument Bus (GPIB)
#****************************************************************************

    # First GPIB bus
    # mknod -m $MODE gpib0 c 160 0 ; chgrp $GROUP gpib0
    # Second GPIB bus 
    # mknod -m $MODE gpib1 c 160 1 ; chgrp $GROUP gpib1
    # ...

#****************************************************************************
#                         nCipher nFast PCI crypto accelerator
#****************************************************************************

    # First nFast PCI device
    # mknod -m $MODE nfastpci0 c 176 0 ; chgrp $GROUP nfastpci0
    # First nFast PCI device 
    # mknod -m $MODE nfastpci1 c 176 1 ; chgrp $GROUP nfastpci1
    # ...

#****************************************************************************
#                         Giganet cLAN1xxx virtual interface adapter
#****************************************************************************

    # First cLAN adapter
    # mknod -m $MODE clanvi0 c 178 0 ; chgrp $GROUP clanvi0
    # Second cLAN adapter 
    # mknod -m $MODE clanvi1 c 178 1 ; chgrp $GROUP clanvi1
    # ...

#****************************************************************************
#                         CCube DVXChip-based PCI products
#****************************************************************************

    # First DVX device
    # mknod -m $MODE dvxirq0 c 179 0 ; chgrp $GROUP dvxirq0
    # Second DVX device 
    # mknod -m $MODE dvxirq1 c 179 1 ; chgrp $GROUP dvxirq1
    # ...    
    
#****************************************************************************
#                         Conrad Electronic parallel port radio clocks
#****************************************************************************

    # First Conrad radio clock
    # mknod -m $MODE pcfclock0 c 181 0 ; chgrp $GROUP pcfclock0
    # Second Conrad radio clock 
    # mknod -m $MODE pcfclock1 c 181 1 ; chgrp $GROUP pcfclock1
    # ...

#****************************************************************************
#                         Picture Elements THR2 binarizer
#****************************************************************************

    # First THR2 board
    # mknod -m $MODE pethr0 c 182 0 ; chgrp $GROUP pethr0
    # Second THR2 board 
    # mknod -m $MODE pethr1 c 182 1 ; chgrp $GROUP pethr1
    # ...

#****************************************************************************
#                         SST 5136-DN DeviceNet interface
#****************************************************************************

    # First DeviceNet interface
    # mknod -m $MODE ss5136dn0 c 183 0 ; chgrp $GROUP ss5136dn0
    # Second DeviceNet interface 
    # mknod -m $MODE ss5136dn1 c 183 1 ; chgrp $GROUP ss5136dn1
    # ...

#****************************************************************************
#                         Picture Elements' video simulator/sender
#****************************************************************************

    # First sender board
    # mknod -m $MODE pevss0 c 184 0 ; chgrp $GROUP pevss0
    # Second sender board 
    # mknod -m $MODE pevss1 c 184 1 ; chgrp $GROUP pevss1
    # ...    
    
#****************************************************************************
#                         InterMezzo high availability file system
#****************************************************************************

    # First cache manager
    # mknod -m $MODE intermezzo0 c 185 0 ; chgrp $GROUP intermezzo0
    # Second cache manager 
    # mknod -m $MODE intermezzo1 c 185 1 ; chgrp $GROUP intermezzo1
    # ...

#****************************************************************************
#                         Object-based storage control device
#****************************************************************************

    # First obd control device
    # mknod -m $MODE obd0 c 186 0 ; chgrp $GROUP obd0
    # Second obd control device 
    # mknod -m $MODE obd1 c 186 1 ; chgrp $GROUP obd1
    # ...

#****************************************************************************
#                         DESkey hardware encryption device
#****************************************************************************

    # First DES key
    # mknod -m $MODE deskey0 c 187 0 ; chgrp $GROUP deskey0
    # Second DES key 
    # mknod -m $MODE deskey1 c 187 1 ; chgrp $GROUP deskey1
    # ... 
    
#****************************************************************************
#                         Kansas City tracker/tuner card
#****************************************************************************

    # First KCT/T card
    # mknod -m $MODE kctt0 c 190 0 ; chgrp $GROUP kctt0
    # Second KCT/T card 
    # mknod -m $MODE kctt1 c 190 1 ; chgrp $GROUP kctt1
    # ...

#****************************************************************************
#                         Z8530 HDLC driver
#****************************************************************************

    # First Z8530, first port
    # mknod -m $MODE scc0 c 34 0 ; chgrp $GROUP scc0
    # First Z8530, second port
    # mknod -m $MODE scc1 c 34 1 ; chgrp $GROUP scc1
    # Second Z8530, first port
    # mknod -m $MODE scc2 c 34 2 ; chgrp $GROUP scc2
    # Second Z8530, second port 
    # mknod -m $MODE scc3 c 34 3 ; chgrp $GROUP scc3
    # ...

#****************************************************************************
#                         Baycom radio modem
#****************************************************************************

    # First Baycom radio modem
    # mknod -m $MODE bc0 c 51 0 ; chgrp $GROUP bc0
    # Second Baycom radio modem 
    # mknod -m $MODE bc1 c 51 1 ; chgrp $GROUP bc1
    # ...

#****************************************************************************
#                         Audit device
#****************************************************************************

    # Audit device 
    # mknod -m $MODE audit b 103 0 ; chgrp $GROUP audit

#****************************************************************************
#                         Myricom PCI Myrinet board
#****************************************************************************

    # First Myrinet board
    # mknod -m $MODE mlanai0 c 38 0 ; chgrp $GROUP mlanai0
    # Second Myrinet board 
    # mknod -m $MODE mlanai1 c 38 1 ; chgrp $GROUP mlanai1
    # ...

#****************************************************************************
#                         ML-16P experimental I/O board
#****************************************************************************

    # First card, first analog channel
    # mknod -m $MODE ml16pa-a0 c 39 0 ; chgrp $GROUP ml16pa-a0
    # First card, second analog channel
    # mknod -m $MODE ml16pa-a1 c 39 1 ; chgrp $GROUP ml16pa-a1
    # ...
    # First card, 16th analog channel
    # mknod -m $MODE ml16pa-a15 c 39 15 ; chgrp $GROUP ml16pa-a15

    # First card, digital lines
    # mknod -m $MODE ml16pa-d c 39 16 ; chgrp $GROUP ml16pa-d
    # First card, first counter/timer
    # mknod -m $MODE ml16pa-c0 c 39 17 ; chgrp $GROUP ml16pa-c0
    # First card, second counter/timer
    # mknod -m $MODE ml16pa-c1 c 39 18 ; chgrp $GROUP ml16pa-c1
    # First card, third counter/timer
    # mknod -m $MODE ml16pa-c2 c 39 19 ; chgrp $GROUP ml16pa-c2

    # Second card, first analog channel
    # mknod -m $MODE ml16pb-a0 c 39 32 ; chgrp $GROUP ml16pb-a0
    # Second card, second analog channel
    # mknod -m $MODE ml16pb-a1 c 39 33 ; chgrp $GROUP ml16pb-a1
    # ...
    # Second card, 16th analog channel
    # mknod -m $MODE ml16pb-a15 c 39 47 ; chgrp $GROUP ml16pb-a15

    # Second card, digital lines
    # mknod -m $MODE ml16pb-d c 39 48 ; chgrp $GROUP ml16pb-d
    # Second card, first counter/timer
    # mknod -m $MODE ml16pb-c0 c 39 49 ; chgrp $GROUP ml16pb-c0
    # Second card, second counter/timer
    # mknod -m $MODE ml16pb-c1 c 39 50 ; chgrp $GROUP ml16pb-c1
    # Second card, third counter/timer 
    # mknod -m $MODE ml16pb-c2 c 39 51 ; chgrp $GROUP ml16pb-c2    
    
#****************************************************************************
#                         BDM interface for remote debugging MC683xx microcontrollers
#****************************************************************************

    # PD BDM interface on lp0
    # mknod -m $MODE pd_bdm0 c 53 0 ; chgrp $GROUP pd_bdm0
    # PD BDM interface on lp1
    # mknod -m $MODE pd_bdm1 c 53 1 ; chgrp $GROUP pd_bdm1
    # PD BDM interface on lp2
    # mknod -m $MODE pd_bdm2 c 53 2 ; chgrp $GROUP pd_bdm2

    # ICD BDM interface on lp0
    # mknod -m $MODE icd_bdm0 c 53 4 ; chgrp $GROUP icd_bdm0
    # ICD BDM interface on lp1
    # mknod -m $MODE icd_bdm1 c 53 5 ; chgrp $GROUP icd_bdm1
    # ICD BDM interface on lp2 
    # mknod -m $MODE icd_bdm2 c 53 6 ; chgrp $GROUP icd_bdm2

#****************************************************************************
#                         Electrocardiognosis Holter serial card
#****************************************************************************

    # First Holter port
    # mknod -m $MODE holter0 c 54 0 ; chgrp $GROUP holter0
    # Second Holter port
    # mknod -m $MODE holter1 c 54 1 ; chgrp $GROUP holter1
    # Third Holter port 
    # mknod -m $MODE holter2 c 54 2 ; chgrp $GROUP holter2

#****************************************************************************
#                         Sundance "plink" Transputer boards
#****************************************************************************

    # First plink device
    # mknod -m $MODE plink0 c 65 0 ; chgrp $GROUP plink0
    # Second plink device
    # mknod -m $MODE plink1 c 65 1 ; chgrp $GROUP plink1
    # Third plink device
    # mknod -m $MODE plink2 c 65 2 ; chgrp $GROUP plink2
    # Fourth plink device
    # mknod -m $MODE plink3 c 65 3 ; chgrp $GROUP plink3

    # First plink device, raw
    # mknod -m $MODE rplink0 c 65 64 ; chgrp $GROUP rplink0
    # Second plink device, raw
    # mknod -m $MODE rplink1 c 65 65 ; chgrp $GROUP rplink1
    # Third plink device, raw
    # mknod -m $MODE rplink2 c 65 66 ; chgrp $GROUP rplink2
    # Fourth plink device, raw
    # mknod -m $MODE rplink3 c 65 67 ; chgrp $GROUP rplink3

    # First plink device, debug
    # mknod -m $MODE plink0d c 65 128 ; chgrp $GROUP plink0d
    # Second plink device, debug
    # mknod -m $MODE plink1d c 65 129 ; chgrp $GROUP plink1d
    # Third plink device, debug
    # mknod -m $MODE plink2d c 65 130 ; chgrp $GROUP plink2d
    # Fourth plink device, debug
    # mknod -m $MODE plink3d c 65 131 ; chgrp $GROUP plink3d

    # First plink device, raw, debug
    # mknod -m $MODE rplink0d c 65 192 ; chgrp $GROUP rplink0d
    # Second plink device, raw, debug
    # mknod -m $MODE rplink1d c 65 193 ; chgrp $GROUP rplink1d
    # Third plink device, raw, debug
    # mknod -m $MODE rplink2d c 65 194 ; chgrp $GROUP rplink2d
    # Fourth plink device, raw, debug 
    # mknod -m $MODE rplink3d c 65 195 ; chgrp $GROUP rplink3d

#****************************************************************************
#                         MA16 numeric accelerator card
#****************************************************************************

    # Board memory access 
    # mknod -m $MODE ma16 c 69 0 ; chgrp $GROUP ma16

#****************************************************************************
#                         SpellCaster Protocol Services Interface
#****************************************************************************

    # Configuration interface
    # mknod -m $MODE apscfg c 70 0 ; chgrp $GROUP apscfg

    # Authentication interface
    # mknod -m $MODE apsauth c 70 1 ; chgrp $GROUP apsauth

    # Logging interface
    # mknod -m $MODE apslog c 70 2 ; chgrp $GROUP apslog

    # Debugging interface
    # mknod -m $MODE apsdbg c 70 3 ; chgrp $GROUP apsdbg

    # ISDN command interface
    # mknod -m $MODE apsisdn c 70 64 ; chgrp $GROUP apsisdn

    # Async command interface
    # mknod -m $MODE apsasync c 70 65 ; chgrp $GROUP apsasync

    # Monitor interface 
    # mknod -m $MODE apsmon c 70 128 ; chgrp $GROUP apsmon

#****************************************************************************
#                         Photometrics AT200 CCD camera
#****************************************************************************

    # Photometrics AT200 CCD camera 
    # mknod -m $MODE at200 c 80 0 ; chgrp $GROUP at200

#****************************************************************************
#                         Ikon 1011[57] Versatec Greensheet Interface
#****************************************************************************

    # First Greensheet port
    # mknod -m $MODE ihcp0 c 84 0 ; chgrp $GROUP ihcp0
    # Second Greensheet port 
    # mknod -m $MODE ihcp1 c 84 1 ; chgrp $GROUP ihcp1
