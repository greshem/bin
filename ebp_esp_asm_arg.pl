#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
0x00000000
#里面的
esp-1
----------
|esp     | #=ebp- 1024 
|esp+n   | #内部参数. =ebp-1024 +n 
|        |
|        |
|        |
|        |
|ebp-n   | #内部参数  = esp+1024 -n 
|ebp     | #= esp+1024 
|________|
ebp+m      #= esp+1024 +m , 一般是外部参数. arg_0 
0xFFFFFFFFFFFFF
