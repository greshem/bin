#!/usr/bin/perl
my @all=glob("*");

my @files=grep {-f && /cpp$|\.c$/} @all;
my @dirs= grep {-d} @all;

if(scalar(@files) == 0)
{
compile_single_files(@files);
}
{
	for(<DATA>)
	{
		print $_;
	}
}

my @stage2 = get_one_depth_dir_cpp_file(@dirs);
compile_single_files(@stage2);




#从目录数组里面 再去返回 所有的 cpp 文件的输出. 
sub get_one_depth_dir_cpp_file(@)
{
	(my @input_dir)=@_;
	
	my @cpp_files;
	
	for(@input_dir)
	{
		my @files=grep { -f } glob($_."/*.cpp");
		push(@cpp_files, @files);
	}
	return @cpp_files;
}


#/subsystem:|console
#           |native|posix|windows| windowsce
#			|efi_application|efi_boot_service_driver|efi_rom|efi_runtime_driver
sub compile_single_files(@)
{
	(my @input)=@_;
	for(@input)
	{
		print <<EOF
	cl.exe $_ /link AdvAPI32.lib Kernel32.lib user32.lib shell32.lib winmm.lib comctl32.lib gdi32.lib   ws2_32.lib
EOF
;
	}
}
	
__DATA__
cl.exe AbortDoc.cpp /link AdvAPI32.lib Kernel32.lib user32.lib shell32.lib winmm.lib comctl32.lib gdi32.lib
