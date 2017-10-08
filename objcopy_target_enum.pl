#!/usr/bin/perl
use Cwd;
use File::Basename;

@target=qw( elf64-x86-64 elf32-i386 a.out-i386-linux pei-i386 pei-x86-64 elf64-l1om elf64-little elf64-big elf32-little elf32-big srec symbolsrec verilog tekhex binary ihex);

my $input_file=shift or die("Usage: $0  input_elf_file \n");
cross_all($input_file);
#cross_all_2x2();

########################################################################
#sub functions
sub cross_all($)
{
	(my $file)=@_;
	my $basename=basename($file);
	my $output_target;
	for $output_target (@target)
	{
			print 	 "objcopy   --output-target $output_target    $file  $basename.$output_target \n";

	}

}
sub cross_all_2x2()
{
	(my $file)=@_;
	my $from;
	my $to;
	for $from (@target)
	{
		for $to (@target )
		{
			print 	 "objcopy  --input-target $from  --output-target $to    /bin/ls  ls.$to \n";
		}

	}
}

__DATA__
our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);
