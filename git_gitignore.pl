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
*.a       #����������.aΪ��׺���ļ�;
!lib.a    #�������ļ�lib.a;
/TODO     #ֻ���Դ�Ŀ¼��TODO�ļ�,��Ŀ¼��TODO��������;
build/    #����buildĿ¼�µ������ļ�;
doc/*.txt #ֻ����doc/�����е�txt�ļ�,���ǲ�����doc/subdir/�µ�txt�ļ�;

#==========================================================================
#���ӷ����һ�ַ�ʽ,  ��ֻ���¼ pl sh ��β���ļ�, 
cat >> .gitignore <<EOF
*
!*.pl
!*.sh
EOF
