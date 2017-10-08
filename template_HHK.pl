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
	@tmp=`find . |grep html\$`;
	@files_list=map{chomp; if (/html$/){s/^\.\///; };$_} @tmp;
	 my $template = Template->new(\$config);
	$files=[];
	
	for $each (@files_list)
	{
		$title=get_title($each);
		
		push(@$files, {title=>$title, name=>$each});
	}
	
	 # define template variables for replacement
	 my $vars = {
	     files  => $files,
	};

	my $input="HTML_HHK.tpl";

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
	die(" $_ have no title\n");
}
