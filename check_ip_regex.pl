#!/usr/bin/perl
$ip=shift or die("usage: $0  ip_addr\n");

if($ip =~ /^([1-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([1-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([1-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([1-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])$/)
{
	print "�� IP��ַ\n"
}
else
{
	print "����IP��ַ\n"
}

print $1."|". $2."|".$3."|".$4."|\n";