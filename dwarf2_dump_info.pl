#!/usr/bin/perl
#=-w[lLiaprmfFsoRt] or
my %hash=(

"--debug-dump=rawline"  =>"-wl",
"--debug-dump=decodedline" =>"-wL",
"--debug-dump=info"		=>"-wi",
"--debug-dump=abbrev"		=>"-wa",
"--debug-dump=pubnames"	=>"-wp",
"--debug-dump=aranges"=>"-wr",
"--debug-dump=macro"=>"-wm",
"--debug-dump=frames"		=>"-wf",
"--debug-dump=frames-interp" =>"-wF",
"--debug-dump=str"		=>"-ws",
"--debug-dump=loc"	=>"-wo",
"--debug-dump=Ranges"		=>"-wR",
"--debug-dump=pubtypes"	=>"-wt",
"--debug-dump=gdb_index" =>"",
"--debug-dump=trace_info" =>"",
"--debug-dump=trace_abbrev" =>"",
"--debug-dump=trace_aranges"=>"",

);

print %hash;

my $elf="/usr/share/diskplat/diskplat";

for $each (keys(%hash))
{
	#print "echo FFFFFFFFFFFFFFFFF  \n";
	(my $name)=($each=~/--debug.*=(.*)/);
	print "readelf $each $elf  > diskplat_$name \n";	
}

