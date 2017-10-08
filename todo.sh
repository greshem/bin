
 grep DIST Manifest |awk '{print $2}' |sed 's|^|http://gentoo.netnitco.net/distfiles/|g' > url.txt
