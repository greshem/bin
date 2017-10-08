sub repaire_to_win_path($)
{
	(my $input)=@_;
	if($input=~/(^\"|\"$|^\'|\'$_)/  ) 
	{
		warn("windows 下cmd 没有对 命令行输入的 \" 进行处理  注意,导致文件不能找到, 这个去除一下\n");
		$input=~s/(^\"|\"$|^\'|\'$)//g;
		print "Input: 变为 $input\n";
	}

	if($input=~/\\\\/  ) 
	{
		warn("windows 下的路径 输入的不能有两个\/ \n");
		$input=~s/\\\\/\\/g;
		print "Input: 变为 $input\n";
	}
	if($input=~/\//) 
	{
		$input=~s/\//\\/g;
	}
	if($^O=~/linux/)
	{
		$input=~s/\\/\\\\/g;	
		$input=~s/^/\"/;
		$input=~s/$/\"/;
	}
	return $input;
}
if($0=~/repaire_perl_path_2_win32.pl/)
{
	$path=shift or die("Usage; $0 input_path \n");
	print repaire_to_win_path($path);
}

