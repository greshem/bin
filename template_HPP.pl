#!/usr/bin/perl 	 
use Template;

	 # some useful options (see below for full list)
	 my $config = {
	#     INCLUDE_PATH => ’/search/path’,  # or list ref
	    INCLUDE_PATH => "/root/chm_mk_v2/template_hhc/",  # or list ref
	     INTERPOLATE  => 1,		      # expand "$var" in plain text
	     POST_CHOMP	  => 1,		      # cleanup whitespace
	  # PRE_PROCESS  => ’header’,	      # prefix each template
	     EVAL_PERL	  => 1,		      # evaluate Perl code blocks
	 };
	@tmp=`find . |grep html\$`;
	@files=map{chomp; if (/html$/){s/^\.\///; s/\//\\/g;};$_} @tmp;
	 my $template = Template->new(\$config);

	 # define template variables for replacement
	 my $vars = {
	     files  => \@files,
	};

	my $input="HTML_HPP.tpl";

	 # process input template, substituting variables
	 $template->process($input, $vars)
	     || die $template->error();


