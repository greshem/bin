#!/usr/bin/php
<?php
	if(isset($argv[1]))
	{
		$file=$argv[1];
	}
	else if(isset($_GET['img']))
	{
		$file=$_GET['img'];
	}
	if (! isset($file))
	{
		die("Usage: ".$argv[0]." image.file\n");
	}
	
	$size=getimagesize($file);
	print_r($size);
?>
