#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

http://www.oss4aix.org/download/RPMS/


wget -c -r -np --reject=html,gif,A,D -nH   http://www.oss4aix.org/download/RPMS/



