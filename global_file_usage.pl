#!/usr/bin/perl
	print "#GPATH 相关功能\n";
	print "#dump所有记录\n";
	print "btreeop -L2 -k \"./\" \"GPATH\" \n";
	print "类似功能\n";
	print "gtags --find \n";

	print "btreeop -L2  \"GRTAGS\"   \n";

	print "btreeop -L2  \"GTAGS\"   \n";

	print "btreeop -L2  \"GSYMS\"   \n";

print <<EOF
 global -nxr ".*" 
 global -nx ".*" 
 global -c    		#打印所有函数
	gtags --find 	#打印所有文件.
	gtags --expand -8 './acconfig.h' 打印这个文件里面的所有的俄标签.
	
EOF
;


