#!/bin/sh
sed   -i '/PXE/{s/^#//g}' /etc/dhcpd.conf
