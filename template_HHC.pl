#!/usr/bin/perl 	 
use Template;

	 # some useful options (see below for full list)
	 my $config = {
	    INCLUDE_PATH => "/root/chm_mk_v2/template_hhc/",  # or list ref
	     INTERPOLATE  => 1,		      # expand "$var" in plain text
	     POST_CHOMP	  => 1,		      # cleanup whitespace
	  # PRE_PROCESS  => ’header’,	      # prefix each template
	     EVAL_PERL	  => 1,		      # evaluate Perl code blocks
	 };
	opendir(DIR,".") ;
	@tmp=readdir(DIR);
	close(DIR);


	@cur_files_array=grep { -f $_ && /html$/} @tmp;
	for($i=0;$i<scalar(@cur_files_array);$i++)
	{
		$cur_files[$i]{"name"}=$cur_files_array[$i];
		$cur_files[$i]{"title"}=get_title($cur_files_array[$i]);
	}

	@tmp_dir= grep { -d $_ && !/^\./} @tmp;

	@cur_dir;
	for $each (@tmp_dir)
	{
		#%tmp={};
		#$hash={};
		#%hash={};
		%file_title={};
		@find_tmp=`find $each -type f |grep html\$`;
		for $html (grep {$_==$_} @find_tmp)
		{
			chomp($html);
			$title=get_title($html);
		#%file_title=map{$_, get_title($_);} ; 
			#$file_title{$html}=$title;
			$hash{$each}{$html}=$title;
		}
		#$hash{$each}= \%file_title;
		#push(@cur_dir, $hash);
		
	}
	
	 my $template = Template->new();
	
	
	 # define template variables for replacement
	 my $vars = {
	     #files  => $files,
		cur_files=>\@cur_files, 
		hash=>\%hash,
	};

	my $input="HTML_HHC.tpl";

	 # process input template, substituting variables
	 $template->process($input, $vars)
	     || die $template->error();


sub get_title($)
{
	(my $in)=@_;
	open(FILE, $in) ||die("open $in error\n");
	while(<FILE>)
	{
		if(/<title>(.*)<\/title>/i)
		{
			close(FILE);
			return $1
		}
	}
	close(FILE);
	die(" $in have no title\n");
}
