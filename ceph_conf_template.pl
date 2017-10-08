$count_mon;
$count_mds;
$mon_mds_ip="172.16.35.151";
$osd_ip;
$count_osd;

open (FILE, ">ceph.conf")  or die("create ceph.conf error\n");

print FILE <<EOF

[global]
auth_service_required = none
filestore_xattr_use_omap = true
auth_client_required = none
auth_cluster_required = none
mon_host = 
mon_initial_members = mon-mds
fsid = 797febdf-a2f2-4a73-a361-f1ab666a87a0


[mon]
        mon data = /data/mon\$id
        debug ms = 1

[mon.0]
        host = cephmon1
        mon addr = 192.168.200.21:6789

[mds]
        keyring = /data/keyring.\$$name

[mds.0]
        host = cephmon1

[osd]

        sudo = true
        osd data = /data/osd\$id
        osd journal = /data/osd\$id/journal
        osd journal size = 512

[osd.0]
        host = cephosd1
        btrfs devs = /dev/sda3

[osd.1]
        host = cephosd2
        btrfs devs = /dev/sda3

[group everyone]
addr = 0.0.0.0/0

[mount /]
allow = %everyone
EOF
;

# mkcephfs -c /etc/ceph/ceph.conf -a --mkbtrfs -k /etc/ceph/keyring.bin
# /etc/init.d/ceph -v start

