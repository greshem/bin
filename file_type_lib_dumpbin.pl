#!/uer/bin/perl

deal_with_one_type("dll");
deal_with_one_type("lib");
deal_with_one_type("exe");
deal_with_one_type("sys");

#sub file_type_cmd_dum_lib()
sub deal_with_one_type($)
{
	(my $pattern)=@_;
	for(glob("*.$pattern"))
	{
		my $line=$_;
		(my $name)=($line=~/(.*).$pattern/i);	

		if($^O=~/win32/i)
		{
			print <<EOF
	dumpbin      /ALL $line > $name.ALL.asm
	dumpbin      /DISASM $line > $name.DISASM.asm
	dumpbin      /ARCHIVEMEMBERS $line > $name.ARCHIVEMEMBERS.asm
	dumpbin      /CLRHEADER $line > $name.CLRHEADER.asm
	dumpbin      /DEPENDENTS $line > $name.DEPENDENTS.asm
	dumpbin      /DIRECTIVES $line > $name.DIRECTIVES.asm
	dumpbin      /EXPORTS $line > $name.EXPORTS.asm
	dumpbin      /FPO $line > $name.FPO.asm
	dumpbin      /HEADERS $line > $name.HEADERS.asm
	dumpbin      /LINENUMBERS $line > $name.LINENUMBERS.asm
	dumpbin      /LOADCONFIG $line > $name.LOADCONFIG.asm
	dumpbin      /PDATA $line > $name.PDATA.asm
	dumpbin      /RELOCATIONS $line > $name.RELOCATIONS.asm
	dumpbin      /SUMMARY $line > $name.SUMMARY.asm
	dumpbin      /SYMBOLS $line > $name.SYMBOLS.asm
	dumpbin      /UNWINDINFO $line > $name.UNWINDINFO.asm
	dumpbin      /IMPORTS    $line > $name.IMPORTS.asm 
EOF
;
		}
		else
		{
			#print "dumpbin  /DISASM $line > $name.asm\n";
			#ิดย๋.
			print "objdump -d  -S  $line |c++filt  > $line.asm \n";
		}
	}
}

__DATA__
C:\Program Files\Microsoft Visual Studio .NET 2003\Vc7\PlatformSDK\Lib>dumpbin /?
Microsoft (R) COFF/PE Dumper Version 7.10.3077
Copyright (C) Microsoft Corporation.  All rights reserved.

usage: DUMPBIN [options] [files]

   options:
dumpbin      /OUT:filename $line > $name.asm
dumpbin      /DISASM[:{BYTES|NOBYTES}] $line > $name.DISASM.asm
dumpbin      /IMPORTS[:filename] $line > $name.IMPORTS.asm
dumpbin      /LINKERMEMBER[:{1|2}] $line > $name.LINKERMEMBER.asm
dumpbin      /PDBPATH[:VERBOSE] $line > $name.PDBPATH.asm
dumpbin      /RAWDATA[:{NONE|1|2|4|8}[,#]] $line > $name.RAWDATA.asm
dumpbin      /SECTION:name $line > $name.SECTION.asm


dumpbin      /ALL $line > $name.ALL.asm
dumpbin      /DISASM $line > $name.DISASM.asm
dumpbin      /ARCHIVEMEMBERS $line > $name.ARCHIVEMEMBERS.asm
dumpbin      /CLRHEADER $line > $name.CLRHEADERasm
dumpbin      /DEPENDENTS $line > $name.DEPENDENTS.asm
dumpbin      /DIRECTIVES $line > $name.DIRECTIVES.asm
dumpbin      /EXPORTS $line > $name.EXPORTS.asm
dumpbin      /FPO $line > $name.FPO.asm
dumpbin      /HEADERS $line > $name.HEADERS.asm
dumpbin      /LINENUMBERS $line > $name.LINENUMBERS.asm
dumpbin      /LOADCONFIG $line > $name.LOADCONFIG.asm
dumpbin      /PDATA $line > $name.PDATA.asm
dumpbin      /RELOCATIONS $line > $name.RELOCATIONS.asm
dumpbin      /SUMMARY $line > $name.SUMMARY.asm
dumpbin      /SYMBOLS $line > $name.SYMBOLS.asm
dumpbin      /UNWINDINFO $line > $name.UNWINDINFO.asm
