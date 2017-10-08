#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
cat >> .gitignore <<EOF
*.[oa]
*.l[oa]
*.so
*.diff
*.dep
*.gz
*.exe
*.dll
*.class
*.com
*.o
*.so
*.7z
*.gz
*.iso
*.html
*.uo
*.rar
*.zip
*.dmg
*.log
.svn
EOF
#==========================================================================
*.a       #忽略所有以.a为后缀的文件;
!lib.a    #不忽略文件lib.a;
/TODO     #只忽略此目录下TODO文件,子目录的TODO不被忽略;
build/    #忽略build目录下的所有文件;
doc/*.txt #只忽略doc/下所有的txt文件,但是不忽略doc/subdir/下的txt文件;

#==========================================================================
#更加方便的一种方式,  我只想记录 pl sh 结尾的文件, 
cat >> .gitignore <<EOF
*
!*.pl
!*.sh
EOF
