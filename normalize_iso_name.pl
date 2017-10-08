#!/usr/bin/perl

my $hash = {


'centos5_0_i386_bin_DVD' => 
[

	'CentOS/kernel-2.6.18-8.el5.i686.rpm',
	'CentOS/kernel-PAE-2.6.18-8.el5.i686.rpm',
	'CentOS/kernel-PAE-devel-2.6.18-8.el5.i686.rpm',
	'CentOS/kernel-devel-2.6.18-8.el5.i686.rpm',
	'CentOS/kernel-doc-2.6.18-8.el5.noarch.rpm',
	'CentOS/kernel-headers-2.6.18-8.el5.i386.rpm',
	'CentOS/kernel-xen-2.6.18-8.el5.i686.rpm',
	'CentOS/kernel-xen-devel-2.6.18-8.el5.i686.rpm',

],

'centos5_0_x86_64-bin-DVD' => 
[
'CentOS/kernel-doc-2.6.18-8.el5.noarch.rpm',
'CentOS/kernel-xen-devel-2.6.18-8.el5.x86_64.rpm',
'CentOS/kernel-2.6.18-8.el5.x86_64.rpm',
'CentOS/kernel-devel-2.6.18-8.el5.x86_64.rpm',
'CentOS/kernel-headers-2.6.18-8.el5.x86_64.rpm',
'CentOS/kernel-xen-2.6.18-8.el5.x86_64.rpm',
],


'centos5_1_i386-bin-DVD'=>
[

	'CentOS/kernel-2.6.18-53.el5.i686.rpm',
	'CentOS/kernel-PAE-2.6.18-53.el5.i686.rpm',
	'CentOS/kernel-PAE-devel-2.6.18-53.el5.i686.rpm',
	'CentOS/kernel-debug-2.6.18-53.el5.i686.rpm',
	'CentOS/kernel-debug-devel-2.6.18-53.el5.i686.rpm',
	'CentOS/kernel-devel-2.6.18-53.el5.i686.rpm',
	'CentOS/kernel-doc-2.6.18-53.el5.noarch.rpm',
	'CentOS/kernel-headers-2.6.18-53.el5.i386.rpm',
	'CentOS/kernel-xen-2.6.18-53.el5.i686.rpm',
	'CentOS/kernel-xen-devel-2.6.18-53.el5.i686.rpm',
	'CentOS/yum-kernel-module-1.0.4-3.el5.centos.2.noarch.rpm',

],

'centos5_1_x86_64-bin-DVD' => 
[
'CentOS/kernel-debug-devel-2.6.18-53.el5.x86_64.rpm',
'CentOS/kernel-devel-2.6.18-53.el5.x86_64.rpm',
'CentOS/kernel-xen-2.6.18-53.el5.x86_64.rpm',
'CentOS/kernel-debug-2.6.18-53.el5.x86_64.rpm',
'CentOS/kernel-2.6.18-53.el5.x86_64.rpm',
'CentOS/kernel-doc-2.6.18-53.el5.noarch.rpm',
'CentOS/kernel-headers-2.6.18-53.el5.x86_64.rpm',
'CentOS/kernel-xen-devel-2.6.18-53.el5.x86_64.rpm',
'CentOS/yum-kernel-module-1.0.4-3.el5.centos.2.noarch.rpm',
],



'centos5_2_i386-bin-DVD'=>
[

	'CentOS//kernel-2.6.18-92.el5.i686.rpm',
	'CentOS//kernel-PAE-2.6.18-92.el5.i686.rpm',
	'CentOS//kernel-PAE-devel-2.6.18-92.el5.i686.rpm',
	'CentOS//kernel-debug-2.6.18-92.el5.i686.rpm',
	'CentOS//kernel-debug-devel-2.6.18-92.el5.i686.rpm',
	'CentOS//kernel-devel-2.6.18-92.el5.i686.rpm',
	'CentOS//kernel-doc-2.6.18-92.el5.noarch.rpm',
	'CentOS//kernel-headers-2.6.18-92.el5.i386.rpm',
	'CentOS//kernel-xen-2.6.18-92.el5.i686.rpm',
	'CentOS//kernel-xen-devel-2.6.18-92.el5.i686.rpm',

],


'centos5_2_x86_64-bin-DVD' => 
[
'CentOS/kernel-debug-devel-2.6.18-92.el5.x86_64.rpm',
'CentOS/kernel-debug-2.6.18-92.el5.x86_64.rpm',
'CentOS/kernel-doc-2.6.18-92.el5.noarch.rpm',
'CentOS/kernel-xen-devel-2.6.18-92.el5.x86_64.rpm',
'CentOS/kernel-2.6.18-92.el5.x86_64.rpm',
'CentOS/kernel-devel-2.6.18-92.el5.x86_64.rpm',
'CentOS/kernel-headers-2.6.18-92.el5.x86_64.rpm',
'CentOS/kernel-xen-2.6.18-92.el5.x86_64.rpm',
'CentOS/yum-kernel-module-1.1.10-9.el5.centos.noarch.rpm',
],

'centos5_3_i386-bin-DVD'=>
[

'CentOS//kernel-PAE-2.6.18-128.el5.i686.rpm',
'CentOS//kernel-PAE-devel-2.6.18-128.el5.i686.rpm',
'CentOS//kernel-debug-2.6.18-128.el5.i686.rpm',
'CentOS//kernel-debug-devel-2.6.18-128.el5.i686.rpm',
'CentOS//kernel-devel-2.6.18-128.el5.i686.rpm',
'CentOS//kernel-doc-2.6.18-128.el5.noarch.rpm',
'CentOS//kernel-headers-2.6.18-128.el5.i386.rpm',
'CentOS//kernel-xen-2.6.18-128.el5.i686.rpm',
'CentOS//kernel-xen-devel-2.6.18-128.el5.i686.rpm',

],

'centos5_3_x86_64-bin-DVD' => 
[
'CentOS/kernel-debug-2.6.18-128.el5.x86_64.rpm',
'CentOS/kernel-xen-devel-2.6.18-128.el5.x86_64.rpm',
'CentOS/kernel-devel-2.6.18-128.el5.x86_64.rpm',
'CentOS/kernel-debug-devel-2.6.18-128.el5.x86_64.rpm',
'CentOS/kernel-2.6.18-128.el5.x86_64.rpm',
'CentOS/kernel-doc-2.6.18-128.el5.noarch.rpm',
'CentOS/kernel-headers-2.6.18-128.el5.x86_64.rpm',
'CentOS/kernel-xen-2.6.18-128.el5.x86_64.rpm',
'CentOS/yum-kernel-module-1.1.16-13.el5.centos.noarch.rpm',
],


'centos5_4_i386-bin-DVD'=>
[



'CentOS//kernel-2.6.18-164.el5.i686.rpm',
'CentOS//kernel-PAE-2.6.18-164.el5.i686.rpm',
'CentOS//kernel-PAE-devel-2.6.18-164.el5.i686.rpm',
'CentOS//kernel-debug-2.6.18-164.el5.i686.rpm',
'CentOS//kernel-debug-devel-2.6.18-164.el5.i686.rpm',
'CentOS//kernel-devel-2.6.18-164.el5.i686.rpm',
'CentOS//kernel-doc-2.6.18-164.el5.noarch.rpm',
'CentOS//kernel-headers-2.6.18-164.el5.i386.rpm',
'CentOS//kernel-xen-2.6.18-164.el5.i686.rpm',
'CentOS//kernel-xen-devel-2.6.18-164.el5.i686.rpm',

],

'centos5_4_x86_64-bin-DVD'=>
[

'CentOS//kernel-2.6.18-164.el5.x86_64.rpm',
'CentOS//kernel-debug-2.6.18-164.el5.x86_64.rpm',
'CentOS//kernel-debug-devel-2.6.18-164.el5.x86_64.rpm',
'CentOS//kernel-devel-2.6.18-164.el5.x86_64.rpm',
'CentOS//kernel-doc-2.6.18-164.el5.noarch.rpm',
'CentOS//kernel-headers-2.6.18-164.el5.x86_64.rpm',
'CentOS//kernel-xen-2.6.18-164.el5.x86_64.rpm',
'CentOS//kernel-xen-devel-2.6.18-164.el5.x86_64.rpm',

],



'centos5_5_i386-bin-DVD'=>
[


'CentOS//kernel-2.6.18-194.el5.i686.rpm',
'CentOS//kernel-PAE-2.6.18-194.el5.i686.rpm',
'CentOS//kernel-PAE-devel-2.6.18-194.el5.i686.rpm',
'CentOS//kernel-debug-2.6.18-194.el5.i686.rpm',
'CentOS//kernel-debug-devel-2.6.18-194.el5.i686.rpm',
'CentOS//kernel-devel-2.6.18-194.el5.i686.rpm',
'CentOS//kernel-doc-2.6.18-194.el5.noarch.rpm',
'CentOS//kernel-headers-2.6.18-194.el5.i386.rpm',
'CentOS//kernel-xen-2.6.18-194.el5.i686.rpm',
'CentOS//kernel-xen-devel-2.6.18-194.el5.i686.rpm',

],


'centos5_5_x86_64-bin-DVD-1of2' => 
[
'CentOS/kernel-debug-2.6.18-194.el5.x86_64.rpm',
'CentOS/kernel-devel-2.6.18-194.el5.x86_64.rpm',
'CentOS/kernel-debug-devel-2.6.18-194.el5.x86_64.rpm',
'CentOS/kernel-xen-devel-2.6.18-194.el5.x86_64.rpm',
'CentOS/kernel-2.6.18-194.el5.x86_64.rpm',
'CentOS/kernel-doc-2.6.18-194.el5.noarch.rpm',
'CentOS/kernel-headers-2.6.18-194.el5.x86_64.rpm',
'CentOS/kernel-xen-2.6.18-194.el5.x86_64.rpm',
],


'centos5_6_i386-bin-DVD'=>
[


'CentOS//kernel-2.6.18-238.el5.i686.rpm',
'CentOS//kernel-PAE-2.6.18-238.el5.i686.rpm',
'CentOS//kernel-PAE-devel-2.6.18-238.el5.i686.rpm',
'CentOS//kernel-debug-2.6.18-238.el5.i686.rpm',
'CentOS//kernel-debug-devel-2.6.18-238.el5.i686.rpm',
'CentOS//kernel-devel-2.6.18-238.el5.i686.rpm',
'CentOS//kernel-doc-2.6.18-238.el5.noarch.rpm',
'CentOS//kernel-headers-2.6.18-238.el5.i386.rpm',
'CentOS//kernel-xen-2.6.18-238.el5.i686.rpm',
'CentOS//kernel-xen-devel-2.6.18-238.el5.i686.rpm',
'CentOS//yum-kernel-module-1.1.16-14.el5.centos.1.noarch.rpm',

],

'centos5_6_x86_64-bin-DVD-1of2' => 
[
'CentOS/kernel-devel-2.6.18-238.el5.x86_64.rpm',
'CentOS/kernel-doc-2.6.18-238.el5.noarch.rpm',
'CentOS/kernel-xen-2.6.18-238.el5.x86_64.rpm',
'CentOS/kernel-debug-2.6.18-238.el5.x86_64.rpm',
'CentOS/kernel-2.6.18-238.el5.x86_64.rpm',
'CentOS/kernel-debug-devel-2.6.18-238.el5.x86_64.rpm',
'CentOS/kernel-headers-2.6.18-238.el5.x86_64.rpm',
'CentOS/kernel-xen-devel-2.6.18-238.el5.x86_64.rpm',
'CentOS/yum-kernel-module-1.1.16-14.el5.centos.1.noarch.rpm',
],


'centos5_7_i386-bin-DVD_1of2'=>
[

'CentOS//kernel-2.6.18-274.el5.i686.rpm',
'CentOS//kernel-PAE-2.6.18-274.el5.i686.rpm',
'CentOS//kernel-PAE-devel-2.6.18-274.el5.i686.rpm',
'CentOS//kernel-debug-2.6.18-274.el5.i686.rpm',
'CentOS//kernel-debug-devel-2.6.18-274.el5.i686.rpm',
'CentOS//kernel-devel-2.6.18-274.el5.i686.rpm',
'CentOS//kernel-doc-2.6.18-274.el5.noarch.rpm',
'CentOS//kernel-headers-2.6.18-274.el5.i386.rpm',
'CentOS//kernel-xen-2.6.18-274.el5.i686.rpm',
'CentOS//kernel-xen-devel-2.6.18-274.el5.i686.rpm',
'CentOS//yum-kernel-module-1.1.16-16.el5.centos.noarch.rpm',

],


'centos5_7_x86_64-bin-DVD-1of2' => 
[
'CentOS/kernel-debug-devel-2.6.18-274.el5.x86_64.rpm',
'CentOS/kernel-xen-devel-2.6.18-274.el5.x86_64.rpm',
'CentOS/kernel-debug-2.6.18-274.el5.x86_64.rpm',
'CentOS/kernel-doc-2.6.18-274.el5.noarch.rpm',
'CentOS/kernel-2.6.18-274.el5.x86_64.rpm',
'CentOS/kernel-devel-2.6.18-274.el5.x86_64.rpm',
'CentOS/kernel-headers-2.6.18-274.el5.x86_64.rpm',
'CentOS/kernel-xen-2.6.18-274.el5.x86_64.rpm',
'CentOS/yum-kernel-module-1.1.16-16.el5.centos.noarch.rpm',
],

'centos5_8_i386-bin-DVD_1of2'=>
[

'CentOS//kernel-2.6.18-308.el5.i686.rpm',
'CentOS//kernel-PAE-2.6.18-308.el5.i686.rpm',
'CentOS//kernel-PAE-devel-2.6.18-308.el5.i686.rpm',
'CentOS//kernel-debug-2.6.18-308.el5.i686.rpm',
'CentOS//kernel-debug-devel-2.6.18-308.el5.i686.rpm',
'CentOS//kernel-devel-2.6.18-308.el5.i686.rpm',
'CentOS//kernel-doc-2.6.18-308.el5.noarch.rpm',
'CentOS//kernel-headers-2.6.18-308.el5.i386.rpm',
'CentOS//kernel-xen-2.6.18-308.el5.i686.rpm',
'CentOS//kernel-xen-devel-2.6.18-308.el5.i686.rpm',
'CentOS//yum-kernel-module-1.1.16-21.el5.centos.noarch.rpm',

],


'centos5_8_x86_64-bin-DVD-1of2' => 
[
'CentOS/kernel-debug-devel-2.6.18-308.el5.x86_64.rpm',
'CentOS/kernel-debug-2.6.18-308.el5.x86_64.rpm',
'CentOS/kernel-devel-2.6.18-308.el5.x86_64.rpm',
'CentOS/kernel-xen-2.6.18-308.el5.x86_64.rpm',
'CentOS/kernel-2.6.18-308.el5.x86_64.rpm',
'CentOS/kernel-doc-2.6.18-308.el5.noarch.rpm',
'CentOS/kernel-headers-2.6.18-308.el5.x86_64.rpm',
'CentOS/kernel-xen-devel-2.6.18-308.el5.x86_64.rpm',
'CentOS/yum-kernel-module-1.1.16-21.el5.centos.noarch.rpm',
],


'centos5_9_i386-bin-DVD_1of2'=>
[


'CentOS//kernel-2.6.18-348.el5.i686.rpm',
'CentOS//kernel-PAE-2.6.18-348.el5.i686.rpm',
'CentOS//kernel-PAE-devel-2.6.18-348.el5.i686.rpm',
'CentOS//kernel-debug-2.6.18-348.el5.i686.rpm',
'CentOS//kernel-debug-devel-2.6.18-348.el5.i686.rpm',
'CentOS//kernel-devel-2.6.18-348.el5.i686.rpm',
'CentOS//kernel-doc-2.6.18-348.el5.noarch.rpm',
'CentOS//kernel-headers-2.6.18-348.el5.i386.rpm',
'CentOS//kernel-xen-2.6.18-348.el5.i686.rpm',
'CentOS//kernel-xen-devel-2.6.18-348.el5.i686.rpm',
'CentOS//yum-kernel-module-1.1.16-21.el5.centos.noarch.rpm',


],



'centos5_9_x86_64-bin-DVD-1of2' => 
[
'CentOS/kernel-debug-2.6.18-348.el5.x86_64.rpm',
'CentOS/kernel-devel-2.6.18-348.el5.x86_64.rpm',
'CentOS/kernel-doc-2.6.18-348.el5.noarch.rpm',
'CentOS/kernel-xen-2.6.18-348.el5.x86_64.rpm',
'CentOS/kernel-2.6.18-348.el5.x86_64.rpm',
'CentOS/kernel-debug-devel-2.6.18-348.el5.x86_64.rpm',
'CentOS/kernel-headers-2.6.18-348.el5.x86_64.rpm',
'CentOS/kernel-xen-devel-2.6.18-348.el5.x86_64.rpm',
'CentOS/yum-kernel-module-1.1.16-21.el5.centos.noarch.rpm',
],

'centos6_0_i386-bin-DVD'=>
[

'Packages//abrt-addon-kerneloops-1.1.13-4.el6.i686.rpm',
'Packages//dracut-kernel-004-32.el6.noarch.rpm',
'Packages//kernel-2.6.32-71.el6.i686.rpm',
'Packages//kernel-debug-2.6.32-71.el6.i686.rpm',
'Packages//kernel-debug-devel-2.6.32-71.el6.i686.rpm',
'Packages//kernel-devel-2.6.32-71.el6.i686.rpm',
'Packages//kernel-doc-2.6.32-71.el6.noarch.rpm',
'Packages//kernel-firmware-2.6.32-71.el6.noarch.rpm',
'Packages//kernel-headers-2.6.32-71.el6.i686.rpm',

],


'centos6_0_x86_64_bin-DVD_1of2' => 
[
'Packages/abrt-addon-kerneloops-1.1.13-4.el6.x86_64.rpm',
'Packages/dracut-kernel-004-32.el6.noarch.rpm',
'Packages/kernel-doc-2.6.32-71.el6.noarch.rpm',
'Packages/kernel-debug-devel-2.6.32-71.el6.x86_64.rpm',
'Packages/kernel-devel-2.6.32-71.el6.x86_64.rpm',
'Packages/kernel-2.6.32-71.el6.x86_64.rpm',
'Packages/kernel-debug-2.6.32-71.el6.x86_64.rpm',
'Packages/kernel-firmware-2.6.32-71.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-71.el6.x86_64.rpm',
],

'centos6_1_i386-bin-DVD_1of2' => 
[
'Packages/abrt-addon-kerneloops-1.1.16-3.el6.centos.i686.rpm',
'Packages/dracut-kernel-004-53.el6.noarch.rpm',
'Packages/kernel-devel-2.6.32-131.0.15.el6.i686.rpm',
'Packages/kernel-doc-2.6.32-131.0.15.el6.noarch.rpm',
'Packages/kernel-debug-devel-2.6.32-131.0.15.el6.i686.rpm',
'Packages/kernel-2.6.32-131.0.15.el6.i686.rpm',
'Packages/kernel-debug-2.6.32-131.0.15.el6.i686.rpm',
'Packages/kernel-firmware-2.6.32-131.0.15.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-131.0.15.el6.i686.rpm',
],



'centos6_1_x86_64-bin-DVD_1of2' => 
[
'Packages/abrt-addon-kerneloops-1.1.16-3.el6.centos.x86_64.rpm',
'Packages/dracut-kernel-004-53.el6.noarch.rpm',
'Packages/kernel-debug-devel-2.6.32-131.0.15.el6.x86_64.rpm',
'Packages/kernel-devel-2.6.32-131.0.15.el6.x86_64.rpm',
'Packages/kernel-debug-2.6.32-131.0.15.el6.x86_64.rpm',
'Packages/kernel-2.6.32-131.0.15.el6.x86_64.rpm',
'Packages/kernel-doc-2.6.32-131.0.15.el6.noarch.rpm',
'Packages/kernel-firmware-2.6.32-131.0.15.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-131.0.15.el6.x86_64.rpm',
],


'centos6_2_x86_64-bin-DVD_1of2' => 
[
'Packages/abrt-addon-kerneloops-2.0.4-14.el6.centos.x86_64.rpm',
'Packages/dracut-kernel-004-256.el6.noarch.rpm',
'Packages/kernel-debug-2.6.32-220.el6.x86_64.rpm',
'Packages/kernel-doc-2.6.32-220.el6.noarch.rpm',
'Packages/kernel-debug-devel-2.6.32-220.el6.x86_64.rpm',
'Packages/kernel-2.6.32-220.el6.x86_64.rpm',
'Packages/kernel-devel-2.6.32-220.el6.x86_64.rpm',
'Packages/kernel-firmware-2.6.32-220.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-220.el6.x86_64.rpm',
'Packages/libreport-plugin-kerneloops-2.0.5-20.el6.x86_64.rpm',
],


'centos6_2_i386-bin-DVD_1of2' => 
[
'Packages/abrt-addon-kerneloops-2.0.4-14.el6.centos.i686.rpm',
'Packages/dracut-kernel-004-256.el6.noarch.rpm',
'Packages/kernel-debug-2.6.32-220.el6.i686.rpm',
'Packages/kernel-doc-2.6.32-220.el6.noarch.rpm',
'Packages/kernel-debug-devel-2.6.32-220.el6.i686.rpm',
'Packages/kernel-2.6.32-220.el6.i686.rpm',
'Packages/kernel-devel-2.6.32-220.el6.i686.rpm',
'Packages/kernel-firmware-2.6.32-220.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-220.el6.i686.rpm',
'Packages/libreport-plugin-kerneloops-2.0.5-20.el6.i686.rpm',
],


'centos6_3_i386-bin-DVD_1of2'=>
[


'Packages//abrt-addon-kerneloops-2.0.8-6.el6.centos.i686.rpm',
'Packages//dracut-kernel-004-283.el6.noarch.rpm',
'Packages//kernel-2.6.32-279.el6.i686.rpm',
'Packages//kernel-debug-2.6.32-279.el6.i686.rpm',
'Packages//kernel-debug-devel-2.6.32-279.el6.i686.rpm',
'Packages//kernel-devel-2.6.32-279.el6.i686.rpm',
'Packages//kernel-doc-2.6.32-279.el6.noarch.rpm',
'Packages//kernel-firmware-2.6.32-279.el6.noarch.rpm',
'Packages//kernel-headers-2.6.32-279.el6.i686.rpm',
'Packages//libreport-plugin-kerneloops-2.0.9-5.el6.centos.i686.rpm',


],


'centos6_3_x86_64_bin-DVD_1of2'=>
[

'Packages/abrt-addon-kerneloops-2.0.8-6.el6.centos.x86_64.rpm',
'Packages/dracut-kernel-004-283.el6.noarch.rpm',
'Packages/kernel-2.6.32-279.el6.x86_64.rpm',
'Packages/kernel-debug-2.6.32-279.el6.x86_64.rpm',
'Packages/kernel-debug-devel-2.6.32-279.el6.x86_64.rpm',
'Packages/kernel-devel-2.6.32-279.el6.x86_64.rpm',
'Packages/kernel-doc-2.6.32-279.el6.noarch.rpm',
'Packages/kernel-firmware-2.6.32-279.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-279.el6.x86_64.rpm',
'Packages/libreport-plugin-kerneloops-2.0.9-5.el6.centos.x86_64.rpm',

],


'centos6_4_x86_64_bin-DVD_1of2'=>
[

'Packages/abrt-addon-kerneloops-2.0.8-15.el6.centos.x86_64.rpm',
'Packages/dracut-kernel-004-303.el6.noarch.rpm',
'Packages/kernel-2.6.32-358.el6.x86_64.rpm',
'Packages/kernel-debug-2.6.32-358.el6.x86_64.rpm',
'Packages/kernel-debug-devel-2.6.32-358.el6.x86_64.rpm',
'Packages/kernel-devel-2.6.32-358.el6.x86_64.rpm',
'Packages/kernel-doc-2.6.32-358.el6.noarch.rpm',
'Packages/kernel-firmware-2.6.32-358.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-358.el6.x86_64.rpm',
'Packages/libreport-plugin-kerneloops-2.0.9-15.el6.centos.x86_64.rpm',

],


'centos6_4_i386-bin-DVD_1of2'=>
[
'Packages//abrt-addon-kerneloops-2.0.8-15.el6.centos.i686.rpm',
'Packages//dracut-kernel-004-303.el6.noarch.rpm',
'Packages//kernel-2.6.32-358.el6.i686.rpm',
'Packages//kernel-debug-2.6.32-358.el6.i686.rpm',
'Packages//kernel-debug-devel-2.6.32-358.el6.i686.rpm',
'Packages//kernel-devel-2.6.32-358.el6.i686.rpm',
'Packages//kernel-doc-2.6.32-358.el6.noarch.rpm',
'Packages//kernel-firmware-2.6.32-358.el6.noarch.rpm',
'Packages//kernel-headers-2.6.32-358.el6.i686.rpm',
'Packages//libreport-plugin-kerneloops-2.0.9-15.el6.centos.i686.rpm',
],


'centos6_5_x86_64_bin-DVD_1of2'=>
[

'Packages/abrt-addon-kerneloops-2.0.8-21.el6.centos.x86_64.rpm',
'Packages/dracut-kernel-004-335.el6.noarch.rpm',
'Packages/kernel-2.6.32-431.el6.x86_64.rpm',
'Packages/kernel-abi-whitelists-2.6.32-431.el6.noarch.rpm',
'Packages/kernel-debug-2.6.32-431.el6.x86_64.rpm',
'Packages/kernel-debug-devel-2.6.32-431.el6.x86_64.rpm',
'Packages/kernel-devel-2.6.32-431.el6.x86_64.rpm',
'Packages/kernel-doc-2.6.32-431.el6.noarch.rpm',
'Packages/kernel-firmware-2.6.32-431.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-431.el6.x86_64.rpm',
'Packages/libreport-plugin-kerneloops-2.0.9-19.el6.centos.x86_64.rpm',



],









#--------------------------------------------------------------------------
'rhel4_8_i386_bin_DVD'=>
[

	'RedHat//RPMS//kernel-2.6.9-89.EL.i686.rpm',
	'RedHat//RPMS//kernel-devel-2.6.9-89.EL.i686.rpm',
	'RedHat//RPMS//kernel-hugemem-2.6.9-89.EL.i686.rpm',
	'RedHat//RPMS//kernel-hugemem-devel-2.6.9-89.EL.i686.rpm',
	'RedHat//RPMS//kernel-smp-2.6.9-89.EL.i686.rpm',
	'RedHat//RPMS//kernel-smp-devel-2.6.9-89.EL.i686.rpm',
	'RedHat//RPMS//kernel-utils-2.4-18.el4.i386.rpm',
	'RedHat//RPMS//kernel-xenU-2.6.9-89.EL.i686.rpm',
	'RedHat//RPMS//kernel-xenU-devel-2.6.9-89.EL.i686.rpm',

],
#--------------------------------------------------------------------------
'rhel4_8_x86_64_bin_DVD'=>
[
	'RedHat//RPMS//kernel-2.6.9-89.EL.x86_64.rpm',
	'RedHat//RPMS//kernel-devel-2.6.9-89.EL.x86_64.rpm',
	'RedHat//RPMS//kernel-doc-2.6.9-89.EL.noarch.rpm',
	'RedHat//RPMS//kernel-largesmp-2.6.9-89.EL.x86_64.rpm',
	'RedHat//RPMS//kernel-largesmp-devel-2.6.9-89.EL.x86_64.rpm',
	'RedHat//RPMS//kernel-smp-2.6.9-89.EL.x86_64.rpm',
	'RedHat//RPMS//kernel-smp-devel-2.6.9-89.EL.x86_64.rpm',
	'RedHat//RPMS//kernel-utils-2.4-18.el4.x86_64.rpm',
	'RedHat//RPMS//kernel-xenU-2.6.9-89.EL.x86_64.rpm',
	'RedHat//RPMS//kernel-xenU-devel-2.6.9-89.EL.x86_64.rpm',
],

#==========================================================================
'rhel5_8_server-i386-bin-dvd'=>
[

'Server//kernel-2.6.18-308.el5.i686.rpm',
'Server//kernel-PAE-2.6.18-308.el5.i686.rpm',
'Server//kernel-PAE-devel-2.6.18-308.el5.i686.rpm',
'Server//kernel-debug-2.6.18-308.el5.i686.rpm',
'Server//kernel-debug-devel-2.6.18-308.el5.i686.rpm',
'Server//kernel-devel-2.6.18-308.el5.i686.rpm',
'Server//kernel-doc-2.6.18-308.el5.noarch.rpm',
'Server//kernel-headers-2.6.18-308.el5.i386.rpm',
'Server//kernel-xen-2.6.18-308.el5.i686.rpm',
'Server//kernel-xen-devel-2.6.18-308.el5.i686.rpm',

],

'rhel5_6_server-x86_64-bin-dvd'=>
[

'Server//kernel-2.6.18-238.el5.x86_64.rpm',
'Server//kernel-debug-2.6.18-238.el5.x86_64.rpm',
'Server//kernel-debug-devel-2.6.18-238.el5.x86_64.rpm',
'Server//kernel-devel-2.6.18-238.el5.x86_64.rpm',
'Server//kernel-doc-2.6.18-238.el5.noarch.rpm',
'Server//kernel-headers-2.6.18-238.el5.x86_64.rpm',
'Server//kernel-xen-2.6.18-238.el5.x86_64.rpm',
'Server//kernel-xen-devel-2.6.18-238.el5.x86_64.rpm',
'Server//redhat-release-5Server-5.6.0.3.x86_64.rpm',


],


'rhel5_8_server-x86_64-bin-dvd'=>
[

'Server/kernel-2.6.18-308.el5.x86_64.rpm',
'Server/kernel-debug-2.6.18-308.el5.x86_64.rpm',
'Server/kernel-debug-devel-2.6.18-308.el5.x86_64.rpm',
'Server/kernel-devel-2.6.18-308.el5.x86_64.rpm',
'Server/kernel-doc-2.6.18-308.el5.noarch.rpm',
'Server/kernel-headers-2.6.18-308.el5.x86_64.rpm',
'Server/kernel-xen-2.6.18-308.el5.x86_64.rpm',
'Server/kernel-xen-devel-2.6.18-308.el5.x86_64.rpm',

],

#--------------------------------------------------------------------------
'rhel6_4_server-x86_64-bin-dvd'=>
[
'Packages/kernel-2.6.32-358.el6.x86_64.rpm',
'Packages/kernel-debug-2.6.32-358.el6.x86_64.rpm',
'Packages/kernel-debug-devel-2.6.32-358.el6.x86_64.rpm',
'Packages/kernel-devel-2.6.32-358.el6.x86_64.rpm',
'Packages/kernel-doc-2.6.32-358.el6.noarch.rpm',
'Packages/kernel-firmware-2.6.32-358.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-358.el6.x86_64.rpm',
],
#--------------------------------------------------------------------------


'rhel6_0_server-6.0-i386-dvd'=>
[

'Packages//abrt-addon-kerneloops-1.1.13-4.el6.i686.rpm',
'Packages//dracut-kernel-004-32.el6.noarch.rpm',
'Packages//kernel-2.6.32-71.el6.i686.rpm',
'Packages//kernel-debug-2.6.32-71.el6.i686.rpm',
'Packages//kernel-debug-devel-2.6.32-71.el6.i686.rpm',
'Packages//kernel-devel-2.6.32-71.el6.i686.rpm',
'Packages//kernel-doc-2.6.32-71.el6.noarch.rpm',
'Packages//kernel-firmware-2.6.32-71.el6.noarch.rpm',
'Packages//kernel-headers-2.6.32-71.el6.i686.rpm',

],

#--------------------------------------------------------------------------
'rhel6_0_server-6.0-x86_64-bin_dvd'=>
[
'Packages//kernel-2.6.32-71.el6.x86_64.rpm',
'Packages//kernel-debug-2.6.32-71.el6.x86_64.rpm',
'Packages//kernel-debug-devel-2.6.32-71.el6.x86_64.rpm',
'Packages//kernel-devel-2.6.32-71.el6.x86_64.rpm',
'Packages//kernel-doc-2.6.32-71.el6.noarch.rpm',
'Packages//kernel-firmware-2.6.32-71.el6.noarch.rpm',
'Packages//kernel-headers-2.6.32-71.el6.x86_64.rpm',
],


#--------------------------------------------------------------------------
'rhel6_1_server_i386_bin-dvd' => 
[
'Packages/abrt-addon-kerneloops-1.1.16-3.el6.i686.rpm',
'Packages/dracut-kernel-004-53.el6.noarch.rpm',
'Packages/kernel-2.6.32-131.0.15.el6.i686.rpm',
'Packages/kernel-debug-2.6.32-131.0.15.el6.i686.rpm',
'Packages/kernel-debug-devel-2.6.32-131.0.15.el6.i686.rpm',
'Packages/kernel-devel-2.6.32-131.0.15.el6.i686.rpm',
'Packages/kernel-doc-2.6.32-131.0.15.el6.noarch.rpm',
'Packages/kernel-firmware-2.6.32-131.0.15.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-131.0.15.el6.i686.rpm',
'Packages/redhat-release-server-6Server-6.1.0.2.el6.i686.rpm',
],

'rhel6_1_server_x86_64_bin-dvd' => 
[
'Packages/abrt-addon-kerneloops-1.1.16-3.el6.x86_64.rpm',
'Packages/dracut-kernel-004-53.el6.noarch.rpm',
'Packages/kernel-2.6.32-131.0.15.el6.x86_64.rpm',
'Packages/kernel-debug-2.6.32-131.0.15.el6.x86_64.rpm',
'Packages/kernel-debug-devel-2.6.32-131.0.15.el6.x86_64.rpm',
'Packages/kernel-devel-2.6.32-131.0.15.el6.x86_64.rpm',
'Packages/kernel-doc-2.6.32-131.0.15.el6.noarch.rpm',
'Packages/kernel-firmware-2.6.32-131.0.15.el6.noarch.rpm',
'Packages/kernel-headers-2.6.32-131.0.15.el6.x86_64.rpm',
],

#--------------------------------------------------------------------------
'rhel6_3_server-6.3-i386-dvd'=>
[
'Packages//kernel-2.6.32-279.el6.i686.rpm',
'Packages//kernel-debug-2.6.32-279.el6.i686.rpm',
'Packages//kernel-debug-devel-2.6.32-279.el6.i686.rpm',
'Packages//kernel-devel-2.6.32-279.el6.i686.rpm',
'Packages//kernel-doc-2.6.32-279.el6.noarch.rpm',
'Packages//kernel-firmware-2.6.32-279.el6.noarch.rpm',
'Packages//kernel-headers-2.6.32-279.el6.i686.rpm',

],


#--------------------------------------------------------------------------
'rhel6_3_server_x86_64-bin_dvd'=>
[

'Packages//kernel-2.6.32-279.el6.x86_64.rpm',
'Packages//kernel-debug-2.6.32-279.el6.x86_64.rpm',
'Packages//kernel-debug-devel-2.6.32-279.el6.x86_64.rpm',
'Packages//kernel-devel-2.6.32-279.el6.x86_64.rpm',
'Packages//kernel-doc-2.6.32-279.el6.noarch.rpm',
'Packages//kernel-firmware-2.6.32-279.el6.noarch.rpm',
'Packages//kernel-headers-2.6.32-279.el6.x86_64.rpm',
'Packages/redhat-release-server-6Server-6.3.0.3.el6.x86_64.rpm',
],




'rhel6_2_server-6.2-i386-dvd'=>
[
'Packages//kernel-2.6.32-220.el6.i686.rpm',
'Packages//kernel-debug-2.6.32-220.el6.i686.rpm',
'Packages//kernel-debug-devel-2.6.32-220.el6.i686.rpm',
'Packages//kernel-devel-2.6.32-220.el6.i686.rpm',
'Packages//kernel-doc-2.6.32-220.el6.noarch.rpm',
'Packages//kernel-firmware-2.6.32-220.el6.noarch.rpm',
'Packages//kernel-headers-2.6.32-220.el6.i686.rpm',
'Packages//redhat-release-server-6Server-6.2.0.3.el6.i686.rpm',
],
#--------------------------------------------------------------------------
'rhel6_2_server-6.2-x86_64-bin_dvd'=>
[

'Packages//kernel-2.6.32-220.el6.x86_64.rpm',
'Packages//kernel-debug-2.6.32-220.el6.x86_64.rpm',
'Packages//kernel-debug-devel-2.6.32-220.el6.x86_64.rpm',
'Packages//kernel-devel-2.6.32-220.el6.x86_64.rpm',
'Packages//kernel-doc-2.6.32-220.el6.noarch.rpm',
'Packages//kernel-firmware-2.6.32-220.el6.noarch.rpm',
'Packages//kernel-headers-2.6.32-220.el6.x86_64.rpm',
'Packages//redhat-release-server-6Server-6.2.0.3.el6.x86_64.rpm',

],




#==========================================================================
};



sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> all.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}
#use Data::Dumper;
#print Data::Dumper->Dump([$hash]);        



sub  emulator_all($$)
{

	(my $iso, my $hash)=@_;
	my $os_name;
	for $os_name  (keys(%{$hash}))
	{
		logger( "\n#¼ì²â $iso ÊÇ·ñ Îª $os_name \n");
		my $os_name=template_($iso, $os_name, @{$hash->{$os_name}} );
		if(defined($os_name))
		{
			logger( "RESULT:  $iso  Îª  $os_name \n");
			return $os_name;
		}
	}

	return undef;
}

sub template_($$@)
{
	(my $input_iso,  my $os_name,  my @pkgs)=@_;



	if(! -d "dir/")
	{
		mkdir("dir/");
	}

	if( ! -f $input_iso)
	{
		goto  unmount;
		#return undef;
	}
	else
	{
		#print("mount  -t iso9660  $input_iso  dir/ -o loop \n");
		system("mount  -t iso9660  $input_iso  dir/ -o loop > /dev/null 2>&1 \n");
	}


	for(@pkgs)
	{
		if( ! -f "dir/".$_)
		{
			#print "dir/".$_."  not exists \n";
			goto  unmount;
			#return undef;
		}
		else
		{
			#print "dir/".$_."   exists \n";
		}
	}	
	goto output;

unmount:
	system("umount dir ");
	return undef; 

output: 
	#print "$input_iso";
	system("umount dir ");
	return "$os_name";


}


my $input_iso=shift or die("Usage: $0  input.iso \n");
my $norm_name=emulator_all($input_iso, $hash);

use Cwd;
use File::Basename;


if(defined($norm_name))
{
	my $dirname=dirname($input_iso);	
	my $basename=basename($input_iso);
	print "mv $input_iso   $dirname/$norm_name.iso \n";
}


__DATA__
sub is_centos5_0_i386_bin_DVD($)
{
	(my $input_iso)=@_;


	if(! -d "dir/")
	{
		mkdir("dir/");
	}

	if( ! -f $input_iso)
	{
		goto  unmount;
		#return undef;
	}
	else
	{
		system("mount  -t iso9660  $input_iso  dir/ -o loop \n");
	}

	my @packages= qw(
	CentOS/kernel-2.6.18-8.el5.i686.rpm
	CentOS/kernel-PAE-2.6.18-8.el5.i686.rpm      	
	CentOS/kernel-PAE-devel-2.6.18-8.el5.i686.rpm
	CentOS/kernel-devel-2.6.18-8.el5.i686.rpm
	CentOS/kernel-doc-2.6.18-8.el5.noarch.rpm
	CentOS/kernel-headers-2.6.18-8.el5.i386.rpm
	CentOS/kernel-xen-2.6.18-8.el5.i686.rpm
	CentOS/kernel-xen-devel-2.6.18-8.el5.i686.rpm
	);

	for(@packages)
	{
		if( ! -f "dir/".$_)
		{
			print "dir/".$_."  not exists \n";
			goto  unmount;
			#return undef;
		}
	}	

unmount:
	system("umount dir ");
	return undef; 


	system("umount dir ");
	return "centos5_0_i386_bin_DVD";
	
}


