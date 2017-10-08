#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
cat >> /etc/ssh/sshd_config  <<EOF

ClientAliveInterval 15
ClientAliveCountMax 45
EOF

