#!/usr/bin/perl

sub dump_to_cpp_cout($)
{
	(my $file)=@_;
	open(FILE, $file) or die("open file $file error, $!\n");
	for(<FILE>)
	{
		chomp;
	print <<EOF
	cout <<"$_="<<in.$_<<"|";
EOF
;
	}
}

sub dump_to_c_printf($)
{
	(my $file)=@_;
	open(FILE, $file) or die("open file $file error, $!\n");
	for(<FILE>)
	{
		chomp;
	print <<EOF
	printf("$_=%d|",  in.$_);
EOF
;
	}

}

sub dump_perl_testunit($)
{
	(my $file)=@_;
	open(FILE, $file)or die("open file $file error, $!\n");
	for(<FILE>)
	{
		chomp;
	print <<EOF
ok( ( substr(\$a, $_, 1) eq  "$_") , "test");
EOF
;
	}

}

#dump_to_c_printf("/tmp/tmp");
dump_perl_testunit("/tmp/tmp");

