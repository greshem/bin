#!/usr/bin/perl
use Cwd;
use File::Basename;

my $input_file=shift or die("usage; input_file \n");

@targets=qw(elf32-i386 a.out-i386-linux pei-i386 elf64-x86-64 elf32-x86-64 elf64-l1om elf64-k1om elf64-little elf64-big elf32-little elf32-big plugin srec symbolsrec verilog tekhex binary ihex trad-core);
@archs=qw( i386 i386:x86-64 i386:x64-32 i8086 i386:intel i386:x86-64:intel i386:x64-32:intel l1om l1om:intel k1om k1om:intel plugin);

my $basename=basename($input_file);

for $target (@targets)
{
	for $arch   (@archs)
	{
		my $output_target_arch="${basename}\@${target}\@${arch}.asm";
		my $output_arch_target="${basename}\@${arch}\@${target}.asm";
		$output_target_arch=~s/:/-/g;
		$output_arch_target=~s/:/-/g;
		print "objdump -d  -b $target  -m  $arch $input_file |c++filt >  $output_target_arch \n";
		print "objdump -d  -b $target  -m  $arch $input_file |c++filt >  $output_arch_target\n";
	}
}

__DATA__
#==========================================================================
-b: objdump: supported targets: elf32-i386 a.out-i386-linux pei-i386 elf64-x86-64 elf32-x86-64 elf64-l1om elf64-k1om elf64-little elf64-big elf32-little elf32-big plugin srec symbolsrec verilog tekhex binary ihex trad-core
-m: objdump: supported architectures: i386 i386:x86-64 i386:x64-32 i8086 i386:intel i386:x86-64:intel i386:x64-32:intel l1om l1om:intel k1om k1om:intel plugin

#==========================================================================
-M 
The following i386/x86-64 specific disassembler options are supported for use
with the -M switch (multiple options should be separated by commas):
  x86-64      Disassemble in 64bit mode
  i386        Disassemble in 32bit mode
  i8086       Disassemble in 16bit mode
  att         Display instruction in AT&T syntax
  intel       Display instruction in Intel syntax
  att-mnemonic
              Display instruction in AT&T mnemonic
  intel-mnemonic
              Display instruction in Intel mnemonic
  addr64      Assume 64bit address size
  addr32      Assume 32bit address size
  addr16      Assume 16bit address size
  data32      Assume 32bit data size
  data16      Assume 16bit data size
  suffix      Always display instruction suffix in AT&T syntax
Report bugs to <http://bugzilla.redhat.com/bugzilla/>.
