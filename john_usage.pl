#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

unshadow /etc/passwd /etc/shadow  > shadow.txt 

./john  -single  		shadow.txt   
./john   --wordlist=/usr/share/dict/linux.words   -rules   shadow.txt  


