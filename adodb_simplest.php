<?
//#2010_08_21_19:35:09 add by qzj
if(is_dir("/var/www/html/adodb5"))
{
	include_once '/var/www/html/adodb5/adodb-errorpear.inc.php';
	include_once '/var/www/html/adodb5/adodb.inc.php';
	include_once '/var/www/html/adodb5/tohtml.inc.php';
}
else
{

	if(is_dir( "/usr/share/php/adodb"))
	{
		include_once("/usr/share/php/adodb/adodb.inc.php");
	}
	else
	{
		die(" php-adodb no install \n 
				yum install php-adodb \n");
	}

}
$db = ADONewConnection("mysql");
$db->Connect("localhost", "root", "q******************************n", "pommo") or die("connect error");
#echo "<p><b>DBServer: $_POST[dbserver]</b></p>";
$result = $db->Execute("SELECT email FROM pommo_subscribers ");
if (!is_object($result)) 
{
	$e = ADODB_Pear_Error();
	echo '<p><b>'.htmlspecialchars($e->message).'</b></p>';
} 
else 
{
	while (!$result->EOF) 
	{
		for ($i = 0, $max = $result->FieldCount(); $i < $max; $i++) 
		{
			echo htmlspecialchars($result->fields[$i])." \n";;
			$result->MoveNext();
		}
	}
}
#else 
#{
#	print_r($TEXT['ADOdb-notdbserver']);
#}


?>
