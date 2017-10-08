#!/usr/bin/perl
for(<DATA>)
{
	print $_;
}
__DATA__
1.preg_match
if(preg_match("/^http/i", "http://www.baidu.com"))
{   
}   
2. 获取目录下 rpm$文件。 
 perl @a=grep{-f &&/rpm$/} (<*>); 
# php
function getFile($in)
{
	if(is_file($in))
	{
		return $in;
	}
}
 $tmp=glob("*");
 $files= array_map(getFile, $tmp);
3. 
