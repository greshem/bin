#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}

for $each (glob("*.thrift"))
{
	print <<EOF
thrift -r --gen cpp $each
EOF
;
}
__DATA__

thrift -r --gen cpp tutorial.thrift

