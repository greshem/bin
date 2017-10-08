#!/usr/bin/perl

use File::Slurp qw(edit_file);
#dsp 里面有16种输出  2^4=16 中, 分别的变量是   WXUNIV | UNICODE | BUILD | SHARED

edit_file {s/WXUNIV = 0/WXUNIV = 0/g} 'config.vc' ; 
edit_file { s/UNICODE = 0/UNICODE = 1/g } 'config.vc' ; 

#debug static 
print "#change to   UNICODE = 1, DEUBG=1  SHARED=0\n";
edit_file { s/BUILD = release/BUILD = debug/g   }  'config.vc';
edit_file { s/SHARED = 1/SHARED = 0/g   }  'config.vc';
system("nmake /f Makefile.vc ");


#debug shared 
print "#change to    UNICODE = 1, DEUBG=1  SHARED=1\n";
edit_file { s/BUILD = release/BUILD = debug/g   }  'config.vc';
edit_file { s/SHARED = 0/SHARED = 1/g   }  'config.vc';
system("nmake /f Makefile.vc ");


#release shared 
print "#change to    UNICODE = 1, release  SHARED=1\n";
edit_file { s/BUILD = debug/BUILD = release/g   }  'config.vc';
edit_file { s/SHARED = 0/SHARED = 1/g   }  'config.vc';
system("nmake /f Makefile.vc ");

#release  static 
print "#change to    UNICODE = 1, release  SHARED=0\n";
edit_file { s/SHARED = 1/SHARED = 0/g   }  'config.vc';
edit_file { s/BUILD = debug/BUILD = release/g   }  'config.vc';
system("nmake /f Makefile.vc ");

#==========================================================================
check();
sub check()
{
print "#下面的目录 必然存在 
C:\\works\\wxWidgets-2.8.10\\lib\\vc_dll\\mswu
C:\\works\\wxWidgets-2.8.10\\lib\\vc_dll\\mswud
C:\\works\\wxWidgets-2.8.10\\lib\\vc_lib\\mswu
C:\\works\\wxWidgets-2.8.10\\lib\\vc_lib\\mswud
";
}
