
open(PIPE, " kolla-build  --list-images 2>&1 | ");
for(<PIPE>)
{
    #print $_;
    @array=split(/:/,$_);
    $name=$array[1];
    print <<EOF
    kolla-build --cache --base centos --type source -p default   $name  
EOF
;

}

