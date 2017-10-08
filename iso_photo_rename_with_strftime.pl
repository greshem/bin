#File Modification Date/Time     : 2010:03:21 11:50:00+08:00
#File Access Date/Time           : 2014:11:17 10:35:53+08:00
#File Creation Date/Time         : 2014:11:17 10:35:53+08:00
#照相机的信息
#Date/Time Original              : 2010:03:21 11:50:18
#Create Date                     : 2010:03:21 11:50:18

sub get_photo_mdf_time($)
{
	(my $file)=@_;
	my $time=undef;
	open(FILE, $file) or die("open file error \n");
	for(<FILE>)
	{
		if($_=~/File Modification.*:.*(\d\d\d\d:..:..) ..:..:../  )
		{
			#print $1."\n";
			$time=$1;
		}
	}
	close(FILE);
	if($time=~/^\s.*$/)
	{
		logger("ERROR: $file 的modify时间 为空\n");
		return undef;
	}
	$time=~s/:/_/g;
	return $time;
}
sub get_photo_taked_time($)
{
	(my $file)=@_;
	my $time=undef;
	open(FILE, $file) or die("open file error \n");
	for(<FILE>)
	{
		if($_=~/Date\/Time Original.*:.*(\d\d\d\d:..:..) ..:..:../  )
		{
			#print $1."\n";
			$time=$1;
		}
	}
	close(FILE);
	if($time=~/^\s.*$/)
	{
		logger("ERROR: $file 的拍摄时间 为空\n");
		return undef;
	}
	$time=~s/:/_/g;
	return $time;
}

sub get_YYYY_mm_dd($)
{
	my %hash;
	(my $input_file)=@_;	
	open(FILE, $input_file) or die("open file error \n");
	for(<FILE>)
	{
		if($_=~/.*(\d\d\d\d:..:..).*/)
		{
			#print $1."\n";
			my $tmp=$1;
			$tmp=~s/:/_/g;
			$hash{$tmp}++;
		}
	}
	close(FILE);
	return keys(%hash);
}


#挂到了p盘 iso 有photo 名字  最后 照片未必会有 photo 的名字的  
sub get_exiftool_info($_)
{
	(my $input_file)=@_;	
	#print "get_exiftool_info  $input_file  \n";
	my @days;
	if($input_file=~/jpg$|png$|gif$|avi$|wma$|vob$|ifo$|bup$|amr$|mp4$|bmp$|thm$|wav$/i)
	#if($input_file=~/jpg$|png$|gif$|avi$|wma$|vob$|ifo$|bup$|amr$/i && $input_file=~/photo/i)
	{
		if(! -f  "$input_file".".exinfo.txt")
		{
			#my $file= "$input_file".".exinfo.txt";
			#open(FILE, ">$file")  or warn("open $file error \n");
			#close(FILE);

			print("exiftool \"$input_file\" >  \"$input_file\".exinfo.txt ");
			system("exiftool \"$input_file\" >  \"$input_file\".exinfo.txt ");
		}
		else
		{
			my $taked_time= get_photo_taked_time( "$input_file".".exinfo.txt");
			my $basename=basename($input_file);
			my $dirname=dirname($input_file);
			if($basename=~/^...._.._../)
			{
				encrypt_one_cpt_file($input_file);
				next;
			}
			

			use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);


			if(!defined($taked_time))
			{
				my $mdf_time=get_photo_mdf_time( "$input_file".".exinfo.txt");
				my $to_file=$dirname."/${mdf_time}_".$basename;
				if($mdf_time=~/^\s+$/)
				{
					logger("PANIC:  $input_file  mdf time is null \n");
				}
				logger("INFO: $input_file  重命名为  修改时间 mtime: $to_file     \n");
				if(!fmove($input_file, $to_file))
				{
					logger("ERROR:  fmove $input_file-> $to_file ");
				}
			}
			else
			{
				my $to_file=$dirname."/${taked_time}_".$basename;
				logger("INFO: $input_file  重命名为  拍摄时间:taked_time: $to_file  \n");
				if(!fmove($input_file, $to_file))
				{
					logger("ERROR:  fmove $input_file-> $to_file ");
				}
			}
			#el
			#{
			#	logger("ERROR: $input_file  重命名为  拍摄时间: $taked_time   \n");
			#}
			#print "$input_file -> $taked_time   已经处理了\n";
		}
		#print("exiftool $input_file > d:\\tmp\\all_exiftool3.txt\n");
		#system("exiftool \"$input_file\" > d:\\tmp\\all_exiftool4.txt ");
		#@days=get_YYYY_mm_dd("d:\\tmp\\all_exiftool4.txt");
	}	
	else
	{
		if(-f $input_file && $input_file!~/exinfo.txt$/)
		{	logger("FFFFF: $input_file  杂类文件 \n");
		}
	}

	$day_str=join("||||", @days);
	for(@days)
	{
		#save_filename_to_YYYY_mm_dd($input_file, $_);
		my $day=$_;
		print "mv $input_file $input_file_${day} \n";
	}
	
	return @days;
}

sub  iso_find_and_get_filelist()
{
	use File::Find ();

	use vars qw/*name *dir *prune/;
	*name   = *File::Find::name;
	*dir    = *File::Find::dir;
	*prune  = *File::Find::prune;

	sub wanted;
	sub wanted {
		my ($dev,$ino,$mode,$nlink,$uid,$gid);

		(($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
		if($name=~/\/\d\d\d\d_\d\d_\d\d/)
		{
			encrypt_one_cpt_file($name);
			next;
		}
		my @days=get_exiftool_info($name);
		
		$name=~s/\//\\\\/g;
		$name=~s/^P:\\\\/$g_iso_file\\/g;


		print("$name\n");

	}

	

	@g_paths=();
	File::Find::find({wanted => \&wanted}, $g_pwd );

	#exit;

}
use Cwd;
use File::Basename;

our $g_pwd=getcwd();

iso_find_and_get_filelist();


sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> c:\\log\\photo_split_all.log") or warn("open all.log error\n");
	print  $log_str;
	print FILE $log_str;
	close(FILE);
}


sub encrypt_one_cpt_file($)
{
	print "处理cpt file \n";
	(my $cpt_file)=@_;
	if( ! -f  "c:\\cygwin\\bin\\ccrypt.exe")
	{
		logger("ccrypt.exe 程序不存在, 需要安装 cygwin\n");
		die("ccrypt.exe 程序不存在, 需要安装 cygwin\n");
	}
	create_passwd_key();	
	if($cpt_file!~/cpt$/)
	{
		$cmd="c:\\cygwin\\bin\\ccrypt.exe -e -f  -k c:\\log\\key  \"$cpt_file\"";
		logger("解压最后执行的命令是: $cmd \n");
		system("$cmd");
	}
	else
	{
		logger("输入的 $cpt_file 的后缀名 是 cpt, skip \n");
	}
}
sub create_passwd_key()
{
	if( ! -d "c:\\log")
	{
		mkdir("c:\\log");
	}
	open(KEY, "> c:\\log\\key");
	print KEY "q**************n";
	close(KEY);
}




