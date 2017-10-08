
# if [ !  $# -eq 1 ];then
#     echo "Usage: ", $0 , " input_mksysb  ";
#     exit
# fi

my $input_iso=shift or die("usage: $0  input_4G_file \n");

$MKSYSB_IMAGE= $input_iso;
print <<EOF

dd bs=4096 count=524160  	if=$MKSYSB_IMAGE  of=$MKSYSB_IMAGE.1
dd bs=4096 skip=524160  	if=$MKSYSB_IMAGE  of=$MKSYSB_IMAGE.2

EOF
;
