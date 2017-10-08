#!/bin/sh
sed   '/PXEClient/!{/PXE/{s/^/#/g}}' /etc/dhcpd.conf > dhcpd.lower.conf
yes |mv dhcpd.lower.conf /etc/dhcpd.conf
