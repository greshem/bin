#!/usr/bin/perl
#2011_06_24_13:46:43   星期五   add by greshem
#产生 每个目录下面的 tmp目录.

mkdir("C:\\Documents and Settings\\Administrator\\桌面\\快捷方式_all");

for(a..z)
{

		if (  -d $_.":\\"  && ! -d $_."\\tmp")
		{
			printf $_."盘要产生 tmp目录\n";
			mkdir("$_:\\tmp");
			if(!  -d  "$_:\\tmp" )
			{
				print "$_:\\tmp 没法产生tmp目录, 可能是只读磁盘.\n"
			}
		}

		# if( ! -d $_.":\\")
		# {
		# 	print $_."盘不存在\n";
		# }
}
