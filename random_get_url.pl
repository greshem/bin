#!/usr/bin/perl
$file=shift; 
open(FILE, $file) or die("open file error\n");
@array=map{$_;} (<FILE>);
$count=scalar(@array);
if($count==1 || $count==2 || $count==3)
{
	#1
	print $array[0];
}
elsif ($count==4 || $count==5)
{
	#2
	print $array[0];
	print $array[$count-1];
}
elsif ($count>=6 && $count<=10)
{
	#3
	print $array[0];
	$mid=int($count/2);
	print $array[$mid];
	print $array[$count-1]
}
elsif($count > 10 && $count<=100)
{
	 #$number=($count/10);
	 #$step=int($count/10);
	#4
	$number=($count/4);
	for($i=0; $i<=$count; $i=$i+$number)
	{
		print $array[$i];
	}
}
elsif ($count > 100  && $count<=200)
{
	$number=($count/5);
	for($i=0; $i<=$count; $i=$i+$number)
	{
		print $array[$i];
	}
}
#6
elsif ($count >= 200  && $count<=500)
{
	$number=($count/6);
	for($i=0; $i<=$count; $i=$i+$number)
	{
		print $array[$i];
	}
}
#7
elsif ($count >500)
{
	$number=($count/7);
	for($i=0; $i<=$count; $i=$i+$number)
	{
		print $array[$i];
	}
}
