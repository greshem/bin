
umount data/LiveOS/dir/
rm -f out/LiveOS/squashfs.img
mksquashfs data/ out/LiveOS/squashfs.img
cd out
/usr/bin/mkisofs -o /tmp/fedora-qianlong-livecd.iso -b isolinux/isolinux.bin -c isolinux/boot.cat \
 -no-emul-boot -boot-load-size 4 -boot-info-table -J -r -hide-rr-moved -hide-joliet-trans-tbl \
  -V fedora-minimal-200903161622 /tmp4/livecd-creator-qianlong/out

