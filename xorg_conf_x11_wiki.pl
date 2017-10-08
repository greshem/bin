#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
xf86gammacfg 
pyxf

#==========================================================================
hwdata
/usr/share/hwdata/MonitorsDB


#==========================================================================
cdm	#tui  窗口管理器的 切换.
system-config-display		#lost after as6

