sub repaire_to_win_path($)
{
	(my $input)=@_;
	if($input=~/(^\"|\"$|^\'|\'$_)/  ) 
	{
		warn("windows ��cmd û�ж� ����������� \" ���д���  ע��,�����ļ������ҵ�, ���ȥ��һ��\n");
		$input=~s/(^\"|\"$|^\'|\'$)//g;
		print "Input: ��Ϊ $input\n";
	}

	if($input=~/\\\\/  ) 
	{
		warn("windows �µ�·�� ����Ĳ���������\/ \n");
		$input=~s/\\\\/\\/g;
		print "Input: ��Ϊ $input\n";
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

