#!/usr/bin/perl
#bug_30m: ע�ⲻ��  д��  
#	File::DosGlob::doglob(1,"c:\\Program Files\\*);
#my @m = File::DosGlob::doglob(1,'c:\\Program\ Files\\*');
#	�ڶ�����Ϊ���� ���ָ���˶��ģʽ.  ���� DosGlob.pm �����д��. 
#	����� ģʽ��Ϊһ������ ��ok�� 

use  File::DosGlob qw(doglob);

my $keyword=shift;
our @all_exe;

$pattern="c:\\Program Files\\*\\*.exe";
my @m = File::DosGlob::doglob(1,$pattern);
push(@all_exe, @m);

$pattern="c:\\Program Files\\*\\*\\*.exe";
my @m = File::DosGlob::doglob(1,$pattern);
push(@all_exe, @m);

$pattern="c:\\Program Files (x86)\\*\\*.exe";
my @m = File::DosGlob::doglob(1,$pattern);
push(@all_exe, @m);

$pattern="c:\\Program Files (x86)\\*\\*\\*.exe";
my @m = File::DosGlob::doglob(1,$pattern);
push(@all_exe, @m);



quotation_line($keyword, @all_exe);


#==========================================================================
our @all_dirs;
$pattern="c:\\Program Files (x86)\\*";
my @m = File::DosGlob::doglob(1,$pattern);
push(@all_dirs, @m);

$pattern="c:\\Program Files\\*";
my @m = File::DosGlob::doglob(1,$pattern);
push(@all_dirs, @m);
my @tmp=grep { -d } @all_dirs;

print "\n#ƥ��Ŀ¼����: \n";
quotation_line_dir($keyword, @tmp);

#==========================================================================
#print_array_with_
sub quotation_line($@)
{
	(my $keyword, my @lines )=@_;
	for $each (@lines)
	{
		chomp($each) unless($each=~/\n$/);
		print "\"$each\"\n" if($each=~/$keyword/i);
		#print "\"$each\"\n" ;
	}

}

sub quotation_line_dir($@)
{
	(my $keyword, my @lines  )=@_;
	for $each (@lines)
	{
		chomp($each) unless($each=~/\n$/);
		print "add_prog_bin_path_to_ENV_PATH.pl  \"$each\"\n" if($each=~/$keyword/i);
		print "ie.pl  \"$each\"\n" if($each=~/$keyword/i);
	}

}
