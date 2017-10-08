#!/usr/bin/perl
use strict;
my $each;
	
my %tmp;
for $each (grep {-d } glob("*"))
{
	#print $each."\n";

	
	my $decode_name= `echo $each | c++filt \n`;
	my $tmp_name=$decode_name;

	(my $function)= ($tmp_name=~/(.*)\(.*\).*/);
	
	if(!defined($function))
	{
		print "# $each, 不是 mangle 符号\n";
		next;
	}

	$function=  function_delete_spical_chars($function);

	
	if(! defined($tmp{$function}) )
	{
		$tmp{$function}=1 ;
		my $number=int(rand(1000));
		#print "cp -a -r  $each    $function \n";
		if( -d $function)
		{
			print "mv  $each    ${function}_${number} # BBB \n";
		}
		else
		{
			print "mv  $each    ${function} # BBB \n";
		}
	}
	else
	{
		$tmp{$function}++ ;

		my $number= $tmp{$function};
		print "mv  $each    ${function}_${number}\n";
	}
}

#***************************************************************************
# Description:  
# @param 	字符串
#				从c++filter 里面获取的 函数名 或者也是类名	
# @return 	
# @notice 	 
#		TTftpClient::InitClient(int arg1, int arg2 ing arg3 ) -> 
#				变成  TTftpClient__InitClient
#***************************************************************************/
sub function_delete_spical_chars($)
{
	(my $function)=@_;
	$function=~s/:/_/g;
	$function=~s/~/_de_/g;
	$function=~s/\!/_not_/g;
	$function=~s/ /_/g;
	$function=~s/\[/_/g;
	$function=~s/\]/_/g;
	$function=~s/\</_/g;
	$function=~s/\>/_/g;
	$function=~s/\*/_/g;
	$function=~s/\+/_/g;
	$function=~s/\=/_/g;

	return $function;	
}
