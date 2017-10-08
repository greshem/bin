for  $each (grep {-f} glob("*.iso"))
{
print <<EOF

cdrecord -eject -v speed=8 dev='/dev/scd0'   -data  $each
EOF
;
}
