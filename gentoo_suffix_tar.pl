#!/usr/bin/perl
for(<DATA>)
{
	print $_;
}
__DATA__
grep ^DIST -R ./ -h > /tmp/tmp
awk '{print $2}' /tmp/tmp  
awk '{print $2}' /tmp/tmp   |wc
awk '{print $2}' /tmp/tmp    > /tmp/tmp_suffix

#主要代码格式: 
sed '/\.tar.gz$/d'  /tmp/tmp_suffix  -i 
sed '/\.tar.bz2$/d'  /tmp/tmp_suffix  -i 
sed '/\.tar.xz$/d'  /tmp/tmp_suffix  -i 
sed '/\.tgz$/d'  /tmp/tmp_suffix  -i 
sed '/\.tar$/d'  /tmp/tmp_suffix  -i 
sed '/\.tar.Z$/d'  /tmp/tmp_suffix  -i 
sed '/\.tar.lzma$/d'  /tmp/tmp_suffix  -i 
sed '/\.zip$/d'  /tmp/tmp_suffix  -i 
sed '/\.tbz$/d'  /tmp/tmp_suffix  -i 
sed '/\.tbz2$/d'  /tmp/tmp_suffix  -i 
sed '/\.rar$/d'  /tmp/tmp_suffix  -i 

sed '/\.rpm$/d'  /tmp/tmp_suffix  -i 
sed '/\.xpi$/d'  /tmp/tmp_suffix  -i 
sed '/\.gem$/d'  /tmp/tmp_suffix  -i 
sed '/\.cab$/d'  /tmp/tmp_suffix  -i 
sed '/\.msi$/d'  /tmp/tmp_suffix  -i 
sed '/\.jar$/d'  /tmp/tmp_suffix  -i 
sed '/\.bin$/d'  /tmp/tmp_suffix  -i 
sed '/\.run$/d'  /tmp/tmp_suffix  -i 

sed '/\.diff.gz$/d'  /tmp/tmp_suffix  -i 
sed '/\.patch.gz$/d'  /tmp/tmp_suffix  -i 
sed '/\.patch.bz2$/d'  /tmp/tmp_suffix  -i 
sed '/\.patch.xz$/d'  /tmp/tmp_suffix  -i 
sed '/\.patch.bz2$/d'  /tmp/tmp_suffix  -i 
sed '/\.el.xz$/d'  /tmp/tmp_suffix  -i 
sed '/\.el.bz2$/d'  /tmp/tmp_suffix  -i 
sed '/\.el.gz$/d'  /tmp/tmp_suffix  -i 

sed '/\.exe$/d'  /tmp/tmp_suffix  -i 
sed '/\.iso$/d'  /tmp/tmp_suffix  -i 
sed '/\.gz$/d'  /tmp/tmp_suffix  -i 
sed '/\.xz$/d'  /tmp/tmp_suffix  -i 
sed '/\.bz2$/d'  /tmp/tmp_suffix  -i 
sed '/\.sh$/d'  /tmp/tmp_suffix  -i 
sed '/\.diff$/d'  /tmp/tmp_suffix  -i 
sed '/\.patch$/d'  /tmp/tmp_suffix  -i 
sed '/\.pdf$/d'  /tmp/tmp_suffix  -i 

