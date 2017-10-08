#!/usr/bin/perl
open(CMD, "papi_avail|") or die("open api_avail faiuer \n");

my @all_op;
for(<CMD>)
{
	#print $_;
	@array=split(/\s+/, $_);
	if($array[0]=~/^PAPI/ && $array[2] =~/yes/i)
	{
		#print "# $_\n";	
		push(@all_op, $array[0]);
		#print join(" ", @array[3..$#array]);
		$desc= join(" ", @array[4..$#array]);
		print "papi_command_line $array[0]   #". $desc ."\n";
	}
}

print "#==========================================================================\n";
print "#把上面所有的 item 10个 一组 join \n";

print "papi_command_line  ".join(" ", @all_op[1..10])."\n";
print "papi_command_line  ".join(" ", @all_op[10..20])."\n";
print "papi_command_line  ".join(" ", @all_op[20..30])."\n";
print "papi_command_line  ".join(" ", @all_op[40..50])."\n";
print "papi_command_line  ".join(" ", @all_op[50..60])."\n";
