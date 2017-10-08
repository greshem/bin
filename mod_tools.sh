moduledep() {
    if [ ! -f "/lib/modules/$(uname -r)/modules.dep" ]; then
	echo "No dep file found for kernel $kernel" >&2
	exit 1
    fi

    echo -n "Looking for deps of module $1"
    deps=$(awk 'BEGIN { searched=ARGV[2]; ARGV[2]=""; rc=1 } \
                function modname(filename) { match(filename, /\/([^\/]+)\.k?o:?$/, ret); return ret[1] } \
                function show() { if (orig == searched) { print dep; orig=""; rc=0; exit } } \
                /^\/lib/ { show(); \
                           orig=modname($1); dep=""; \
                           if ($2) { for (i = 2; i <= NF; i++) { dep=sprintf("%s %s", dep, modname($i)); } } } \
                /^	/ { dep=sprintf("%s %s", dep, modname($1));  } \
                END      { show(); exit(rc) }' /lib/modules/$(uname -r)/modules.dep $1)
    echo -e "\t$deps"
}

findmodule() {
    skiperrors=""

    if [ $1 == "--skiperrors" ]; then
	skiperrors=--skiperrors
	shift
    fi

    local modName=$1

    if [ "$modName" = "off" -o "$modName" = "null" ]; then
	return
    fi

    if [ $(echo $modName | cut -b1) = "-" ]; then
	skiperrors=--skiperrors
	modName=$(echo $modName | cut -b2-)
    fi

    if echo $builtins | egrep -q '(^| )'$modName'( |$)' ; then
	[ -n "$verbose" ] && echo "module $modName assumed to be built in"
	set +x
	return
    fi

    # special cases
    if [ "$modName" = "i2o_block" ]; then
	findmodule i2o_core
	findmodule -i2o_pci
	modName="i2o_block"
    elif [ "$modName" = "ppa" ]; then
	findmodule parport
	findmodule parport_pc
	modName="ppa"
    elif [ "$modName" = "sbp2" ]; then
	findmodule ieee1394
	findmodule ohci1394
	modName="sbp2"
    elif [ "$modName" = "usb-storage" ]; then
	usbModName="$modName"
    fi
    if [ -n "$usbModName" \
            -a "$modName" != "uhci-hcd" \
            -a "$modName" != "ohci-hcd" \
            -a "$modName" != "ehci-hcd" ]; then
        withusb=yes
        findmodule ehci-hcd
        findmodule ohci-hcd
        findmodule uhci-hcd

        usbModName=""
    fi
    moduledep $modName
    for i in $deps; do
	findmodule $i
    done

    for modExt in o.gz o ko ; do
	if [ -d /lib/modules/$kernel/updates ]; then
	    fmPath=`(cd /lib/modules/$kernel/updates; echo find . -name $modName.$modExt -type f | /sbin/nash --quiet) | /bin/awk {'print $1; exit;'}`
	fi
	
	if [ -f /lib/modules/$kernel/updates/$fmPath ]; then
	    fmPath=updates/$fmPath
	    break
	fi

	fmPath=`(cd /lib/modules/$kernel; echo find . -name $modName.$modExt -type f | /sbin/nash --quiet) | /bin/awk {'print $1; exit;'}`
	if [ -f /lib/modules/$kernel/$fmPath ]; then
	    break
	fi
    done

    if [ ! -f /lib/modules/$kernel/$fmPath ]; then
	if [ -n "$skiperrors" ]; then
	    return
	fi

        # ignore the absence of the scsi modules
	for n in $PRESCSIMODS; do
	    if [ "$n" = "$modName" ]; then
		return;
	    fi
	done;

	if [ -n "$allowmissing" ]; then
	    echo "WARNING: No module $modName found for kernel $kernel, continuing anyway" >&2
	    return
	fi
    
	echo "No module $modName found for kernel $kernel, aborting." >&2
	exit 1
    fi

    # only need to add each module once
    if ! echo $MODULES | grep -q "$fmPath" 2>/dev/null ; then
	MODULES="$MODULES $fmPath"
    fi
}


moduledep  $1
