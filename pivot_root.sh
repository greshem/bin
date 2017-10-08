pivot_root
# mount /dev/hda1 /new_root
# cd /new_root
# pivot_root . old_root
# exec chroot . sh <dev/console >dev/console 2>&1
# umount /old_rootp 
cp -dpR
