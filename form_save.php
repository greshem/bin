<?
	$tmp;
	foreach ($_POST as $key=>$value)
	{
		echo $key."==>".$value."<br>";
		
		$tmp.=$key."\t";
		$tmp.=$value."\n";
	}	
	$tmp.="############################\n";
	file_put_contents("feed_back.txt", $tmp,  FILE_APPEND);
?>
