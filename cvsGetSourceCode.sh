#!/bin/bash
#2011_02_28_15:41:14   ����һ   add by greshem
#  sf �� ��Ŀ�� CVS �Ļ�ȡ�ķ�ʽ. 
if [ !  $# -eq 1 ];then
	echo "Usage: ", $0  "    sourceforge_project_name";
	exit 
fi

name=$1
cvs -d:pserver:anonymous@${name}.cvs.sourceforge.net:/cvsroot/${name} login
cvs -z3 -d:pserver:anonymous@${name}.cvs.sourceforge.net:/cvsroot/${name} co -P  ${name}
