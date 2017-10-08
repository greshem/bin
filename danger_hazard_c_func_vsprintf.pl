#!/usr/bin/perl
@func_name;
foreach (<DATA>)
{
	print "#".$_;
	if($_=~/^([a-z]+)\s+很危险.*/)
	{
		push(@func_name, $1);	
	}
}

for(@func_name)
{
	print "grep -R $_ *\n";
}
__DATA__

#2011_06_09_ 星期四 add by greshem

#Hazard
#函数 严重性 解决方案

gets 最危险 使用 fgets（buf, size, stdin）。这几乎总是一个大问题！
strcpy 很危险 改为使用 strncpy。
strcat 很危险 改为使用 strncat。
sprintf 很危险 改为使用 snprintf，或者使用精度说明符。
scanf 很危险 使用精度说明符，或自己进行解析。
sscanf 很危险 使用精度说明符，或自己进行解析。
fscanf 很危险 使用精度说明符，或自己进行解析。
vfscanf 很危险 使用精度说明符，或自己进行解析。
vsprintf 很危险 改为使用 vsnprintf，或者使用精度说明符。
vscanf 很危险 使用精度说明符，或自己进行解析。
vsscanf 很危险 使用精度说明符，或自己进行解析。
streadd 很危险 确保分配的目的地参数大小是源参数大小的四倍。
strecpy 很危险 确保分配的目的地参数大小是源参数大小的四倍。
realpath 很危险（或稍小，取决于实现） 分配缓冲区大小为 MAXPATHLEN。同样，手工检查参数以确保输入参数不超过 MAXPATHLEN。
syslog 很危险（或稍小，取决于实现） 在将字符串输入传递给该函数之前，将所有字符串输入截成合理的大小。
getopt 很危险（或稍小，取决于实现） 在将字符串输入传递给该函数之前，将所有字符串输入截成合理的大小。
getopt_long 很危险（或稍小，取决于实现） 在将字符串输入传递给该函数之前，将所有字符串输入截成合理的大小。
getpass 很危险（或稍小，取决于实现） 在将字符串输入传递给该函数之前，将所有字符串输入截成合理的大小。

strtrns 危险 手工检查来查看目的地大小是否至少与源字符串相等。

getchar 中等危险 如果在循环中使用该函数，确保检查缓冲区边界。
fgetc 中等危险 如果在循环中使用该函数，确保检查缓冲区边界。
getc 中等危险 如果在循环中使用该函数，确保检查缓冲区边界。
read 中等危险 如果在循环中使用该函数，确保检查缓冲区边界。
bcopy 低危险 确保缓冲区大小与它所说的一样大。
fgets 低危险 确保缓冲区大小与它所说的一样大。
memcpy 低危险 确保缓冲区大小与它所说的一样大。
snprintf 低危险 确保缓冲区大小与它所说的一样大。
strccpy 低危险 确保缓冲区大小与它所说的一样大。
strcadd 低危险 确保缓冲区大小与它所说的一样大。
strncpy 低危险 确保缓冲区大小与它所说的一样大。
vsnprintf 低危险 确保缓冲区大小与它所说的一样大。 
########################################################################

