#!/usr/bin/perl
$input= shift or warn("Usage: $0 input_file \n");
$input="input_file" ;
print <<EOF
sed  's/^\\s*#*//g' $input #ȥ��ע��, �������÷�.
sed '/./{N;s/\\n//}'  $input  	# join 
sed '/^\$/d' $input				#delete  empty line  

EOF
;
