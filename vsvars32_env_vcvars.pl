#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

"C:\Program Files\Microsoft Visual Studio\VC98\Bin\vcvars32.bat"
nmake /f makefile.vc
"C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\Tools\vsvars32.bat"
nmake /f makefile.vc
"C:\Program Files\Microsoft Visual Studio 8\Common7\Tools\vsvars32.bat"
nmake /f makefile.vc
"C:\Program Files\Microsoft Visual Studio 9.0\Common7\Tools\vsvars32.bat"
nmake /f makefile.vc
"C:\Program Files\Microsoft Visual Studio 10.0\Common7\Tools\vsvars32.bat"
nmake /f makefile.vc




