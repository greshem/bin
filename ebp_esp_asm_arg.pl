#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
0x00000000
#�����
esp-1
----------
|esp     | #=ebp- 1024 
|esp+n   | #�ڲ�����. =ebp-1024 +n 
|        |
|        |
|        |
|        |
|ebp-n   | #�ڲ�����  = esp+1024 -n 
|ebp     | #= esp+1024 
|________|
ebp+m      #= esp+1024 +m , һ�����ⲿ����. arg_0 
0xFFFFFFFFFFFFF
