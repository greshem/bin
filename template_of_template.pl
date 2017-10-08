#!/usr/bin/perl 
#���� tpl_give_a_name  ��Ŀ¼�Զ�����   give_a_name 
#ע��: ��ǰĿ¼���� tpl_��ͷ��Ŀ¼  �������� ��.tpl ��β���ļ�, �ο�  develop_ddk ��Ŀ¼.
#!/usr/bin/perl 
use Cwd;
my $g_pwd=getcwd();

my @tpls_dirs=grep{ -d $_}  glob("tpl_*");
#my $input_tpl_dir=shift (@tpls_dirs) or die("��ǰĿ¼�� û�� tpl_* Ŀ¼");
for(@tpls_dirs)
{
	if(! -f $_.".pl")
	{
		deal_with_a_tpl_dir($g_pwd."/".$_)
	}
	else
	{
		#print "$_ �Ľű��Ѿ����ɲ���������\n";
		#deal_with_a_tpl_dir($_)
		deal_with_a_tpl_dir($g_pwd."/".$_)
	}
}

########################################################################
#�����һ���Ǿ��Ե�ַ.
sub deal_with_a_tpl_dir($)
{
	
	(my $input_tpl_dir)=@_;
	if($input_tpl_dir!~/^\//)
	{
		die("����Ĳ��� ���Ե�ַ\n");
	}
	#(my $output_tpl_dir)= ($input_tpl_dir=~/tpl_(.*)/);
	use File::Basename;
	#print basename("/root/linux/bbb"); #�����. bbb
	(my $output_tpl_dir)= dirname($input_tpl_dir)."/output/".basename($input_tpl_dir);
	my @tmps=glob($input_tpl_dir."/*.tpl");
	if(scalar(@tmps) eq 0)
	{
		warn($input_tpl_dir."Ŀ¼û�� �� .tpl ��β���ļ�\n");
	}


	$relative_input_tpl_dir= $input_tpl_dir;
	$relative_output_tpl_dir= $output_tpl_dir;
	$relative_input_tpl_dir=~s/$g_pwd\///g;
	$relative_output_tpl_dir=~s/$g_pwd\///g;

	open(OUTPUT, ">".$input_tpl_dir.".pl") or die("create $input_tpl_dir.pl ʧ��\n ");
print OUTPUT  <<EOF
#!/usr/bin/perl
use Template;

my \$config = {
INTERPOLATE  => 1,		      # expand "\$var" in plain text
POST_CHOMP	  => 1,		      # cleanup whitespace
EVAL_PERL	  => 1,		      # evaluate Perl code blocks
};

my \$template = Template->new();
\$Name=shift  or die("Usage: \$0 Name\\n");
#\$Name="Netware";


\$tpl_input_dir="$relative_input_tpl_dir";
\$tpl_output_dir="$relative_output_tpl_dir"."_".\$Name;

if ( ! -d   \$tpl_output_dir)
{
	mkdir(\$tpl_output_dir);
}

########################################################################
#���� App
my \$vars = {
Name => \$Name,
members=> \@array,
};
#\$template->process(\$tpl_input_dir."/MyApp.tpl", \$vars, "src_gen_frame/MyApp.cpp") || die \$template->error();


EOF
;

	my $g_reversive=1;
	my @tmps;
	if( $g_reversive)
	{
		@tmps=find_and_get_tpl_filelist($input_tpl_dir);
	}
	else
	{
		#@tmps=glob($input_tpl_dir."/*.tpl");
	}
	for(@tmps)
	{
		my $output_cpp=$_;
		my $full_path=$_;

		$output_cpp=~s/\.tpl//g;
		$output_cpp=~s/$input_tpl_dir//g;
		$full_path =~s/$input_tpl_dir//g;

	print OUTPUT  <<EOF
\$template->process(\$tpl_input_dir."$full_path", \$vars, "\$tpl_output_dir/$output_cpp") || die \$template->error();
EOF
;
}

	close(OUTPUT);
	print $output_tpl_dir.".pl �Ѿ�����\n";
}

########################################################################
#�ݹ��ȡ��Ŀ¼�����е�tpl �ļ�.
sub  find_and_get_tpl_filelist($)
{

	(my $dir)=@_;
	logger("[find_and_get_tpl_filelis]: $dir Ŀ¼�»�ȡ���е� tpl�ļ�\n");
	#my @tpl_files=(); #bug our my ��������Ҫע����.
	our @tpl_files=();

	use File::Find ();

	use vars qw/*name *dir *prune/;
	*name   = *File::Find::name;
	*dir    = *File::Find::dir;
	*prune  = *File::Find::prune;

	sub wanted_exe;
	sub wanted_exe 
	{
		my ($dev,$ino,$mode,$nlink,$uid,$gid);

		(($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
		#$name=~s/\//\\\\/g;
		#print("$name\n");
		if($name=~/tpl$/i && -f $name )
		{
			$name=~s/^$dir//g; #ȥ������·��.
			push(@tpl_files , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted_exe}, $dir);

	logger("$dir Ŀ¼�� һ����ȡ��ȡ ".scalar(@tpl_files)."��tpl�ļ�\n");
	return @tpl_files;
}

sub logger($)
{
	(my $log_str)=@_;
	#open(FILE, ">>/var/log/template_of_template.log") or warn("open all.log error\n");
	open(FILE, ">>all.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

