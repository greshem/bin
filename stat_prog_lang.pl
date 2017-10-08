#!/usr/bin/perl
my %static;
my $total;
my $total_c;
my $total_php;
my $total_perl;
my $total_python;
my $total_java;
my $total_ruby;
my $total_tcl;
my $total_bash;
my $total_other;
my %return_val=("error"=>0,
		"c"=>1,
		"cpp"=>2,
		"php"=>3,
		"perl"=>4,
		"python"=>5,
		"java"=>6,
		"ruby"=>7,
		"tcl"=>8,
		"bash"=>9,
		"other"=>10,
		);

my $total_prog={"error"=>0,
		"c"=>0,
		"cpp"=>0,
		"php"=>0,
		"perl"=>0,
		"python"=>0,
		"java"=>0,
		"ruby"=>0,
		"tcl"=>0,
		"bash"=>0,
		"other"=>0,
		};
while(<STDIN>)
{
	if(/\s*(\S*)\s*(\S*)/)
	{ 
		$static{$2}=$1."\n";
	}
} 
#去掉非代码文件的数量,为0.在代码小的情况下排除,HTML等造成的印象.
for $each (keys %static)
{
	if($each=~/\.o|\.xpm|\.ppm|\.ogg|\.pdf|\.tex|\.tif|\.am|\.man|\.xsl|\.xml|\.in|\.txt|\.sln|\.png|\.tif|\.html|\.jpg|\.gif|\.m4|\.po|\.gmo/)
	{	
	#	print $static{$each};
		$static{$each}=0;
	}
}

for $each (keys %static)
{
	$total=$total+$static{$each};
	$each=lc($each);
	if( $each=~/\.c$|\.h$/)
	{
	#	print "CC=>".$each;
		$total_c=$total_c+$static{$each};
		$total_prog{"c"}=$total_c
	}
	elsif ($each=~/\.cc|\.hpp|\.cpp|\.hh|\.cxx|\.hxx/)
	{
	#	print "CC=>".$each;
		$total_cpp=$total_cpp+$static{$each};
		$total_prog{"cpp"}=$total_cpp;
	}
	elsif ($each=~/\.py/)
	{
		$total_python=$total_python+$static{$each};
		$total_prog{"python"}=$total_python;
	
	}
	elsif ($each=~/\.php/)
	{
		$total_php=$total_php+$static{$each};
		$total_prog{"php"}=$total_php;
	
	}elsif ($each=~/\.java|\.jsp|\.jar/)
	{
		#print "DEBUG ".$each."-->".$static{$each};
		$total_java=$total_java+$static{$each};

		$total_prog{"java"}=$total_java;
	
	}elsif ($each=~/\.pl|\.pm|\.cgi/)
	{
		$total_perl=$total_perl+$static{$each};
		$total_prog{"perl"}=$total_perl;
	
	}elsif ($each=~/\.rb|\.ruby/)
	{
		$total_ruby=$total_ruby+$static{$each};
		$total_prog{"ruby"}=$total_ruby;
	
	}elsif ($each=~/\.tcl|\.tk/)
	{
		$total_tcl=$total_tcl+$static{$each};
		$total_prog{"tcl"}=$total_tcl;
	
	}elsif ($each=~/\.sh|\.shell/)
	{
		$total_bash=$total_bash+$static{$each};
		$total_prog{"bash"}=$total_bash;
	
	}



	else
	{	
	#	print "OTHER".$each."->".$static{$each};
		$total_other=$total_other+$static{$each};
	
		$total_prog{"other"}=$total_other;
	}	



}

#print $total."\n";
#print "c_cpp_pecent\t".int($total_c*100/$total)."\n";
#print "java_pecent\t".int($total_java*100/$total)."\n";
#print "php_pecent\t".int($total_php*100/$total)."\n";
#print "python_pecent\t".int($total_python*100/$total)."\n";
#print "perl_pecent\t".int($total_perl*100/$total)."\n";
#print "other_pecent\t".int($total_other*100/$total)."\n";
#print "+++++++++++++++++++++++++++++++++++++++++++++++++\n";
for $each (keys %total_prog)
{	
	if($max< $total_prog{$each})
	{
		$max=$total_prog{$each};
		$max_lang=$each;
	}
	#print $each."=>".$total_prog{$each}."\n";
	$total_prog{$each}=$total_prog{$each}*100/$total;	
	print "percent ".$each."   ".int($total_prog{$each})."\n";
#	if( $total_prog{$each}>=50)
#	{print $each;
#	 exit 0;
#	}
#	exit -1;
}

	print "RESULT=>".$max_lang."\n";
	exit $return_val{$max_lang};
	#exit 11;
