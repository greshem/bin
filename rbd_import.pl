for $each  (glob("*img"))
{
	print "qemu-img convert -f qcow2 -O raw $each $each.raw\n";
}


for $each  (glob("*raw"))
{
print <<EOF
/usr/bin/rbd import --image-format 2 --path $each --dest rbd/$each  --id admin --conf /etc/ceph/ceph.conf
EOF
;
}

