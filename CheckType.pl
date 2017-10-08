#!/usr/bin/perl
$type=shift;
$input=shift;

$ret=CheckIp($input);
exit( $ret);


sub CheckIp()
{
	($in)=@_;
	@array=split(/\./, $in);
	if(scalar(@array) != 4)
	{
		return 1;	
	}
	for( $i=0; $i<=3; $i++)
	{
		if( $array[$i] < 0 || $array[$i] > 255 )
		{
			return 1;
		}
		if($array[$i] !~/\d+/)
		{
			return  1
		}

	}
	#print "IsIp\n";
	return 0;
}
