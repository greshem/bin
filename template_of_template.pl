#!/usr/bin/perl 
#根据 tpl_give_a_name  的目录自动生成   give_a_name 
#注意: 当前目录下有 tpl_开头的目录  并且里面 有.tpl 结尾的文件, 参看  develop_ddk 的目录.
#!/usr/bin/perl 
use Cwd;
my $g_pwd=getcwd();

my @tpls_dirs=grep{ -d $_}  glob("tpl_*");
#my $input_tpl_dir=shift (@tpls_dirs) or die("当前目录下 没有 tpl_* 目录");
for(@tpls_dirs)
{
	if(! -f $_.".pl")
	{
		deal_with_a_tpl_dir($g_pwd."/".$_)
	}
	else
	{
		#print "$_ 的脚本已经生成不在生成了\n";
		#deal_with_a_tpl_dir($_)
		deal_with_a_tpl_dir($g_pwd."/".$_)
	}
}

########################################################################
#输入的一定是绝对地址.
sub deal_with_a_tpl_dir($)
{
	
	(my $input_tpl_dir)=@_;
	if($input_tpl_dir!~/^\//)
	{
		die("输入的不是 绝对地址\n");
	}
	#(my $output_tpl_dir)= ($input_tpl_dir=~/tpl_(.*)/);
	use File::Basename;
	#print basename("/root/linux/bbb"); #结果是. bbb
	(my $output_tpl_dir)= dirname($input_tpl_dir)."/output/".basename($input_tpl_dir);
	my @tmps=glob($input_tpl_dir."/*.tpl");
	if(scalar(@tmps) eq 0)
	{
		warn($input_tpl_dir."目录没有 以 .tpl 结尾的文件\n");
	}


	$relative_input_tpl_dir= $input_tpl_dir;
	$relative_output_tpl_dir= $output_tpl_dir;
	$relative_input_tpl_dir=~s/$g_pwd\///g;
	$relative_output_tpl_dir=~s/$g_pwd\///g;

	open(OUTPUT, ">".$input_tpl_dir.".pl") or die("create $input_tpl_dir.pl 失败\n ");
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
#生成 App
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
	print $output_tpl_dir.".pl 已经生成\n";
}

########################################################################
#递归获取子目录下所有的tpl 文件.
sub  find_and_get_tpl_filelist($)
{

	(my $dir)=@_;
	logger("[find_and_get_tpl_filelis]: $dir 目录下获取所有的 tpl文件\n");
	#my @tpl_files=(); #bug our my 的区别需要注意了.
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
			$name=~s/^$dir//g; #去掉绝对路径.
			push(@tpl_files , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted_exe}, $dir);

	logger("$dir 目录下 一共获取获取 ".scalar(@tpl_files)."个tpl文件\n");
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

