#!/usr/bin/perl
#来自于  nova-computer 的一些 东西: 

my $template= shift or die("Usage: $0 \n");

print <<EOF
[Unit]
Description= $template  Server
After=syslog.target network.target

[Service]
Environment=env_$template=appliance
Type=notify
NotifyAccess=all
TimeoutStartSec=0
Restart=always
User=nova
ExecStart=/usr/bin/shell_$template.pl

[Install]
WantedBy=multi-user.target

EOF
;
