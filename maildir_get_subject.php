<?php
#maildir 的获取 通过    getmail 的方式获取. 

function Decode_mime($Str){
		if( substr_count($Str,'=?')==0 ) return $Str;
		list($Token,$Charset,$Encoding,$Str,$End) = split('\?',$Str,5);
		$End = preg_replace("/^\=/","",$End);
		$Token = preg_replace("/\=/","",$Token);
		$Encoding = strtolower($Encoding);
		switch($Encoding){
			case 'b':
				$Text = trim(base64_decode($Str));
				break;
			case 'q':
				$Text = trim(quoted_printable_decode($Str));
		}
		if( substr_count($End,'=?')!=0 ) $End = Decode_mime($End);
		return $Token.$Text.$End;
	}
	
function get_subject($file)
{
    $file=fopen($file,"r") or  die("Error open $file!");
    if (! $file)  { die("error open file \n"); };  

    $ret;
    while( $line=fgets($file,1024))
    {
        if(preg_match("/^Subject/",$line))
        {
            $ret=$line;    
        }
    }
    return $ret;
}

$dir=$argv[1];
if(!is_dir($dir))
{
    die("input |$dir| is not maildir \n");
}
foreach (glob("$dir/*")   as $key=>$value)
{
    echo $value."\n";
    $subject=get_subject($value);
    print Decode_mime($subject);
}

?>
