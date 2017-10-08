#!/usr/bin/perl
sub sed_file($$$)
{
	(my $input_file, $from_pattern, $to_pattern)=@_;;
	if(! open(INPUT,  $input_file) )
	{
		warn("open input $input_file error. $!\n");
		return ;
	}
	my $output=$input_file.".sed_output";
	if(! open(OUTPUT, ">".$output ))
	{
		warn("create output $output error $!\n");
		return ;
	}
	for(<INPUT>)
	{
		my $line=$_;
		$line=~s/$from_pattern/$to_pattern/g;
		print OUTPUT  $line;
	}
	close(INPUT);
	close(OUTPUT);
}

my $input=shift 	or die("usage: $0 input_file  pattern  output_dest_string \n");
my $pattern=shift 	or die("usage: $0 input_file  pattern  output_dest_string \n");
my $dest_str=shift  or die("usage: $0 input_file  pattern  output_dest_string \n");

#sed_file("/etc/passwd", "root", "q**************nzhongjie");
sed_file($input, $pattern,  $dest_str);
rename("$input.sed_output", $input);

