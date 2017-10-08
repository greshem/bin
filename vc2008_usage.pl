#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

iso_search_file.pl  "VC2008±‡“Î∆˜.rar"

MYPATH=D:\Development\Compiler\VC2008
PATH=%MYPATH%\bin
INCLUDE=%MYPATH%\include;%MYPATH%\PlatformSDK\Include;%MYPATH%\atlmfc\include;%MYPATH%\DirectX_SDK\Include;
LIB=%MYPATH%\lib;%MYPATH%\PlatformSDK\Lib;%MYPATH%\atlmfc\lib;%MYPATH%\DirectX_SDK\Lib\x86;

