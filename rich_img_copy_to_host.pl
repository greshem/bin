#!/usr/bin/perl

print <<EOF
iso_copy_out_to_desktop.pl "sdb1:\\sdb2\\vmware_disk_iso\\vmware_disk_1.iso\\rich_img_VMWARE.IMG.gz"
iso_copy_out_to_desktop.pl "sdb1:\\sdb2\\vmware_disk_iso\\vmware_disk_1.iso\\
EOF
;

open(PIPE, "vmrun list|") or die("vmrun list error $!\n");
for(<PIPE>)
{
chomp;
print <<EOF
#==========================================================================
vmrun -T ws -gu root -gp q**************n   CopyFileFromHostToGuest  "$_"  "P:\\rich_img_VMWARE.IMG.gz" "/home/richdisk.IMG.gz"

vmrun -T ws -gu root -gp q**************n   runProgramInGuest        "$_"  "/bin/touch"   "/home/richdisk.IMG.host_copy_ok"
vmrun -T ws -gu root -gp q**************n   runProgramInGuest        "$_"  "/bin/gzip" "-f"  "-d"  /home/richdisk.IMG.gz"
vmrun -T ws -gu root -gp q**************n   runProgramInGuest        "$_"  "/sbin/service"   "diskplat" "restart"

EOF
;	
}
