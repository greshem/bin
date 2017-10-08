#!/usr/bin/perl
my $input_file=shift or die("usage: $0  input_file \n");
my $perl_output=$input_file.".pl";
	$perl_output=~s/\//_/g;

#生成的脚本里面的, 生成的二进制文件. 
my $output_file_in_perl= $input_file.".bin";
$output_file_in_perl=~s/\//_/g;

if( -f $perl_output )
{
	print "#[Warn]: $perl_output while  be delete \n";
}

open(OUTPUT, "> $perl_output") or die("create file error \n");
print OUTPUT  <<EOF
open(FILE, ">$output_file_in_perl");
binmode FILEHANDLE, ":raw";
my \$buffer= 
EOF
;
#-A address   没有address 偏移地址. 
#-t 每个字节 打印.  便于输出到per里面去. 
#od -An -t x1  gpxe -v  
#print( "od -An -t x1 -w  -v  $input_file     \n");
#open( PIPE, "od -An -t x1 -w  $input_file -v    |") or die(" open file error \n");
open( PIPE,  "od -An -t x1  -v  $input_file     |") or die(" open file error \n");

for(<PIPE>)
{
	chomp;
	$_=~s/ /\\x/g;	
	print OUTPUT  "\"$_\"\.\n";
}
print OUTPUT  "\"\"\n";
print OUTPUT  ";\n";


print OUTPUT <<EOF
print FILE  \$buffer;
close(FILE);
print "#$output_file_in_perl  generated \\n"; 
EOF
;


print "#$perl_output have generated\n";
#print "#[NOTICE]: mdf  gpxe_hex.pl ,  and exec it \n";
#print "#[NOTICE]:  find pattern  5c\\x11  change to  b8\\x22\n";
#print "#	           as        4444    ->         8888 \n"
