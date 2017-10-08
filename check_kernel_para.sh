function check_config()
{
	if ! grep $1 .config >/dev/null ;then
		echo $1 not support
	fi
}
echo $#
if [ $# != 1 ];then
echo Usage:$0 kernel_config_file
exit
fi

cp $1 .config
check_config CONFIG_IP_PNP=y
check_config CONFIG_IP_PNP_DHCP=y
check_config CONFIG_IP_PNP_BOOTP=y
check_config CONFIG_IP_PNP_RARP=y
##check_config ################################################
check_config CONFIG_BLK_DEV_LOOP=y
check_config CONFIG_BLK_DEV_RAM=y
check_config CONFIG_BLK_DEV_RAM_COUNT=16
check_config CONFIG_BLK_DEV_RAM_SIZE=16384
check_config CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
check_config CONFIG_BLK_DEV_INITRD=y
##check_config ################################################
check_config CONFIG_IDE=y
check_config CONFIG_BLK_DEV_IDE=y
check_config CONFIG_BLK_DEV_IDE_SATA=y
check_config CONFIG_BLK_DEV_HD_IDE is not set
check_config CONFIG_BLK_DEV_IDEDISK=y
check_config CONFIG_IDEDISK_MULTI_MODE is not set
check_config CONFIG_BLK_DEV_IDECD=y
check_config CONFIG_BLK_DEV_IDEFLOPPY=y
check_config CONFIG_BLK_DEV_IDESCSI=y
check_config CONFIG_IDE_GENERIC=y
check_config CONFIG_BLK_DEV_IDEPCI=y
check_config CONFIG_BLK_DEV_GENERIC=y
check_config CONFIG_BLK_DEV_IDEDMA_PCI=y
check_config CONFIG_BLK_DEV_PIIX=y
check_config CONFIG_BLK_DEV_IDEDMA=y
##check_config ################################################
check_config CONFIG_SCSI=y
check_config CONFIG_BLK_DEV_SD=y
check_config CONFIG_BLK_DEV_SR=y
check_config CONFIG_BLK_DEV_SR_VENDOR is not set
check_config CONFIG_CHR_DEV_SG=y
check_config CONFIG_CHR_DEV_SCH=y
check_config CONFIG_SCSI_GDTH=y
check_config CONFIG_ATA=y
check_config CONFIG_ATA_NONSTANDARD is not set
check_config CONFIG_SATA_AHCI=y
check_config CONFIG_SATA_SVW=y
check_config CONFIG_ATA_PIIX=y
check_config CONFIG_ATA_GENERIC=y
check_config CONFIG_PATA_MPIIX=y
check_config CONFIG_PATA_PLATFORM=y
##check_config ################################################
check_config CONFIG_MD=y
check_config CONFIG_BLK_DEV_MD=y
check_config CONFIG_MD_FAULTY=y
check_config CONFIG_BLK_DEV_DM=y
##check_config ################################################
check_config CONFIG_BROADCOM_PHY=y
check_config CONFIG_NET_ETHERNET=y
check_config CONFIG_MII=y
check_config CONFIG_NET_PCI=y
check_config CONFIG_PCNET32=y
check_config CONFIG_8139TOO=y
check_config CONFIG_8139TOO_PIO=y
check_config CONFIG_E100=y
check_config CONFIG_E1000=y
check_config CONFIG_TIGON3=y
check_config CONFIG_BNX2=y
check_config CONFIG_NETXEN_NIC=y
##check_config ################################################
check_config CONFIG_INPUT_MOUSEDEV=y
check_config CONFIG_INPUT_KEYBOARD=y
check_config CONFIG_KEYBOARD_ATKBD=y
##check_config ################################################
check_config CONFIG_VT=y
check_config CONFIG_VT_CONSOLE=y
check_config CONFIG_HW_CONSOLE=y
check_config CONFIG_VT_HW_CONSOLE_BINDING=y
check_config CONFIG_UNIX98_PTYS=y
check_config CONFIG_LEGACY_PTYS=y
check_config CONFIG_FB=y
check_config CONFIG_FB_VESA=y
check_config CONFIG_FB_CFB_FILLRECT=y
check_config CONFIG_FB_CFB_COPYAREA=y
check_config CONFIG_FB_CFB_IMAGEBLIT=y
check_config CONFIG_FB_MODE_HELPERS=y
check_config CONFIG_FB_TILEBLITTING=y
##check_config ################################################
check_config CONFIG_HID=y
check_config CONFIG_USB_ARCH_HAS_HCD=y
check_config CONFIG_USB_ARCH_HAS_OHCI=y
check_config CONFIG_USB_ARCH_HAS_EHCI=y
check_config CONFIG_USB=y
check_config CONFIG_USB_DEVICEFS=y
check_config CONFIG_USB_EHCI_HCD=y
check_config CONFIG_USB_ISP116X_HCD=y
check_config CONFIG_USB_OHCI_HCD=y
check_config CONFIG_USB_OHCI_LITTLE_ENDIAN=y
check_config CONFIG_USB_UHCI_HCD=y
check_config CONFIG_USB_SL811_HCD=y
check_config CONFIG_USB_STORAGE=y
check_config CONFIG_USB_STORAGE_DEBUG=y
check_config CONFIG_USB_STORAGE_FREECOM=y
check_config CONFIG_USB_HID=y
check_config CONFIG_USB_HIDINPUT_POWERBOOK=y
check_config CONFIG_USB_HIDDEV=y
##check_config ################################################
check_config CONFIG_EXT2_FS=y
check_config CONFIG_EXT2_FS_XATTR=y
check_config CONFIG_EXT2_FS_POSIX_ACL=y
check_config CONFIG_EXT2_FS_SECURITY=y
check_config CONFIG_EXT2_FS_XIP=y
check_config CONFIG_FS_XIP=y
check_config CONFIG_EXT3_FS=y
check_config CONFIG_EXT3_FS_XATTR=y
check_config CONFIG_EXT3_FS_POSIX_ACL=y
check_config CONFIG_EXT3_FS_SECURITY=y
check_config CONFIG_JBD=y
check_config CONFIG_PROC_FS=y
check_config CONFIG_PROC_KCORE=y
check_config CONFIG_PROC_SYSCTL=y
check_config CONFIG_SYSFS=y
check_config CONFIG_RAMFS=y
check_config CONFIG_CRAMFS=y
check_config CONFIG_NFS_FS=y
check_config CONFIG_NFS_V3=y
check_config CONFIG_NFS_V3_ACL=y
check_config CONFIG_NFS_DIRECTIO=y
check_config CONFIG_NFSD=y
check_config CONFIG_NFSD_V2_ACL=y
check_config CONFIG_NFSD_V3=y
check_config CONFIG_NFSD_V3_ACL=y
check_config CONFIG_NFSD_TCP=y
check_config CONFIG_ROOT_NFS=y
check_config CONFIG_LOCKD=y
check_config CONFIG_LOCKD_V4=y
check_config CONFIG_EXPORTFS=y
check_config CONFIG_NFS_ACL_SUPPORT=y
check_config CONFIG_NFS_COMMON=y
check_config CONFIG_SUNRPC=y
rm .config -f
