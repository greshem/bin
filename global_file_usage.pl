#!/usr/bin/perl
	print "#GPATH ��ع���\n";
	print "#dump���м�¼\n";
	print "btreeop -L2 -k \"./\" \"GPATH\" \n";
	print "���ƹ���\n";
	print "gtags --find \n";

	print "btreeop -L2  \"GRTAGS\"   \n";

	print "btreeop -L2  \"GTAGS\"   \n";

	print "btreeop -L2  \"GSYMS\"   \n";

print <<EOF
 global -nxr ".*" 
 global -nx ".*" 
 global -c    		#��ӡ���к���
	gtags --find 	#��ӡ�����ļ�.
	gtags --expand -8 './acconfig.h' ��ӡ����ļ���������еĶ��ǩ.
	
EOF
;


