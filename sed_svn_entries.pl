#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

acer="acer"
for each in $(find . |grep entries$);  
do 
echo sed "s/172.16.10.68/$acer/g" $each -i
sed "s/172.16.10.68/$acer/g" $each -i
sed "s/172.16.10.10/$acer/g" $each -i
sed "s/192.168.0.102/$acer/g" $each -i
sed "s/192.168.1.10/$acer/g" $each -i
done

