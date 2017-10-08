#!/usr/bin/perl
use strict;
my $file=shift;

if(defined($file))
{
	indent_file($file);
}
else
{
	foreach(glob("*.h"))
	{
		print "# deal with $_\n";
		indent_file($_);
	}
}

sub indent_file($)
{
	(my $file)=@_;
	print "indent  --line-length200  --case-indentation0   --blank-lines-after-commas  --blank-lines-after-declarations     --blank-lines-after-procedures    --blank-lines-before-block-comments    --declaration-indentation16  --braces-after-if-line        --brace-indent4   --case-brace-indentation0  --indent-level4  --dont-break-function-decl-args     --comment-indentation4  --struct-brace-indentation4  --braces-after-if-line			   	 --braces-after-func-def-line		    --line-comments-indentation4  --no-space-after-for --no-space-after-function-call-names --no-space-after-if --no-space-after-while --no-space-after-parentheses --space-special-semicolon          --braces-on-struct-decl-line --comment-delimiters-on-blank-lines   --start-left-side-of-comments  $file \n";
}
__DATA__
########################################################################

--blank-lines-after-commas			    -bc
--blank-lines-after-declarations		    -bad
--blank-lines-after-procedures		    -bap
--blank-lines-before-block-comments		    -bbb
--braces-after-if-line			    -bl
--braces-after-func-def-line		    -blf
--brace-indent				    -bli -bli0
#--braces-after-struct-decl-line		    -bls
#--braces-on-if-line				    -br
#--braces-on-func-def-line			    -brf
--braces-on-struct-decl-line		    -brs
#--break-after-boolean-operator		    -nbbo
#--break-before-boolean-operator		    -bbo
#--break-function-decl-args			    -bfda
#--break-function-decl-args-end		    -bfde
--case-indentation				    -clin -cli0
--case-brace-indentation			    -cbin -cbi0
--comment-delimiters-on-blank-lines		    -cdb
--comment-indentation			    -cn	-c0
--continuation-indentation			    -cin -ci0
--continue-at-parentheses			    -lp
#--cuddle-do-while				    -cdw
#--cuddle-else				    -ce
--declaration-comment-column		    -cdn
--declaration-indentation			    -din
--dont-break-function-decl-args		    -nbfda
#--dont-break-function-decl-args-end		    -nbfde
--dont-break-procedure-type			    -npsl
--dont-cuddle-do-while			    -ncdw
--dont-cuddle-else				    -nce
--dont-format-comments			    -nfca
--dont-format-first-column-comments		    -nfc1
--dont-line-up-parentheses			    -nlp
--dont-left-justify-declarations		    -ndj
#--dont-space-special-semicolon		    -nss
#--dont-star-comments			    -nsc
--else-endif-column				    -cpn
--format-all-comments			    -fca
--format-first-column-comments		    -fc1
#--gnu-style					    -gnu
--honour-newlines				    -hnl
--ignore-newlines				    -nhnl
--ignore-profile				    -npro
--indent-label				    -iln
--indent-level				    -in
#--k-and-r-style				    -kr
--leave-optional-blank-lines		    -nsob
--leave-preprocessor-space			    -lps
--left-justify-declarations			    -dj
--line-comments-indentation			    -dn
--line-length200				    -ln
#--linux-style				    -linux
#--no-blank-lines-after-commas		    -nbc
#--no-blank-lines-after-declarations		    -nbad
#--no-blank-lines-after-procedures		    -nbap
#--no-blank-lines-before-block-comments	    -nbbb
#--no-comment-delimiters-on-blank-lines	    -ncdb
--no-space-after-casts			    -ncs
--no-parameter-indentation			    -nip
--no-space-after-for		    -nsaf
--no-space-after-function-call-names	    -npcs
--no-space-after-if		       -nsai
--no-space-after-parentheses		    -nprs
--no-space-after-while		    -nsaw
--no-tabs					    -nut
--no-verbosity				    -nv
#--original					    -orig
--parameter-indentation			    -ipn
--paren-indentation				    -pin
--preserve-mtime		       -pmt
--preprocessor-indentation			    -ppin
--procnames-start-lines			    -psl
--remove-preprocessor-space			    -nlps
#--space-after-cast				    -cs
#--space-after-for		       -saf
#--space-after-if		       -sai
#--space-after-parentheses			    -prs
#--space-after-procedure-calls		    -pcs
#--space-after-while		       -saw
--space-special-semicolon			    -ss
--standard-output				    -st
--start-left-side-of-comments		    -sc
--struct-brace-indentation			    -sbin
--swallow-optional-blank-lines		    -sob
--tab-size					    -tsn -ts4
#--use-tabs					    -ut
#--verbose					    -v

