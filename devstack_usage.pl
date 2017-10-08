#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

git clone https://github.com/openstack-dev/devstack.git

cd devstack && ./stack.sh

#grep \.git  stackrc  |awk -F/ '{print $NF}'  |grep }$ > /tmp/tmp




