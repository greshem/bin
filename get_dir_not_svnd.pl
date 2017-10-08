#!/usr/bin/perl
$tag=shift;
for ( grep {-d } (glob("*")) )
{
	if (  -d $_."/.svn" ||  -d $_."/.git")
	{
		
		printf $_."\n" if( $tag);
	}
	else
	{
		printf $_."\n" if(! $tag);
	}
}
