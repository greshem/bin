#!/usr/bin/perl
#-S, --source             Intermix source code with disassembly
#-l, --line-numbers             Include line numbers and filenames in output
#-F, --file-offsets             Include file offsets when displaying information
#-M att-mnemonic 	#Display instruction in AT&T mnemonic
#-M  intel-mnemonic #Display instruction in Intel mnemonic

print_common("diskplat.exe");

sub print_common()
{
	(my $diskplat)=@_;
	print <<EOF
objdump -S   ${diskplat}  | c++filt > ${diskplat}_att_objdump_intermix.asm 		#     intermix source code ´úÂë»ìºÏ. 
objdump -S -l  -M intel ${diskplat} 	|c++filt >  ${diskplat}_intel_intermix_line_number.asm 	#
objdump -S     -M intel ${diskplat} 	|c++filt >  ${diskplat}_intel_intermix_line_number.asm 	#


objdump -d -M att:att-mnemonic   					${diskplat} |c++filt > ${diskplat}_att.asm 
objdump -d -M intel:intel-mnemonic  	${diskplat} |c++filt  > ${diskplat}_intel.asm 

objdump -d -M intel:att-mnemonic  	${diskplat} |c++filt  > ${diskplat}_intel_att-mnemonic.asm 
objdump -d -M att:intel-mnemonic  	${diskplat} |c++filt  > ${diskplat}_att_intel-mnemonic.asm 



EOF
;

	print ("test");

}

