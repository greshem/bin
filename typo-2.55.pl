#!/usr/bin/perl
###############################################################################
#
# The information contained in this document represents the 
# current view of Microsoft Corporation on the issues discussed as of the date 
# of publication. Because Microsoft must respond to changing market conditions, 
# it should not be interpreted to be a commitment on the part of Microsoft, 
# and Microsoft cannot guarantee the accuracy of any information presented. 
# This document is for informational purposes only.  
# 
# MICROSOFT MAKE NO WARRANTIES, EXPRESS OR IMPLIED, IN THIS DOCUMENT.
# 
# Microsoft Corporation may have patents or pending patent applications, 
# trademarks, copyrights, or other intellectual property rights covering 
# subject matter in this document. The furnishing of this document does not
# give you any license to these patents, trademarks, copyrights, or
# other intellectual property rights.
# 
# Microsoft does not make any representation or warranty regarding
# specifications in this document or any product or item developed based on 
# these specifications. Microsoft disclaims all express and implied warranties,
# including but not limited to the implied warranties of merchantability, 
# fitness for a particular purpose, and freedom from infringement. 
# Without limiting the generality of the foregoing,  Microsoft shall not be
# liable for any damages arising out of or in connection with the use of these
# specifications, including liability for lost profit, business interruption, 
# or any other damages whatsoever. 
# 
# Copyright (C) 1996-2001 Microsoft Corporation. All rights reserved.
#
# First release to public Aug 24 1999
#
###############################################################################

require 5.001;

# Forward declarations
sub clear_function;
sub clear_new_function;
sub add_to_function_list;
sub parse_options;
sub Usage;
sub init_function_list;
sub init_type_hash;
sub delete_unchecked_var;
sub commify_number;
sub case28;
sub case29;
sub valid_registry_return_values;
sub case57;
sub parse_vars;
sub add_vars;
sub scan_expression;
sub scan_statement;
sub clear_statement;
sub update_statement;
sub find_function;
sub check_expression;
sub print_file_kloc;
sub filter_constants;
sub extract_strings_from_mc;
sub check_function_params;
sub load_files_from_build_db;
sub find_and_load_build_db;
sub display_function_typo;
sub display_function_typo_normal;
sub display_typo;
sub display_typo_normal;
sub display_typo_xml;

# Constants
$CASE_MIN			= 1;
$CASE_MOST			= 62;

$INVALID_HANDLE		= 1;
$CHECK_FUNCTION		= 2;
$OVERFLOW_FUNCTION	= 4;
$HANDLE_FUNCTION	= 8;
$FILLMEM_FUNCTION	= 16;
$MEMCRT_FUNCTION	= 32;
$ALLOCA_FUNCTION	= 64;
$LOCALREALLOC_FUNCTION	= 128;
$GLOBALREALLOC_FUNCTION	= 256;
$REALLOC_FUNCTION	= 512;
$HEAPREALLOC_FUNCTION	= 1024;
$HFILE_FUNCTION		= 2048;
$THROW_FUNCTION		= 4096;
$VOID_FUNCTION		= 8192;
$HRESULT_FUNCTION	= 16384;
$SAFEASSERT_FUNCTION	= 32768;
$LENGTH_FUNCTION	= 65536;
$DISALLOW_FUNCTION	= 131072;
$RPC_FUNCTION		= 262144;
$BUFFER_CHARS_FUNCTION	= 524288;
$REG_FUNCTION		= 1048576;
$EXALLOCATE_FUNCTION	= 2097152;

$OP_ADD				= 0;
$OP_INVERT			= 1;

$SCRIPT_VERSION		= "2.55";
$TYPO_VERSION		= "TYPO.PL Version $SCRIPT_VERSION Aug 27 2001 by Johnny Lee (typo_pl\@hotmail.com)",


$IH_FUNC_RESULT		= 'INVALID_HANDLE_VALUE | ' .
					  '\(HANDLE\)-1 | \(HANDLE\)\(-1\) | ' .
					  '\(HANDLE\)~0 | INVALID_SOCKET | -1';


$DIR_CMD			= "dir /S /B /ON";

# Cutoff
$EXPRESSION_LIMIT	= 2048;

$KEYWORD_NEW		= 1;
$KEYWORD_DELETE		= 2;
$KEYWORD_IF			= 4;
$KEYWORD_ELSE		= 8;
$KEYWORD_CASE		= 16;
$KEYWORD_TRY		= 32;
$KEYWORD_FOR		= 64;
$KEYWORD_WHILE		= 128;
$KEYWORD_DEFAULT	= 256;
$KEYWORD_RETURN		= 512;
$KEYWORD_BREAK		= 1024;
$KEYWORD_SWITCH		= 2048;
$KEYWORD_CONTINUE	= 4096;
$KEYWORD_GOTO		= 8192;

$PP_IF				= 1;
$PP_ELSE			= 2;
$PP_END				= 3;
$PP_KEYWORD			= 4;
$PP_DEFINE			= 5;

$VAR_UNUSED			= 0;
$VAR_UNCHECKED		= -1;
$VAR_USED			= 1;

$STRINGS_NONE		= 0;
$STRINGS_MC			= 1;
$STRINGS_CODE		= 2;
$STRINGS_RSRC		= 4;
$STRINGS_STRIP		= 8;
$STRINGS_MASK		= 15;

$KLOC_NONE			= 0;
$KLOC_OLD			= 1;
$KLOC_NEW			= 2;
$KLOC_MAX			= 3;

#
# init enable array - determines which cases to report
# Need to start at 0 since arrays start at 0
# but we only use elements 1+
#
@enable_main		= (0 .. $CASE_MOST);
@enable				= ();

$show_time			= 0;
$show_stats			= 0;
$newer_seconds		= 0;
$show_progress		= 0;
$show_kloc			= 0;
$kernel_code		= 0;
$output_xml			= 0;
@option_dirs		= ();

#
# Handle case 1 exceptions of the form:
#	if (XXX);
#	else DoRealWork();
#
# i.e. don't print out the typo right away, wait until 
#      we see what's after the semicolon.
#

%typo1				= ();

%checked_list		= ();
%noderef_list		= ();
%endcase_list		= ();
%constant_list		= ();
%ignore_result_list	= ();
$checked_list_count	= 0;
$noderef_list_count	= 0;
$endcase_list_count	= 0;
$ignore_result_list_count	= 0;

@unchecked_vars		= ();
@braces				= ();
$brace_level		= 0;

$no_typo			= 0;
$option_files		= 0;

%temp_defined_list	= ();

%function_call = (
	NAME	=> '',
	LINE	=> 0,
	BEFORE	=> '',
	PARAMS	=> '',
	PARENS	=> 0,
);

%function_list		= ();
%type_hash			= ();

%string_list		= ();
$disallowed_strings	= '';

$statement			= '';
$statement_line		= 0;

%user_define_hash	= ();
%evaluated_def_expression = ();
@preprocess			= ();

push(@preprocess, 1);
$do_ifdef			= 0;
$ifdef_verbose	= 0;

$log_functions	= 0;
@func_output_str= ();

$do_strings		= $STRINGS_NONE;
%ignore_strings	= ();

$use_build_dat	= 0;
%build_files_hash	= ();
$debug_build_dat= 0;

$open_cmd		= '';

#
%typo_description = (

	1  => "if (XXX);",
	2  => "X==Y;",
	3  => "if (X=0);",
	4  => 'Assert(X=Y);',
	5  => "*XXX++;",
	6  => "&& #;",
	7  => "|| #;",
	8  => "& XXX == ;",
	"8a" => "== XXX & ;",
	9  => "->Release;",

	10 => "\\<SP><EOL>",
	11 => "<< XXX + ;",
	"11a"=> "\% XXX + ;",
	12 => "for(uninit);",
	13 => "Microsoft misspelled",
	14 => 'memset(ptr, bytes, 0);',
	15 => 'FillMemory(ptr, 0, bytes);',
	16 => 'Realloc w/o MOVEABLE;',
	17 => 'realloc overwrite src if NULL;',
	18 => 'LocalReAlloc Flags wrong place;',
	"18a"=> 'GlobalReAlloc Flags wrong place;',
	"18b"=> 'wrong HeapReAlloc Flags;',
	19 => "Case w/o Break or Return",

	20 => "if (CreateFile == NULL)",
	21 => "cast of 32-bit number;",
	22 => "possible mistype of 32-bit number;",
	25 => "if (alloca == NULL)",
	26 => 'alloca not in try/except', 
	28 => "if ((X!=0) || (X!=1))",
	29 => "if ((X==0) && (X==1))",

	31 => 'use of func that can overflow;',
	32 => "No assignment of fn result",
	33 => "using ! on a number",
	37 => "using ^ on a number",

	43 => "XX;;",
	44 => 'strlen(X+1)',
	45 => "boolVal = TRUE;",
	47 => "if (!X & Y)",
	49 => "if (X[0] == '0')",

	50 => 'disallowed', 
	51 => "disallowd string",
	52 => 'filling object with zeros',
	53 => "X | Y == 0;",
	54 => "not Multimon-safe",
	55 => "sizeof(this)",
	56 => 'incorrect count of chars',
	58 => "using NULL DACL for SetSecurityDescriptorDacl",
	59 => "extraneous test for non-NULL ptr",

	60 => "extremely long expression",
	61 => "SendMessage(HWND_BROADCAST,...) can deadlock",
	62 => "ExAllocatePool(NonPagedPoolMustSucceed,...) can bugcheck",
	);

#
# Init hash for functions we care about
#

init_function_list();
init_type_hash();

# Init keyword hash

%keyword_list = (
		"new"	=> $KEYWORD_NEW,
		"if"	=> $KEYWORD_IF,
		"else"	=> $KEYWORD_ELSE,
		"case"	=> $KEYWORD_CASE,
		"try"	=> $KEYWORD_TRY,
		"__try"	=> $KEYWORD_TRY,
		"TRY"	=> $KEYWORD_TRY,
		"for"	=> $KEYWORD_FOR,
		"while"	=> $KEYWORD_WHILE,
		"default"=> $KEYWORD_DEFAULT,
		"return"	=> $KEYWORD_RETURN,
		"break"	=> $KEYWORD_BREAK,
		"switch"	=> $KEYWORD_SWITCH,
		"continue"=> $KEYWORD_CONTINUE,
		"goto"	=> $KEYWORD_GOTO,
	);

%preprocessor_list = (
	"define"	=> $PP_DEFINE,
	"elif"		=> $PP_ELSE,
	"else"		=> $PP_ELSE,
	"endif"		=> $PP_END,
	"error"		=> $PP_KEYWORD,
	"if"		=> $PP_IF,
	"ifdef"		=> $PP_IF,
	"ifndef"	=> $PP_IF,
	"import"	=> $PP_KEYWORD,
	"include"	=> $PP_KEYWORD,
	"line"		=> $PP_KEYWORD,
	"pragma"	=> $PP_KEYWORD,
	"undef"		=> $PP_KEYWORD,
);

# If we have any options, try and parse them
if ($#ARGV >= 0)
{
	$arg_index = parse_options(@ARGV);
}

if (($do_strings & $STRINGS_MASK) == $STRINGS_STRIP)
{
	die "Invalid extract_strings options\n";
}

# Get the disallowed strings
{
	my $str;

	foreach $str (keys(%string_list))
	{
		# Check to see if strings have been reallowed
		if ($string_list{$str} == 0)
		{
			delete($string_list{$str});
		}
	}

	if (scalar(keys(%string_list)) > 0)
	{
		$disallowed_strings = join("|",  keys(%string_list));
	}

	# Optimization: If we don't have any disallowed strings then
	# looking for any is wasted effort.
	if ($disallowed_strings eq '')
	{
		$enable_main[51] = 0;
	}

	undef %string_list;
}

if (($KLOC_NONE != $show_kloc) || ($STRINGS_NONE != $do_strings))
{
	# Disable all the typo tests
	foreach (@enable_main)
	{
		$_ = 0;
	}
}

#
# What files do we scan?
#

# No file specified, so scan all text files
if ($#ARGV < $arg_index)
{
	# Get a list of all the files in the current directory and all subdirs
	$open_cmd = "$DIR_CMD . |";
}
# More than one file specified, error
elsif ($#ARGV > $arg_index)
{
	$arg_index += 1;
	$error = "Too many options '$ARGV[$arg_index]'";

	Usage($error);
}
# Grab the list of files to scan from STDIN
elsif ($ARGV[$arg_index] eq "-")
{
	# Use list of files passed in thru stdin
	# i.e. "dir /B | perl typo.pl -" or "dir /S /B | perl typo.pl -"
	$open_cmd = "-";
}
# Scan files that have typical C/C++ source file extensions
elsif ($ARGV[$arg_index] eq "c")
{
	$open_cmd = "$DIR_CMD";

	# Get a list of all the files in the current directory and all subdirs
	# with C/C++ source code file extensions
	if ($STRINGS_CODE & $do_strings)
	{
		$open_cmd .= " *.c *.cxx *.cpp *.h *.hxx *.hpp *.inl";
	}
	if ($STRINGS_RSRC & $do_strings)
	{
		$open_cmd .= " *.rc *.rcv *.dlg";
	}
	if ($STRINGS_MC & $do_strings)
	{
		$open_cmd .= " *.mc";
	}
	elsif ($do_strings == $STRINGS_NONE)
	{
		$open_cmd .= " *.c *.cxx *.cpp *.h *.hxx *.hpp *.inl *.rc";
	}
	
	$open_cmd .= " |";
}
# scan the specified file
elsif (-T $ARGV[$arg_index])
{
	# Examine file passed on cmdline if it is a textfile
	$open_cmd = "echo $ARGV[$arg_index] |";
}
else
{
	$arg_index += 1;
	$error = "Bad option" . (($#ARGV == 0) ? "" : "s") . " (@ARGV) " .
			 "Bad arg # $arg_index";

	Usage($error);
}

open(FIND, $open_cmd) || die "Couldn't open file(s)!\n";

print STDERR " $TYPO_VERSION\n";
print STDERR " Copyright (C) 1996-2001 Microsoft Corporation. All rights reserved.\n";
if (0 == $option_files)
{
	print STDERR "\n *** WARNING: ***********************************************\n";
	print STDERR " *** WARNING: No option files were specified as parameters.\n";
	print STDERR " *** WARNING: This reduces the effectiveness of typo.pl.\n";
	print STDERR " *** WARNING: ***********************************************\n\n\n";
}

if ($show_time)
{
	if (0 == $output_xml)
	{
		print "// Perl version: $]\n";
		print "// $TYPO_VERSION\n";
		print "// OPTIONS: '@ARGV'\n";
	}

	$now = localtime;

	if (0 == $output_xml)
	{
		print "// START: $now\n";
	}
}

%found_function = ();
%vars			= ();
%define_hash	= ();
$var_count		= 0;
%vars_sizeof	= ();

@enable			= @enable_main;
@lines			= ();
$line_current	= 0;
$file_lines		= 0;
$filename		= '';
$current_function = '';
$current_function_line = 0;

$try			= '';
$try_body		= '';
$try_line		= 0;
$try_unbalanced_parens = 0;

$temp_pack		= '';
$temp			= '';

%stats =
(
	ASSERTS => 0,
	CHARS	=> 0,
	CODE	=> 0,
	COMMENTS=> 0,
	COMMENT_LINES => 0,
	FILES	=> 0,
	FUNCTIONS => 0,
	LINES	=> 0,
	SEMICOLONS => 0,
	TYPOS	=> 0,
);

%stats_prev =
(
	ASSERTS => 0,
	CHARS	=> 0,
	CODE	=> 0,
	COMMENTS=> 0,
	COMMENT_LINES => 0,
	FUNCTIONS => 0,
	LINES	=> 0,
	SEMICOLONS => 0,
	TYPOS	=> 0,
);


if ($show_kloc == $KLOC_OLD)
{
	print "                                         Comment                 LOC/semi\n";
	print "Component Name   Lines    Code  Comments   Ratio Asserts   Semis    Ratio\n";
}
elsif ($show_kloc == $KLOC_NEW)
{
	print "                                                                 LOC/semi\n";
	print "Component Name   Lines   Funcs    Code  Comments Asserts   Semis    Ratio\n";
}

FILE:
while ($filename = <FIND>) 
{
	# Remove the newline from the end of the filename
	chomp($filename);

	# Should we ignore this file?
	if ($ignore_files && ($filename =~ /$ignore_files/io))
	{
		# Yes.
		next FILE;
	}

	if ($newer_seconds)
	{
		# Get the modification time for the file
		my $mtime = (stat($filename))[9];

		# If file is older than what we want, skip it
		next FILE if ($mtime <= $newer_seconds);
	}

	if ($use_build_dat)
	{
		my $file = $filename;

		$file =~ tr/A-Z/a-z/;
		if (!exists($build_files_hash{$file}))
		{
			next FILE;
		}
	}

	# If the file isn't a text file, skip
	next FILE unless -T $filename;

	# open the file
	if (!open(TEXTFILE, $filename))
	{
		my $wait;

		$wait = 10;
WAIT:
		# Wait around to see if we can access the file
		while ($wait <= 1000)
		{
			print STDERR "Can't open $filename -- sleeping $wait seconds...\n";

			sleep($wait);

			# Try opening the file again
			if (!open(TEXTFILE, $filename))
			{
				$wait += 5;
			}
			else
			{
				print STDERR "Opened $filename\n";

				$wait = 0;
				last WAIT;
			}
		}

		# Give up and go on to the next one
		if ($wait)
		{
			print STDERR "Can't open $filename -- continuing...\n";

			next FILE;
		}
	}

	# Read in all the lines
	@lines = <TEXTFILE>;

	# Close file ASAP
	close(TEXTFILE);

	if ($show_progress)
	{
		print STDERR "Processing $filename...\n";
	}

	# contents of previous line
	my $prev		= '';
	my $prev_pack	= '';
	my $prev_pack_code	= '';
	my $prev_line	= '';
	my $prev_char_last	= '#';

	# We are not in the middle of a C comment
	my $in_comment	= 0;

	my $extended_line	= '';

	# Are we currently within a case block?
	my $incase		= 0;

	# Was the previous line a case statement?
	my $prevcase	= 0;

	# Case stmt-related vars
	my $case_line	= '';
	my $case		= 0;

	# function and its parameters
	clear_function();

	# keyword 
	my $keyword		= '';
	my $key_line	= 0;
	my $key_params	= '';
	my $key_unbalanced_parens = 0;
	my $key_params_unpacked = 0;

	# Try...except
	$try		= '';
	$try_body	= '';
	$try_line	= 0;
	$try_unbalanced_parens = 0;

	# Number of curly braces
	my $curly_braces= 0;
	my $curly_braces_line = 0;

	# In __asm line?
	my $inasm		= 0;

	# new operator
	clear_new_function();

	# number of vars assigned function results
	$var_count		= 0;

	# Calc number of lines scanned
	$file_lines = scalar(@lines);
	$stats{LINES} += $file_lines;
	$stats{FILES} += 1;
	$line_current = 0;

#$TODO Need better name
	my $alt_found = '';

	my $do_while = 0;

	# go thru all the lines in the file

	if ($do_strings != $STRINGS_NONE)
	{
		# Process MC files?
		if (($do_strings & $STRINGS_MC) && ($filename =~ /\.mc$/i))
		{
			#
			# We're gonna be sneaky here.
			# $filename and @lines are parameters 
			# used by extract_strings_from_mc.
			#
			extract_strings_from_mc();

			undef %vars;
			undef @unchecked_vars;
			undef @braces;

			%vars			= ();
			@unchecked_vars	= ();
			@braces			= ();
			$brace_level = 0;

			undef @lines;
			next FILE;
		}

		# If we're not extracting strings from CODE or RC files
		# then clean up now and go to the next file.
		if (!($do_strings & ($STRINGS_CODE | $STRINGS_RSRC)))
		{
			undef %vars;
			undef @unchecked_vars;
			undef @braces;
			%vars			= ();
			@unchecked_vars	= ();
			@braces			= ();
			$brace_level = 0;

			undef @lines;
			next FILE;
		}
	}

LINE:
	foreach (@lines)
	{
		my $function_scan	= '';
		my $function_scan_pos= 0;
		my %word_hash		= ();
		my @found_vars		= ();
		my $new_seen;
		my $comments		= 0;
		my $enable_changes	= 0;

		$line_current++;
		$stats{CHARS} += length($_);

		if ($enable[51] && ($_ =~ /$disallowed_strings/ox))
		{
			display_typo_normal($filename, $line_current, 51, $_);
		}

		############################################################
		#
		# Check to make sure line-continuation characters
		# don't have spaces after them before the EOL
		#
		if ($enable[10] && ($_ =~ /\\[ \t]+$/) && ($_ !~ /\/\//))
		{
			display_typo_normal($filename, $line_current, 10, $_);
		}

		############################################################
		#
		# Misspelling Microsoft
		#
		# If possible, avoid the long regexp, by checking that
		# we have enough characters to make up the word "microsoft"
		#
		if ($enable[13] && (/\w{8,}/) && (/[microsftMICROSFT]{8,8}/) &&
			(/mcirosoft | mircosoft | micorsoft |
						micrsooft | microosft | microsfot/ix))
		{
			display_typo_normal($filename, $line_current, 13, $_);
		}

		# Are we in the middle of a multi-line C comment?
		#
		if (!$in_comment)
		{
			# No. Make a copy of line
			$temp = $_;
		}
		else
		{
			# Yes.

			# Handle "fall through/thru" and "no break" comments
			if (($incase == 1) && 
				(/ fall.*?thr | no.*?break /ix))
			{
				$prevcase = 0;
				$incase = 0;
			}

			# Does this line have the end of the C comment?
			#
			if (/\*\//)
			{
				# Yes. Keep everything after the end of the
				# comment and keep going with normal processing

				$temp = $';
				$in_comment = 0;

				if ($show_kloc == $KLOC_OLD)
				{
					$stats{COMMENT_LINES} += 1;
				}
			}
			else
			{
				if (($show_kloc == $KLOC_OLD) && (/\S/))
				{
					$stats{COMMENT_LINES} += 1;
				}

				# No. Go to the next line.
				next LINE;
			}
		}

		if ((length($temp) > 1) && (substr($temp, -2, 1) eq '\\'))
		{
			substr($temp, -2, 2) = '';

			$extended_line = join("", $extended_line, $temp);
			next LINE;
		}
		elsif ($extended_line ne '')
		{
			$temp = join("", $extended_line, $temp);
			$extended_line = '';
		}

		# Remove single line C "/* */" comments
		$comments = ($temp =~ s/\/\*.*?\*\///g);

		# Code metric app counts semicolon chars as semis
		if ($show_kloc == $KLOC_OLD)
		{
			while ($temp =~ /\'\;\'/g)
			{
				$stats{SEMICOLONS} += 1;
			}
		}

		# If the line doesn't begin with a C++ comment
		# or preprocessor directive and there's
		# a string/character constant, then filter out the constants
		if (($temp !~ /^ \s* (\/\/ | \#)/x) &&
				($temp =~ /\" [^\"]* \" | \' [^\']* \'/x))
		{
			$temp = filter_constants($temp);
		}

		# Remove any "//" comments
		# Multi-line C comment?
		if ($temp =~ /\/([\/\*])/)
		{
			my $comment_type = $1;
			# Need to make it look like there's still a EOL marker
			my $before = $` . "\n";

			$comments += 1;

			# Grab anything before the comment
			$temp = $before;

			if ($comment_type eq '*')
			{
				# Remember that we're in "comment" mode
				$in_comment = 1;
			}
		}

		# Preprocessor directive?
		if ($temp =~ /^\s*#\s*(\w+)/)
		{
			my $word = $1;

			if (exists($preprocessor_list{$word}))
			{
				my $val	= $preprocessor_list{$word};

				if (($enable_main[36] || $enable_main[48] || (0 != $do_ifdef)) &&
						(($val == $PP_IF) || ($word eq "elif")))
				{
					my $line= $';
					my $define;

					if ($word =~ /ifn?def/)
					{
						# We're processing ifdefs, but we're
						# in the middle of an undefined region
						if ((0 != $do_ifdef) && ($preprocess[$#preprocess] < 1))
						{
							# If the current level is not defined
							# then we put -1 on the stack to show that we're in
							# the middle of an undefined region
							# and not processing the ifdef/ifndef
							#
							push(@preprocess, -1);
						}
						elsif ($line =~ /(\w+)/)
						{
							$define = $1;

							# We're processing ifdefs
							if (0 != $do_ifdef)
							{
								my $val;

								if (exists($user_define_hash{$define}))
								{
									$val = 1;
								}
								else
								{
									$val = 0;
								}

								# invert the value if we have ifndef
								if ($word eq "ifndef")
								{
									$val = 1 - $val;
								}

								push(@preprocess, $val);

								if ($ifdef_verbose)
								{
								print "$word: @preprocess\n";
								}
							}

							if ($enable_main[36])
							{
								$define_hash{$define}++;
							}
						}
						else
						{
							print "$filename ($line_current) No define: '$line'\n";
						}
					}
					else
					{
						my $prev_def = '';
						my %check_defined = ();

						if ($do_ifdef)
						{
							# If the current level is not defined
							# then we put -1 on the stack to show that we're in
							# the middle of an undefined region
							# and not processing the if/elif
							#
							if ($preprocess[$#preprocess] < 1)
							{
								push(@preprocess, -1);
							}
							elsif (exists($evaluated_def_expression{$line}))
							{
								if ($ifdef_verbose)
								{
									my $expr;
									chomp($expr = $line);
									warn "Got expression for '$expr'\n\n";
								}

								if ($evaluated_def_expression{$line})
								{
									push(@preprocess, 1);
								}
								else
								{
									push(@preprocess, 0);
								}
							}
							else
							{
								my $eval_str = '';
								my $eval_param = '';
								my $val;

								if ($ifdef_verbose)
								{
									my $line1 = $line;
									chomp($line1);
									print ">> '$line1'\n";
								}

								while ($line =~ /defined\((\w+)\) | (\w+) | (\W+)/xg)
								{
									if ($1 ne '')
									{
										if (exists($user_define_hash{$1}))
										{
											$val = 1;
										}
										else
										{
											$val = 0;
										}
									}
									elsif ($2 ne '')
									{
										my $word = $2;

										if ($word =~ /^\d+$ | ^0x[\da-fA-F]+$/x)
										{
											$val = $word;
										}
										elsif (exists($user_define_hash{$word}))
										{
											$val = $user_define_hash{$word};
										}
										else
										{
											$val = 0;
										}
									}
									elsif ($3 ne '')
									{
										$val = $3;
									}
									else
									{
										die " '$&' What in the world?";
									}
									$eval_str = join("", $eval_str, $val);
								}

								chomp($eval_str);

								if ($ifdef_verbose)
								{
									warn "END: '$eval_str'\n";
								}

								$eval_param = $eval_str;
								$val = eval($eval_param);
								if ($@ ne '')
								{
									$val = 0;
								}
								elsif ($val eq '')
								{
									$val = 0;
								}

								if ($ifdef_verbose)
								{
									warn "EVAL: '$eval_param' = $val\n\n";
								}

								$evaluated_def_expression{$line} = $val;
								if ($val)
								{
									push(@preprocess, 1);
								}
								else
								{
									push(@preprocess, 0);
								}
							}

							if ($ifdef_verbose)
							{
								print ">> @preprocess\n";
							}
						}

						while ($line =~ /(\w+)/g)
						{
							$define = $1;

							if (($define ne "defined") && ($define =~ /\D/) &&
								($define !~ /^0x|^0X|^\d+[lL]$/))
							{
								if ($enable_main[48])
								{
									if (exists($temp_defined_list{$define}) &&
										($prev_def ne "defined") && 
										!exists($check_defined{$define}))
									{
										print "$filename ($line_current):\t",
												"$define not always defined 48:\t$_";
									}

									$check_defined{$define} = 1;
								}

								if ($enable_main[36])
								{
									$define_hash{$define}++;
								}
							}

							$prev_def = $define;
						}
					}
				}

				if ($val == $PP_IF)
				{
					$braces[$brace_level] = $curly_braces;
					$brace_level += 1;
				}
				elsif ($val == $PP_ELSE)
				{
					die "$word without if $filename $line_current" unless ($brace_level > 0);

					$curly_braces = $braces[$brace_level-1];
					if ($do_ifdef)
					{
						# If the current level is in the middle
						# of an undefined region then we don't want
						# to invert the status and start processing
						# ifdefs.
						#
						# If we are in a defined region, then we can
						# invert the status and process ifdefs accordingly
						#
						if ($preprocess[$#preprocess] >= 0)
						{
							$preprocess[$#preprocess] = !$preprocess[$#preprocess];
						}

						if ($ifdef_verbose)
						{
							print "#else: @preprocess\n";
						}
					}
				}
				elsif ($val == $PP_END)
				{
					$brace_level -= 1;

					if ($brace_level < 0)
					{
						print STDERR "BRACE_LEVEL: $filename ($line_current)\n";
						print "// BRACE_LEVEL: $filename ($line_current)\n";

						$brace_level = 0;
						$curly_braces = $braces[$brace_level-1];
					}

					if ($do_ifdef)
					{
						pop(@preprocess);

						if ($ifdef_verbose)
						{
							print "#endif: @preprocess\n";
						}
					}
				}

				# Nuke the line if it starts with a #, 
				#	to ignore pre-processor stuff
				# unless it's a #define with a line-continuation char
				if (($val != $PP_DEFINE) || ($temp !~ /\\$/))
				{
					if ($show_kloc == $KLOC_OLD)
					{
						$stats{CODE} += 1;
					}
					$temp = "\n";
				}
			}
		}

		$temp_pack = $temp;

		# Replace spaces between word characters with '#'
		$temp_pack =~ s/(\w)\s+(\w)/$1#$2/g;

		# remove whitespace
		$temp_pack =~ tr/ \t//d;

		# Remove any "//" comments
		if ($temp_pack =~ m{^\/\/})
		{
			$temp_pack = "\n";
			$comments += 1;
		}

		# Code metric app reports lines that have multiple comments as
		# one line of comments
		if (($show_kloc == $KLOC_OLD) && ($comments > 0))
		{
			$stats{COMMENT_LINES} += 1;
		}

		$stats{COMMENTS} += $comments;

		############################################################
		#
		# For empty lines, 
		# do the minimal stuff necessary.
		#
		# N.B. If stuff gets added, this may need to change
		#
		if ($temp_pack eq "\n")
		{
			# Handle "fall [through|thru|0]", and "no break" comments
			if ($incase &&
				(m#//.*fall | /\*.*fall | 
				  //.*no.*?break | /\*.*no.*?break #ix))
			{
				$prevcase = 0;
				$incase = 0;
			}

			next LINE;
		}

		# If we're extracting strings and we're ignoring
		# strings from code, then skip to the next line
		if (($do_strings != $STRINGS_NONE) &&
			!($do_strings & $STRINGS_CODE))
		{
			next LINE;
		}

		# If we're processing #ifdefs and we're in
		# an undefined portion of code, skip the line
		if ((0 != $do_ifdef) && (1 != $preprocess[$#preprocess]))
		{
			next LINE;
		}

		# Handle case 1 exceptions of the form:
		#	if (XXX);
		#	else if (YYY) DoRealWork();
		#
		if (exists($typo1{DESCRIPTION}))
		{
			if ($temp_pack !~ /^else/)
			{
				display_typo_normal($filename, $typo1{LINE}, 1, $typo1{DESCRIPTION});
			}

			%typo1 = ();
		}

		# Count the number of open curly braces
		$curly_temp = $curly_braces;

		$curly_braces_line = 0;
		while ($temp_pack =~ /\{/g)
		{
			$curly_braces_line += 1; 
		}

		$curly_braces += $curly_braces_line;

		# Check to see that we really started a function
		# when the number of curly braces transitions from 0 to 1
		if ((0 == $curly_temp) && ($curly_braces_line > 0))
		{
			# Don't count 'extern "C" {' as bumping up the curly braces count
			if (($temp =~ /extern\s+\_\s+\{/) || 
				(($prev_pack =~ /extern_$/) && ($temp =~ /^\s*\{/)))
			{
				$curly_braces -= 1;
			}
			# Don't count class,struct,enum,union or namespace as
			# bumping up the curly braces count if these keywords
			# are on the previous line
			#
			# N.B. Don't worry if the enum/struct/union is passed as
			# a parameter to a function
			elsif (($temp_pack =~ /^\{/) && $prev_pack &&
					($prev_pack =~ /^class\b[^\);]*$|\bstruct[^\);]*$|\benum[^\);]*$|
									\bunion[^\);]*$|\bnamespace[^\);]*$/x))
			{
				$curly_braces -= 1;
			}
			# Don't count class,struct,enum,union or namespace as
			# bumping up the curly braces count if these keywords
			# are on the current line
			#
			# Make sure the char before the keyword isn't a
			# "(" or "," to handle these keywords appearing
			# in a fn prototype, i.e. "void FooBar(class X *px) {"
			#
			elsif (($temp_pack =~ /class [^\{]+\{ |
									\bstruct [#\w]*\{ |
									\benum [#\w]*\{ |
									\bnamespace [#\w]*\{ |
									\bunion [#\w]* \{ /x) &&
					($` !~ /[\(\,]$/))
			{
				$curly_braces -= 1;
			}

			# Find Function name
			if ($curly_braces > 0)
			{
				if ($log_functions || $output_xml)
				{
					find_function($prev_pack);
				}
				else
				{
					$stats{FUNCTIONS} += 1;
				}
			}
		}

		if ($KLOC_NONE != $show_kloc)
		{
			$stats{CODE} += 1;
		}

		# If we're handling NO_TYPO comments
		# and there were comments on the current line
		# and the current line contains NO_TYPO
		# then check to see what is temporarily disabled
		#
		#$TODO Do this only when we're about to report a typo
		#      for the current line instead for every line
		#      with a comment
		#
		if (($no_typo != 0) && ($comments > 0) && /\bNO_TYPO\b/)
		{
			my $after = $';

			# Looking for a ":" followed by a set of numbers
			# which represent cases to be temporarily disabled
			if ($after =~ /^:/)
			{
				my $ignore = $';

				while ($ignore =~ /(\d+)/g)
				{
					my $case = $1;

					if (($case >= $CASE_MIN) && ($case <= $CASE_MOST))
					{
						$enable_changes = 1;
						$enable[$case] = 0;
					}
				}
			}
			else
			{
				# disable all of them
				grep($_ = 0, @enable);
				$enable_changes = 1;
			}
		}

		########################################
		#
		# Skip assembly language
		#

		if (1 == $inasm)
		{
			#
			# If we're in an __asm block,
			# Look for the end brace
			# If we can't find it, then go to the next line
			#
			if ($temp_pack !~ /}/)
			{
				next LINE;
			}
			else
			{
				$temp_pack = $';
				$inasm = 0;
				if ($temp_pack eq "\n")
				{
					next LINE;
				}

				$after = $temp;
				if ($after =~ /}/)
				{
					$temp = $';
				}
			}
		}
		elsif (2 == $inasm)
		{
			#
			# If we previously saw an __asm stmt, but nothing else,
			# then we look for a start brace or the actual assembly language
			# C/C++ comments have been removed by this time
			#
			if ($temp_pack =~ /^{/)
			{
				my $after = $';

				$curly_braces -= 1;

				# Is there an end brace on the same line?
				if ($after !~ /}/)
				{
					# No. So keep looking for that end brace.
					$inasm = 1;
					next LINE;
				}

				# Yes. Then grab anything after the end brace,
				# thereby removing the assembly language code and
				# continue on

				$temp_pack = $';
				$inasm = 0;

				$after = $temp;
				if ($after =~ /}/)
				{
					$temp = $';
				}
			}
			else
			{
				if ($temp_pack =~ /\S/)
				{
					$inasm = 0;
				}
			}

			clear_statement();
		}
		elsif ($temp_pack =~ /^__?asm/)
		{
			# Found an __asm stmt

			my $after = $';

			if ($after eq "\n")
			{
				# Nothing else on this line though.
				# Need to find out if we're in an asm block or just a stmt

				$inasm = 2;
				clear_statement();
				next LINE;
			}
			elsif ($after =~ /^\{/)
			{
				# In an asm block
				my $after2 = $';

				$curly_braces -= 1;

				# Does the asm block end on the same line?
				if ($after2 !~ /\}/)
				{
					# No end brace on the same line, so
					# keep on looking for the end brace

					$inasm = 1;
					clear_statement();
					next LINE;
				}

				# Yes, the asm block ends on the same line
				# Need to grab anything after the end brace
				$temp_pack = $';

				if ($temp_pack !~ /\S/)
				{
					# If there's nothing after the end brace, go to the next line
					next LINE;
				}

				$after = $temp;
				if ($after =~ /\{/)
				{
					$after = $';
					if ($after =~ /\}/)
					{
						$temp = $';
					}
				}
			}
			else
			{
				# __asm stmt - skip to next line
				next LINE;
			}
		}

		############################################################
		#
		# Check for uninitialized variables in for-loops
		#
		# for(ULONG icpp; icpp < ccppMax; icpp++)
		#
		if ($enable[12] &&
			($temp =~ /for\s*\(\s*[^;,=]+[\s\*]+[\w*\->]+;/))
		{
			display_typo_normal($filename, $line_current, 12, $_);
		}

		############################################################
		#
		# Check for doubled semicolons. Innocent, but careless.
		#
		if ($enable[43] && ($temp_pack =~ /;;/) && ($` !~ /\bfor\(/))
		{
			display_typo_normal($filename, $line_current, 43, $_);
		}

		############################################################
		#
		# Check for using sizeof(this) in code. 
		# Nothing good comes from this, most of the time...
		#
		if ($enable[55] && ($temp_pack =~ /sizeof\(this\)/i))
		{
			display_typo_normal($filename, $line_current, 55, $_);
		}

		############################################################
		#
		# If we're in a function, search for functions and
		# keywords we're interested in.
		#
		# For functions, we keep track of the function name
		# and the end position in the string where it was found
		#
		# For keywords, we add the function to a hash with the
		# end position in the string as the value for the hash entry.
		#
		# Also, if it's operator new, we keep track of
		# the function name.
		# 

		$new_seen = '';

		if (0 < $curly_braces)
		{
			my	$function_found = ($function_call{NAME}) ? 1 : 0;
			my	%seen;

			while ($temp_pack =~ /(\w+)/g)
			{
				my $word = $1;

				if ($var_count && exists($vars{$word}) && 
					!exists($seen{$word}))
				{
					push(@found_vars, $word);
					$seen{$word} = 1;
				}

				if (!$function_found && 
					($function_found = exists($function_list{$word})))
				{
					$function_scan		= $word;
					$function_scan_pos	= pos($temp_pack);
				}
				elsif (($function_found || $function_call{NAME}) && 
						exists($function_list{$word}))
				{
					if (!$alt_found)
					{
						$alt_found = $word;
					}
				}

				if (exists($keyword_list{$word}) &&
						!exists($word_hash{$keyword_list{$word}}))
				{
					if ($KEYWORD_NEW == $keyword_list{$word})
					{
						if (!$new_seen)
						{
							$new_seen = $word;
						}
						else
						{
							$new_seen = join("", $new_seen, '|', $word);
						}
					}

					$word_hash{$keyword_list{$word}} = pos($temp_pack);
				}
			}
		}

		############################################################
		#
		# Are we gathering the params for a function?
		#
		if ($function_call{NAME})
		{
			# Yes.
			$param = $temp_pack;

			# We may have gotten confused by #ifdef's
			# or imcomplete code within #ifdef's
			#
			# Check to see we're processing an
			# if or else keyword
			#
			if (exists($word_hash{$KEYWORD_IF}) || exists($word_hash{$KEYWORD_ELSE}))
			{
				clear_function();

				$param = '';
			}
		}
		############################################################
		#
		# Does the line contain a "function" that we're interested in
		#
		else
		{
			if ($function_scan)
			{
				my $char_index;
				my $len;

				$len		= length($function_scan);
				$char_index	= $function_scan_pos - $len;

				# Yes. Keep track of some info
				# when we've got all the function's params
				#

				# The actual function we've got
				$function_call{NAME} = $function_scan;

				# part of the function's parameters
				($function_call{BEFORE}, $param) = unpack("a$char_index x$len a*", $temp_pack);

				if ($checked_list_count)
				{
					while ($function_call{BEFORE} =~ /\b(\w+)\b/g)
					{
						if (exists($checked_list{$1}))
						{
							clear_function();

							$param = '';
							last;
						}
					}
				}
			}
			elsif ($temp_pack =~ /(\w*assert\w*)\b/i)
			{
				$stats{ASSERTS} += 1;

				if ($temp_pack !~ /SideAssert|EXECUTE_ASSERT/)
				{
					
					# Yes. Keep track of some info
					# when we've got all the function's params
					#

					# The actual function we've got
					$function_call{NAME} = $1;

					# Stuff before the function
					$function_call{BEFORE} = $`;

					# part of the function's parameters
					$param = $';
				}
			}

			if ($function_call{NAME} && 
				($param ne '') && (substr($param,0,1) ne '('))
			{
				clear_function();

				$param = '';
			}
			elsif ($function_call{NAME})
			{
				my $invalid = 0;

				# The line number where the function was invoked
				$function_call{LINE} = $line_current;

				# string for the function's parameters
				$function_call{PARAMS} = '';

				# number of unbalanced parentheses
				$function_call{PARENS} = 0;

				# If the previous line has an assignment then prepend
				# to current line.
				#
				# This assumes that multiple assignment were split across lines.
				if ($prev_pack_code =~ /[\w\.\->\[\]\(\)\*\+]+ 
										[\w\]\)]
										(= \\? | 
										 = \(.*?\) \\? | 
										 = \w+_cast\<.*?\> \\? \(* |
										 = \w+\(*
										)$/x)
				{
					my $temp2 = $prev_pack_code;

					chomp($temp2);

					# Remove any beginning of block text, i.e.
					#
					# if (x) 
					# {
					#    p =
					#    y = X();
					#
					if ($temp2 =~ /{ ([^{}]+ =) $/x)
					{
						$temp2 = $1;
					}

					$function_call{BEFORE} = join("", $temp2, $function_call{BEFORE});
				}

				# If before the function is a "(" or ".", two characterts
				# that don't usually appear before a function call
				# (except for a class member function - but we don't handle those)
				# or if after the function call there's a "." or "->",
				# then we probably don't have a function call.
				# More likely a variable that has the same name.
				#
				if ((($function_call{BEFORE} =~ /[^A-Z]\($|\.$/) &&
					 ($function_call{BEFORE} !~ /if\($/)) ||
					($param =~ /^\.|^\-\>/))
				{
					clear_function();

					$invalid = 1;
					$param = '';
				}

				# No assignment, let's complain
				#
				# We key on having no equals char or alphanumeric char
				# before the function call and no all-uppercase word.
				# on the previous line.
				#
				# Exclude certain functions from the complaint since
				# their return values are rarely checked
				#
				if ($enable[32] && (0 < $curly_braces) &&
					($function_call{BEFORE} !~ /=|\w/) && ($prev_pack !~ /^[A-Z]+$/) &&
					$function_call{NAME})
				{
					my $complain = 0;

					# Also need to check RegOpenKey/RegOpenKeyEx to
					# see if we're in an if stmt, since we don't
					# need to free its return value, it's okay to just
					# compare it to some value
					#
					if (exists($function_list{$function_call{NAME}}) &&
						(0 != ($function_list{$function_call{NAME}} & $REG_FUNCTION)))
					{
						if ($function_call{NAME} =~ /RegOpenKey/)
						{
							if (($function_call{BEFORE} !~ /\bif\b|for\b/) && 
								($keyword !~ /\bif\b|for\b/))
							{
								$complain = 1;
							}
						}
					}
					elsif ($function_call{NAME} =~ /OpenFile/)
					{
						# If you use OpenFile to delete a file, you may not
						# care if you couldn't delete it (what can you do
						# if delete does fail, other than complain to the user?)
						if ($param !~ /[\,\|]OF_DELETE\)/)
						{
							$complain = 1;
						}
					}
					elsif ($function_call{NAME} =~ /assert/i)
					{
						# Don't complain
					}
					elsif (0 == ($function_list{$function_call{NAME}} &
								($FILLMEM_FUNCTION | $MEMCRT_FUNCTION |
								 $OVERFLOW_FUNCTION | $VOID_FUNCTION)))
					{
						$complain = 1;
					}

					if ($complain)
					{
						display_typo_normal($filename, $line_current, 32, $_);

						clear_function();

						$invalid = 1;
						$param = '';
					}
				}

				# if desired, keep a list of functions we're following
				if ((0 == $invalid) && $show_stats)
				{
					if (!exists($found_function{$function_call{NAME}}))
					{
						$found_function{$function_call{NAME}} = 0;
					}

					$found_function{$function_call{NAME}} += 1;
				}
			}
			else
			{
				# No function, then no parameters for the function
				$param = '';
			}
		}

		if ($param && ($param !~ /^\n/))
		{
			# remove the CRLF
			chomp($param);

			# Look for parentheses
			while ($param =~ /(\()|(\))/g) 
			{
				$1 ? $function_call{PARENS}++ :	$function_call{PARENS}--;

				# we've seen the closing parentheses for the function
				if (!$function_call{PARENS})
				{
					# Grab the stuff after the last matched parentheses
					$param =~ /\G(.*)/g;

					# Delete the stuff after the last parentheses, if any
					if (length($1) > 0)
					{
						substr($param, -length($1)) = '';
					}
				}

				# Too many closing parentheses
				if ($function_call{PARENS} < 0)
				{
					$function_call{NAME} = '';
				}

				last if ($function_call{PARENS} <= 0);
			}

			$function_call{PARAMS} = join("", $function_call{PARAMS}, $param);

			#
			# Now we've got the function and its parameters
			#
			if (!$function_call{PARENS})
			{
				my $function_id;

				if (exists($function_list{$function_call{NAME}}))
				{
					$function_id = $function_list{$function_call{NAME}};
				}
				else
				{
					$function_id = 0;
				}

				check_function_params($filename, $alt_found, $function_id);

				if (!$try && (0 < $curly_braces))
				{
					if ($enable[26] && ($function_id & $ALLOCA_FUNCTION))
					{
						display_function_typo_normal(26);
					}

					if ($enable[35] && ($function_id & $THROW_FUNCTION))
					{
						display_function_typo("$function_call{NAME} not in try/except", 35);
					}
				}

				if ($alt_found ne '')
				{
					$alt_found = '';
				}

				clear_function();
			}
			elsif (length($function_call{PARAMS}) > $EXPRESSION_LIMIT)
			{
				if ($EXPRESSION_LIMIT > 128)
				{
					substr($function_call{PARAMS}, 128) = '...';
				}

				if ($enable[60])
				{
					display_typo_normal($filename, $function_call{LINE}, 60, 
								"$function_call{NAME}$function_call{PARAMS}\n");
				}

				clear_function();
			}
		}

		############################################################
		#
		# Are we gathering the expression for a try/except?
		#
		if ($try)
		{
			# Yes.
			$param = $temp_pack;
		}
		############################################################
		#
		# Does the line contain a try
		#
		elsif (exists($word_hash{$KEYWORD_TRY}))
		{
			my $char_index = $word_hash{$KEYWORD_TRY} - 3; # 3 for "try"

			# Yes. Keep track of some info
			# when we've got all the try's body
			#

			# The line number where the try was invoked
			$try_line = $line_current;

			# string for the try's body
			$try_body = '';

			# number of unbalanced curly parentheses
			$try_unbalanced_parens = 0;

			($try, $param) = unpack("x$char_index a3 a*", $temp_pack);
		}
		else
		{
			# No try/except, then no body for the try
			$param = '';
		}

		if ($param && ($param !~ /^\n/))
		{
			# remove the CRLF
			chomp($param);

			# Look for curly parentheses
			while ($param =~ /(\{)|(\})/g)
			{
				$1 ? $try_unbalanced_parens++ : $try_unbalanced_parens-- ;

				# we've seen the closing parentheses for the try
				if (!$try_unbalanced_parens)
				{
					# Grab the stuff after the last matched parentheses
					$param =~ /\G(.*)/g;

					# Delete the stuff after the last parentheses, if any
					if (length($1) > 0)
					{
						substr($param, -length($1)) = '';
					}
				}

				# Too many closing parentheses
				if ($try_unbalanced_parens < 0)
				{
					print "// $filename ($line_current) too many parentheses '$try'\n";
					$try = '';
				}

				last if ($try_unbalanced_parens <= 0);
			}

			# Handle code that tries to do portable exception handling
			if (($try eq "TRY") && ($param =~ /CATCH\(/))
			{
				$try_unbalanced_parens = 0;

				# Put "{}" around current try body so
				# code that clears $try below will work
				$try_body = join("", '{', $try_body);
				$param = '}';
			}

			$try_body = join("", $try_body, $param);
		}


		############################################################
		#
		# Are we checking for using "new" result before checking
		# for success?
		#
		if ($enable[34])
		{
			############################################################
			#
			# Are we gathering the params for a new operator?
			#
			if (0 != $new_line)
			{
				# Yes.
				$param = $temp_pack;
			}
			############################################################
			#
			# Does the line contain a "new"
			#
			# Make sure we're not within an if statement
			# since we're looking for unchecked new's, if the new
			# is within an if statement, then it's gonna be checked.
			#
			# Also check to see that we're in a function and
			# we're not in the middle of a try...except
			#
			elsif ($new_seen && 
					(0 < $curly_braces) && (!$try) &&
					(($keyword ne "if") && ($temp_pack !~ /if\(/)) &&
					($temp_pack =~ /$new_seen/))
			{
				my $clear	= 0;

				$param		= $';

				$before_new	= $`;
				$new_line	= $line_current;
				$new_params	= '';

				# If there's an if stmt before the "new", then punt
				if ($before_new =~ /if\(/)
				{
					$clear = 1;
				}
				# If they're using a var named new, punt
				elsif ($param =~ /^[;\.\-]/)
				{
					$clear = 1;
				}
				#
				# If the previous line has an assignment then prepend
				# to current line.
				#
				# This assumes that multiple assignment were split across lines.
				elsif ($prev_pack_code =~ /[\w\.\->\[\]\(\)\*\+]+ 
											[\w\]\)]
											(= \\? | 
											 = \(.*?\) \\? | 
											 = \w+_cast\<.*?\> \\? \(* |
											 = \w+\(*
											)$/x)
				{
					my $temp2 = $prev_pack_code;

					chomp($temp2);

					# Remove any beginning of block text, i.e.
					#
					# if (x) 
					# {
					#    p =
					#    y = X();
					#
					if ($temp2 =~ /{ ([^{}]+ =) $/x)
					{
						$temp2 = $1;
					}

					$before_new = join("", $temp2, $before_new);
				}

				if (($before_new !~ /[\)=]$/) || ($param =~ /^\w/))
				{
					$clear = 1;
				}
				elsif ($checked_list_count)
				{
					while ($before_new =~ /\b(\w+)\b/g)
					{
						if (exists($checked_list{$1}))
						{
							$clear = 1;
							last;
						}
					}
				}

				if (!$clear && ($ignore_result_list_count > 0))
				{
					my $new_word;

					@new_words = split(/,/, $new_seen);
					foreach $new_word (@new_words)
					{
						if (exists($ignore_result_list{$new_word}))
						{
							$clear = 1;
							last;
						}
					}
				}
				
				if ($clear)
				{
					$param = '';
					clear_new_function();
				}
				elsif ($show_stats)
				{
					$found_function{"new"} += 1;
				}
			}
			elsif ($show_stats && 
					$new_seen && (0 < $curly_braces) && 
					($temp_pack =~ /$new_seen/))
			{
				if (!exists($found_function{"new"}))
				{
					$found_function{"new"} = 0;
				}

				$found_function{"new"} += 1;
				$param = '';
			}
			else
			{
				$param = '';
			}
		}
		else
		{
			$param = '';
		}

		if ($param && ($param !~ /^\n/))
		{
			# remove the CRLF
			chomp($param);

			if ($param =~ /;/)
			{
				my $slop;
				my $new_var;
				my $new_var_display;
				my $new_call;
				my $new_call_display;
				my @assign_vars = ();
				my $cast = '';

				$new_params = join("", $new_params, $`, ";");

				if ($before_new =~ /==/)
				{
					$slop = "==";
				}
				else
				{
					if ($before_new =~ /(\([^\(\)]+\))$/)
					{
						$cast = $1;
					}

					# Try and remove templated classes before the var
					# like "Cfoo<int>"
					if ($before_new =~ /^\w+\<[\w\,]+\>/)
					{
						$before_new = $';
					}

					$slop = '';
					@assign_vars = parse_vars($before_new);
				}

				if (($slop =~ /^==/) || ($#assign_vars < 0))
				{
					$new_var = '';
				}
				else
				{
					my $func_info;

					$new_call = join("", '=', $cast, 'new', $new_params);
					$new_call_display = $new_call;

					########################################
					#
					# We need to quote the contents of $new_var
					# so that when we try to look for $new_var
					# in another string, perl doesn't interpret
					# any of the chars in $new_var as part of
					# a regular expression.
					#
					# We just want a literal match.
					#
					# Many neurons died needlessly before I figured 
					# out what was going on
					#
					$new_call =~ s/(\W)/\\$1/g;

					$func_info = {
									TYPE => "new",
									CALL => $new_call,
									CALL_SHOW => $new_call_display,
									LINE => $new_line,
									CHECK => $enable[27],
									REFS => 0,
									REPORT => $VAR_UNUSED
								};

					add_vars($func_info, @assign_vars);

					clear_new_function();
				}
			}
			else
			{
				$new_params = join("", $new_params, $param);
			}
		}

		############################################################
		#
		# Are we gathering the expression for a keyword?
		#
		if ($keyword)
		{
			# Yes.
			$param = $temp_pack;

			# We may have gotten confused by #ifdef's
			# or broken code within #ifdef's
			#
			# Check to see we're processing an
			# if keyword
			#
			if ((exists($word_hash{$KEYWORD_IF})) && 
				($word_hash{$KEYWORD_IF} == 2) &&
					(($keyword eq "if") || 
					 ($keyword eq "while") || 
					 ($keyword eq "for")))
			{
				# If we saw an if stmt, then 
				# we resync to this if keyword as the most current one
				# The actual keyword we've got
				$keyword = "if";

				# The line number where the keyword was invoked
				$key_line = $line_current;

				# string for the keyword's expression
				$key_params = '';

				# number of unbalanced parentheses
				$key_unbalanced_parens = 0;

				my $char_index = $word_hash{$KEYWORD_IF};

				$param = unpack("x$char_index a*", $temp_pack);
			}
		}
		############################################################
		#
		# Does the line contain a keyword that we're interested in
		#
		# Someone's code uses a large macro called BREAK_IF to 
		# check stuff
		#
		elsif (exists($word_hash{$KEYWORD_IF}) || 
				exists($word_hash{$KEYWORD_FOR}) || 
				exists($word_hash{$KEYWORD_SWITCH}) || 
				exists($word_hash{$KEYWORD_WHILE}))
		{
			my $char_index;

			if (exists($word_hash{$KEYWORD_FOR}))
			{
				# The actual keyword we've got
				$keyword = "for";
				$char_index = $word_hash{$KEYWORD_FOR};
			}
			elsif (exists($word_hash{$KEYWORD_IF}))
			{
				# The actual keyword we've got
				$keyword = "if";
				$char_index = $word_hash{$KEYWORD_IF};
			}
			elsif (exists($word_hash{$KEYWORD_WHILE}))
			{
				# The actual keyword we've got
				$keyword = "while";
				$char_index = $word_hash{$KEYWORD_WHILE};

				if (($temp_pack =~ /\}while/) || ($prev_char_last eq '}') ||
					($prev_pack =~ /do\b/))
				{
					$do_while = 1;
				}
				else
				{
					$do_while = 0;
				}
			}
			elsif (exists($word_hash{$KEYWORD_SWITCH}))
			{
				# The actual keyword we've got
				$keyword = "switch";
				$char_index = $word_hash{$KEYWORD_SWITCH};
			}

			# Yes. Keep track of some info
			# when we've got all the keyword's expression
			#
			
			# The line number where the keyword was invoked
			$key_line = $line_current;

			# string for the keyword's expression
			$key_params = '';

			# number of unbalanced parentheses
			$key_unbalanced_parens = 0;

			$param = unpack("x$char_index a*", $temp_pack);

			$char_index -= length($keyword);

			if ($char_index > 0)
			{
				my $text = substr($temp_pack, 0, $char_index);

				update_statement($text, $line_current, $file_lines, $prev_pack);
			}
		}
		else
		{
			# No keyword, then no expression for the keyword
			$param = '';

			update_statement($temp_pack, $line_current, $file_lines, $prev_pack);
		}

		############################################################
		#
		# Check for vars that are referenced before they've
		# been checked for success
		#
		# We don't handle the following situation:
		#	x = new Class;
		#	*px = x;
		#	if (x) return NULL;
		#
		if ($#found_vars >= 0)
		{
			my $word;

			foreach $word (@found_vars)
			{
				my $var_info;
				my $index;

				if (!exists($vars{$word}))
				{
					next;
				}

VAR_INFO:
				for ($index = 0; $index <= $#{$vars{$word}}; $index++)
				{
					my $var;

					$var_info = ${$vars{$word}}[$index];

					$var = $var_info->{EXPR};

					#
					# If the current line number isn't the same
					# as the line number when the fn result was assigned
					# OR the variable is used in the function call
					# AND the variable hasn't been referenced yet
					# AND the variable is in the current line
					#

					if ((($var_info->{FUNC}->{LINE} != ($line_current)) ||
						($var =~ /$var_info->{FUNC}->{CALL}/)) &&
						($var_info->{FUNC}->{REPORT} != $VAR_USED) &&
						($temp_pack =~ /(\b|\W)$var(\W)/))
					{
						my $before;
						my $after;
						my $complain = 0;
						my $handled = 0;

						# If there were parentheses around the var,
						# dev may have just wanted to make sure that
						# the var was protected from side effects
						if (($1 eq "(") && ($2 eq ")"))
						{
							$before = $`;
							$after = $';

							# If there's an alphanumeric char at the end
							# before the var, then maybe we were wrong
							# so add back in the parentheses
							if ($before =~ /\w$/)
							{
								$before = join("", $before, '(');
								$after = join("", ')', $after);
							}
						}
						else
						{
							$before = join("", $`, $1);
							$after = join("", $2, $');
						}

						#
						# Has the function result been handled by a specified
						# routine?
						#
						if ($checked_list_count || $noderef_list_count)
						{
							while ($before =~ /\b(\w+)\b/g)
							{
								if (exists($checked_list{$1}))
								{
									$complain = -1;
									$handled = 1;
									last;
								}
								elsif (exists($noderef_list{$1}))
								{
									# ignore
									$handled = 1;
									last;
								}
							}
						}

						if ($handled)
						{
							# Do nothing
						}
						#
						# If we're returning the function result back to the caller,
						# then don't worry about the function call any more.
						#
						elsif ($before =~ /\breturn[^;]*$/)
						{
							# If ternary, don't complain
							if ($after =~ /^[^\;]*\?[^\;]+\:/ || !$enable[41])
							{
								$complain = -1;
							}
							else
							{
								$complain = -2;
							}
						}
						elsif ($before =~ /\bdelete\b/i)
						{
							$complain = -1;
						}
						#
						# If we're assigning to another variable
						#
						elsif ((($before =~ /[^\!=]=$/) || 
								($before =~ /[\w\)\]]=[\*\w\(\[\]]/)) &&
								($after =~ /^;/))
						{
							my @assign_vars;

							if ($prev_pack_code =~ /[\w\.\->\[\]\(\)\*\+]+ 
													[\w\]\)]
													= $/x)
							{
								my $temp2 = $prev_pack_code;

								chomp($temp2);

								# Remove any beginning of block text, i.e.
								#
								# if (x) 
								# {
								#    p =
								#    y = X();
								#
								if ($temp2 =~ /{ ([^{}]+ =) $/x)
								{
									$temp2 = $1;
								}

								$before = join("", $temp2, $before);
							}
							@assign_vars = parse_vars($before);

							add_vars($var_info->{FUNC}, @assign_vars);

							my $temp2 = $_;

							if (($enable[30] && ($var_info->{FUNC}->{TYPE} ne "new") &&
								($var_info->{FUNC}->{TYPE} !~ /alloca/)) ||
								($enable[34] && ($var_info->{FUNC}->{TYPE} eq "new")))
							{
								my $var_function = $var_info->{FUNC}->{TYPE};
								my $var_display = $var_info->{NAME};

								chomp($temp2);

								# Don't mark as having been used before being checked
								# This allows us to track the aliases too.
							}
						}
						#
						# - if we are capturing params for a keyword, then the 
						#   params for the keyword's expression don't contain
						#   the var already,
						#
						elsif ($keyword && ($keyword =~ /\bif\b|\bwhile\b/))
						{
							# Do nothing
							#$complain = -1;
						}
						# If we're assigning to some other variable using
						# the new result as the expression for a ternary operator
						elsif (($before =~ /[^=\!\>\<]\s*=\s*\(?$/) &&
								($after =~ /\?.*\:|[=\!\>\<]\s*=/))
						{
							# Clear out
							$complain = -1;
						}
						#
						# If text before the var is "=" and either "!= | =="
						# is before or after the var, and the function
						# is one in the list that returns INVALID_HANDLE_VALUE
						# and we compare against INVALID_HANDLE_VALUE
						# then we'll say that it has been checked.
						#
						elsif (($before =~ /=\(?/) && 
								(($' =~ /[=\!]=/) || ($after =~ /[=\!]=/)) &&
								(exists($function_list{$var_info->{FUNC}->{TYPE}})) &&
								($function_list{$var_info->{FUNC}->{TYPE}} & $INVALID_HANDLE) &&
								(($before =~ /$IH_FUNC_RESULT/ox) ||
								 ($after =~ /$IH_FUNC_RESULT/ox)))
						{
							$complain = -1;
						}
						#
						# If we see the var being passed as a parameter, we're using it
						#
						# We key off of:
						# - a comma or open parentheses before the var,
						# - we're not in the middle of an ASSERT, BREAK, printf, if,
						# - after the var contains a comma or parentheses and a semicolon,
						# OR
						# - we're not in the middle of an ASSERT, BREAK, printf, if,
						# - after the var isn't a ternary operator or a comparison
						# - we're not assigning something to the var again
						#
						elsif (($before =~ /[,\(]$/) &&
								($before !~ /assert/i) &&
								($before !~ /sizeof\(\*$ |
											\bif\s*\($ | 
											\bwhile\s*\($ | [^s]printf/x) &&
								($after =~ /^,|^\)+;?/))
						{
							$complain = 1;
						}
						elsif (($before !~ /\bswitch\b |
											sizeof\(\*$ |
											\breturn | 
											\bif\b | \bwhile\b | [^s]printf|[=\!]=/x) && 
								($before !~ /assert/i) &&
								($after !~ /\?.*\:|[=\!\>\<]=/) &&
								!(($before !~ /\S/) && ($after =~ /^[^=\!\<\>]?=[^=]/)))
						{
							$complain = 2;
						}
						# in an assignment, if the string after the
						# variable references the variable
						#
						elsif (($before !~ /\S/) && ($after =~ /^[^=\!\<\>]?=[^=]/) &&
								($after =~ /$var/))
						{
							$complain = 3;
						}
						elsif (($before =~ /\*$/) && ($after =~ /^=/))
						{
							$complain = 4;
						}

						if ($complain > 0)
						{
							my $temp2 = $_;

							if (($enable[30] && ($var_info->{FUNC}->{TYPE} ne "new") &&
								($var_info->{FUNC}->{TYPE} !~ /alloca/)) ||
								($enable[34] && ($var_info->{FUNC}->{TYPE} eq "new")))
							{
								my $var_function = $var_info->{FUNC}->{TYPE};
								my $var_display = $var_info->{NAME};

								chomp($temp2);

								if (($try eq '') || (1 == $kernel_code))
								{
								display_typo($filename, $line_current, "using $var_function result w/no check", 
											($var_function eq "new") ? 34 : 30, "$temp2 [$var_display]\n");
								}

								# Mark as having been used before being checked
								$var_info->{FUNC}->{REPORT} = $VAR_USED;
							}
						}
						elsif ($complain == -2)
						{
							if (($VAR_UNUSED == $var_info->{FUNC}->{REPORT}) &&
								$var_info->{FUNC}->{CHECK})
							{
								my $func_info = $var_info->{FUNC};

								if ($enable[27])
								{
									display_typo($filename, $func_info->{LINE}, 
												"no immediate $func_info->{TYPE} check", 
												27, "$func_info->{CALL_SHOW} [$var_info->{NAME}]\n");
								}

								$var_info->{FUNC}->{REPORT} = $VAR_UNCHECKED;
							}
						}
						elsif ($complain < 0)
						{
							$var_info->{FUNC}->{REPORT} = $VAR_USED;
						}

						if ($var_info->{FUNC}->{REPORT} == $VAR_USED)
						{
							$var_count -= $var_info->{FUNC}->{REFS};
					
							if (0 == $#{$vars{$word}})
							{
								delete $vars{$word};
							}
							else
							{
								splice(@{$vars{$word}}, $index, 1);
								if ($#{$vars{$word}} < 0)
								{
									delete $vars{$word};
								}
							}
						}

						last VAR_INFO;
					}
				}
			}
		}

		if ($param && ($param !~ /^\n/))
		{
			# remove the CRLF
			chomp($param);

			# Look for parentheses
			while ($param =~ /(\()|(\))/g)
			{
				$1 ? $key_unbalanced_parens++ : $key_unbalanced_parens-- ;

				# we've seen the closing parentheses for the keyword
				if (!$key_unbalanced_parens)
				{
					my $until_end;

					# Grab the stuff after the last matched parentheses
					$param =~ /\G(.*)/g;

					$until_end = $1;

					############################################################
					#
					# Look for if statements with an appended semicolon
					#
					# We key off of the keyword "if" with a semicolon
					# after the final ")"
					#
					if ($until_end && ($until_end =~ /^;/))
					{
						my $after = $';

						if ($enable[1] && ($keyword eq "if")) 
						{
							# don't whine if we see
							#	if (XXX); else DoRealWork();
							# otherwise, wait until we see what's after the semicolon
							if ($after !~ /\belse\b/)
							{
								$typo1{DESCRIPTION} = "$keyword$key_params$param\n";
								$typo1{LINE} = $line_current;
							}
						}
						elsif ($enable[46] && ($keyword ne "if"))
						{
							if (0 == $do_while)
							{
								display_typo($filename, $line_current, "$keyword (XXX);", 46, "$keyword$key_params$param\n");
							}
						}
					}

					# Delete the stuff after the last parentheses, if any
					if ($until_end)
					{
						if (length($until_end) > 0)
						{
							substr($param, -length($until_end)) = '';
						}

						if ($until_end ne "\n")
						{
							my $end = join("", $until_end, "\n");

							update_statement($end, $line_current, $file_lines, $keyword . $key_params. $param);
						}
					}
				}

				# Too many closing parentheses
				if ($key_unbalanced_parens < 0)
				{
					$keyword = '';
				}

				last if ($key_unbalanced_parens <= 0);
			}

			$key_params = join("", $key_params, $param);

			#
			# Now we've got the keyword and its expression
			#
			if (!$key_unbalanced_parens)
			{
				$do_while = 0;

				scan_expression($key_params, $key_line);

				# Code metric app counts the semicolons in the for-loop
				# So to make the counts the same, behave the same as Code metric app
				if (($show_kloc == $KLOC_OLD) && ($keyword eq "for"))
				{
					$stats{SEMICOLONS} += ($key_params =~ tr/;/;/);
				}

				if (($keyword ne "for") && ($KLOC_NONE == $show_kloc))
				{
					############################################################
					#
					# Look for if statements which assign a number/constant
					#
					# We key off of "("
					# followed by a "=" followed by a number/uppercase word
					# followed by a ")"
					#
					if (($key_params =~ /\( (.+ [^\;=\%\^\|\&\+\-\*\/!<>] | \w) [\|\+]?= 
											([0-9A-Z_]+) [^\;\:\(]* \)/x))
					{
						if ($enable[3])
						{
							display_typo_normal($filename, $key_line, 3, "$keyword$key_params\n");
						}
					}

					############################################################
					#
					# Look for if statements which do a boolean inversion
					# and a bitwise-AND, i.e. "if (!x & Y)"
					#
					# C/C++ precedence rules have '!' before '&'.
					#
					# We key off of "!" followed by a word,
					# followed by a "&" followed by another word.
					#
					if ($enable[47] &&
						($key_params =~ /\! 
										  ( 
											[\w\.\->\[\]\(\)\*\+]* [\w\]\)] 
										  )
										 (\& | \| \^)
										    [\w\.\->\[\]\(\)\*\+]* [\w\]\)]
										 /x))
					{
						my $open;
						my $close;
						my $var = $1;

						# Remove parenthesized stuff from the string until
						# there aren't anymore
						$open = $var =~ tr/\(/\(/;
						$open += $var =~ tr/\[/\[/;
						
						$close = $var =~ tr/\)/\)/;
						$close += $var =~ tr/\]/\]/;

						# Make sure it's not a cast
						if ($var =~ /\(.*?(\w+).*?\)/)
						{
							my $type = $1;

							if (exists($type_hash{$type}))
							{
								$open = 1;
								$close = 0;
							}
						}

						# var shouldn't begin with an open parentheses
						# nor should it have unbalanced parentheses
						if ($open == $close)
						{
							display_typo_normal($filename, $key_line, 47, "$keyword$key_params\n");
						}
					}

					##################################################
					#
					# Look for comparisons with constant '0' where
					# the user may have meant '\0', i.e. null byte.
					#
					# Only worry about comparisons with one 
					# character constant in the expression
					#
					if ($enable[49] &&
						($key_params =~ /[\!=]= \'0\' | \'0\' [\!=]=/x) && 
						($' !~ /\'/) && ($` !~ /\'/))
					{
						display_typo_normal($filename, $key_line, 49, "$keyword$key_params\n");
					}

					if ($enable[28])
					{
						case28($filename, $keyword, $key_line, $key_params);
					}

					if ($enable[29])
					{
						case29($filename, $keyword, $key_line, $key_params);
					}

					if ($enable[57])
					{
						case57($filename, $keyword, $key_line, $key_params);
					}

					if ($var_count)
					{
						my @words;
						my $word_count = 0;

						while ($key_params =~ /(\w+)/g)
						{
							my $word = $1;

							if (exists($vars{$word}))
							{
								$words[$word_count] = $word;
								$word_count += 1;
							}
						}

						if ($word_count)
						{
							check_expression($keyword, $key_params, $key_line, 
											 $word_count, @words);
						} # end if $word_count

						if (($var_count > 0) && defined(@unchecked_vars))
						{
							my $var_info;

							foreach $var_info (@unchecked_vars)
							{
								if (($VAR_UNUSED == $var_info->{FUNC}->{REPORT}) && 
									$var_info->{FUNC}->{CHECK})
								{
									my $expression = $key_params;

									$expression =~ s/$var_info->{FUNC}->{CALL}//;

									#
									# Put \b at start and \W at end so
									# we check for the right variable, i.e.
									# "if (hWnd)" not "if (hWndT)"
									# Can't use \b on end because if
									# $var ends in a non-word character,
									# \b won't work, so just check for a non-word char
									#
									if ($expression !~ /(\b|\W)$var_info->{EXPR}\W/)
									{
										my $func_info = $var_info->{FUNC};

										if ($enable[27])
										{
											display_typo($filename, $func_info->{LINE}, 
														"no immediate $func_info->{TYPE} check", 27, 
														"$func_info->{CALL_SHOW} [$var_info->{NAME}]\n");
										}

										$func_info->{REPORT} = $VAR_UNCHECKED;
									}
								}
							}
						}

						undef @unchecked_vars;
					}
				}

				$keyword = '';
				$key_line = 0;
				$key_params = '';
				$key_unbalanced_parens = 0;
			}
			elsif (length($key_params) > $EXPRESSION_LIMIT)
			{
				if ($EXPRESSION_LIMIT > 128)
				{
					substr($key_params, 128) = '...';
				}

				if ($enable[60])
				{
					display_typo_normal($filename, $key_line, 60, "$keyword$key_params\n");
				}

				$keyword = '';
				$key_line = 0;
				$key_params = '';
				$key_unbalanced_parens = 0;
			}
		}

		#
		# Now we've got the try and its body
		#
		if (!$try_unbalanced_parens && ($try ne "") &&
			($try_body =~ /\{.*\}/))
		{
			$try		= '';
			$try_body	= '';
			$try_line	= 0;
		}

		############################################################
		#
		# Look for a Case xx : that is not followed by
		# a "break" or "return"
		#
		# case labels can take the form
		# CONSTANT or CLASS::CONSTANT or CONSTANT +| CONSTANT
		#
		# TRY: Add "default:" as something to check for
		# Add "|\bdefault\s*:" to regex.
		# Need to watch out for text strings that contain
		# the word 'default'.
		#
		if ((exists($word_hash{$KEYWORD_CASE}) || 
				exists($word_hash{$KEYWORD_DEFAULT})) &&
			($temp =~ /case\s+([\w:]*\s*[|+]?\s*\w+)\s*:|default\s*:/))
		{
			my $before = $`;

			$case_line = $';

			# No error if the previous line has an exception.
			# Exceptions are: Fall Through comment, goto, default, or exit
			# OR in additional exceptions to this statement.

			if ($incase && ($prevcase == 0) && ($case > 0) &&
				($before !~ /\bbreak\s*;/) &&
				($prev_line !~ /\bfall|goto|default\s*:|\bexit\b/i))
			{
				if ($enable[19])
				{
					display_typo_normal($filename, $line_current, 19, $_);
				}
			}

			# Remove any trailing case stmts on the same line
			# or any line continuation characters.
#
# TODO: Why did we care about/handle lines with continuation chars???
#					($case_line =~ /\s+\\$/)
#
			while ($case_line =~ /^\s+case\s+[\w:]*\w\s*:/)
			{
				$case_line = $';
			}

			$incase		= 1;
			$prevcase	= 1;
			$case		= 0;
		}
		elsif ($incase)
		{
			$case_line = $temp;
		}

		if ($incase)
		{
			if ($case_line =~ /\w/)
			{
				$case += 1;

				$prevcase = 0;

				# change quoted strings to something innocent
				$case_line =~ s/"[^"]*"/_/g;

				# Do we see something that ends the case statement?
				# Add in YY_BREAK for flex files
				if ($case_line =~ /\breturn\b | \bbreak\s*; | \bgoto\b |
									\bswitch\b | \bcontinue\b | YY_BREAK |
									exit\s*\(.+?\) | \bdefault\s*:/x)
				{
					$incase = 0;
				}
				elsif ($endcase_list_count)
				{
					while ($case_line =~ /\b(\w+)\b/g)
					{
						if (exists($endcase_list{$1}))
						{
							$incase = 0;
							last;
						}
					}
				}
			}
			# Handle "fall [through|thru|0]", and "no break" comments
			if (m#//.*fall | /\*.*fall | 
				  //.*no.*?break | /\*.*no.*?break #ix)
			{
				$prevcase	= 0;
				$incase		= 0;
			}
		}

		# Count the number of close curly braces
		while ($temp_pack =~ /\}/g)
		{
			$curly_braces -= 1;
		}

		if ($curly_braces < 0) 
		{
			$curly_braces = 0;
		}
		
		# Remember previous line, only if it's not empty
		if ($temp_pack =~ /\S/)
		{
			$prev = $temp_pack;

			# Only keep stuff that's part of the current statement,
			# i.e. anything after the last semicolon
			if ($prev_pack =~ /;([^;]*)$/)
			{
				$prev_pack = $1;
			}

			# Eat the CRLF, if any
			chomp($prev_pack);

			#
			# It's faster to use substr instead of regexp to pull
			# last chars off string for comparison
			#

			my $last;
			my $first;

			if ($prev ne '')
			{
				$first= substr($prev, 0, 1);
			}
			else
			{
				$first = '#';
			}

			# Add in a "#" if the prev string ends in an
			# alphanum char and the current string begins with one

			if (($prev_char_last =~ /\w/) && ($first =~ /\w/))
			{
				$prev_pack = join("", $prev_pack, "#", $prev);
			}
			else
			{
				$prev_pack = join("", $prev_pack, $prev);
			}

			if (length($prev) > 1)
			{
				$prev_char_last = substr($prev, -2, 1);
				if ((substr($prev, -1, 1) ne "\n") && ($line_current != scalar(@lines)))
				{
					die "$filename ($line_current):bad line ending '", substr($prev, -1, 1), "'\n";
				}
			}
			else
			{
				$prev_char_last = $prev;
			}

			if (0 != $curly_braces)
			{
				$prev_pack_code = $prev_pack;

				# Remove any parenthesized expressions in previous line
				while ($prev =~ /\([^\(\)]*\)/)
				{
					$prev =~ s/\([^\(\)]*\)/_/g;
				}
			}
		}

		if (0 == $curly_braces)
		{
			clear_new_function();

			$prev = '';
			$prev_pack_code = '';
			$prev_line = '';

			my $var_info;

			if (($var_count > 0) && $enable[27] && defined(@unchecked_vars))
			{
				foreach $var_info (@unchecked_vars)
				{
					if (($VAR_UNUSED == $var_info->{FUNC}->{REPORT}) && 
						$var_info->{FUNC}->{CHECK})
					{
						my $func_info = $var_info->{FUNC};

						display_typo($filename, $func_info->{LINE}, 
									"no immediate $func_info->{TYPE} check", 27, 
									"$func_info->{CALL_SHOW} [$var_info->{NAME}]\n");
					}
				}
			}

			$try		= '';
			$try_body	= '';
			$try_line	= 0;
			$try_unbalanced_parens = 0;

			$var_count = 0;

			undef %vars;
			undef %vars_sizeof;
			undef @unchecked_vars;
		}
		else
		{
			# Remember previous line unless it is blank.
			if ($incase && ($_ =~ /\S/))
			{
				$prev_line = $_;
			}
		}

		if ($enable_changes)
		{
			@enable = @enable_main;
		}
	}

	clear_statement();

	if ($do_ifdef)
	{
		# Sanity check - everything should balance out
		if ($#preprocess > 0)
		{
			warn ">> $filename: wrong number of preprocessor commands\n>> = $#preprocess '@preprocess'\n";
			print ">> $filename: wrong number of preprocessor commands\n>> = $#preprocess '@preprocess'\n";
		}

		@preprocess = ();
		push(@preprocess, 1);
	}

	if ($KLOC_NONE != $show_kloc)
	{
		print_file_kloc($filename, 0);
	}	

	undef %vars;
	undef @unchecked_vars;
	undef @braces;
	$brace_level = 0;

	undef @lines;
}

if ($enable_main[36])
{
	my $define;
	my $len = 0;

	# Find the longest define symbol
	foreach $define (keys(%define_hash))
	{
		if (length($define) > $len)
		{
			$len = length($define);
		}
	}

	# create the format string
	$len = join("", "%", $len, "s");

	# print out each define symbol and its count
	foreach $define (sort keys(%define_hash))
	{
		printf "// $len %d\n", $define, $define_hash{$define};
	}
}

if ($show_stats)
{
	my $func;
	my $len_func	= length("Comments:");
	my $len_result;

	my $print_str;

	if ($stats{COMMENTS} > 0)
	{
		# adjust for commas in displayed number
		$len_result = length($stats{COMMENTS}) + 
						int((length($stats{COMMENTS}) - 1) / 3);	
	}
	else
	{
		$len_result = 0;
	}

	foreach $func (sort keys(%found_function))
	{
		if (length($func) > $len_func)
		{
			$len_func = length($func);
		}

		if (length($found_function{$func}) > $len_result)
		{
			$len_result = length($found_function{$func});
		}
	}

	$len_result += int(($len_result-1)/3);

	if ($len_func < 1)
	{
		$len_func = 1;
	}
	if ($len_result < 1)
	{
		$len_result = 1;
	}

	$print_str = join("", "%-", $len_func, "s %", $len_result, "s");

	print   "//\n",
			"// Stats:\n",
			"//", '-' x ($len_func + $len_result + 2), "\n";

	printf  "// $print_str\n", "Comments:", commify_number($stats{COMMENTS});

	foreach $func (sort keys(%found_function))
	{
		printf "// $print_str\n", $func, commify_number($found_function{$func});
	}

	print   "//\n//\n";
}

if ($KLOC_NONE != $show_kloc)
{
	print_file_kloc("Totals", 1);
}	

if ($show_time)
{
	my $end;

	$end = localtime;

	if (0 == $output_xml)
	{
		print "// FILES: ", commify_number($stats{FILES}), "\n";
		print "// FUNCS: ", commify_number($stats{FUNCTIONS}), "\n";
		print "// SEMIS: ", commify_number($stats{SEMICOLONS}), "\n";
		print "// COMMS: ", commify_number($stats{COMMENTS}), "\n";
		print "// LINES: ", commify_number($stats{LINES}), "\n";
		print "// CHARS: ", commify_number($stats{CHARS}), "\n";
		print "// TYPOS: ", commify_number($stats{TYPOS}), "\n";
		print "// START: $now\n";
		print "// STOP:  $end\n";
	}
	else
	{
		if (0 == $stats{TYPOS})
		{
			print "\<\?xml version=\"1.0\" encoding=\"UTF-8\"\?\>\<DEFECTS FoundBy=\"TYPO.PL $SCRIPT_VERSION\"\>";
		}
		print "\n";
		print "\<FILES\>", commify_number($stats{FILES}), "\<\/FILES\>\n";
		print "\<FUNCS\>", commify_number($stats{FUNCTIONS}), "\<\/FUNCS\>\n";
		print "\<SEMIS\>", commify_number($stats{SEMICOLONS}), "\<\/SEMIS\>\n";
		print "\<COMMS\>", commify_number($stats{COMMENTS}), "\<\/COMMS\>\n";
		print "\<LINES\>", commify_number($stats{LINES}), "\<\/LINES\>\n";
		print "\<CHARS\>", commify_number($stats{CHARS}), "\<\/CHARS\>\n";
		print "\<TYPOS\>", commify_number($stats{TYPOS}), "\<\/TYPOS\>\n";
		print "\<START\>$now\<\/START\>\n";
		print "\<STOP\>$end\<\/STOP\>\n";
	}
}

if ((0 != $output_xml) && ($show_time || (0 != $stats{TYPOS})))
{
	print "\<\/DEFECTS\>";
}


sub commify_number
{
	my ($text) = @_;

	1 while ($text =~ s/(.*\d)(\d\d\d)/$1,$2/);

	return scalar $text;
}

sub clear_function
{
	%function_call = (
		NAME	=> '',
		LINE	=> 0,
		BEFORE	=> '',
		PARAMS	=> '',
		PARENS	=> 0
	);
}

sub clear_new_function
{
	$before_new		= '';
	$new_line		= 0;
	$new_params		= '';
}

sub add_to_function_list
{
	my ($list, $value, $op) = @_;
	my @functions;
	my $function;

	# Convert string to array of function names
	@functions = split(/,/, $list);

	# Add each function to the function hash
	foreach $function (@functions)
	{
		if (exists($function_list{$function}))
		{
			if ($op eq $OP_INVERT)
			{
				$function_list{$function} &= ~($value);
			}
			else
			{
				$function_list{$function} |= $value;
			}
		}
		else
		{
			if ($op eq $OP_INVERT)
			{
				$function_list{$function} = 0;
			}
			else
			{
				$function_list{$function} = $value;
			}
		}
	}
}

sub parse_options
{
	my $arg_index = 0;
	my %fn_opts = (
		"BUFFERCHARS:"	=> $BUFFER_CHARS_FUNCTION,
		"HANDLE:"	=> $HANDLE_FUNCTION,
		"HR:"		=> $HRESULT_FUNCTION,
		"INVALID:"	=> $INVALID_HANDLE,
		"LEN:"		=> $LENGTH_FUNCTION,
		"OVERFLOW:"	=> $OVERFLOW_FUNCTION,
		"REALLOC:"	=> $REALLOC_FUNCTION,
		"REG:"		=> $REG_FUNCTION,
		"RPC:"		=> $RPC_FUNCTION,
		"SAFEASSERT:"	=> $SAFEASSERT_FUNCTION,
		"THROW:"	=> $THROW_FUNCTION,
		"VOID:"		=> $VOID_FUNCTION,
		"ALLOW:"	=> $DISALLOW_FUNCTION,
		"DISALLOW:"	=> $DISALLOW_FUNCTION,
	);

	my %options_hash = (
		'-cfr:' => 0,
		'-checked:' => 0,
		'-constant:' => 0,
		'-define:' => 0,
		'-disable:' => 0,
		'-enable:' => 0,
		'-endcase:' => 0,
		'-extract_strings:' => 0,
		'-fn:' => 0,
		'-h' => 0,
		'-help' => 0,
		'-ifdef' => 0,
		'-ignore:' => 0,
		'-ignore_result:' => 0,
		'-ignore_string:' => 0,
		'-kernel_code' => 0,
		'-kloc:' => 0,
		'-log_functions' => 0,
		'-new:' => 0,
		'-newer:' => 0,
		'-noderef:' => 0,
		'-nonbuffered' => 0,
		'-notypo' => 0,
		'-optiondir:' => 0,
		'-optionfile:' => 0,
		'-output_xml' => 0,
		'-showprogress' => 0,
		'-showstats' => 0,
		'-showtime' => 0,
		'-string:' => 0,
		'-temp_defined:' => 0,
		'-use_build_dat' => 0,
		'-version:' => 0,
		'-?' => 0,
		'#' => 0,
	);

OPTION:
	# check to see if there are any options to parse
	while (($#_ >= $arg_index) &&
			(($_[$arg_index] eq "") ||
			 ($_[$arg_index] =~ /(^-\w+\:? | ^\# | ^-\? )(.*)/x)))
	{
		my $option_word = $1;
		my $rest_of_line = $2;

		if (($option_word ne '') && !exists($options_hash{$option_word}))
		{
			print STDERR "Unknown option: '$_[$arg_index]' OPT:'$option_word'\n";
		}
		elsif ($_[$arg_index] eq "")
		{
			# do nothing
		}
		# Check to see if we should show progress of scanning
		elsif ($option_word eq "-log_functions") 
		{
			$log_functions = 1;
			@func_output_str = ("// FUNCTION ", "\t", "\n");
		}
		# Check to see if we should not report certain cases
		elsif (($option_word eq "-disable:") ||
				($option_word eq "-enable:"))
		{
			my $disenable = $rest_of_line;
			my $value;
			my $option = $option_word;
			my $case;
			my @cases;

			if ($disenable eq '')
			{
				my $error = "No params for $option option.";
				Usage($error);
			}

			if ($option eq "-disable:")
			{
				$value = 0;
			}
			else
			{
				$value = 1;
			}

			# split up the disable params into an array
			#
			# params must be comma-separated
			@cases = split(/,/, $disenable);

			# operate on each section
			foreach $case (@cases)
			{
				my $begin;
				my $end;

				# Range? i.e. "1-10"
				if ($case =~ /(\d+)\-(\d+)/)
				{
					$begin = $1;
					$end = $2;
				}
				else
				{
					# disable this specific case
					$begin = $case;
					$end = $case;
				}

				# Validity checks:
				# has to be valid case number, must be an integer, begin <= end
				#
				if (($begin >= $CASE_MIN) && ($begin <= $CASE_MOST) &&
					($begin !~ /\./) &&
					($end >= $CASE_MIN) && ($end <= $CASE_MOST) && 
					($end !~ /\./) &&
					($begin <= $end))
				{
					# Disable the specified cases
					for ($begin..$end)
					{
						$enable_main[$_] = $value;
					}
				}
				else
				{
					$error = "Bad $option option '$case' [valid = $CASE_MIN .. $CASE_MOST]";
					Usage($error);
				}
			}
		}
		# Check to see if there are files we should ignore
		elsif ($option_word eq "-ignore:")
		{
			my $ignore = $rest_of_line;

			if ($ignore eq '')
			{
				my $error = "No params for ignore option.";
				Usage($error);
			}

			# Quote "\" or "."
			$ignore =~ s/([\\\.])/\\$1/g;

			# Convert '*' to '.*'
			$ignore =~ s/\*/\.\*/g;

			# Convert "," to "$|"
			# patterns match the end of the filename
			$ignore =~ s/,/\$\|/g;

			# Make sure the last pattern matches at filename end 
			if ($ignore_files)
			{
				$ignore_files = join("", $ignore_files, "|");
			}

			$ignore_files = join("", $ignore_files, $ignore, "\$");
		}
		elsif ($option_word eq "-newer:")
		{
			my @days_in_year = (-1, 30, 58, 89, 119, 150, 180, 
								211, 242, 272, 303, 333, 364);

			my ($year, $month, $day, $hour, $minute) = split(/,/, $rest_of_line);
			my $days;
			my $days1970;

			if (($year < 1970) || ($year > 2038))
			{
				my $error = "Bad year: $year";
				Usage($error);
			}

			if (($month < 1) || ($month > 12))
			{
				my $error = "Bad month: $month";
				Usage($error);
			}

			if (($day < 1) || ($day > 31))
			{
				my $error = "Bad day: $day";
				Usage($error);
			}

			if (($hour < 0) || ($hour > 23))
			{
				my $error = "Bad hour: $hour";
				Usage($error);
			}

			if (($minute < 0) || ($minute > 59))
			{
				my $error = "Bad minute: $minute";
				Usage($error);
			}

			$year -= 1900;

			#
			# Calculate days from the beginning of the epoch to
			# the specified year.
			#
			$days1970 = (($year - 70) * 365) + (($year - 1) >> 2) - 17;

			# Days since 1970 until the specified year, month, and day
			$days = $days1970 + $days_in_year[$month-1] + $day;

			# If we're in a leap year and it's after Feb, add 1
			if ((0 == ($year & 3)) && ($month > 2))
			{
				$days += 1;
			}

			# Convert days, hours, & minutes to seconds
			$newer_seconds = (((($days * 24) + $hour) * 60) + $minute) * 60;
		}
		# Check to see if we should show the time at begin/end of scan
		elsif ($option_word eq "-showtime")
		{
			$show_time = 1;
		}
		# Check to see if we should show statistics at the end
		elsif ($option_word eq "-showstats")
		{
			$show_stats = 1;
		}
		# Check to see if we should show progress as we go
		elsif ($option_word eq "-showprogress")
		{
			$show_progress = 1;
		}
		# Check to see if we should watch other functions
		elsif (($option_word eq "-cfr:") ||
				($option_word eq "-fn:"))
		{
			my $list = $rest_of_line;
			my $value;
			my $op = $OP_ADD;

			if ($list eq '')
			{
				my $error = "No params for '$option_word' option.";
				Usage($error);
			}

			if ($option_word eq "-cfr:")
			{
				$value = $CHECK_FUNCTION;
			}
			elsif ($option_word eq "-fn:")
			{
				my $type = '';

				if ($list =~ /(^[A-Z]+\:) (.*)/x)
				{
					my $option = $1;

					if (exists($fn_opts{$option}))
					{
						$type = $option;
						$value = $fn_opts{$option};
						$list = $2;

						if ($option eq 'ALLOW:')
						{
							$op = $OP_INVERT;
						}
					}
				}

				if ($type eq '')
				{
					my $error = "Bad params for '-fn' option = '$list'.";
					Usage($error);
				}
			}

			add_to_function_list($list, $value, $op);
		}
		# Other constants to ignore for cases 28/29
		elsif ($option_word eq "-string:")
		{
			my $list = $rest_of_line;
			my $type;
			my $op;
			my $value;
			my @strings;
			my $string;

			if ($list eq '')
			{
				my $error = "No params for '$option_word' option.";
				Usage($error);
			}

			if ($list =~ /(^ALLOW: | ^DISALLOW:) (.*)/x)
			{
				$type = $1;
				$list = $2;
			}
			else
			{
				my $error = "Bad params for '-string' option = '$list'.";
				Usage($error);
			}

			if ($type eq "ALLOW:")
			{
				$value = $DISALLOW_FUNCTION;
				$op = $OP_INVERT;
			}
			elsif ($type eq "DISALLOW:")
			{
				$value = $DISALLOW_FUNCTION;
				$op = $OP_ADD;
			}

			# Convert string to array of strings
			@strings = split(/,/, $list);

			# Add each string to the string hash
			foreach $string (@strings)
			{
				if (exists($string_list{$string}))
				{
					if ($op == $OP_INVERT)
					{
						$string_list{$string} &= ~($value);
					}
					else
					{
						$string_list{$string} |= $value;
					}
				}
				else
				{
					if ($op != $OP_INVERT)
					{
						$string_list{$string} = $value;
					}
				}
			}
		}
		# Other constants to ignore for cases 28/29
		elsif ($option_word eq "-constant:")
		{
			my $list = $rest_of_line;
			my @constants;
			my $constant;

			if ($list eq '')
			{
				my $error = "No params for constant option.";
				Usage($error);
			}

			# Convert string to array of constant names
			@constants = split(/,/, $list);

			# Add each constant to the constant hash
			foreach $constant (@constants)
			{
				$constant_list{$constant} = 1;
			}
		}
		elsif ($option_word eq "-new:")
		{
			my $list = $rest_of_line;
			my @functions;
			my $function;

			if ($list eq '')
			{
				my $error = "No params for '$option_word' option.";
				Usage($error);
			}

			# Convert string to array of function names
			@functions = split(/,/, $list);

			# Add each function to the function hash
			foreach $function (@functions)
			{
				$keyword_list{$function} = $KEYWORD_NEW;
			}
		}
		elsif ($option_word eq "-optiondir:")
		{
			my $list = $rest_of_line;
			my @dirs;
			my $dir;

			if ($list eq '')
			{
				my $error = "No params for '$option_word' option.";
				Usage($error);
			}

			# Convert string to array of function names
			@dirs = split(/,/, $list);

			foreach $dir (@dirs)
			{
				if ($dir eq '')
				{
					Usage("Empty dir for '$option_word' option.");
				}

				if (substr($dir, -1, 1) ne "\\")
				{
					$dir .= "\\";
				}
			}

			# Append to option_dirs array
			push(@option_dirs, @dirs);
		}
		elsif ($option_word eq "-optionfile:")
		{
			my $file = $rest_of_line;
			my @options;
			my $option;
			my $args;

			if (!(-T $file))
			{
				my $last_try = 0;
				my $dir;

				# See if it's in one of the option dirs
				foreach $dir (@option_dirs)
				{
					my $try_file = $dir . $file;

					if (-T $try_file)
					{
						$last_try = 1;
						$file = $try_file;
						last;
					}
				}

				if (0 == $last_try)
				{
					Usage("Bad option file - not text: '$file'\n");
				}
			}

			if (!open(OPTIONFILE, $file))
			{
				print STDERR "Can't open $file -- continuing...\n";
				next OPTION;
			}

			@options = <OPTIONFILE>;

			close OPTIONFILE;

			if ($#options < 0)
			{
				Usage("Empty optionfile: '$file'\n");
			}

			foreach $option (@options)
			{
				chomp($option);

				# remove end of line comments
				$option =~ s/\#[^\#]*$//;

				# remove leading and trailing whitespace
				$option =~ s/^\s+//;
				$option =~ s/\s+$//;
			}

			$args = parse_options(@options);
			if ($args <= $#options)
			{
				$args += 1;
				Usage("Bad option: line $args '$file'\n");
			}

			$option_files += 1;
		}
		# Check to see if we should watch other functions
		elsif ($option_word eq "-checked:")
		{
			my $checked = $rest_of_line;
			my @functions;
			my $function;

			if ($checked eq '')
			{
				my $error = "No params for checked option.";
				Usage($error);
			}

			# Convert string to array of function names
			@functions = split(/,/, $checked);

			$checked_list_count	+= scalar(@functions);

			# Add each function to the function hash
			foreach $function (@functions)
			{
				$checked_list{$function} = 1;
			}
		}
		elsif ($option_word eq "-ignore_result:")
		{
			my $ignore = $rest_of_line;
			my @functions;
			my $function;

			if ($ignore eq '')
			{
				my $error = "No params for ignore_result option.";
				Usage($error);
			}

			# Convert string to array of function names
			@functions = split(/,/, $ignore);

			$ignore_result_list_count	+= scalar(@functions);

			# Add each function to the function hash
			foreach $function (@functions)
			{
				$ignore_result_list{$function} = 1;
			}
		}
		# Check to see if we should ignore other functions
		elsif ($option_word eq "-noderef:")
		{
			my $noderef = $rest_of_line;
			my @functions;
			my $function;

			if ($noderef eq '')
			{
				my $error = "No params for noderef option.";
				Usage($error);
			}

			# Convert string to array of function names
			@functions = split(/,/, $noderef);

			$noderef_list_count	+= scalar(@functions);

			# Add each function to the function hash
			foreach $function (@functions)
			{
				$noderef_list{$function} = 1;
			}
		}
		# Check to see if we should ignore other functions
		elsif ($option_word eq "-endcase:")
		{
			my $user_functions	= $rest_of_line;
			my @functions;
			my $function;

			if ($user_functions eq '')
			{
				my $error = "No params for endcase option.";
				Usage($error);
			}

			# Convert string to array of function names
			@functions = split(/,/, $user_functions);

			$endcase_list_count	+= scalar(@functions);

			# Add each function to the function hash
			foreach $function (@functions)
			{
				$endcase_list{$function} = 1;
			}
		}
		# Check to see if we can handle this optionfile
		elsif ($option_word eq "-version:")
		{
			my $version = $rest_of_line;

			if ($version eq '')
			{
				my $error = "No param for version option.";
				Usage($error);
			}

			if ($version > $SCRIPT_VERSION)
			{
				my $error = "Unacceptable version: $version ( $SCRIPT_VERSION ).";
				Usage($error);
			}
		}
		elsif ($option_word eq "-nonbuffered")
		{
			$| = 1;
		}
		elsif ($option_word eq "-notypo")
		{
			$no_typo = 1;
		}
		elsif ($option_word eq "-temp_defined:")
		{
			my $temp_defined	= $rest_of_line;
			my @defines;
			my $define;

			if ($temp_defined eq '')
			{
				my $error = "No params for temp_defined option.";
				Usage($error);
			}

			# Convert string to array of function names
			@defines = split(/,/, $temp_defined);

			# Add each function to the function hash
			foreach $define (@defines)
			{
				$temp_defined_list{$define} = 1;
			}
		}
		elsif ($option_word eq "-kloc:")
		{
			my $kloc	= $rest_of_line;

			if (($kloc eq '') || ($kloc !~ /^\d+$/))
			{
				my $error;
				
				if ($kloc eq '')
				{
					$error = "No param for kloc option.";
				}
				else
				{
					$error = "Invalid param for kloc option.";
				}

				Usage($error);
			}

			if (($kloc > $KLOC_NONE) && ($kloc < $KLOC_MAX))
			{
				$show_kloc = $kloc;
			}
			else
			{
				Usage("Out of range param for kloc option.");
			}
		}
		elsif ($option_word eq "-extract_strings:")
		{
			my $string	= $rest_of_line;

			if (($string eq '') || ($string !~ /^[cmrs]{1,4}$/))
			{
				my $error;

				if ($string eq '')
				{
					$error = "No param for extract_string option.";
				}
				else
				{
					$error = "Invalid param for extract_string option.";
				}

				Usage($error);
			}

			if ($string =~ /m/)
			{
				$do_strings |= $STRINGS_MC;
			}
			if ($string =~ /c/)
			{
				$do_strings |= $STRINGS_CODE;
			}
			if ($string =~ /r/)
			{
				$do_strings |= $STRINGS_RSRC;
			}
			if ($string =~ /s/)
			{
				$do_strings |= $STRINGS_STRIP;
			}
		}
		elsif ($option_word eq "-ignore_string:")
		{
			my $ignore	= $rest_of_line;
			my @strings;
			my $strings;

			if ($ignore eq '')
			{
				my $error = "No params for ignore_string option. $_[$arg_index]";
				Usage($error);
			}

			# Convert string to array of function names
			@strings = split(/,/, $ignore);

			# Add each function to the function hash
			foreach $string (@strings)
			{
				$ignore_strings{$string} = 1;
			}
		}
		elsif ($option_word eq "-ifdef")
		{
			if ($rest_of_line ne '')
			{
				Usage("No params needed for ifdef option.");
			}

			$do_ifdef = 1;
		}
		elsif ($option_word eq "-define:")
		{
			my $temp_defined	= $rest_of_line;
			my @defines;
			my $define;

			if ($temp_defined eq '')
			{
				my $error = "No params for define option.";
				Usage($error);
			}

			# Convert string to array of function names
			@defines = split(/,/, $temp_defined);

			# Add each function to the function hash
			foreach $define (@defines)
			{
				if ($define =~ /=/)
				{
					my $def = $`;
					my $val = $';
					$def =~ tr/ \t//d;
					$val =~ tr/ \t//d;

					$user_define_hash{$def} = $val;
				}
				else
				{
					$user_define_hash{$define} = '';
				}
			}
		}
		elsif ($option_word eq "-use_build_dat")
		{
			if (0 == $use_build_dat)
			{
				$use_build_dat = 1;
				find_and_load_build_db();
			}
		}
		elsif ($option_word eq "-output_xml")
		{
			$output_xml = 1;
		}
		elsif ($option_word eq "-kernel_code")
		{
			$kernel_code = 1;
		}
		elsif ($option_word eq "#")
		{
		}
		elsif (($option_word eq "-?") ||
				($option_word eq "-h") ||
				($option_word eq "-help"))
		{
			Usage("");
		}
		else
		{
			my $error;

			$arg_index += 1;
			$error = "Bad option" . (($#_ == 0) ? "" : "s") . " (@_) " .
					 "Bad arg # $arg_index";

			Usage($error);
		}

		$arg_index += 1;
	}

	return $arg_index;
}

sub Usage
{
	local($error) = @_;

	die "\n$error\n",
		"$TYPO_VERSION\n\n",
		"Usage: perl typo.pl [options] [c|-|<file>]\n",
		"Options:\n",
		"    [-cfr:<function1>[,<function2>,...]]\n",
		"    [-checked:<function1>[,<function2>,...]]\n",
		"    [-constant:<constant1>[,<constant2>,...]]\n",
		"    [-define:<define1[=value1]>[,<define2[=value2]>,...]]\n",
		"    [-disable:<case|case-range>[,<case|case-range>]]\n",
		"    [-enable:<case|case-range>[,<case|case-range>]]\n",
		"    [-endcase:<function1>[,<function2>,...]]\n",
		"    [-extract_strings:c|m|r|s]\n",
		"    [-fn:\n",
		"      <BUFFERCHARS:|HANDLE:|HR:|INVALID:|LEN:|OVERFLOW:|REALLOC:|REG:|RPC:|SAFEASSERT:|THROW:|VOID:>\n",
		"      <fn1>[,<fn2>,...]]\n",
		"    [-h]\n",
		"    [-help]\n",
		"    [-ifdef]\n",
		"    [-ignore:<pattern1>[,<pattern2>,...]]\n",
		"    [-ignore_result:<function1>[,<function2>,...]]\n",
		"    [-ignore_string:<string1>[,<string2>,...]]\n",
		"    [-kernel_code]\n",
		"    [-kloc:<1 | 2>]\n",
		"    [-log_functions]\n",
		"    [-new:<function1>[,<function2>,...]]\n".
		"    [-newer:<yr=1970-2038>,<mon=1-12>,<day=1-31>,<hr=0-23>,<minute=0-59>]\n",
		"    [-noderef:<function1>[,<function2>,...]]\n",
		"    [-nonbuffered]\n",
		"    [-notypo]\n",
		"    [-optiondir:<directory1>[,<directory2>[,...]]\n",
		"    [-optionfile:<filename>]\n",
		"    [-output_xml]\n",
		"    [-showprogress]\n",
		"    [-showstats]\n",
		"    [-showtime]\n",
		"    [-string:[ALLOW:|DISALLOW:]<string1>[,<string2>,...]]\n",
		"    [-temp_defined:<define1>[,<define2>,...]]\n",
		"    [-use_build_dat]\n",
		"    [-version:<version#>\n",
		"    [-?]\n";
}

sub init_function_list
{
	%function_list = (
		RegOpenKeyEx	=> $CHECK_FUNCTION,
		RegOpenKeyExA	=> $CHECK_FUNCTION,
		RegOpenKeyExW	=> $CHECK_FUNCTION,
		RegOpenKey		=> $CHECK_FUNCTION,
		RegOpenKeyA		=> $CHECK_FUNCTION,
		RegOpenKeyW		=> $CHECK_FUNCTION,
		CreateThread	=> $CHECK_FUNCTION,
		CreateWindowEx	=> $CHECK_FUNCTION,
		CreateWindowExA	=> $CHECK_FUNCTION,
		CreateWindowExW	=> $CHECK_FUNCTION,
		CreateWindow	=> $CHECK_FUNCTION,
		CreateWindowA	=> $CHECK_FUNCTION,
		CreateWindowW	=> $CHECK_FUNCTION,
		CreateFile		=> $INVALID_HANDLE,
		CreateFileA		=> $INVALID_HANDLE,
		CreateFileW		=> $INVALID_HANDLE,
		GetStdHandle	=> $INVALID_HANDLE,
		FindFirstPrinterChangeNotification	=> $INVALID_HANDLE,
		FindFirstFileEx	=> $INVALID_HANDLE,
		FindFirstFileExA=> $INVALID_HANDLE,
		FindFirstFileExW=> $INVALID_HANDLE,
		FindFirstFile	=> $INVALID_HANDLE,
		FindFirstFileA	=> $INVALID_HANDLE,
		FindFirstFileW	=> $INVALID_HANDLE,
		FindFirstChangeNotification	=> $INVALID_HANDLE,
		FindFirstChangeNotificationA=> $INVALID_HANDLE,
		FindFirstChangeNotificationW=> $INVALID_HANDLE,
		CreateNamedPipe	=> $INVALID_HANDLE,
		CreateNamedPipeA=> $INVALID_HANDLE,
		CreateNamedPipeW=> $INVALID_HANDLE,
		CreateMailslot	=> $INVALID_HANDLE,
		CreateMailslotA	=> $INVALID_HANDLE,
		CreateMailslotW	=> $INVALID_HANDLE,
		CreateConsoleScreenBuffer	=> $INVALID_HANDLE,
		SetupOpenInfFile=> $INVALID_HANDLE,
		SetupOpenInfFileA=> $INVALID_HANDLE,
		SetupOpenInfFileW=> $INVALID_HANDLE,
		SetupOpenFileQueue	=> $INVALID_HANDLE,
		SetupInitializeFileLog	=> $INVALID_HANDLE,
		SetupInitializeFileLogA	=> $INVALID_HANDLE,
		SetupInitializeFileLogW	=> $INVALID_HANDLE,
		SetupOpenMasterInf	=> $INVALID_HANDLE,
		FillMemory	=> $FILLMEM_FUNCTION,
		RtlFillMemory=> $FILLMEM_FUNCTION,
		ZeroMemory  => $FILLMEM_FUNCTION,
		memset		=> $MEMCRT_FUNCTION,
		memchr		=> $MEMCRT_FUNCTION,
		memccpy		=> $MEMCRT_FUNCTION,
		_memccpy		=> $MEMCRT_FUNCTION,
		wmemchr		=> $MEMCRT_FUNCTION,
		alloca		=> $ALLOCA_FUNCTION,
		_alloca		=> $ALLOCA_FUNCTION,
		LocalReAlloc=> $LOCALREALLOC_FUNCTION,
		GlobalReAlloc=> $GLOBALREALLOC_FUNCTION,
		realloc		=> $REALLOC_FUNCTION,
		HeapReAlloc	=> $HEAPREALLOC_FUNCTION,
		_lcreat		=> $HFILE_FUNCTION,
		_lopen		=> $HFILE_FUNCTION,
		OpenFile	=> $HFILE_FUNCTION,
		StrCpyA		=> $OVERFLOW_FUNCTION,
		StrCpy		=> $OVERFLOW_FUNCTION,
		StrCpyW		=> $OVERFLOW_FUNCTION,
		lstrcpy		=> $OVERFLOW_FUNCTION,
		lstrcpyA	=> $OVERFLOW_FUNCTION,
		lstrcpyW	=> $OVERFLOW_FUNCTION,
		strcpy		=> $OVERFLOW_FUNCTION,
		strcat		=> $OVERFLOW_FUNCTION,
		StrCatA		=> $OVERFLOW_FUNCTION,
		StrCatW		=> $OVERFLOW_FUNCTION,
		StrCat		=> $OVERFLOW_FUNCTION,
		lstrcatA	=> $OVERFLOW_FUNCTION,
		lstrcatW	=> $OVERFLOW_FUNCTION,
		lstrcat		=> $OVERFLOW_FUNCTION,
		wcscpy		=> $OVERFLOW_FUNCTION,
		wcscat		=> $OVERFLOW_FUNCTION,
		_mbscpy		=> $OVERFLOW_FUNCTION,
		_mbscat		=> $OVERFLOW_FUNCTION,
		_tcscpy		=> $OVERFLOW_FUNCTION,
		_tcscat		=> $OVERFLOW_FUNCTION,
		CreateFileMapping => $HANDLE_FUNCTION,
		CreateFileMappingA => $HANDLE_FUNCTION,
		CreateFileMappingW => $HANDLE_FUNCTION,
		ExAllocatePool => $EXALLOCATE_FUNCTION,
		ExAllocatePoolWithTag => $EXALLOCATE_FUNCTION,
		ExAllocatePoolWithQuota => $EXALLOCATE_FUNCTION,
		ExAllocatePoolWithQuotaTag => $EXALLOCATE_FUNCTION,
		ExAllocatePoolWithTagPriority => $EXALLOCATE_FUNCTION,
	);
}

sub init_type_hash
{ 	
	%type_hash = (
		ULONG => 1, PULONG => 1, USHORT => 1, PUSHORT => 1,
		UCHAR => 1, PUCHAR => 1, PSZ => 1, DWORD => 1,
		BOOL => 1, BYTE => 1, WORD => 1, FLOAT => 1,
		PFLOAT => 1, PBOOL => 1, LPBOOL => 1, PBYTE => 1,
		LPBYTE => 1, PINT => 1, LPINT => 1, PWORD => 1,
		LPWORD => 1, LPLONG => 1, PDWORD => 1, LPDWORD => 1,
		LPVOID => 1, LPCVOID => 1, INT => 1, UINT => 1,
		PUINT => 1, ATOM => 1, HGLOBAL => 1, HLOCAL => 1,
		FARPROC => 1, WNDPROC => 1, HGDIOBJ => 1, HBITMAP => 1,
		HBRUSH => 1, HKEY => 1, HANDLE => 1, HDC => 1,
		HICON => 1, HCURSOR => 1, RECT => 1, RECTL => 1,
		POINT => 1, POINTL => 1, SIZE => 1, SIZEL => 1,
		POINTS => 1, DLGPROC => 1,
		ULONGLONG => 1, LONGLONG => 1, PLONGLONG => 1, PULONGLONG => 1,
	);
}

sub delete_unchecked_var
{
	my ($var, $indexStop) = @_;
	my $index;
	my $var_info;

	# Remove element from unchecked_vars array
	$index = scalar(@unchecked_vars) - 1;
	if ($index > $indexStop)
	{
		$index = $indexStop;
	}

	while ($index >= 0)
	{
		$var_info = $unchecked_vars[$index];

		if ($var_info->{EXPR} eq $var)
		{
			splice(@unchecked_vars, $index, 1);
			last;
		}

		$index--;
	}
}

sub case28
{
	my ($filename, $keyword, $line, $params) = @_;

	############################################################
	#
	# Look for multiple inequality comparisons of the same var
	# of the form: "if (X != 0 || X != 1)"
	#
	# The "||" should be "&&" otherwise, if X == 0, the second
	# expression will succeed or if X == 1, then the first
	# expression will succeed.
	#
	# We key off of a alphanumeric string, "!=", another
	# alphanumeric string followed by ")" and ending in "||".
	#
	# Then we need to make sure the alphanumeric strings are
	# variables and not numbers or constants (uppercase only).
	#
	if ($params =~ /([\w*\->\.\[\]\'\\\@]+)  
						\!= 
						([\w*\->\.\[\]\'\\\@]+)
						([\)]*) \|\| (.*)/x)
	{
		my $arg1 = $1;
		my $arg2 = $2;
		my $end_parens = $3;
		my $after = $4;
		my $end_parens_count = 0;

		while ($end_parens =~ /\)/g) 
		{
			$end_parens_count += 1;
		}

		# Weed out constants, assuming that they're all uppercase
		# add in the "\d+f" pattern to weed out floating pt numbers
		if ((($arg1 !~ /[a-z]/) && ($arg1 =~ /[A-Z_]{3,}/)) || 
			exists($constant_list{$arg1}) ||
			($arg1 =~ /0x[A-Fa-f0-9]+|\d+f?|L?\'|_/))
		{
			$arg1 = ' ';
		}
		else
		{
			$arg1 =~ s/(\W)/\\$1/g;
		}

		# Weed out constants, assuming that they're all uppercase
		# add in the "\d+f" pattern to weed out floating pt numbers
		if ((($arg2 !~ /[a-z]/) && ($arg2 =~ /[A-Z_]{3,}/)) || 
			exists($constant_list{$arg2}) ||
			($arg2 =~ /0x[A-Fa-f0-9]+|\d+f?|L?\'|_/))
		{
			$arg2 = ' ';
		}
		else
		{
			$arg2 =~ s/(\W)/\\$1/g;
		}

		# Look for 0 or more "(" followed by one of the args
		# from the first comparison, "!=" and another alphanumeric
		# string. Finally the chars after the second arg shouldn't
		# be +,-,*,/ or & since they mean that the second arg
		# may not be complete.
		#
		if ((($arg1 ne " ") &&
			(($after =~ /^ (\(*?) $arg1 \!= [\w*\->\.\[\]\'\\\@]+ [^\w\-\+\&\*\/]/x) ||
			 ($after =~ /^ (\(*?) [\w*\->\.\[\]\'\\\@]+ \!= $arg1 [^\w\-\+\&\*\/]/x))) ||
			(($arg2 ne " ") &&
			 (($after =~ /^ (\(*?) $arg2 \!= [\w*\->\.\[\]\'\\\@]+ [^\w\-\+\&\*\/]/x) ||
			  ($after =~ /^ (\(*?) [\w*\->\.\[\]\'\\\@]+ \!= $arg2 [^\w\-\+\&\*\/]/x))))
		{
			my $begin_parens = $1;
			while ($begin_parens =~ /\(/g) 
			{
				$end_parens_count -= 1;
			}

			if ($end_parens_count <= 0)
			{
				display_typo_normal($filename, $line, 28, "$keyword$params\n");
			}
		}
	}
}

sub case29
{
	my ($filename, $keyword, $line, $params) = @_;

	############################################################
	#
	# Look for multiple equality comparisons of the same var
	# of the form: "if (X == 0 && X == 1)"
	#
	# The "&&" should be "||" otherwise the expression will never
	# succeed.
	#
	# We key off of a alphanumeric string, "==", another
	# alphanumeric string followed by ")" and ending in "&&".
	#
	# Then we need to make sure the alphanumeric strings are
	# variables and not numbers or constants (uppercase only).
	#
	if ($params =~ /([\w*\->\.\[\]\'\\\@]+)
						==
						([\w*\->\.\[\]\'\\\@]+)
						([\)]*) \&\& (.*)/x)
	{
		my $arg1 = $1;
		my $arg2 = $2;
		my $end_parens = $3;
		my $after = $4;
		my $end_parens_count = 0;

		while ($end_parens =~ /\)/g) 
		{
			$end_parens_count += 1;
		}

		# Weed out constants, assuming that they're all uppercase
		# add in the "\d+f" pattern to weed out floating pt numbers
		if ((($arg1 !~ /[a-z]/) && ($arg1 =~ /[A-Z_]{3,}/)) || 
			exists($constant_list{$arg1}) ||
			($arg1 =~ /0x[A-Fa-f0-9]+|\d+f?|L?\'/))
		{
			$arg1 = ' ';
		}
		else
		{
			$arg1 =~ s/(\W)/\\$1/g;
		}

		# Weed out constants, assuming that they're all uppercase
		# add in the "\d+f" pattern to weed out floating pt numbers
		if ((($arg2 !~ /[a-z]/) && ($arg2 =~ /[A-Z_]{3,}/)) || 
			exists($constant_list{$arg2}) ||
			($arg2 =~ /0x[A-Fa-f0-9]+|\d+f?|L?\'/))
		{
			$arg2 = ' ';
		}
		else
		{
			$arg2 =~ s/(\W)/\\$1/g;
		}

		# Look for 0 or more "(" followed by one of the args
		# from the first comparison, "==" and another alphanumeric
		# string. Finally the chars after the second arg shouldn't
		# be +,-,*,/ or & since they mean that the second arg
		# may not be complete.
		#
		if ((($arg1 ne " ") &&
			(($after =~ /^ (\(*?) $arg1 == [\w*\->\.\[\]\'\\\@]+ [^\w\-\+\&\*\/]/x) ||
			 ($after =~ /^ (\(*?) [\w*\->\.\[\]\'\\\@]+ == $arg1 [^\w\-\+\&\*\/]/x))) ||
			(($arg2 ne " ") &&
			 (($after =~ /^ (\(*?) $arg2 == [\w*\->\.\[\]\'\\\@]+ [^\w\-\+\&\*\/]/x) ||
			  ($after =~ /^ (\(*?) [\w*\->\.\[\]\'\\\@]+ == $arg2 [^\w\-\+\&\*\/]/x))))
		{
			my $begin_parens = $1;

			while ($begin_parens =~ /\(/g) 
			{
				$end_parens_count -= 1;
			}

			if ($end_parens_count <= 0)
			{
				display_typo_normal($filename, $line, 29, "$keyword$params\n");
			}
		}
	}
}

sub valid_registry_return_values
{
	my ($reg_api, $before, $after) = @_;
	my $valid = 1;

	# If the Registry API is RegQueryMultipleValues, API docs list several expected return values
	if ($reg_api eq "RegQueryMultipleValues")
	{
		if (($before !~ /(ERROR_SUCCESS|ERROR_CANTREAD|ERROR_MORE_DATA|ERROR_TRANSFER_TOO_LONG)[!=]=\(*$/) &&
			($after !~ /^\)*[!=]=(ERROR_SUCCESS|ERROR_CANTREAD|ERROR_MORE_DATA|ERROR_TRANSFER_TOO_LONG)/))
		{
			$valid = 0;
		}
	}
	# If the Registry API is RegEnumXXX, API docs list a couple of expected return values
	elsif ($reg_api =~ /^RegEnum\w+/)
	{
		if (($before !~ /(ERROR_SUCCESS|ERROR_NO_MORE_ITEMS)[!=]=\(*$/) &&
			($after !~ /^\)*[!=]=(ERROR_SUCCESS|ERROR_NO_MORE_ITEMS)/))
		{
			$valid = 0;
		}
	}
	# If the Registry API is RegQueryXXX, API docs list a couple of expected return values
	elsif ($reg_api =~ /^RegQuery\w+/)
	{
		if (($before !~ /(ERROR_SUCCESS|ERROR_MORE_DATA)[!=]=\(*$/) &&
			($after !~ /^\)*[!=]=(ERROR_SUCCESS|ERROR_MORE_DATA)/))
		{
			$valid = 0;
		}
	}
	else
	{
		# Otherwise, Registry API docs list one expected return value
		if (($before !~ /ERROR_SUCCESS[!=]=\(*$/) &&
			($after !~ /^\)*[!=]=ERROR_SUCCESS/))
		{
			$valid = 0;
		}
	}

	return $valid;
}

sub case57
{
	my ($filename, $keyword, $line, $params) = @_;
	my $state = 0;
	my $parens_count;
	my $reg_api_pos;
	my $reg_api_word;
	my $prev_pos;
	my $i;
	my @reg_api_begin = ();
	my @reg_api_end = ();
	my @reg_api = ();

	# If the keyword is "switch" or there's no Reg API in the expression, punt
	if (($keyword eq 'switch') || ($params !~ /\bReg\w+\(/))
	{
		return;
	}

	# remove the outermost parens on the params
	$params =~ s/^\((.*?)\)$/$1/;

	# State machine
	#
	# state 0:
	#  no Reg API
	#   parse data until a Reg API is seen, bump 
	#
	# state 1:
	#  Reg API - keep track of beginning char pos
	#   count embedded parens until parens == 0 - keep track of end char pos
	#   go to state 0
	#
	while ($params =~ /(\bReg\w+\()|(\()|(\))/g)
	{
		if (0 == $state)
		{
			# Reg API seen?
			if ($1)
			{
				my $reg = $1;

				# calc the pos of the char at the start of the Reg API match
				$reg_api_pos = pos($params) - length($reg);

				# Remove the trailing parens on the keyword match
				$reg =~ s/\($//;

				# Do we recognize this RegX function?
				if (exists($function_list{$reg}))
				{
					$parens_count = 1;
					$state = 1;
					$reg_api_word = $reg;
				}
			}
		}
		elsif (1 == $state)
		{
			if ($1)
			{
				# If we see a Registry API within another Registry API
				# things aren't kosher
				die "Bad parsing at $filename ($line)!!!\n";
			}
			elsif ($2)
			{
				$parens_count += 1;
			}
			elsif ($3)
			{
				$parens_count -= 1;

				if (0 == $parens_count)
				{
					push(@reg_api_begin, $reg_api_pos);
					push(@reg_api_end, pos($params));
					push(@reg_api, $reg_api_word);

					$state = 0;

				}
			}
		}
	}

	# If no Registry APIs seen, punt
	if ($#reg_api_begin < 0)
	{
		return;
	}

	for ($i = 0, $prev_pos = 0; $i <= $#reg_api_begin; ++$i)
	{
		my $before = '';
		my $api_params = '';
		my $after = '';
		my $typo = 0;

		# IF we aren't at the last entry in the array we can use the following array entry
		# as an UPPER bound on the text to include after the Registry API

		if ($i < $#reg_api_begin)
		{
			my $pre = $reg_api_begin[$i] - $prev_pos;
			my $skip= $reg_api_end[$i] - $reg_api_begin[$i];
			my $post= $reg_api_begin[$i+1] - $reg_api_end[$i];

			($before, $api_params, $after) = unpack("x$prev_pos a$pre a$skip a$post", $params);
		}
		else
		{
			# Otherwise we grab everything after the Registry API call for consideration

			my $pre = $reg_api_begin[$i] - $prev_pos;
			my $skip= $reg_api_end[$i] - $reg_api_begin[$i];

			($before, $api_params, $after) = unpack("x$prev_pos a$pre a$skip a*", $params);
		}

		#
		# We try to transform text of the form:
		#
		#   ERROR_SUCCESS == (err = RegXXX(...)
		# into:
		#   ERROR_SUCCESS == RegXXX(...)
		#

		if (($before ne '') && ($before =~ /\(\w+\=\:{0,2}$/))
		{
			$before = $`;
		}

		$typo = (0 == valid_registry_return_values($reg_api[$i], $before, $after));

		if (0 != $typo)
		{
			display_typo($filename, $line, "invalid result check for $reg_api[$i]", 57, "$api_params\n");
		}

		$prev_pos = $reg_api_end[$i] + 1;
	}
}

sub parse_vars
{
	my ($str)	= @_;
	my $len		= length($str);
	my @vars	= ();

	while ($str =~ /([\w\.\->\[\]\(\)\*\+]*
							[\w\]\)]) =/gx)
	{
		my $var = $1;
		my $pos = pos($str);

		# if it's actually a comparison 
		# (another '=' after the first '='), then
		# we don't want the variable
		if (($len > $pos) && 
			substr($str, $pos, 1) eq '=')
		{
			next;
		}

		push(@vars, $var);
	}

	return @vars;
}

sub add_vars
{
	my $func_info = shift @_;
	my (@assign_vars) = @_;
	my $new_var_display;
	my $word;
	my $var_info;
	my $match;

	foreach $new_var (@assign_vars)
	{
		# Remove complete if/while stmts
		$new_var =~ s/^(if|while)\([^\(\)]+\)//;

		# We may pickup the "if(", "while(" at the
		# beginning as part of the variable name
		$new_var =~ s/^(if|while)\(//;

		# remove any "TYPE *"
		$new_var =~ s/^\w+\*+//;

		# Also need to remove any unbalanced open parentheses
		while ($new_var =~ /^\([^\)]+$/)
		{
			$new_var =~ s/^\(//;
		}

		$new_var =~ s/^long\*|^int\*|^short\*//;

		#
		# If we have something of the form
		#	"Verify(hrgn = Create());"
		# then we don't want to include the Verify(
		# as part of the variable.
		#
		if ($new_var =~ /\( ([^\(\)]+) $/x)
		{
			$new_var = $1;
		}

		$new_var_display = $new_var;

		# Strip any surrounding parentheses
		if ($new_var =~ /^\((.*)\)$/)
		{
			$new_var = $1;
		}

		########################################
		#
		# We need to quote the contents of $new_var
		# so that when we try to look for $new_var
		# in another string, perl doesn't interpret
		# any of the chars in $new_var as part of
		# a regular expression.
		#
		# We just want a literal match.
		#
		# Many neurons died needlessly before I figured 
		# out what was going on
		#
		$new_var =~ s/(\W)/\\$1/g;

		if ($new_var_display =~ /(\w+)/)
		{
			$word = $1;
		}
		else
		{
			die "No word\n";
		}

		my $var_info = {
				NAME => $new_var_display,
				EXPR => $new_var,
				INDEX => 0,
				FUNC => $func_info
				};

		$match = 0;

		# Conflict?
		if (exists($vars{$word}))
		{
			# Yes. Replace.
			my $index;
			my $var;

			for ($index = scalar(@{$vars{$word}}) - 1; $index >= 0; $index--)
			{
				$var = ${$vars{$word}}[$index];
				if ($var->{EXPR} eq $var_info->{EXPR})
				{
					$match = 1;

					# var hasn't been checked
					if (($VAR_UNUSED == $var->{FUNC}->{REPORT}) &&
						$var->{FUNC}->{CHECK})
					{
						if ($enable[27])
						{
							display_typo($filename, $var->{FUNC}->{LINE}, 
										"no immediate $var->{FUNC}->{TYPE} check", 27, 
										"$var->{FUNC}->{CALL_SHOW} [$var->{NAME}]\n");
						}
						$var->{FUNC}->{REPORT} = $VAR_USED;

						# Remove element from unchecked_vars array
						delete_unchecked_var( $var->{EXPR}, $var->{INDEX} );
					}

					${$vars{$word}}[$index] = $var_info;
				}
			}
		}

		if (0 == $match)
		{
			$func_info->{REFS} += 1;

			push(@{$vars{$word}}, $var_info);
			$var_count += 1;

			if ($#{$vars{$word}} > 0)
			{
				@{$vars{$word}} = sort 
									{ length($b->{NAME}) <=> length($a->{NAME}) } 
									@{$vars{$word}};
			}
		}

		if ($enable_main[27] && $func_info->{CHECK})
		{
			$var_info->{INDEX} = $#unchecked_vars + 1;
			push(@unchecked_vars, $var_info);
		}
	}
}


sub scan_expression
{
	my ($line, $line_number) = @_;
	my @typos = ();

	############################################################
	#
	# Using '!' on a number, probably wanted '~'
	#
	if ($enable[33] &&
		($line =~ /\! (0x[0-9A-Fa-f]+ | \d+)/x) &&
		($1 != 0))
	{
		push(@typos, "33");
	}

	############################################################
	#
	# Casting a number with the high-bit set to some type
	#
	if ($line =~ /\( ([\w\#]+\*?) \) 
					0x ([8-9A-Fa-f]{1,16} [A-Fa-f0-9]*)/ix)
	{
		my $cast = $1;
		my $number = $2;

		if ($enable[21] && (length($number) == 8) && 
			($cast !~ /DWORD | ULONG | LONG | long | short |
						unsigned#long | int | UINT | NTSTATUS/x))
		{
			push(@typos, "21");
		}
	}

	if ($enable[22] && ($line =~ /0x ([7-9A-Fa-f]{1,16} [A-Fa-f0-9]*)/ix))
	{
		my $number = $1;
		my $len = length($number);
		my $remainder = $len % 8; 

		if (($len >= 6) && ($remainder != 0) && (($remainder >= 6) || ($remainder <= 2)))
		{
			push(@typos, "22");
		}
	}

	# There might be some problem with Perl 5.001
	# If I have the "\d+" before the hex number pattern,
	# the second group isn't filled in, 
	# i.e. 0xFF ^ 0xA5 produces (0xFF, 0)
	#
	if ($enable[37])
	{
		if ($line =~ /\b(0x[A-F0-9]+ | \d+) \^ (0x[A-F0-9]+ | \d+)/ix)
		{
			my $exponent = $2;

			# if number begins with a 0 convert from oct/hex to decimal
			# otherwise, leave $factor alone since it's already in decimal.
			# oct() handles conversion from hex to dec.
			if ($exponent =~ /^0/)
			{
				$exponent = oct($exponent);
			}

			if ($exponent > 0)
			{
				push(@typos, "37");
			}
		}
	}

	############################################################
	#
	# Check for "&& #", logical AND followed by a number.
	# Authour probably meant "& #", bitwise AND followed by a number.
	#
	if ($enable[6] && (($line =~ /\&\&\d+/) ||
			($line =~ /\&\&0x[A-Fa-f0-9]+/)) &&
		($' !~ /[\!\=\<\>]/))
	{
		push(@typos, "6");
	}

	############################################################
	#
	# Check for "|| #", logical OR followed by a nonzero number.
	# Authour probably meant "| #", bitwise OR followed by a nonzero number.
	#
	# Note: I've never seen this one yet.
	#
	if ($enable[7] && (($line =~ /\|\|\d+/) ||
			($line =~ /\|\|0x[A-Fa-f0-9]+/)) &&
		($' !~ /[\!\=\<\>]/))
	{
		push(@typos, "7");
	}

	############################################################
	#
	# Check for "& <symbol> ==" or "& <symbol> !=".
	#
	# C/C++ precedence rules have "==" higher than "&"
	#
	# So code like:
	#	"if (x & 0x03 == 0x02)"
	# is treated as if the programmer wrote:
	#	"if (x & (0x03 == 0x02))"
	#
	# Also check to make sure there's no '&' or '(' before the '&'
	# in the pattern since that could mean logical-AND operator
	# or the user was taking the address of the symbol.
	#
	# Check for bitwise-XOR and bitwise-OR too. To reduce
	# false positives for bitwise-OR, make sure there's no
	# '|' before the '|' in the pattern since we'd have a
	# logical-OR operator.
	#
	if ($enable[8] && 
		($line =~ /[^&(|] [&^|] ( [\w*\->\.]*\w [><=!]) =/x))
	{
		my $typo = 1;
		my $var = $1;

		# Handle the case of template where you have
		# 	bitset<_N>& operator>>=(size_t _P)
		#
		if ($var !~ /operator\>/)
		{
			# If the expression that matched was "& XXX =="
			if ($line =~ /&[\w*\->\.#]*\w[><=!]=/)
			{
				my $before = $`;

				# check to see if the code is trying to
				# cast the address of a var to a different
				# type and deref that value
				if ($before =~ /\*\([\w*#]+[\w*]\)$/)
				{
					$typo = 0;
				}
			}
		}
		else
		{
			$typo = 0;
		}

		if ($typo == 1)
		{
			push(@typos, "8");
		}
	}

	############################################################
	#
	# Check for "== <symbol> &" or "!= <symbol> &".
	#
	# C/C++ precedence rules have "==" higher than "&"
	#
	# So code like:
	#	"if (0x02 == 0x03 & x)"
	# is treated as if the programmer wrote:
	#	"if ((0x02 == 0x03) & x)"
	#
	# Also check to make sure there's no '&' or '(' before the '&'
	# in the pattern since that could mean logical-AND operator
	# or the user was taking the address of the symbol.
	#
	# Check for bitwise-XOR and bitwise-OR too. To reduce
	# false positives for bitwise-OR, make sure there's no
	# '|' before the '|' in the pattern since we'd have a
	# logical-OR operator.
	#
	if ($enable[8] &&
		($line =~ /[><=!]=[\w*\->\.]*\w[&^|][^&|]/))
	{
		push(@typos, "8a");
	}

	############################################################
	#
	# Check for "(X | Y) == 0" or "(X | Y) != 0".
	# Check for "0 == (X | Y)" or "0 != (X | Y)".
	#
	# C/C++ precedence rules have "==" higher than "|"
	# and bitwise-ORing to test is not the logical thing
	#
	if ($enable[53])
	{
		if ($line =~ /[><=!] = (\(+) [\w*\->\.]* \w \| [^|]/x)
		{
			my $open_parens = $1;
			my $after = $';
			my $typo = 1;

			if ($after =~ /.*? (\)+)/x)
			{
				my $after_close_parens = $';

				if ((length($open_parens) > 1) && ($after_close_parens =~ /^\&[^\&]/))
				{
					$typo = 0;
				}
			}

			if (1 == $typo)
			{
				push(@typos, "53");
			}
		}
		elsif ($line =~ /[^|] \| [\w*\->\.]*\w(\)+) [><=!] =/x)
		{
			my $before = $`;
			my $close_parens = $1;
			my $typo = 1;

			if ($before =~ /(.*)\(/)
			{
				my $before_last_open_parens = $1;
				my $after_last_open_parens = $';

				if ($after_last_open_parens =~ /,/)
				{
					$typo = 0;
				}
				####
				# Check if the expression is "(X & (Y | Z | ...)) == 0"
				#
				elsif ((length($close_parens) > 1) && ($before_last_open_parens =~ /[^\&]\&$/))
				{
					$typo = 0;
				}
			}

			if (1 == $typo)
			{
				push(@typos, "53");
			}
		}
	}

	############################################################
	#
	# Check for "<< <symbol> {+ | - | * | /}"
	#
	# Another operator precedence case
	# The "+,-,*,/" have higher precedence than the shift operator.
	#
	# So code like:
	#	"y = x << 1 - 1;"
	# is treated as if the programmer wrote:
	#	"y = x << (1 - 1);"
	#
	# Add a "[^+] so we don't report "x << y++"
	#
	# Need to check that we actually have bitwise-shift operators
	# so we can weed out template code like:
	#   my_str<c, traits<c>, alloc<c> > __cdecl operator+(
	# 
	if (($temp =~ /<<|>>/) &&
		(($line =~ /([\w*\->()\>#]+) (<<|>>) [\w*\->\.#]* \w 
							([\(\)]{0,2} | \([^\)]+\)) [\+\*\/] [^\+]/x) ||
		 ($line =~ /([\w*\->()\>#]+) (<<|>>) [\w*\->\.#]* \w 
							([\(\)]{0,2} | \([^\)]+\)) \- [^-\>]/x)))
	{
		my $shift = $2;
		my $before = $`;
		my $after = $';

		if (($1 ne "_") && ($3 !~ /^\)+/) &&
			($before !~ /$shift [_'] | $shift TEXT\(_\)/x) && 
			($after !~ /$shift [_'] | $shift TEXT\(_\)/x))
		{
			if ($enable[11])
			{
				push(@typos, "11");
			}
		}
	}

	if (($line =~ /%/) &&
		(($line =~ /[\w*\->()\>#]+ % [\w*\->\.#]* \w ([\(\)]{0,2} | \([^\)]+\)) [\+\*\/] [^\+]/x) ||
		 ($line =~ /[\w*\->()\>#]+ % [\w*\->\.#]* \w ([\(\)]{0,2} | \([^\)]+\)) \- [^-\>]/x)))
	{
		my $before = $`;
		my $after = $';

		if (($1 !~ /^\)+/) &&
			($before !~ /\% [_'] | \% TEXT\(_\)/x) && 
			($after !~ /\% [_'] | \% TEXT\(_\)/x))
		{
			if ($enable[11])
			{
				push(@typos, "11a");
			}
		}
	}

	if ($enable[45] && 
		($line =~ /[\.\>]boolVal=/))
	{
		my $after = $';

		if ($after !~ /VARIANT_(TRUE|FALSE)|^=|boolVal/)
		{
			$after =~ s/VARIANT_\w+//g;
			$after =~ s/FALSE//;

			if ($after =~ /[A-Za-z1-9] | \!+ | [><=!]=/x)
			{
				push(@typos, "45");
			}
		}
	}

	if ($#typos >= 0)
	{
		$line = $line . "\n";
		foreach (@typos)
		{
			display_typo_normal($filename, $line_number, $_, $line);
		}
	}
}

sub scan_statement
{
	my ($line, $line_number, $prev) = @_;
	my @typos = ();

	scan_expression($line, $line_number);

	############################################################
	#
	# Look for assignment statements that use sizeof
	# on the right-hand side.
	#
	if ($enable[56])
	{
		if ($line =~ /([\w*\->()\>#]*? [\w\)\]]) = (sizeof\(\S+\) [^;]*)/xi)
		{
			my $var = $1;
			my $value = $2;

			# Skip over dereferences of the variable
			if ($var =~ /^\*/)
			{
				$var = $';
			}

			$vars_sizeof{$var} = $value;
		}
	}

	############################################################
	#
	# Look for assignment statements that use "==" instead of "="
	#
	# We key off of "==" followed by a ";" and make sure that
	# the string "<space>=<space>" isn't in the source string
	# and the string doesn't contain the word "Assert" or "ASSERT"
	# or "assert" or "for" or "return" or "SideAssert" or "Trace" or "while"
	#
	if ($enable[2] &&
			($line !~ /\breturn_?\b|\bswitch\b|\bthrow\b/) &&
			($line !~ /assert|\bTrace\b/i) &&
			($line !~ /[\+\-\*\/\%\&\^\|\~\w\)\]\<\>] = [^=]/x) && 
			(($line =~ /[\w\)\]] == [\*\w\(\[] [^\,\+\?\<\>]* ;/x) || 
				($line =~ /[\w\)\]] [\+\-] [\*\w\(\[] [^\,\+\?\<\>]* ;/x)))
	{
		my $temp2 = $line;

		# Remove parenthesized stuff from the string until
		# there aren't anymore
		while ($temp2 =~ /\([^\(\)]*\)/)
		{
			$temp2 =~ s/\([^\(\)]*\)/_/g;
		}

		while ($temp2 =~ /\[[^\[\]]*\]/)
		{
			$temp2 =~ s/\[[^\[\]]*\]/_/g;
		}

		# Remove any strings
		# Note: Doesn't handle quoted quote characters correctly
		$temp2 =~ s/"[^"]*"/_/g;

		# If there's an open parentheses and no closed parentheses
		# or if there's no open parentheses and an closed parentheses
		# or if the line begins with "&&" or "||" or "==" or
		# "=" followed by "==" or "operator" followed by "=="
		# then we don't have a match
		#
		# The "operator" condition is for C++ files that are
		# overloading the "==" operator.
		#
		# Also do quick checks on contents of previous line
		# i.e. if there's an unterminated for-loop, or
		# if the last line ends with "&&" or "||" or "?" or "="
		# or (":" and it's not the second part of a ?:).
		#
		if (($temp2 !~ /=.+==.+;/) &&
			($temp2 !~ /operator(==|[\+\-])/))
		{
			# If the string still satisfies the conditions
			# then we have a match
			if ($temp2 =~ /== [^\,\+\?\<\>]+ ; |
							([\w\)\]] [\+\-] [\*\w\(\[] [^\,\+\?\<\>\:]* ;)/x)
			{
				my $typo2 = 1;

				#
				# Is this a bitfield declaration?
				# i.e. ULONG dw : 32 - CONSTANT;
				#
				if ($1 && ($1 ne ''))
				{
					my $before = $`;
					
					if ($before =~ /\w+:\w+$/)
					{
						$typo2 = 0;
					}
				}

				if ($typo2)
				{
					push(@typos, 2);
				}
			}
		}
	}

	############################################################
	#
	# Look for increment/decrement of dereferenced pointer
	#
	# We key off of "*" followed by a word followed by "++" or "--"
	# followed by a ";".
	#
	# This is either redundant or unintentional,
	#  i.e. (*px)++; was desired
	#
	if ($enable[5] &&
		(($line =~ /\*\w[\w*\->#\.]*\+\+;/) ||
		($line =~ /\*\w[\w*\->#\.]*\-\-;/)) && ($` !~ /=/) &&
		($` !~ /delete/))
	{
		push(@typos, 5);
	}

	############################################################
	#
	# Check for referencing Release method without "()"
	# which will do nothing rather than call the Release method
	#
	# Might as well check for AddRef too
	#
	# VC 5.0 will supposedly emit a warning for the general
	# case where an object's method is only referenced.
	#
	# Don't complain if we're assigning the fn ptr to another var
	#
	if ($enable[9] &&
		($line =~ /->(Release|AddRef);/) && ($` !~ /=/))
	{
		push(@typos, 9);
	}

	if ($enable[54] &&
		($line =~ / \w*?(x|y|left|top|right|bottom) = (.*?)(LOWORD|HIWORD) \(/xi))
	{
		my $pre = $2;

		if ($pre !~ /\(short\)/)
		{
			push(@typos, 54);
		}
	}

	############################################################
	#
	# Check for non-NULL-ptr checks before calling memory
	# deallocator functions that handle NULL ptrs.
	#
	# Make sure the operator array delete is before the operator delete,
	# Otherwise, the brackets become part of the variable which is not correct
	#
	if ($enable[59] && 
		($line =~ /\b 
					(delete \[ \] | 
					 delete \#? \(? | 
					 LocalFree \( | 
					 SysFreeString \( | 
					 free \( 
					) /x))
	{
		my $after = $';
		my $var;

		if ($after =~ /[\(\)]/)
		{
			my $parens_count = 1;

			$var = '';

			while ($after =~ /(\()|(\))/g)
			{
				$1 ? ++$parens_count : --$parens_count;

				if (0 == $parens_count)
				{
					$var = substr($after, 0, pos($after)-1);

					last;
				}
			}
		}
		else
		{
			# Must be "delete var" or "delete [] var" if there are no parens
			$var = $';

			# Remove the semicolon
			chop($var);
		}

		# Quote all the non-alphanumeric chars so they don't mess up the regex below
		$var =~ s/(\W)/\\$1/g;
		
		if ($prev =~ /\bif\b\(($var|NULL\!\=$var|$var\!\=NULL)\)\{?$/)
		{
			push(@typos, 59);
		}
	}

	if ($enable[61] && ($line =~ /\bSendMessage[AW]?\(HWND_BROADCAST\,/))
	{
		push(@typos, 61);
	}

	if ($#typos >= 0)
	{
		$line = $line . "\n";
		foreach (@typos)
		{
			display_typo_normal($filename, $line_number, $_, $line);
		}
	}
}

sub clear_statement
{
	$statement = '';
	$statement_line = 0;
}

sub update_statement
{
	my ($str, $line_number, $lines, $prev)	= @_;
	my $char_last;
	my $char_pu;
	my $char_first;
	my $str_len;

	chomp($str);
	$str_len = length($str);

	if ($str_len > 0)
	{
		$char_last = substr($str, -1, 1);
		$char_first = substr($str, 0, 1);
		if($str_len > 1)
		{
			$char_pu = substr($str, -2, 1);
		}
		else
		{
			$char_pu = '';
		}
	}
	else
	{
		$char_last = $str;
		$char_first = $str;
		if ($char_first eq '')
		{
			$char_first = '#';
		}

		$char_pu = '';
	}

	# Reset if we see an opening brace or label
	if (($char_last eq '{') || 
		(($statement eq '') && ($str =~ /^[\w:]+\:$ | ^case\#[\w:\+]+\:$/x)))
	{
		clear_statement();
	}
	else
	{
		if ($statement ne '')
		{
			if ((substr($statement, -1, 1) =~ /\w/) && ($char_first =~ /\w/))
			{
				$statement = join("", $statement, '#', $str);
			}
			else
			{
				$statement = join("", $statement, $str);
			}
		}
		else
		{
			$statement = $str;
		}

		if ($statement_line == 0)
		{
			my $char_first = substr($statement, 0, 1);

			if ((length($statement) == 1) &&
				(($char_first eq '{') ||
				 ($char_first eq '}')))
			{
				clear_statement();
			}
			else
			{
				$statement_line = $line_number;
			}
		}

		if (($char_last eq ';') || ($char_pu eq ';'))
		{
			my @statements;
			my $stmt;

			chomp($statement);

			$stats{SEMICOLONS} += ($statement =~ tr/;/;/);

			if ($KLOC_NONE == $show_kloc)
			{
				@statements = split(/;/, $statement);

				foreach $stmt (@statements)
				{
					if ($stmt eq '')
					{
						next;
					}

					if ($stmt =~ /^.*\{/)
					{
						$stmt = $';
					}

					$stmt = join("", $stmt, ";");

					if ($char_pu ne '}')
					{
						scan_statement($stmt, $statement_line, $prev);
					}
				}
			}

			clear_statement();
		}
	}
}

sub find_function
{
	my ($temp_prev) = @_;
	my $current = 0;
	my $match = '';
	my $line_offset = -1;

	chomp $temp_prev;

	# If the beginning of the current line doesn't begin
	# with a curly brace, check to see if there's
	# a curly brace on the line and grab any text before it
	if ((substr($temp_pack, 0, 1) ne '{') &&
		($temp_pack =~ /(.*?)\{/))
	{
		$match = $1;

		# If we've got the end of a function, grab the stuff after it
		if ($temp_prev =~ /\;\}/)
		{
			$temp_prev = $';
		}

		$temp_prev = $temp_prev . $match;
		$current = 1;

		if ($temp_prev)
		{
			my $char_last = substr($temp_prev, -1, 1);

			if (($char_last ne ';') && ($char_last ne ')'))
			{
				# If function has a const or volatile qualifier, 
				# don't ignore, just drop the qualifier
				if ($temp_prev =~ /\b(const|volatile)$/)
				{
					$temp_prev = $`;
				}
				else
				{
					$temp_prev = '';
				}
			}
		}
	}

	if ($temp_prev)
	{
		my $char_last = substr($temp_prev, -1, 1);

		if ($char_last eq ';')
		{
			my $line = $line_current - 1 - 1;
			my $parens = -9999;

FUNC_LINE:
			while ($line >= 0)
			{
				my $line_prev = $lines[$line];

				if (1 == $current)
				{
					$line_prev = $temp_prev;
					$line = $line_current;
					$current = 0;
				}

				if ($line_prev)
				{
					my $param = $line_prev;

					# Remove single line C "/* */" comments
					# and any string, put '#' between words
					# strip any C++ comments and remove whitespace
					$param =~ s/\/\*.*?\*\///g;
					$param =~ s/"[^"]*"/_/g;
					$param =~ s/(\w)\s+(\w)/$1#$2/g;
					$param =~ s/\/\/.*$//;
					$param =~ tr/ \t//d;

					# Change STDMETHOD(XX) to XX
					$param =~ s/STDMETHOD\((\w+)\)/$1/;
					# Change STDMETHOD_(VAR, XX) to XX
					$param =~ s/STDMETHOD_\(.*,(\w+)\)/$1/;
					# Change STDMETHODIMP_(VAR) to nothing
					$param =~ s/STDMETHODIMP_\(\w+\)//;

					$param = reverse($param);

					while ($param =~ /(\()|(\))/g)
					{
						if (-9999 == $parens)
						{
							if ($1)
							{
								print STDERR "PARENS: $filename ($line)\n";
								print "// PARENS: $filename ($line)\n";
							}

							$parens = 0;
						}

						$1 ? $parens++ : $parens-- ;

						if (!$parens)
						{
							my $until_end = $';

							if ($until_end =~ /^([^\#\s\*\}]+)/)
							{
								my $func = $1;

								$until_end = reverse($func);
							}
							else
							{
								$until_end = '';
							}

							if ($until_end)
							{
								$stats{FUNCTIONS} += 1;

								if ($log_functions)
								{
									print $func_output_str[0], $line+1, 
											$func_output_str[1], $until_end, $func_output_str[2];
								}
								elsif (0 != $output_xml)
								{
									$current_function = $until_end;
									$current_function_line = $line + 1;
								}

								$temp_prev = '';
							}

							last FUNC_LINE;
						}
					}
				}

				$line -= 1;
			}
		}
		else
		{
			# Remove groups of macros, i.e. BEGIN_MESSAGE_MAP...END_MESSAGE_MAP
			while ($temp_prev =~ /END_.*\(\)/)
			{
				$temp_prev = $';
			}

			# Remove one line macros
			while ($temp_prev =~ /IMPLEMENT_.*\(.*\)/)
			{
				$temp_prev = $';
			}

			# Remove C++ keywords in classse
			if ($temp_prev =~ /public: | private: | protected:/x)
			{
				$temp_prev = $';
			}

			if (!$char_last || ($char_last ne ')'))
			{
				if ($temp_prev =~ /([^\#\s\*\}]+?)\(.*\)/)
				{
					my $function = $1;
					my $func = $function;

					$func =~ s/(\W)/\\$1/g;

					if ($match =~ /$func/)
					{
						$line_offset = 0;
					}

					$stats{FUNCTIONS} += 1;

					if ($log_functions)
					{
						print $func_output_str[0], $line_current+$line_offset, 
								$func_output_str[1], $function, $func_output_str[2];
					}
					elsif (0 != $output_xml)
					{
						$current_function = $function;
						$current_function_line = $line_current - 1;
					}
				}

				$temp_prev = '';
			}
		}
	}

	if ($temp_prev)
	{
		# Change STDMETHOD(XX) to XX
		$temp_prev =~ s/STDMETHOD\((\w+\*?)\)/$1/;
		# Change STDMETHOD_(VAR, XX) to XX
		$temp_prev =~ s/STDMETHOD_\(.*,(\w+\*?)\)/$1/;
		# Change STDMETHODIMP_(VAR) to nothing
		$temp_prev =~ s/STDMETHODIMP_\(\w+\*?\)//;
		# Change STDAPI_(VAR) to nothing
		$temp_prev =~ s/STDAPI_\(\w+\)//;
		# Change ^.*virtual~ to ~
		$temp_prev =~ s/^.*?(virtual|inline)~/~/;
		# Change \w+; to nothing
		$temp_prev =~ s/^\w+;//;
		# Change \w+(); to nothing
		$temp_prev =~ s/^.*\w+\(\);//;
		# Change ^; to nothing
		$temp_prev =~ s/^\}?\;//;

		# Remove C++ keywords in classse
		# or references as return values (make sure there are no parentheses before the reference
		# which may mean we're looking at the function parameters)
		while ($temp_prev =~ /{ | public: | private: | protected: | ^[^\(]*\w+\&/x)
		{
			$temp_prev = $';
		}

		if ($temp_prev =~ /([^\#\s\*\}]+?)\(/)
		{
			my $function = $1;

			if ($function !~ /^DECLARE_INTERFACE|^__declspec|^\b(return|if|SUCCEEDED|FAILED)\b/)
			{
				my $func = $function;

				$func =~ s/(\W)/\\$1/g;

				if ($match =~ /$func/)
				{
					$line_offset = 0;
				}
				$stats{FUNCTIONS} += 1;

				if ($log_functions)
				{
					print $func_output_str[0], $line_current+$line_offset, 
							$func_output_str[1], $function, $func_output_str[2];
				}
				elsif (0 != $output_xml)
				{
					$current_function = $function;
					$current_function_line = $line_current - 1;
				}
			}
		}
		else
		{
			
			if ($temp_prev =~ /\(.*\)/)
			{
				$temp_prev = $`;
			}

			if ($temp_prev ne '')
			{
				my $func = $temp_prev;

				$func =~ s/(\W)/\\$1/g;

				if ($match =~ /$func/)
				{
					$line_offset = 0;
				}

				$stats{FUNCTIONS} += 1;

				if ($log_functions)
				{
					print $func_output_str[0], $line_current+$line_offset, 
							$func_output_str[1], $temp_prev, $func_output_str[2];
				}
				elsif (0 != $output_xml)
				{
					$current_function = $temp_prev;
					$current_function_line = $line_current - 1;
				}
			}
		}
	}
}

sub check_expression
{
	my ($keyword, $key_params, $key_line, $word_count, @words) = @_;
	my $expression = $key_params;
	my $var_info;
	my $index;
	my $word;

WORD_IF:
	foreach $word (@words)
	{
		if (0 == $word_count)
		{
			last WORD_IF;
		}

		if (!exists($vars{$word}))
		{
			next WORD_IF;
		}

VAR_IF:
		for ($index = 0; $index <= $#{$vars{$word}}; $index++)
		{
			my $var;
			my $before;
			my $after;
			my $old_report;

			$var_info = ${$vars{$word}}[$index];
			$var = $var_info->{EXPR};
			$old_report = $var_info->{FUNC}->{REPORT};

			if ($expression =~ /(\b|\W)$var(\W)/)
			{
				$before = join("", $`, $1);
				$after = join("", $2, $');

				$expression =~ s/$var//;

				$word_count -= 1;
			}
			else
			{
				next VAR_IF;
			}

			if ($var_info->{FUNC}->{TYPE} eq "new")
			{
				if (($before =~ /\!\(?$ | (0|NULL)[\!=]=\(?$/x) ||
					($after =~ /^\)?[\!=]=(NULL|0)/) ||
					($after =~ /^\)?[\!=]=\(.+?\)(NULL|0)/) ||
					(($before =~ /\($ | \&\&$ | \|\|$/x) && 
						($after =~ /^\) | ^\&\& | ^\|\| /x)))
				{
					# Clear out
					if ($enable[34] && ($VAR_USED != $var_info->{FUNC}->{REPORT}))
					{
						$var_info->{FUNC}->{REPORT} = $VAR_USED;
					}
				}
				elsif ($VAR_USED != $var_info->{FUNC}->{REPORT})
				{
					if ($enable[34])
					{
						if (($try eq '') || (1 == $kernel_code))
						{
						display_typo($filename, $key_line, 
									"using $var_info->{FUNC}->{TYPE} result w/no check", 34, 
									"$keyword$key_params [$var_info->{NAME}]\n");
						}
					}

					# Mark as having been used before being checked
					$var_info->{FUNC}->{REPORT} = $VAR_USED;
				}
			}
			else
			{
				############################################################
				#
				# Look for if statements which don't check for
				# INVALID_HANDLE_VALUE after invoking a function
				# that returns INVALID_HANDLE_VALUE on error.
				#
				my $function_id;

				if (exists($function_list{$var_info->{FUNC}->{TYPE}}))
				{
					$function_id = $function_list{$var_info->{FUNC}->{TYPE}};
				}
				else
				{
					$function_id = 0;
				}

				if ($after =~ /$var_info->{FUNC}->{CALL}/)
				{
					# Remove everything up to and including
					# the function call
					# i.e.
					#	"if ((p = x = malloc(10)) == NULL)"
					# will become:
					#	"if ((p) == NULL)"
					# instead of
					#	"if ((p = x ) == NULL)"
					#
					$after =~ s/.*$var_info->{FUNC}->{CALL}//;
				}

				if ($function_id & $CHECK_FUNCTION)
				{
					# If variable isn't compared to NULL,
					#
					# If the variable isn't dereferenced by 
					# either '*' or '->'
					if ($enable[30] &&
						($VAR_USED != $var_info->{FUNC}->{REPORT}) &&
						(($before =~ /\*$/) || ($after =~ /^\-\>/) ||
						(($before !~ /\!\(?$ | NOT\#$ |
									(0|NULL|ERROR_SUCCESS)[\!=]=\(?$ |
									\&\&$ | \|\|$/x) &&
						  ($after !~ /^\)?[\!=]=(NULL|0|ERROR_SUCCESS) |
									  ^\)?[\!=]=\(.+?\)(NULL|0|ERROR_SUCCESS) |
									  ^\#is\#NULL | is\#empty |
									  ^\&\&| ^\|\|/x)) &&
						!(($before =~ /\($/) && ($after =~ /^\)|is\#empty/))))
					{
						if (($try eq '') || (1 == $kernel_code))
						{
						display_typo($filename, $key_line, 
									"using $var_info->{FUNC}->{TYPE} result w/no check", 30, 
									"$keyword$key_params [$var_info->{NAME}]\n");
						}
						$var_info->{FUNC}->{REPORT} = $VAR_USED;
					}
				}

				if ($function_id & $HANDLE_FUNCTION)
				{
					if (($before =~ /INVALID_HANDLE_VALUE[=\!]=\(? | 
									\(HANDLE\)-1[=\!]=\(? |
									\(HANDLE\)\(-1\)[=\!]=\(? | 
									\(HANDLE\)~0[=\!]=\(? | 
									\(HANDLE\)HFILE_ERROR[=\!]=\(?/x) ||
						($after =~ /[=\!]=INVALID_HANDLE_VALUE |
									[=\!]=\(HANDLE\)-1 | 
									[=\!]=\(HANDLE\)\(-1\) | 
									[=\!]=\(HANDLE\)~0 | 
									[=\!]=\(HANDLE\)HFILE_ERROR/x))
					{
						if ($enable[23] && 
							($VAR_UNUSED == $var_info->{FUNC}->{REPORT}))
						{
							display_typo($filename, $key_line, 
										"if ($var_info->{FUNC}->{TYPE} == IHV)", 23, 
										"$keyword$key_params [$var_info->{NAME}]\n");
							$var_info->{FUNC}->{REPORT} = $VAR_USED;
						}
					}
					# If variable isn't compared to NULL,
					# by either "(x == NULL/0)" or "(x != NULL/0)"
					# or "if (x && y)" or "if (x ||y)" or "if (!x)"
					# or "if (x)"
					elsif ($enable[30] && 
							($VAR_USED != $var_info->{FUNC}->{REPORT}) &&
							((($before !~ /\!\(?$ | (0|NULL)[\!=]=\(?$ | 
											\&\&$ | \|\|$ | [<>]$/x) &&
							  ($after !~ /^\)?[\!=]=(NULL|0) | 
										 ^\)?[\!=]=\(.+?\)(NULL|0) |
										 ^\&\&| ^\|\| | ^[<>]/x)) &&
							  !(($before eq "(") && ($after eq ")"))))
					{
						if (($try eq '') || (1 == $kernel_code))
						{
						display_typo($filename, $key_line, 
									"using $var_info->{FUNC}->{TYPE} result w/no check", 30, 
									"$keyword$key_params [$var_info->{NAME}]\n");
						}
						$var_info->{FUNC}->{REPORT} = $VAR_USED;
					}
				}
				elsif ($function_id & $ALLOCA_FUNCTION)
				{
					if (($before =~ /\!\(?$ | NULL[\!=]=\(?$/x) ||
						($after =~ /^\)?[\!=]=NULL/) ||
						($after =~ /^\)?[\!=]=\(.+\)NULL/))
					{
						if ($enable[25] && 
							($VAR_UNUSED == $var_info->{FUNC}->{REPORT}))
						{
							display_typo_normal($filename, $key_line, 
										25, "$keyword$key_params [$var_info->{NAME}]\n");
							$var_info->{FUNC}->{REPORT} = $VAR_USED;
						}
					}
				}
				elsif ($function_id & $HFILE_FUNCTION)
				{
					if (($before !~ /\(HFILE\)-1[=\!]= |
									\(HFILE\)\(-1\)[=\!]= | 
									\(HFILE\)~0[=\!]= | 
									HFILE_ERROR[=\!]= | 
									\(int\)-1[=\!]= |
									\(INT\)-1[=\!]= |
									-1[=\!]= | 
									\(HFILE\)HFILE_ERROR /x) &&
						($after !~ /[=\!]=\(HANDLE\)INVALID_HANDLE_VALUE |
									[=\!]=\(HFILE\)-1 |
									[=\!]=\(HFILE\)\(-1\) | 
									[=\!]=\(HFILE\)~0 | 
									[=\!]=HFILE_ERROR | 
									[=\!]=-1 | 
									[=\!]=\(int\)-1 |
									[=\!]=\(INT\)-1 |
									[=\!]=\(HFILE\)HFILE_ERROR/x))
					{
						if ($enable[24] && 
							($VAR_UNUSED == $var_info->{FUNC}->{REPORT}))
						{
							display_typo($filename, $key_line, 
										"if ($var_info->{FUNC}->{TYPE} == NULL)", 24, 
										"$keyword$key_params [$var_info->{NAME}]\n");
							$var_info->{FUNC}->{REPORT} = $VAR_USED;
						}
					}
				}
				elsif ($function_id & $HRESULT_FUNCTION)
				{
					if (($before !~ /SUCCEEDED\( |
									FAILED\( |
									S_OK [=\!]=\(? | 
									S_FALSE [=\!]=\(? | 
									NOERROR [=\!]=\(? /x) &&
						($after !~ /[=\!]=S_OK |
									[=\!]=S_FALSE |
									[=\!]=NOERROR/x))
					{
						if ($enable[42] &&
							($VAR_UNUSED == $var_info->{FUNC}->{REPORT}))
						{
							display_typo($filename, $key_line, 
										"using $var_info->{FUNC}->{TYPE} result w/no check", 42, 
										"$keyword$key_params [$var_info->{NAME}]\n");
							$var_info->{FUNC}->{REPORT} = $VAR_USED;
						}
					}
				}
				elsif ($function_id & $REG_FUNCTION)
				{
					my $typo;

					$typo = (0 == valid_registry_return_values($var_info->{FUNC}->{TYPE}, $before, $after));

					if ($typo)
					{
						if ($enable[57] &&
							($VAR_UNUSED == $var_info->{FUNC}->{REPORT}))
						{
							display_typo($filename, $key_line, 
										"invalid result check for $var_info->{FUNC}->{TYPE}", 57, 
										"$keyword$key_params [$var_info->{NAME}]\n");
							$var_info->{FUNC}->{REPORT} = $VAR_USED;
						}
					}
				}
				elsif (($before || $after) &&
						($function_id & $INVALID_HANDLE))
				{
					if (($before !~ /$IH_FUNC_RESULT/ox) &&
						($after !~ /$IH_FUNC_RESULT/ox))
					{
						if ($enable[20] &&
							($VAR_UNUSED == $var_info->{FUNC}->{REPORT}))
						{
							display_typo_normal($filename, $key_line, 20, 
										"$keyword$key_params [$var_info->{NAME}]\n");
							$var_info->{FUNC}->{REPORT} = $VAR_USED;
						}
					}
				}

				if ($before || $after)
				{
					$var_info->{FUNC}->{REPORT} = $VAR_USED;
				}
			}


			if (($var_info->{FUNC}->{REPORT} == $VAR_USED) && 
				($old_report != $VAR_USED))
			{
				$var_count -= $var_info->{FUNC}->{REFS};
				if (0 == $#{$vars{$word}})
				{
					delete $vars{$word};
				}
				else
				{
					splice(@{$vars{$word}}, $index, 1);
					if ($#{$vars{$word}} < 0)
					{
						delete $vars{$word};
					}
				}

				last VAR_IF;
			}

		} # end foreach @{$vars{$word}}
	} # end foreach @words
}

sub print_file_kloc
{
	my ($file, $Totals) = @_;
	my $line_count_file = $stats{LINES};
	my $code_count_file = $stats{CODE};
	my $comment_lines_count_file = $stats{COMMENT_LINES};
	my $comment_count_file = $stats{COMMENTS};
	my $func_count_file = $stats{FUNCTIONS};
	my $assert_count_file = $stats{ASSERTS};
	my $semi_count_file = $stats{SEMICOLONS};
	my $typo_count_file = $stats{TYPOS};
	my $comment_ratio;
	my $loc_semi_ratio;

	# Grab the filename only
	if (!$Totals)
	{
		$file =~ s/^.*\\//;
		$file = uc($file);

		$line_count_file -= $stats_prev{LINES};
		$code_count_file -= $stats_prev{CODE};
		$comment_lines_count_file -= $stats_prev{COMMENT_LINES};
		$comment_count_file -= $stats_prev{COMMENTS};
		$func_count_file -= $stats_prev{FUNCTIONS};
		$assert_count_file -= $stats_prev{ASSERTS};
		$semi_count_file -= $stats_prev{SEMICOLONS};
		$typo_count_file -= $stats_prev{TYPOS};
	}

	if ($code_count_file > 0)
	{
		$comment_ratio = $comment_lines_count_file / $code_count_file;
	}
	else
	{
		$comment_ratio = $comment_lines_count_file;
	}

	if ($semi_count_file > 0)
	{
		$loc_semi_ratio = $code_count_file / $semi_count_file;
	}
	else
	{
		$loc_semi_ratio = $code_count_file;
	}

	if ($show_kloc == $KLOC_OLD)
	{
		printf "%-16.16s%6lu  %6lu  %8lu  %6.2f %7lu %7lu   %6.2f\n", 
				$file, $line_count_file,
				$code_count_file,
				$comment_lines_count_file,
				$comment_ratio,
				$assert_count_file,
				$semi_count_file,
				$loc_semi_ratio;
	}
	elsif ($show_kloc == $KLOC_NEW)
	{
		printf "%-16.16s%6lu  %6lu  %6lu  %8lu %7lu %7lu   %6.2f\n", 
				$file, $line_count_file,
				$func_count_file,
				$code_count_file,
				$comment_count_file,
				$assert_count_file,
				$semi_count_file,
				$loc_semi_ratio;
	}
	

	$stats_prev{ASSERTS}	= $stats{ASSERTS};
	$stats_prev{CHARS}		= $stats{CHARS};
	$stats_prev{CODE}		= $stats{CODE};
	$stats_prev{COMMENT_LINES}	= $stats{COMMENT_LINES};
	$stats_prev{COMMENTS}	= $stats{COMMENTS};
	$stats_prev{FUNCTIONS}	= $stats{FUNCTIONS};
	$stats_prev{LINES}		= $stats{LINES};
	$stats_prev{SEMICOLONS}	= $stats{SEMICOLONS};
	$stats_prev{TYPOS}		= $stats{TYPOS};
}

sub filter_constants
{
	my ($str) = @_;
	my $new_str = '';

	while ($str =~ /([\'\"]) | ([^\'\"]+)/xg)
	{
		if ($1)
		{
			my $type = $1;
			my $before = $`;
			my $after = $';
			my $fail = 1;

			if ($type eq '"')
			{
				my $str_constant = '';

				# We've got a string constant

STR_LOOP:
				while ($after =~ /( [^\"]* ) \"/xg)
				{
					my $constant = $1;

					$str_constant = join("", $str_constant, $constant);

					if ($constant =~ /(\\+)$/)
					{
						if (0 != (length($1) & 1))
						{
							# Odd number of backslashes
							# That means the double-quote was
							# escaped, so nuke the last backslash
							substr($str_constant, -1, 1) = '"';
							next STR_LOOP;
						}
					}

					# String constant found
					emit_string($str_constant);

					$new_str = join("", $new_str, "_");
					pos($str) = pos($str) + pos($after);
					$fail = 0;
					last STR_LOOP;
				}
			}
			else
			{
				my $char_constant = '';

				# We've got a character constant

				# Check to see if the char before 
				# the single quote is an L
				if ((length($before) > 0) && (substr($before, -1, 1) eq "L"))
				{
					chop($new_str);
				}

CHAR_LOOP:
				while ($after =~ /( [^\']* ) \'/xg)
				{
					my $constant = $1;

					$char_constant = join("", $char_constant, $constant);

					if ($constant =~ /(\\+)$/)
					{
						if (0 != (length($1) & 1))
						{
							# Odd number of backslashes
							# That means the single-quote was
							# escaped, so nuke the last backslash
							substr($char_constant, -1, 1) = "\'";
							next CHAR_LOOP;
						}
					}

					# Char constant found
#					warn "\U$filename\E $line_current '$char_constant'\n";
					$char_constant =~ s/\W+/@/g;
					$new_str = join("", $new_str, "\'$char_constant\'");
					pos($str) = pos($str) + pos($after);
					$fail = 0;
					last CHAR_LOOP;
				}

				if (0 != $fail)
				{
					$new_str = join("", $new_str, $type);
				}
			}
		}
		else
		{
			$new_str = join("", $new_str, $2);
		}
	}

	return $new_str;
}


sub extract_strings_from_mc
{
	my $state = 0;
	my $line_current = 0;

	foreach (@lines)
	{
		$line_current += 1;

		# MC files have a certain format.
		# The part that we care about is
		# any lines following a line that begins with "Language="
		# is a message that is compiled
		# Message lines are terminated by a line with a single period.
		#
		if (0 == $state)
		{
			# Lines following this line are messages
			if (/^Language=/)
			{
				$state = 1;
			}
		}
		# End of messages?
		elsif (/^\.$/)
		{
			$state = 0;
		}
		# Messages?
		else
		{
			my $str = $_;

			chomp($str);

			# Don't print out empty lines or strings with all caps
			if ((length($str) > 1) &&
				($str =~ /[a-z]/) && 
				!exists($ignore_strings{$str}))
			{
				print "\U$filename\E ($line_current):\tmessage 98:\t'$str'\n";
			}
		}
	}
}

sub check_function_params
{
	my ($filename, $alt_found, $function_id) = @_;

	if ($alt_found ne '')
	{
		if ($enable[44] &&
			($LENGTH_FUNCTION & $function_list{$alt_found}) &&
			($function_call{PARAMS} =~ /$alt_found \( [^\,\)]+? \+ \d+/x))
		{
			display_function_typo_normal(44);
		}
	}

	if ($enable[44] &&
		($LENGTH_FUNCTION & $function_id) &&
		($function_call{PARAMS} =~ /$function_call{NAME} \( [^\,\)]+? \+ \d+/x))
	{
		display_function_typo_normal(44);
	}

	if ($enable[50] &&
		($DISALLOW_FUNCTION & $function_id))
	{
		display_function_typo_normal(50);
	}

	############################################################
	#
	# Look for assignment statements inside Asserts
	#
	# We key off of a "(" followed by a lone "=" followed by ")"
	#
	if (($function_call{NAME} =~ /assert/i) &&
		!($function_id & $SAFEASSERT_FUNCTION) &&
		($function_call{PARAMS} =~ /\(.*[^!=<>']=[^=].*\) |
									\(.*[\+\-]=[^=].*\) | 
									\(.*\+\+.*\) | \(.*\-\-.*\)/x))
	{
		if ($enable[4])
		{
			display_function_typo_normal(4);
		}
	}
	############################################################
	#
	# Look for incorrect usage of memset
	#
	# Fn proto: void *memset( void *dest, int c, size_t count );
	#
	# Many times 'c' and 'count' are swapped, i.e.
	#
	#	memset(ptr, cb, 0);
	#
	elsif ($function_id & $MEMCRT_FUNCTION)
	{
		if ($enable[14] && ($function_call{PARAMS} =~ /,0\)$/))
		{
			display_function_typo_normal(14);
		}

		if ($enable[52] && ($function_call{PARAMS} =~ /this,0,sizeof\(\*?this\)/))
		{
			display_function_typo_normal(52);
		}
	}
	############################################################
	#
	# If memset gets messed up,
	# check if FillMemory/RtlFillMemory gets messed up too.
	#
	elsif ($function_id & $FILLMEM_FUNCTION)
	{
		if ($enable[15] && ($function_call{PARAMS} =~ /\(.*,0,[^,]*\)$/))
		{
			display_function_typo_normal(15);
		}

		if ($enable[52] && 
			($function_call{PARAMS} =~ /this,sizeof\(this\)/))
		{
			display_function_typo_normal(52);
		}
	}
	############################################################
	#
	# LocalReAlloc and GlobalReAlloc may fail if
	# LMEM_MOVEABLE/GMEM_MOVEABLE isn't passed in and the
	# memory needs to be relocated
	#
	# LHND/GHND include LMEM_MOVEABLE/GMEM_MOVEABLE.
	# The third param must have uppercase letters. '_', or 0.
	# otherwise, it's probably a var/parameter.
	#
	elsif (($function_id & ($LOCALREALLOC_FUNCTION | $GLOBALREALLOC_FUNCTION)) &&
			($function_call{PARAMS} =~ /,[A-Z_0|+]+\)/) &&
			($function_call{PARAMS} !~ /MEM_MOVEABLE|HND/))
	{
		# Don't whine if we see a function prototype, i.e.
		# LocalReAlloc(HLOCAL,UINT,UINT)
		#
		if ($enable[16] && ($function_call{PARAMS} !~ /\([A-Z]+,[A-Z]+,[A-Z]+\)/))
		{
			display_function_typo_normal(16);
		}
	}

	############################################################
	#
	# Check if the ReAlloc flags have been entered in
	# the wrong order or the wrong flags are being used,
	# i.e. HEAP_XXX or GMEM_XXX for LocalReAlloc
	#
	# Simple check would be ",LMEM_FIXED," but
	# that wouldn't catch the case where the flags are
	# bitwise-OR'd together, i.e.
	# ",LMEM_MOVEABLE|LMEM_ZEROINIT,"
	#
	# So we just check for the trailing comma
	#
	if ($enable[18] && ($function_id & $LOCALREALLOC_FUNCTION))
	{
		if ($function_call{PARAMS} =~ /
							LMEM_FIXED,|
							LMEM_MOVEABLE,|
							LMEM_NOCOMPACT,|
							LMEM_NODISCARD,|
							LMEM_ZEROINIT,|
							LMEM_MODIFY,|
							LMEM_DISCARDABLE,|
							LMEM_VALID_FLAGS,|
							LMEM_INVALID_HANDLE,|
							LHND,|
							LPTR,|
							NONZEROLHND,|
							NONZEROLPTR,
						   /x ||
			$function_call{PARAMS} =~ /,HEAP[A-Z_|+]+\)|,GMEM_[A-Z_|+]+\)/)
		{
			display_function_typo_normal(18);
		}
	}

	if ($enable[18] && ($function_id & $GLOBALREALLOC_FUNCTION))
	{
		if ($function_call{PARAMS} =~ /
							GMEM_FIXED,|
							GMEM_MOVEABLE,|
							GMEM_NOCOMPACT,|
							GMEM_NODISCARD,|
							GMEM_ZEROINIT,|
							GMEM_MODIFY,|
							GMEM_DISCARDABLE,|
							GMEM_NOT_BANKED,|
							GMEM_SHARE,|
							GMEM_DDESHARE,|
							GMEM_NOTIFY,|
							GMEM_LOWER,|
							GHND,|
							GPTR,
						   /x ||
			$function_call{PARAMS} =~ /,HEAP[A-Z_|+]+\)|,LMEM_[A-Z_|+]+\)/)
		{
			display_function_typo_normal("18a");
		}
	}

	if ($enable[18] && ($function_id & $HEAPREALLOC_FUNCTION))
	{
		if ($function_call{PARAMS} =~ /,GMEM_[A-Z_|+]+,|,LMEM_[A-Z_|+]+,/)
		{
			display_function_typo_normal("18b");
		}
	}

	if ($enable[31] && ($function_id & $OVERFLOW_FUNCTION))
	{
		display_function_typo_normal(31);
	}

	# Make sure we don't use flags from CreateFile/CreateFileMapping
	if ($enable[38] && ($function_id & $CHECK_FUNCTION) &&
		($function_call{NAME} eq "MapViewOfFile") &&
		($function_call{PARAMS} =~ /[\|\,\(] (GENERIC_\w+ | PAGE_\w+ | FILE_SHARE) |
									^(GENERIC_\w+|PAGE_\w+|FILE_SHARE)/x))
	{
		display_function_typo("invalid flag for $function_call{NAME};", 38);
	}

	if (($function_id & $INVALID_HANDLE) &&
		($function_call{NAME} eq "CreateFile"))
	{
		# Make sure we don't use flags 
		# from MapViewOfFile/CreateFileMapping
		if ($enable[39] && ($function_call{PARAMS} =~ /FILE_MAP_|PAGE_/))
		{
			display_function_typo("invalid flag for $function_call{NAME};", 39);
		}

		# Make sure we don't use the same flag more than once
		if ($enable[40])
		{
			while ($function_call{PARAMS} =~ /(GENERIC_[A-Z]+ | FILE_SHARE_[A-Z]+)/gx)
			{
				my $pos = pos($function_call{PARAMS});
				my $match = $1;

				if ($' =~ /^[^:]* [\|\+] $match/x)
				{
					display_function_typo("duplicate $match flags for $function_call{NAME};", 40);
					last;
				}

				pos($function_call{PARAMS}) = $pos;
			}
		}
	}

	#
	# Check if a NULL DACL is passed to SetSecurityDescriptorDacl
	# This provides no security for the resulting object
	#
	if ($enable[58] && ($function_call{NAME} eq "SetSecurityDescriptorDacl"))
	{
		my $params = $function_call{PARAMS};
		my $count = $params =~ tr/\,/\,/;

		if ($count > 3)
		{
			# Remove outermost parens
			$params =~ s/^\((.*?)\)$/$1/;

			# Remove any inner parens
			$params =~ s/\([^\(]*\)/_/g;
		}

		if ($params =~ /^ .*? \, .*? \, (.*?) \,/x)
		{
			my $dacl = $1;
			if ($dacl =~ /\)?NULL/)
			{
				display_function_typo_normal(58);
			}
		}
	}

	#
	# Check if ExAllocatePool called with NonPagedPoolMustSucceed or 
	# NonPagedPoolCacheAlignedMustS flags
	#
	if ($enable[62] && ($function_id & $EXALLOCATE_FUNCTION))
	{
		my $params = $function_call{PARAMS};

		if ($params =~ /NonPagedPoolMustSucceed|NonPagedPoolCacheAlignedMustS/)
		{
			display_function_typo_normal(62);
		}
	}

	############################################################
	#
	# We've got a function that  we're interested in
	#
	# Keep track of where the return value is put and all
	# the parameters for the function call
	#
	if ($function_id & 
			($ALLOCA_FUNCTION | $CHECK_FUNCTION | $RPC_FUNCTION | $BUFFER_CHARS_FUNCTION |
			$LOCALREALLOC_FUNCTION | $GLOBALREALLOC_FUNCTION | $REG_FUNCTION |
			$REALLOC_FUNCTION | $HEAPREALLOC_FUNCTION | $HRESULT_FUNCTION |
			 $INVALID_HANDLE | $HANDLE_FUNCTION | $HFILE_FUNCTION))
	{
		my $slop;
		my $func;
		my $func_display;
		my $func_call;
		my $func_line;
		my @assign_vars = ();
		my $cast = '';

		if ($function_call{BEFORE} =~ /==/)
		{
			$slop = "==";
		}
		elsif (($function_call{NAME} =~ /^ExAllocatePool/) &&
			($function_call{PARAMS} =~ /NonPagedPoolMustSucceed |
										NonPagedPoolCacheAlignedMustS/x))
		{
			$slop = "==";
		}
		else
		{
			if ($function_call{BEFORE} =~ /(\([^\(\)]+\))$/)
			{
				$cast = $1;
			}

			$slop = '';
			@assign_vars = parse_vars($function_call{BEFORE});
		}

		if (($slop !~ /^==/) && ($#assign_vars >= 0))
		{
			my $func_info;

			$func = join("", '=', $cast, $function_call{NAME}, $function_call{PARAMS});

			$func_call = $function_call{NAME};
			$func_line = $function_call{LINE};
			# remove any trailing CRLF
			chomp($func);

			$func_display = $func;

			########################################
			#
			# We need to quote the contents of $func
			# so that when we try to look for $func
			# in another string, perl doesn't interpret
			# any of the chars in $func as part of
			# a regular expression.
			#
			# We just want a literal match.
			#
			# Many neurons died needlessly before I figured 
			# out what was going on
			#
			$func =~ s/(\W)/\\$1/g;

			$func_info = {
							TYPE => $func_call,
							CALL => $func,
							CALL_SHOW => $func_display,
							LINE => $func_line,
							CHECK => 0,
							REFS => 0,
							REPORT => $VAR_UNUSED
						};

			if ($enable[27] &&
				exists($function_list{$func_info->{TYPE}}) &&
				($function_list{$func_info->{TYPE}} & 
					($CHECK_FUNCTION | $LOCALREALLOC_FUNCTION |
					$GLOBALREALLOC_FUNCTION | $REALLOC_FUNCTION | $REG_FUNCTION |
					$HEAPREALLOC_FUNCTION |	$INVALID_HANDLE | $RPC_FUNCTION | $BUFFER_CHARS_FUNCTION |
					$HANDLE_FUNCTION | $HFILE_FUNCTION | $HRESULT_FUNCTION)))
			{
				$func_info->{CHECK} = 1;
			}

			if ((0 == $ignore_result_list_count) || !exists($ignore_result_list{$func_call}))
			{
				add_vars($func_info, @assign_vars);
			}
		}
	}

	############################################################
	#
	# Check if the result from a realloc is assigned to
	# the variable that was passed to realloc.
	#
	# If the realloc fails, then the memory has leaked
	#
	if ($enable[17] &&
		($function_id & ($REALLOC_FUNCTION | 
						$LOCALREALLOC_FUNCTION | 
						$GLOBALREALLOC_FUNCTION)) &&
		($function_call{BEFORE} =~ /([\w\->\[\]\.]+)=/))
	{
		my $var = $1;
		$var =~ s/(\W)/\\$1/g;

		# Code may cast the realloced var to
		# HLOCAL or HGLOBAL to make the compiler happy
		if ($function_call{PARAMS} =~ /\($var, |
										\(\(HGLOBAL\)$var, |
										\(\(HLOCAL\)$var, /x)
		{
			display_function_typo_normal(17, $function_call{BEFORE});
		}
	}
	elsif ($enable[17] && ($function_id & $HEAPREALLOC_FUNCTION) &&
		($function_call{BEFORE} =~ /([\w\->\[\]\.]+)=/))
	{
		my $var = $1;
		$var =~ s/(\W)/\\$1/g;

		if ($function_call{PARAMS} =~ /,.*?,$var,.*?\)/)
		{
			display_function_typo_normal(17, $function_call{BEFORE});
		}
	}

	############################################################
	#
	# Check if there's use of sizeof for these functions
	#
	#
	if ($enable[56] && ($function_id & $BUFFER_CHARS_FUNCTION))
	{
		my $found = 0;

		if ($function_call{PARAMS} =~ /[\(\,]sizeof\(/)
		{
			my $after = $';

			if ($after !~ /^[^,]+?\/sizeof\(/)
			{
				$found = 1;
			}
			else
			{
				my $params = $after;

				while ($params =~ /[\(\,]sizeof\(/)
				{
					my $after = $';

					if ($after !~ /^[^,]+?\/sizeof\(/)
					{
						$found = 1;
						last;
					}

					$params = $after;
				}
			}
		}

		if (0 == $found)
		{
			my $var;

			foreach $var (sort keys(%vars_sizeof))
			{
				if ($function_call{PARAMS} =~ /[\(\,]&?$var\b/)
				{
					my $after = $';

					# We know var uses sizeof.
					# If there's a sizeof after the var then 
					# we'll assume it's kosher
					if ($after =~ /^[^,]*?\/sizeof\(/)
					{
						next;
					}

					if ($vars_sizeof{$var} !~ /sizeof\([^,]+?\/sizeof\(/)
					{
						$found = 1;
						last;
					}
				}
			}
		}

		if (1 == $found)
		{
			display_function_typo_normal(56);
		}
	}
}

sub emit_string
{
	my ($str_constant) = @_;

	if ($do_strings && ($str_constant ne '') && ($str_constant ne 'C'))
	{
		if ($do_strings & $STRINGS_STRIP)
		{
			# Remove ampersands, in the case of menus, the ampersand,
			# represents which character is underlined by Windows
			$str_constant =~ tr /&//d;

			# Remove character constants like CR, LF, TAB, and NULL
			while ($str_constant =~ /[^\\]\\[nrt0]/)
			{
				$str_constant =~ s/([^\\])\\[nrt0]/$1 /g;
			}

			$str_constant =~ s/^\\[nrt0]/ /;

			# Remove strings from menus that represent accelerators
			$str_constant =~ s/\b(CTRL|ALT|SHIFT)\+F?(\w|\d+)$//i;
			$str_constant =~ s/\bF\d+$//;

			# strip whitespace from beginning and end of the string
			$str_constant =~ s/\s+$//;
			$str_constant =~ s/^\s+//;

			if ($str_constant =~ /^\# | ^\.+\\+/x)
			{
				$str_constant = '';
			}
		}

		# Don't pass on anything that looks like a filename
		if ((length($str_constant) > 1) &&
			($str_constant =~ /[a-z]/) && 
			($str_constant !~ /^\S+\.(h | bmp | tlb | rc | exe |
										htm | js | rgs | ico)$/x) &&
			!exists($ignore_strings{$str_constant}))
		{
			print "\U$filename\E ($line_current):\tmessage 98:\t'$str_constant'\n";
		}
	}
}

sub find_and_load_build_db
{
	my $build_db_file = '';
	my $build_dir = '';

	# build base specified by BASEDIR?
	if (exists($ENV{BASEDIR}) && ($ENV{BASEDIR} ne ''))
	{
		$build_dir = $ENV{BASEDIR};
		print STDERR "Found BASEDIR @ '$build_dir'\n" if (0 != $debug_build_dat);
	}
	else
	{
		my $root = '';
		my $drive = '';

		# build base specified by _NTROOT & _NTDRIVE?
		if (exists($ENV{_NTROOT}) && ($ENV{_NTROOT} ne ''))
		{
			$root = $ENV{_NTROOT};
		}

		if (exists($ENV{_NTDRIVE}) && ($ENV{_NTDRIVE} ne ''))
		{
			$drive = $ENV{_NTDRIVE};
		}

		$build_dir = $drive . $root;

		if ($build_dir ne '')
		{
			print STDERR "Found _NTROOT + _NTDRIVE @ '$build_dir'\n" if (0 != $debug_build_dat);
		}
	}

	# Found a build dir
	if ($build_dir ne '')
	{
		$build_db_file = $build_dir . "\\build.dat";

		# Found a build.dat?
		if (-T $build_db_file)
		{
			# Yes. Load up its files into the hash
			print STDERR "Loading build.dat from '$build_db_file'\n" if (0 != $debug_build_dat);
			load_files_from_build_db($build_db_file);
		}
		else
		{
			$build_db_file = '';
		}
	}

	# No build.dat yet?
	if ($build_db_file eq '')
	{
		my $cur_dir = '';
		my $dir = '';

		# No build environment or CE build environment.
		#
		# Let's try searching the current dir and its parent dirs for build.dat

		# Get the current working directory
		# I don't want to pull in other packages
		# so the following does the same thing
		open(CWD, "cd |") || die ">> Can't get current working directory!!!\n";
		$cur_dir = <CWD>;
		close(CWD);

		# Make sure there's no EOL
		chomp($cur_dir);

		print STDERR "Got CWD = '$cur_dir'\n" if (0 != $debug_build_dat);

		# Search for build.dat in current dir
		# If no build.dat, check for a dirs or sources file
		# If we find either one, search the parent for build.dat
		# If we don't have a dirs or sources, then we're not
		# in the build tree

		$dir = $cur_dir;

		while ($dir ne '')
		{
			my $dirs;
			my $sources;

			# Is build.dat in this directory?
			$build_db_file = $dir . "\\build.dat";
			if (-T $build_db_file)
			{
				# Yes.
				print STDERR "Got build.dat @ '$build_db_file'\n" if (0 != $debug_build_dat);
				print STDERR "Loading build.dat from '$build_db_file'\n" if (0 != $debug_build_dat);
				load_files_from_build_db($build_db_file);
				last;
			}

			# No build.dat found - so null out var
			$build_db_file = '';

			# Check if there's a dirs or sources file in this directory
			$dirs = $dir . "\\dirs";
			$sources = $dir . "\\sources";

			if ((-T $dirs) || (-T $sources))
			{
				# Yes.
				print STDERR "Found dirs/sources in: '$dir'\n" if (0 != $debug_build_dat);

				# Move up to the parent dir by
				# grabbing everything until the last dir separator
				if ($dir =~ /^(.*)[\\\/][^\\\/]+$/)
				{
					$dir = $1;
					print STDERR "Moving up to parent: $dir\n" if (0 != $debug_build_dat);
					next;
				}
				else
				{
					print STDERR "Couldn't get parent for '$dir'!!!\n" if (0 != $debug_build_dat);
					$dir = '';
					last;
				}
			}

			print STDERR "Couldn't find either dirs or sources file!!!\n" if (0 != $debug_build_dat);
			last;
		}
	}

	# No build.dat found yet.
	#
	# Maybe we're in a dir higher than the build.dat (which can happen in CE)
	#
	# Scan for build.dat files in the subdirs and use those
	#
	if ($build_db_file eq '')
	{
		my $line;
		local *BUILDDAT;

		# Scan for build.dat files in current dir and all subdirs
		open(BUILDDAT, "$DIR_CMD build.dat |") || die "Can't get list of build.dat's!!!\n";

		while ($line = <BUILDDAT>)
		{
			chomp($line);

			if (-T $line)
			{
				print STDERR "Got build.dat @ '$line'\n" if (0 != $debug_build_dat);
				print STDERR "Loading build.dat from '$line'\n" if (0 != $debug_build_dat);
				load_files_from_build_db($line);
			}
		}

		close(BUILDDAT);
	}
}


sub load_files_from_build_db
{
	my ($build_dat_file)	= @_;
	my $FILEDB_DIR			= 0x00000002;
	my $first				= 0;
	my $line				= '';
	my $line_count			= 0;
	my $dir					= '';
	my @lines				= ();
	local *FILE;

	# Open the BUILD.DAT file
	if (!open(FILE, $build_dat_file))
	{
		print STDERR ">> Couldn't open file: $build_dat_file\n" if (0 != $debug_build_dat);
		return;
	}

	# Read in the whole file
	@lines = <FILE>;

	# Close the file
	close(FILE);

	# Parse the file
	foreach (@lines)
	{
		$line = $_;
		$line_count += 1;

		if ($line =~ /^V\s+\d+/)
		{
			# VERSION

			if ((0 != $first) || (1 != $line_count))
			{
				print STDERR ">> Bad build.dat file: line #$line_count\n";
				last;
			}

			$first = 1;
		}
		elsif ($line =~ /^D\s/)
		{
			# DIRECTORY

			my $after = $';

			if ($after =~ /^(\S+) \s [\da-fA-F]+/x)
			{
				$dir = $1;
				print STDERR "DIR = '$dir'\n" if (0 != $debug_build_dat);
			}
			else
			{
				print STDERR ">> Bad build.dat file: Bad dir description line #$line_count\n";
			}
		}
		elsif ($line =~ /^\sF\s/)
		{
			# FILE

			my $after = $';

			if ($after =~ /^(\S+)
							\s ([\da-fA-F]+)
							\s ([\da-fA-F]+)
							\s ([\da-fA-F]+)
							\s ([\da-fA-F]+)
							\s ([\da-fA-F]+)/x)
			{
				my $file = $dir . "\\" . $1;
				my $attr = hex($2);

				if (!($attr & $FILEDB_DIR))
				{
					$file =~ tr/A-Z/a-z/;
					$build_files_hash{$file} = $attr;
					print STDERR "FILE = '$file'\n" if (0 != $debug_build_dat);
				}
			}
			else
			{
				print STDERR ">> Bad build.dat file: Bad file description line #$line_count\n";
			}
		}
		elsif ($line =~ /^\s\sI\s/)
		{
			# INCLUDE

			my $after = $';

			if ($after =~ /^(\S+) \s ([\da-fA-F]+) \s ([\da-fA-F]+)/x)
			{

			}
			else
			{
				print STDERR ">> Bad build.dat file: Bad include description line #$line_count\n";
			}
		}
		elsif ($line eq "\n")
		{
			if ($dir eq '')
			{
				print STDERR ">> Bad build.dat file: No dir before empty line: line #$line_count\n";
			}
			$dir = '';
		}
		else
		{
			print STDERR ">> Bad build.dat file: Unknown line: line #$line_count\n";
			last;
		}
	}

	undef @lines;
}

sub display_function_typo
{
	my ($typo, $typo_num) = @_;

	display_typo($filename, $function_call{LINE}, $typo, $typo_num, 
				"$function_call{NAME}$function_call{PARAMS}\n");
}

sub display_function_typo_normal
{
	my $typo_num = shift @_;
	my $misc = '';
	my $typo_display = $typo_num;

	if ($#_ >= 0)
	{
		$misc = shift @_;
	}
	$typo_display =~ s/[A-Za-z]//g;

	display_typo($filename, $function_call{LINE}, $typo_description{$typo_num}, $typo_display, 
				"$misc$function_call{NAME}$function_call{PARAMS}\n");
}

sub display_typo_normal
{
	my ($filename, $line_number, $typo_number, $description)	= @_;
	my $typo_display = $typo_number;

	$typo_display =~ s/[A-Za-z]//g;

	$stats{TYPOS} += 1;
	if (0 == $output_xml)
	{
		print "$filename ($line_number):\t$typo_description{$typo_number} $typo_display:\t$description";
	}
	else
	{
		display_typo_xml($filename, $line_number, $typo_description{$typo_number}, $typo_display);
	}
}

sub display_typo
{
	my ($filename, $line_number, $warning, $typo_number, $description)	= @_;

	$stats{TYPOS} += 1;

	if (0 == $output_xml)
	{
		print "$filename ($line_number):\t$warning $typo_number:\t$description";
	}
	else
	{
		display_typo_xml($filename, $line_number, $warning, $typo_number);
	}
}

sub display_typo_xml
{
	my ($filename, $line_number, $warning, $typo_number)	= @_;
	my $path = '';
	my $file = '';
	my $function = ($current_function ne '') ? $current_function : "foo";

	# First typo - need to output opening tags
	if (1 == $stats{TYPOS})
	{
		print "\<\?xml version=\"1.0\" encoding=\"UTF-8\"\?\>\<DEFECTS FoundBy=\"TYPO.PL $SCRIPT_VERSION\"\>";
	}

	if ($filename =~ /^(.*[\\\/])([^\\\/]+)$/)
	{
		$path = $1;
		$file = $2;
	}
	else
	{
		$path = "\.\\";
		$file = $filename;
	}

	print "\<DEFECT _seq=\"$stats{TYPOS}\"\>",
		  "\<SFA\>",
		  "\<LINE\>$line_number\<\/LINE\>",
		  "\<COLUMN\>1\<\/COLUMN\>",
		  "\<FILENAME\>$file\<\/FILENAME\>",
		  "\<FILEPATH\>$path\<\/FILEPATH\>",
		  "\<\/SFA\>",
		  "\<DEFECTCODE\>$typo_number\<\/DEFECTCODE\>",
		  "\<DESCRIPTION\><![CDATA[$warning]]>\<\/DESCRIPTION\>",
		  "\<RANK\>0\<\/RANK\>",
		  "\<MODULE\>$file\<\/MODULE\>",
		  "\<RUNID\>1\<\/RUNID\>",
		  "\<FUNCTION\><![CDATA[$function]]>\<\/FUNCTION\>",
		  "\<FUNCLINE\>$current_function_line\<\/FUNCLINE\>",
		  "\<PATH\>",
		  "\<SFA\>",
		  "\<LINE\>$line_number\<\/LINE\>",
		  "\<COLUMN\>1\<\/COLUMN\>",
		  "\<FILENAME\>$file\<\/FILENAME\>",
		  "\<FILEPATH\>$path\<\/FILEPATH\>",
		  "\<\/SFA\>",
		  "\<\/PATH\>",
		  "\<\/DEFECT\>";
}

######################################################################
######################################################################
######################################################################
######################################################################

=pod

=for html
<font size="-1">

Authour:

=for html 
<A name="mailto" href="mailto:typo_pl@hotmail.com">Johnny Lee</A>

Last update: Aug 27 12:00 PDT 

=for html
</font>

=head1 LEGAL INFORMATION

The information contained in this document represents the 
current view of Microsoft Corporation on the issues discussed as of the date 
of publication. Because Microsoft must respond to changing market conditions, 
it should not be interpreted to be a commitment on the part of Microsoft, 
and Microsoft cannot guarantee the accuracy of any information presented. 
This document is for informational purposes only.  

MICROSOFT MAKE NO WARRANTIES, EXPRESS OR IMPLIED, IN THIS DOCUMENT.

Microsoft Corporation may have patents or pending patent applications, 
trademarks, copyrights, or other intellectual property rights covering 
subject matter in this document. The furnishing of this document does not
give you any license to these patents, trademarks, copyrights, or
other intellectual property rights.

Microsoft does not make any representation or warranty regarding
specifications in this document or any product or item developed based on 
these specifications. Microsoft disclaims all express and implied warranties,
including but not limited to the implied warranties of merchantability, 
fitness for a particular purpose, and freedom from infringement. 
Without limiting the generality of the foregoing,  Microsoft shall not be
liable for any damages arising out of or in connection with the use of these
specifications, including liability for lost profit, business interruption, 
or any other damages whatsoever. 

Copyright E<copy> 1996-2001 Microsoft Corporation. All rights reserved.

=head1 NAME

TYPO.PL - scans C/C++ source code for possible errors

=head1 DESCRIPTION

Typo.pl is a Perl script which scans 
C/C++ source code for possible errors.

The script was originally written to locate various typing errors, 
i.e. C<X == Y;> instead of C<X = Y;>

The L<list of possible errors|"ERRORS"> reported by the script has grown considerably.


If you have any questions, suggestions, or complaints, please let L<me|"mailto"> know.

=head1 VERSION

B<2.55> (released Aug 27 2001)

=head1 LATEST CHANGES

=over 4

=item * 

fixed output problem when neither C<-output_xml> or C<-showtime> options were specified and no typos were found

=item * 

fixed problem with case 27 when variables were assigned inside an try-catch

=item * 

added case 62 to catch using C<NonPagedPoolMustSucceed> or C<NonPagedPoolCacheAlignedMustS> flags with
with the C<ExAllocatePool> class of allocation APIs. 


=back

=head1 HOW TO GET MORE COMPLETE RESULTS

You'll have to do some work and specify the behaviour of
your private functions to the Perl script via one of the L<options in the Usage section|"USAGE">.
You should place these options in an optionfile so you don't have to enter them
repeatedly.

If you have a function, C<AllocFoo>, that allocates memory and returns the allocated memory, 
you would use the C<-cfr> option, i.e. C<-cfr:AllocFoo>.

=head1 QUICK START

=over 4

=item 1 

If you don't have Perl installed, install the latest

=for html <a href="http://www.activestate.com/Products/ActivePerl/index.html">Win32 version from ActiveState</a>

=item 2

=for html
Copy typo.pl to your machine.<br>

=item 3

Copy either win32.txt or ce.txt to your machine.

=item 4

Go to the topmost directory in your source and type the following:

 perl c:\bin\typo.pl -optionfile:c:\bin\win32.txt c >c:\temp\typo.out

=item 5

To view the script's output, use any text editor or the typo viewer app

=back

=head1 USAGE

=over 4

=item To examine all text files from the current directory down

 perl typo.pl

=item To examine a list of files from STDIN

 perl typo.pl -

C<dir /B /A:-R | perl typo.pl -> will examine 
 all writable text files in a directory

=for html <br><br>

=item To examine all C/C++ files in the current directory down

 perl typo.pl c

=item To examine a single file

 perl typo.pl <path to filename>

the path to filename can be a partial or full path

=for html <br><br>

=item To disable reporting certain cases, use the -disable option

 perl typo.pl -disable:1,2-5,9

disables reporting about cases 1, 2 to 5, and 9

=for html <br><br>

=item To enable reporting certain cases, use the -enable option

 perl typo.pl -enable:1,2-5,9

enables reporting about cases 1, 2 to 5, and 9

N.B. last -enable/-disable wins:

C<-disable:1-30 -enable:1-15>
results in cases 16-30 disabled, 1-15 enabled.

=for html <br><br>

=item To ignore certain files:

 perl typo.pl -ignore:<pattern1>[,<pattern2>[,...]]

ignores filenames that match the given patterns

'*' is only valid wilcard character

=for html <br><br>

=item To scan files that have a modification date/time later than given

 perl typo.pl -newer:<yr=1970-2038>,<mon=1-12>, <day=1-31>,<hr=0-23>,<minute=0-59>

scans files that have a mod. date/time later than
given, i.e. -newer:1998,1,31,4,30 => Jan 31, 1998 04:30

=for html <br><br>

=item To print out the time when the script starts and stops scanning

 perl typo.pl -showtime

=item To print out the # of comments and which functions were seen

 perl typo.pl -showstats

=item To print out the file that the script is currently processing

 perl typo.pl -showprogress

=item To enable nonbuffered output

 perl typo.pl -nonbuffered

=item To enable line-by-line disabling of specific cases

 perl typo.pl -notypo

Code must be annotated with the word "NO_TYPO"
on the line to be disabled for typo reporting.
To specify certain cases to be disabled, use
the format S<NO_TYPO:XX,YY,...> where XX, YY
represent the specific cases that are disabled.

=for html <br><br>

=item To check the results of additional functions

 perl typo.pl -cfr:<function1>[,<function2>[,...]]

scans results of specified functions to see
if they are used before they have been checked for success

=for html <br><br>

=item To use a text file to specify a list of options

 perl typo.pl -optionfile:<filename>

reads in all the lines of the specified file and parses
each line as a possible option

=for html
<table cellpadding=10 summary="Sample option file">
<caption>Sample option file</caption>
<tr>
<td class="option">
<pre>
-version:2.47
-showtime
-cfr:GlobalAlloc,LocalAlloc,HeapAlloc,malloc,VirtualAlloc
-cfr:SysAllocString,ExAllocatePool
-newer:1998,6,14,12,30
</pre>
</td>
</tr>
</table>
<br>

=item To specify directories to look for option files

 perl typo.pl -optiondir:<directory1>[,<directory2>[,...]]

specifies directories to be searched if the option file
cannot be found in the current directory. This option should 
be specified before -optionfile. If directories are not 
specified with trailing backslashes, then backslashes 
will be appended.

=for html <br><br>

=item To add to list that checks on function results

 perl typo.pl -checked:<function1>[,<function2>[,...]]

informs script that the specified functions will 
check the result from previous function calls
so there's no need to report use before check typo

i.e. if you specify C<-checked:foobar>, then

 x = malloc(16);
 foobar(x);

won't report a typo.

=for html <br><br>

=item To add to list that doesn't deref/access function results

 perl typo.pl -noderef:<function1>[,<function2>[,...]]

informs script that the specified functions will 
not dereference the result from previous function calls
so there's no need to report use before check typo yet.

i.e. if you specify C<-noderef:Output>, then

 x = malloc(16);
 Output("%8.8lX\n", x);

won't report a typo yet.

=for html <br><br>

=item To add to list that checks on function results similar to operator new

 perl typo.pl -new:<function1>[,<function2>[,...]]

informs script that the specified functions behave
similar to C<operator new> for case 34.

=for html <br><br>

=item To check the results of functions that return handles

 perl typo.pl -fn:HANDLE:<function1>[,<function2>[,...]]

scans results of specified functions to see
if they're used before they've been checked
for success and if the result is compared to 
C<INVALID_HANDLE_VALUE>.

=for html <br><br>

=item To check the results of functions that return HRESULTs

 perl typo.pl -fn:HR:<function1>[,<function2>[,...]]

scans results of specified functions to see
if they're used before they've been checked for success
and if the result is tested via 
C<SUCCEEDED> or C<FAILED> macros.

=for html <br><br>

=item To add to the function list that return INVALID_HANDLE_VALUE

 perl typo.pl -fn:INVALID:<function1>[,<function2>[,...]]

scans results of specified functions that behave
like C<CreateFile> (case 20)

=for html <br><br>

=item To add to the function list that return the length of strings

 perl typo.pl -fn:LEN:<function1>[,<function2>[,...]]

scans for use of specified functions that are used for 
finding the lengths of null-terminated strings

=for html <br><br>

=item To add to the function list that could overflow buffers

 perl typo.pl -fn:OVERFLOW:<function1>[,<function2>[,...]]

scans for use of specified functions that can overflow
buffers passed to them

=for html <br><br>

=item To add to the function list that behaves like C<realloc>

 perl typo.pl -fn:REALLOC:<function1>[,<function2>[,...]]

scans for use of specified functions that behave
like realloc (case 17)

=for html <br><br>

=item To add to the function list that are registry functions

 perl typo.pl -fn:REG:<function1>[,<function2>[,...]]
	
specifies registry functions whose result need to checked with ERROR_SUCCESS

=for html <br><br>

=item To add to the function list that are RPC functions

 perl typo.pl -fn:RPC:<function1>[,<function2>[,...]]
	
specifies RPC functions that need to be checked with RPC_* error codes

=for html <br><br>

=item To add to the function list that are ignorable asserts

 perl typo.pl -fn:SAFEASSERT:<function1>[,<function2>[,...]]
	
specifies assert functions that are ignored for case 4

=item To add to the function list that can throw/raise exceptions

 perl typo.pl -fn:THROW:<function1>[,<function2>[,...]]

scans for specified functions to see if they're used in a C<try>

=for html <br><br>

=item To add to the function list that don't return a value

 perl typo.pl -fn:VOID:<function1>[,<function2>[,...]]

prevents reports of case 32 for functions that don't
return a value.

=for html <br><br>

=item To add to the function list that terminate a case statement

 perl typo.pl -endcase:<function1>[,<function2>[,...]]

informs script that the specified functions behave
similar to C<break> statement for case 19.

=for html <br><br>

=item To add to list of #defines that may not be always defined

 perl typo.pl -temp_defined:<define1>[,<define2>[,...]]

informs script that the specified defines may
not always be available.

=for html <br><br>

=item To specify that C<#if>, C<#ifdef>, C<#ifndef>, C<#elif>, 
 C<#else>, and C<#endif> preprocessor directives should be handled

 perl typo.pl -ifdef

There should be accompanying use of the C<-define> option B<unless> you want
the script to never check code within C<#if>'s, C<#ifdef>'s, etc.

=for html <br><br>

=item To specify symbols and their values for C<#if>, C<#ifdef>, C<#ifndef>, and C<#elif>
	preprocessor directives, use the C<-define> option:

 perl typo.pl -define:<define1>[=<value1>]

This must be used with the C<-ifdef> option

=for html <br><br>

=item To print out metrics about the scanned files:

 perl typo.pl -kloc:[1 | 2]

=over 4

=item 1 

specifies functionality and display similar to Code metric app

=item 2

specifies functionality and display similar to Code metric app but also
displays the number of functions in a file.

=back

=for html <br>

=item To specify that string constants should be extracted from the scanned files:

 perl typo.pl -extract_strings:[c | m | r | s]

=over 4

=item C<c>

specifies strings from C/C++ source code files should be extracted

=item C<m> 

specifies strings from message compiler (.MC) files should be extracted

=item C<r> 

specifies strings from resource (.RC, .RCV, .DLG) files should be extracted

=item C<s> 

specifies that the strings should be stripped, 
mostly removing escaped character constants, Menu accelerators, and strings that 
look like filenames

=back

=for html <br><br>

=item To print out help

 perl typo.pl -help
 perl typo.pl -h
 perl typo.pl -?

=for html <br>

=item To specify that results are output in XML format

 perl typo.pl -output_xml

=for html <br>

=item To specify the version of the typo.pl script required

 perl typo.pl -version:<number>

=for html <br>

=item To specify functions whose results should be ignored

 perl typo.pl -ignore_result:<function>[,<function2>[,...]]

=item To specify that the code is run in kernel-mode and code in try-except blocks should B<ALWAYS> check for non-NULL ptrs

 perl typo.pl -kernel_code

=for html <br>

=item To specify that the script should only scan files that are in build.dat:

 perl typo.pl -use_build_dat

The algorithm that the script uses to locate the build.dat is as follows:

=over 4

=item *

Check if the environment variable BASEDIR exists, if so, use that as the dir for build.dat

=item *

Otherwise check if the environment variables _NTROOT && _NTDRIVE exist, if so, use that as the dir for build.dat

If the dir is specified, check if build.dat is located in that dir.

=item *

If no build.dat was found, do the following scan, which works in non-build environment command windows 
and for CE source trees:

=over 4

=item 1

Get current directory.

=item 2

If we find build.dat in current directory, use it.

=item 3

If we find a dirs or sources file, set parent dir as current dir (we don't actually change the current working dir).

=item 4

Go to step 2.

=back

=item *

If we still can't find a build.dat file, which may occur if we're in _WINCEROOT for a CE tree,
we search for build.dat in the current directory and any sub dirs. Any build.dat files
that are found are used.

=back

=back

=head1 ERRORS

Following potential programming errors are flagged:

=for html <table summary="Errors" border="1" cellpadding="10">

=for html <tr><td>1.</td><td><a name="typo1"></a>

semicolon appended to an if statement

 if (x == y);
  exit(1);

=for html </td></tr>

=for html <tr><td>2.</td><td><a name="typo2"></a>

use of C<==> instead of C<=> in assignment statements, handles C<+>/C<-> too.

 X == Y;
 X - NULL;

=for html </td></tr>

=for html <tr><td>3.</td><td><a name="typo3"></a>

assignment of a number in an if statement, probably meant a comparison

 if (x = 3)

=for html </td></tr>

=for html <tr><td>4.</td><td><a name="typo4"></a>

assignment within an Assert

 ASSERT(Z = 4);

=for html </td></tr>

=for html <tr><td>5.</td><td><a name="typo5"></a>

increment/decrement of ptr, ptr's contents not modified, may have meant to modify ptr's contents

 *ptr++;

=for html </td></tr>

=for html <tr><td>6.</td><td><a name="typo6"></a>

logical AND with a number

 x = y && 1;

=for html </td></tr>

=for html <tr><td>7.</td><td><a name="typo7"></a>

logical OR with a number

 x = y || 2;

=for html </td></tr>

=for html <tr><td>8.</td><td><a name="typo8"></a>

bitwise-AND/OR/XOR of number compared to another value
may have undesired result due to C precedence rules since bitwise-AND/OR/XOR has lower precedence than
the comparison operators.

 if (x & 1 == 0)

=for html </td></tr>

=for html <tr><td>9.</td><td><a name="typo9"></a>

referencing C<Release>/C<AddRef> instead of invoking them

 punk->Release;

=for html </td></tr>

=for html <tr><td>10.</td><td><a name="typo10"></a>

whitespace following a line-continuation character

 #define X stuff \<SPACE>

=for html </td></tr>

=for html <tr><td>11.</td><td><a name="typo11"></a>

shift or mod operator ( <<, >>, % ) followed by +,-,*,/ may 
have undesired result due to C precedence rules.
The shift operator has lower precedence.

 x = (y << 1 + 1);

is seen by the compiler as

 x = y << (1 +1);

Some code confused the precedence of % and +/-.
% is higher than +/-.

=for html </td></tr>

=for html <tr><td>12.</td><td><a name="typo12"></a>

very basic check for uninitialized vars in for-loops

 for (ULONG i; i; ++i)

=for html </td></tr>

=for html <tr><td>13.</td><td><a name="typo13"></a>

misspelling Microsoft

 Copyright 1999 Micorsoft Corporation

=for html </td></tr>

=for html <tr><td>14.</td><td><a name="typo14"></a>

swapping the last two args of C<memset> may set 0 bytes

 memset(buf, nCount, 0);

=for html </td></tr>

=for html <tr><td>15.</td><td><a name="typo15"></a>

swapping the last two args of C<FillMemory> may set 0 bytes

 FillMemory(pAction, 0, sizeof(Action));

=for html </td></tr>

=for html <tr><td>16.</td><td><a name="typo16"></a>

LocalReAlloc/GlobalReAlloc may fail without MOVEABLE flag

 pv1 = LocalReAlloc(pv, cbNew, 0);

=for html </td></tr>

=for html <tr><td>17.</td><td><a name="typo17"></a>


assigning result of realloc to same var that's realloced
may result in leaked memory if realloc fails since C<NULL>
will overwrite original value

 p = (char *)realloc(p, 100);

=for html </td></tr>

=for html <tr><td>18.</td><td><a name="typo18"></a>


ReAlloc flags in wrong place or using ReAlloc flags for
a different realloc API, 

 pv1 = LocalReAlloc(pv, cbNew, GMEM_MOVEABLE);

i.e. passing C<GMEM_MOVEABLE> to C<LocalReAlloc>, it's not
an error to the compiler, but I'd say you were
playing with fire.

=for html </td></tr>

=for html <tr><td>19.</td><td><a name="typo19"></a>


C<case> statement without a C<break>/C<return>/C<goto>/C<exit>

 case 2:
  Foo();

 case 3:
  Bar();
  break;

If you add a comment with the text C<fall through> or C<no break>
before the next case statement, then the script will not emit a warning.

=for html </td></tr>

=for html <tr><td>20.</td><td><a name="typo20"></a>

comparing C<CreateFile> return value vs C<NULL> for failure
problem is that C<CreateFile> returns C<INVALID_HANDLE_VALUE>
on failure

 hFile = CreateFile(...);
 if (hFile == NULL)

=for html </td></tr>

=for html <tr><td>21.</td><td><a name="typo21"></a>

casting a 32-bit number (may not be 64-bit safe)

 if (p == (HANDLE)0xffffffff)

=for html </td></tr>

=for html <tr><td>22.</td><td><a name="typo22"></a>

casting a 7-digit hex number with high-bit set of
first digit, may have meant to add an extra digit?

 if (p == 0xfff0000)

=for html </td></tr>

=for html <tr><td>23.</td><td><a name="typo23"></a>

comparing functions that return handles to
C<INVALID_HANDLE_VALUE> for failure, problem is that
these functions return C<NULL> on failure

 h = CreateFileMapping(...);
 if (h == INVALID_HANDLE_VALUE)

=for html </td></tr>

=for html <tr><td>24.</td><td><a name="typo24"></a>

comparing C<OpenFile>/C<_lopen>/C<_lclose>/C<_lcreat> return value
to anything other than C<HFILE_ERROR>, which is the
documented return value when a failure occurs.

 fh = OpenFile(...);
 if (fh < 0)

=for html </td></tr>

=for html <tr><td>25.</td><td><a name="typo25"></a>

comparing C<alloca> result to C<NULL> is wrong since C<alloca>
fails by raising an exception, not returning C<NULL>.

 pv = alloca(10);
 if (pv == NULL)
 {
     goto Done;
 }

=for html </td></tr>

=for html <tr><td>26.</td><td><a name="typo26"></a>

C<alloca> fails by raising an exception, so check to
see if C<alloca> is within a C<try {}>

 BOOL foo(void)
 {
     PVOID pv;

     pv = alloca(10);
     return bar(pv);
 }

=for html <br><B>

N.B. You will only get one stack overflow exception. 

The stack is left in an unstable state (the guard page at the 
end of the stack has been converted to a normal stack page but
there is no room for a new guard page below it).

The next stack fault will walk off the bottom of the stack and the process 
will be terminated immediately, no debugger, no nothing.

=for html </B><br><br>

=for html </td></tr>

=for html <tr><td>27.</td><td><a name="typo27"></a>

check to see if the result from C<CreateWindow> or
C<CreateThread> or some other specified function is checked at the first if-stmt.

 hwnd = CreateWindow(...);
 ShowWindow(hwnd, SW_SHOW);

N.B. I'd like to make this more flexible, as long as
the return value is checked before the value is used.

=for html </td></tr>

=for html <tr><td>28.</td><td><a name="typo28"></a>

check for multiple inequality comparisons of the same 
var separated by "||",

i.e. C<if ((x != 0) || (x != 2))>

in this case, if x == 0, the second comparison will
succeed and the code will enter the if-stmt body.

Programmer probably meant C<&&> instead of C<||>.

=for html </td></tr>

=for html <tr><td>29.</td><td><a name="typo29"></a>

similar to 28, check for cases of the form:

 if ((x == 0) && (x == 1))

=for html </td></tr>

=for html <tr><td>30.</td><td><a name="typo30"></a>

if a function result is used before it has
been checked for success

 pv = LocalAlloc(...);
 strcpy(pv, sz);

=for html </td></tr>

=for html <tr><td>31.</td><td><a name="typo31"></a>

check for use of C<lstrcpy>/C<strcpy>

 strcpy(d, s);

=for html </td></tr>

=for html <tr><td>32.</td><td><a name="typo32"></a>

check to see if function result was stored somewhere

=for html </td></tr>

=for html <tr><td>33.</td><td><a name="typo33"></a>

trying to take the logical inverse of a number

 x = !3;

=for html </td></tr>

=for html <tr><td>34.</td><td><a name="typo34"></a>

if the result from the C<new> operator is used before
it has been checked for success

 p = new CLASS;
 p->DoIt();

=for html </td></tr>

=for html <tr><td>35.</td><td><a name="typo35"></a>

function that raises exception on error is not
in a C<try>.

 void foo() 
 {
  InitializeCriticalSection(&crit);
  .
  .
  .
 }

=for html <B>

From July 2000 MSDN, EnterCriticalSection:

=for html </B>

In low memory situations, EnterCriticalSection can raise 
a STATUS_INVALID_HANDLE exception. 
To avoid problems, use structured exception handling, or call the 
InitializeCriticalSectionAndSpinCount function to 
preallocate the event used by EnterCriticalSection 
instead of calling the InitializeCriticalSection function, 
which forces EnterCriticalSection to allocate the event.

=for html <B>

From July 2000 MSDN, InitializeCriticalSectionAndSpinCount:

=for html </B>

Windows 2000: If the high-order bit is set, the function preallocates 
the event used by the EnterCriticalSection function. Do not set this bit 
if you are creating a large number of critical section objects, 
because it will consume a significant amount of nonpaged pool. 


=for html </td></tr>

=for html <tr><td>36.</td><td><a name="typo36"></a>

check for misspelled defined symbols. User must do
most of the investigative work. The script will
note all the symbols used in C<#ifdef>,C<#ifndef>,C<#if>,C<#elif>
statements and print them out at the end.

=for html </td></tr>

=for html <tr><td>37.</td><td><a name="typo37"></a>

check for bitwise-C<XOR>ing one number with another

 x = 10 ^ 2;

=for html </td></tr>

=for html <tr><td>38.</td><td><a name="typo38"></a>

wrong flags used with C<MapViewOfFile>

 MapViewOfFile(hfileMap, PAGE_READWRITE, 0, 0, 0x1000);

should be

 MapViewOfFile(hfileMap, FILE_MAP_WRITE, 0, 0, 0x1000);

=for html </td></tr>

=for html <tr><td>39.</td><td><a name="typo39"></a>

wrong flags used with C<CreateFile>

 CreateFile(szFile, FILE_MAP_WRITE, ...);

should be

 CreateFile(szFile, GENERIC_READ | GENERIC_WRITE, ...);

=for html </td></tr>

=for html <tr><td>40.</td><td><a name="typo40"></a>

duplicate flags passed to C<CreateFile>

 CreateFile(szFile, GENERIC_WRITE | GENERIC_WRITE, ...);

=for html </td></tr>

=for html <tr><td>41.</td><td><a name="typo41"></a>

complain about returning unchecked function results

=for html </td></tr>

=for html <tr><td>42.</td><td><a name="typo42"></a>

using C<HRESULT> function result w/no check

=for html </td></tr>

=for html <tr><td>43.</td><td><a name="typo43"></a>

double semicolon

 x = 0;;

=for html </td></tr>

=for html <tr><td>44.</td><td><a name="typo44"></a>

calculating memory needed incorrectly by
using C<strlen(X+1)> instead of C<strlen(X)+1>

 c = strlen(sz+1);
 p = malloc(c);
 if (p) strcpy(p, sz);

=for html </td></tr>

=for html <tr><td>45.</td><td><a name="typo45"></a>

assigning C<TRUE> to C<boolVal> field of C<VARIANT>
should use C<VARIANT_TRUE> (= -1)

 var.boolVarl = TRUE;

=for html </td></tr>

=for html <tr><td>46.</td><td><a name="typo46"></a>

empty statement after C<while>/C<for> loop

 while (pFoo);

=for html </td></tr>

=for html <tr><td>47.</td><td><a name="typo47"></a>

use of C<(!x & Y)>, probably meant C<(!(x & Y))>
C/C++ precedence rules have C<!> before C<&>

 if (!x & 3)

=for html </td></tr>

=for html <tr><td>48.</td><td><a name="typo48"></a>

testing a #define for a value instead of existence

=for html </td></tr>

=for html <tr><td>49.</td><td><a name="typo49"></a>

test a char for C<0> instead of C<'\0'>, i.e.
user meant to test for null terminator instead of number 0

=for html </td></tr>

=for html <tr><td>50.</td><td><a name="typo50"></a>

use of a disallowed function

 TerminateThread();

=for html </td></tr>

=for html <tr><td>51.</td><td><a name="typo51"></a>

use of a disallowed string

=for html </td></tr>

=for html <tr><td>52.</td><td><a name="typo52"></a>

filling object with zeros

 memset(this, 0, sizeof(*this));

=for html </td></tr>

=for html <tr><td>53.</td><td><a name="typo53"></a>

check for C<(X | Y) == 0> or C<(X | Y) != 0>, probably meant
C<(X & Y) == 0>

=for html </td></tr>

=for html <tr><td>54.</td><td><a name="typo54"></a>

check for non-Multimon-safe constructs:
C<pt.x = LOWORD(lParam);>, should use 
C<pt.x = GET_X_LPARAM(lParam);> instead

=for html </td></tr>

=for html <tr><td>55.</td><td><a name="typo55"></a>

check for use of C<sizeof(this)> instead of C<sizeof(*this)>. 
C<this> is a pointer to the current object. C<*this> is the current object.

=for html </td></tr>

=for html <tr><td>56.</td><td><a name="typo56"></a>

check for use of C<sizeof(X)> instead of C<sizeof(X)/sizeof(X[0])> when calling
an API that wants number of characters in a buffer, 
instead of number of bytes in a buffer

=for html </td></tr>

=for html <tr><td>57.</td><td><a name="typo57"></a>

check that results of registry APIs are compared with C<ERROR_SUCCESS> or other common
registry error codes. C<-fn:REG:> option was added to allow user to add to list
of registry APIs to check.

=for html </td></tr>

=for html <tr><td>58.</td><td><a name="typo58"></a>

check for use of a NULL DACL passed as the third parameter to C<SetSecurityDescriptorDacl>

=for html <B>

From January 2001 MSDN, SetSecurityDescriptorDacl:

=for html </B>

If this parameter is NULL, a NULL discretionary ACL is assigned to the security descriptor, B<allowing all access to the object>.

=for html </td></tr>

=for html <tr><td>59.</td><td><a name="typo59"></a>

check for non-NULL-ptr checks before calling memory deallocator function that can handle
NULL ptrs. These memory deallocators include C<free>, C<delete>, C<delete []>, 
C<SysFreeString>, and C<LocalFree>.

Since code performance usually follows the 80/20 rule (80% of the execution time is spent in 20% of the code),
case 59 may help reduce the size of the 80% of code that's not CPU-limited, i.e.

	if (sz) LocalFree(sz);

The C<if> check is extraneous since C<LocalFree> can handle NULL ptrs. 
If this was CPU-intensive code, you might not want to do a function call just for a NULL check.

B<But in most cases, the ptr is non-NULL and/or the code is not CPU-intensive.>

Looking at some optimized code from VC, removing the extraneous check saves at least four bytes
if the ptr is in a register aleady!

=for html </td></tr>

=for html <tr><td>60.</td><td><a name="typo60"></a>

check for extremely long expressions [default=2048 chars]. This is usually a sign of code
that can be redesigned, either for maintainability or efficiency or both. Or the script's
parsing algorithm got confused...

=for html </td></tr>

=for html <tr><td>61.</td><td><a name="typo61"></a>

check for using C<HWND_BROADCAST> with C<SendMessage>. C<SendMessage> is a blocking call so if one
of the receiving windows is not responding, then your thread will block until the window responds.
You can work around this by using C<SendMessageTimeout>, C<PostMessage>, or only sending the windows message
to your known windows, if that's what you wanted to do.

=for html </td></tr>

=for html <tr><td>62.</td><td><a name="typo62"></a>

check for using C<NonPagedPoolMustSucceed> or C<NonPagedPoolCacheAlignedMustS> flags
with the C<ExAllocatePool> class of allocation APIs. 
If the allocation fails, then the machine will crash.

=for html </td></tr>

=for html </table>

=head1 MICROSOFT VISUAL STUDIO INTEGRATION

=over 4

=item 1

Select Tools.Customize menu item from MSDEV

=item 2

Click the Add button.

=item 3

Type "Typo" in the edit control and hit OK. Ignore the warning
about invalid path.

=item 4

In the Command edit control, enter perl.exe. Specify the
full pathname to perl.exe if it isn't on your PATH.

=item 5

In the Arguments edit control, enter the path to typo.pl.

=item 6

In the initial directory edit control, select one of the
directory entries from the dropdown menu, i.e. File Directory,
Current Directory, Target Directory, or Workspace Directory,
or enter a directory of your own.

=item 7

Make sure the "Redirect to Output Window" checkbox is set.

=item 8

Hit Close.

=back

You can now run TYPO.PL from Visual Studio and double-click on the
captured output to have it locate the potential error for you.


=head1 HISTORY

=over 4

=item Jan 06 1996

Created.

=for html <br><br>

=item Jan 26 1996

Repeatedly replace parenthesized expressions (PE)
with '_' for errors 1 and 2.

Tweak C<==> case to remove PEs before checking
for unbalanced parentheses or lines that begin
with &&,||,==, or = * ==.

Tweak C<==> case to check previous line for
unterminated for-loop or line ending with
C<&&> or C<||>.

=for html <br><br>

=item Jan 29 1996

Adjust error 1 and 3 regexp so script
can find errors of the form C<else if (XXXX);> or
C<else if (XXX = 1)>

Print line number of error too

Released as Version 1.0.

=for html <br><br>

=item Feb 08 1996

Suggestion:
Look for assignment within an C<Assert>

Modify output so one can use typo.pl from Microsoft Visual Studio
to locate errors

Released as Version 1.0.1.

=for html <br><br>

=item Apr 04 1996

Suggestion:

Look for pattern of the form C<*psz++;>

Suggestion:

For assignment statements that use C<==>,
ignore previous lines which look like part of
C<? :> constructs or an assignment.

Check for C<&& #> or C<|| #>. Authour probably meant
to use bitwise versions.

Remove spaces from a copy of the current line to
make patterns simpler.

Allow user to specify list of files by piping
list of files to perl, i.e. C<dir /s /b | perl typo.pl ->.

=for html <br><br>

=item Jul 09 1996	

Check for C<&> E<lt>C<symbol>E<gt> C<==>

C/C++ precedence rules have C<==> higher than C<&>.

So code like
C<if (x & 0x03 == 0x02)>
is treated as if the programmer wrote:
C<if (x & (0x03 == 0x02))>

=for html <br><br>

=item Oct 09 1996

Add in descriptions of new errors (5-8) that are
flagged

=for html <br><br>

=item Nov 30 1996	

Made removal of quoted strings in C<if> cases always
happen so I was also able to move code out of
special cases and always apply transformations

Check for C<if> that begins on word-boundary rather
than doing weak check for C<else if> in body of
of C<if> checks.

In error 8, C<& XXX ==>, check for bitwise-XOR and
bitwise-OR as well as bitwise-AND.

In error 9, C<->Release>, add comment describing
the typo and check for C<AddRef> case too.

Add new cases from similar perl tool. These cases
include, line-continuation char followed by
whitespace and then EOL, and an operator precedence
typo, C<A << B + C>. The C<+> operator has higher
precedence than the shift operator.

Instead of using "\w" to match a word, use the
character set [A-Za-z0-9_*\->].

Remove strings in the general case.

=for html <br><br>

=item Jan 24 1997

Check for C<== <symbol> &>
C/C++ precedence rules have C<==> higher than C<&>
So code like:
C<if (0 == x & 0x03)>
is treated as if the programmer wrote:
C<if ((0 == x) & 0x03)>
This is almost the same as the Jul 09 1996 check
but the position of operators have been swapped.

Added tweak to case 10 suggested.

Don't complain if C<\<SP>> follows a C++ comment

=for html <br><br>

=item Feb 07 1998

suggestion from Bryan Krische
close the TEXTFILE handle when we're done.
 This is important because Perl is not spec'ed to
 reset its line counter when opening a new file in
 an existing file handle...  So running the script
 as is the current release of Perl (the official 
 one, not the activeware port) comes up with weird
 line numbers.  Doing the close resets the line
 count and then all is fine.

=for html <br><br>

=item Mar 09 1998

don't look for typos within multi-line C comments

=for html <br><br>

=item Mar 22 1998

Suggestion:
quick check for uninitialized vars in for-loops

discovered bug in handling of cmd-line switches

add error msg display for invalid cmd-line switches

=for html <br><br>

=item Apr 04 1998

mistyped "Microsoft" => "Micorsoft"

add check to see if case 8 C<& XXX ==> is really
taking address of var and casting to ptr of 
another type and then derefing that ptr
- this should reduce # of false positives

=for html <br><br>

=item Apr 20 1998

Bad usage of memset
code had swapped the value and # bytes to set
i.e. C<memset(ptr, 0, bytes)> would be 
C<memset(ptr, bytes, 0)>

do similar check for C<FillMemory>

=for html <br><br>

=item Apr 23 1998

Suggestion:
skip over preprocessor directives

=for html <br><br>

=item Apr 28 1998

regexp cleanup and use Perl 5 features, i.e.
non-greedy parsing for C-comments

Suggestion:
look for C<LocalReAlloc>/C<GlobalReAllocs> which
don't pass in MOVEABLE flag

Suggestion:
look for places where result from realloc
is assigned to the same var that was realloced
If the realloc fails, the memory has leaked, i.e.

 ptr = realloc(ptr, cb + 1024);

=item Apr 29 1998

check for ReAlloc flags passed in the wrong order

incorporate checking for break in case stmt code

add ability to scan one file passed on the cmdline

=for html <br><br>

=item May 21 1998

User noted that the script reports
C<x << y++> as a typo. Make the pattern check
that there's no second "+".

Users noted problems with the C<x << y +> case 
if the expression was doing text output via C++ iostreams. 
Check for strings/character constants on the line. 
If we find them, then we probably have some 
C++ iostream usage.

=for html <br><br>

=item Jun 01 1998

User noted a problem with a quoted 
double-quote character confusing the code that
looked for C<if (X);>. Need to map any
quoted double-quote characters to something safer,
i.e. "_".

Users noted problems with how
people dealt with C<CreateFile>'s return value.
Many expect a failed C<CreateFile> to return NULL
but it returns C<INVALID_HANDLE_VALUE>.

Added code to check for C<CreateFile> failure
and similar APIs, i.e. C<FindFirstFile>, etc.

=for html <br><br>

=item Jun 03 1998

User noted a couple of problems in
cases 8 & 11 when dealing with C++ code.

Looking at the results from a test run, I saw
many cases of C<(HANDLE)0xFFFFFFFF> which
may not do the expected thing on 64-bit NT.

Also added check for casting a 7-digit hex
number which may need an extra digit

=for html <br><br>

=item Jun 09 1998

Update the script usage text

=for html <br><br>

=item Jun 10 1998

Add tweak to case 2 to not report lines of the form:
C< X == Y ? 10 : 20;>

=for html <br><br>

=item Jun 24 1998

User says that the his group
defines C<INVALID_FH> to C<INVALID_HANDLE_VALUE>.
So add that to the list of acceptable 
alternatives.

User noted that the script was complaining
about C<CreatFileTypePage>. Add that to the list
of exceptions.

User noted that case 5 will report
C<delete *i++;> as a typo.

=for html <br><br>

=item Jun 29 1998

Check for C<CreatFileMapping>'s return value compared
with C<INVALID_HANDLE_VALUE> on failure. One
should compare with NULL.

Check C<OpenFile>/C<_lcreat>/C<_lopen>/C<_lclose>'s return value
with anything other than C<HFILE_ERROR>.

=for html <br><br>

=item Jul 02 1998

User noted that the explanation for case 19,
C<case> stmt without C<break>, was confusing since
the offending line printed out was usually
the following case stmt, not the case stmt which
didn't have the break.

=for html <br><br>

=item Jul 05 1998

User suggested looking at C<alloca>.
C<alloca> fails by raising an exception, so
checking the alloca result for C<NULL> doesn't
make sense.

User suggested checking to see if code
checked the return values from C<CreateWindow> and
C<CreateThread>

Cleaned up case 19 (Case w/o break).

=for html <br><br>

=item Jul 07 1998

User suggested adding an option to disable
certain cases. I did the least disruptive thing,
specifying "-disable:#x,#y-#z" will not
print anything for case x and cases y...z.

=for html <br><br>

=item Jul 08 1998

Suggestion: add support for ignoring
certain files. Also noted a problem with the
CreatFileMapping case in a private drop.

Report any functions return values that haven't
been checked by the end of the enclosing function
or by the time another function call is made.

User noted that script was getting 
CreateFileEntry mixed up with CreateFile. Weed out.

=for html <br><br>

=item Jul 11 1998

Added "-showtime" option to show start/end of scan

Added check for too many options

User suggested checking for 
C<(x != 0) || (x != YYY)>. The C<||> should be C<&&>.

=for html <br><br>

=item Jul 13 1998

Make ignore files option case-insensitive.

=for html <br><br>

=item Jul 14 1998

Added "-newer" option to only scan files that
have been modified after the given date

User checkin mail talked about code not
checking the result from RegOpenKey. Add that.

=for html <br><br>

=item Jul 16 1998

Problem with multi-line C comment code if beginning
of C comment appeared within a string, lots
of code would be removed as part of comment.

=for html <br><br>

=item Jul 19 1998

For Invalid handle functions, if the variable that
holds the function result doesn't appear in an
if statement, then we won't clear the info about
the function.

Add check for function result being used before it
has been checked.

=for html <br><br>

=item Jul 21 1998

Ran with "perl -w" and fixed a couple of
uninitialized variables reports. Whoops.

Add "-cfr" option to allow user to specify other
functions whose results should be checked.

=for html <br><br>

=item Jul 23 1998

Move case 27 check so that it's by itself instead
in the middle of "elsif" tests.

For case 30, assigning to the function result
again doesn't count as using the function result
before checking it.

=for html <br><br>

=item Jul 24 1998

Switched to using /ox instead of /x in regexps
that interpolate variables. Adding 'o' speeds
up the script.

=for html <br><br>

=item Jul 28 1998

Convert spaces between words to '#' so we can
handle some cases better, i.e. 23-27, and 30.

Check for use of lstrcpy/strcpy due to public Outlook
Express/Outlook 98 buffer overflow problems.
Also NetMeeting 2.1 had a publicisized buffer overflow prob.

Fix "C++ comment inside string" problem

Fix problem with above fix if starting double
quote is inside a character constant, i.e. '\"'

Need to check if keyword or function collection
gets too long. If it does we reset ourselves.

Need to handle case where we get confused by 
#ifdef's and doesn't see the end of an if stmt
If we see an if or else keyword while we're
collecting for an if stmt, then we will throw
away the previous collection and start with
the new if stmt.

Extend limit when we think keyword or function
collection is too long. Some people like to
code if stmts that are > 2048 chars. Glad
I don't have to debug that code.

=for html <br><br>

=item Aug 05 1998

Suggestion. Check for other
side effects inside Asserts, i.e. ++, +=, -=

=for html <br><br>

=item Aug 08 1998

Added "-optionfile" support

Changed enable array init

=for html <br><br>

=item Aug 13 1998

Fixed problem with case 32 and C<OpenFile> with
C<OF_DELETE> flag getting reported

Added expceptions to counting curly braces

Should close option files that are opened

Finally got around to handle C<if (X = NEW CLASS)>

=for html <br><br>

=item Aug 18 1998

User suggested that the result from
the new operator should be checked for success
before it's used.

Check for logical inverse of a number, i.e. C<!4>

Found a problem with the try/except code where
it wouldn't clear the try info if it
found that the parens count was 0 - it also
needs to check that it has seen the opening
and closing curly parentheses.

Use 'my' to make variables "local" lexically.

Fix cases 28 and 29 where "$arg1[xx]" was interpreted
as an array reference by using "/x" regex option
and adding appropriate spacing

=for html <br><br>

=item Aug 23 1998

User noted that case 20 would match with
anything that started with C<CreateFile>. added
C<CreateFileA> and C<CreateFileW> to pattern. Changed
check to disallow multiple alphanumeric characters
after C<CreateFile> string.

=for html <br><br>

=item Sep 03 1998

Added support for checking for functions that return
handles (C<HDC>, C<HBRUSH>, etc.) via the "-fn:HANDLE:"
option. Behaviour is similar to "-cfr" option.

Moved C<CreateFileMapping> checks into this category.

=for html <br><br>

=item Sep 14 1998

Various optimizations including:

- Use hashes instead of regexps w/ alternatives

- Use 'join' instead of '.' string concatentation

- Use 'unpack' instead of 'substr'.

- For empty lines, do only what's necessary and
skip to the next line.

- Remove some script that doesn't apply anymore.

- User suggestion: Add support for
code that does the checking and turn off any 
following reports about using var before checking
for success. "-check" option added.

User suggestion: Add support for adding to
list of functions that could overflow a buffer.
"-fn:OVERFLOW:" option added.

User suggestion: Add support for detecting
functions that should be in a try/except.
"-fn:THROW:" option added.

Add "-new:" option to specify functions that
are synonymous or similar to "operator new".

Add "-version" option to specify minimum 
script version required.

=for html <br><br>

=item Sep 27 1998

User noted some missing overflow functions:
C<wcscpy>, C<wcscat>, etc.

Add case 36, check for misspelled symbols used in
C<#if>, C<#elif>, C<#ifdef>, C<#ifndef>. Script just collects
all the symbols used, user must determine if
there's something wrong.

=for html <br><br>

=item Oct 04 1998

Minor cleanup

Add "-fn:VOID:" option for functions that don't
return a value and that case 32 should ignore.

=for html <br><br>

=item Nov 30 1998

Handle case 1 better, i.e.
 if (XXX);
 else

Added -notypo to support NO_TYPO comments which
temporarily disable cases on a line-by-line basis

Added -fn:INVALID to support adding functions that
return INVALID_HANDLE_VALUE/-1 values

Added ability to reenable cases using -enable option.

Added -noderef option for specifying functions that 
don't deref values

Added -nonbuffered option for nonbuffered output

Added -showstats option and keep track of # of comments
and functions seen.

Added cases 38, 39, amd 40

Made some vars local to the file-processing while loop

Cleaned up some regexp code in case 2.

Keep track of # of comments seen and fns invoked

Determined start of a function with greater accuracy.

Reduce false positives for case 9.

Determined function invocation with greater accuracy, 
character after the function name should be a "(".

Added realloc functions to those function results
that we track

Needed to add a couple of aliases to try: __try and TRY

Don't track new function result if it's in an if stmt.

Move Case 28 and 29 to their own functions

Corrected support for comments in option files

Based on Raymond Chen bugfix, extend 
case 2 to handle +/- operators.

Change file reading algorithm to reduce time that 
file is opened to minimum

Add "default:" to case 19 fall-thru code.

Relax restrictions for case 3.

Handle code that tries to do portable exception 
handling via (TRY / CATCH).

Check that all args from option files were processed

=for html <br><br>

=item Dec 14 1998

Documented -endcase option

=for html <br><br>

=item Feb 25 1999

Fix disabling/enabling case 27 warnings

Reduce false positives for assigning allocations to 
pointer on same line as pointer declaration

Support adding/using/testing against list of constants

Added -showprogress option

Added -fn:<HR|LEN|SAFEASSERT> options

Added -constant option

Added -temp_defined option for case 48

Support empty lines and end of line comments in option files

Print number of chars scanned at summary

Added cases 41-49

Fix a spelling error in comment

Correct enabling/disabling of cases 38-40

Check for % operator in case 11

Get sorted list of files from DIR command

=for html <br><br>

=item Mar 24 1999	

Added disallowed string option and case 51

Added disallow/allow functions

Use parentheses with chomp for consistency

Keep track of stats for Code metric app functionality

Batch up lines until we have a semicolon,
then perform checks for typos

Fix script so you can disable case 44

Added -help, -h, and -? options to print help
without innocuous warning

=for html <br><br>

=item May 07 1999	

Added cases 50, 51, 52.

Centralized removal of string and character constants

Support for extracting strings from code, resources,
and message compiler files (.mc)

Added more Code metric app-type functionality - shows number
of functions in code

Handle lines that have continuations chars at the end

Able to process preprocessor directives

Fix some cases that were broken due to code movement

Cleaned up/centralized function handling with its
own hash object.

Moved scanning for several cases to their own function

=for html <br>

=item Jun 16 1999	

Cleanup

=for html <br><br>

=item Jul 31 1999

Convert comments to pod-style

optimize scan for case 51 by disabling case 51 if disallowed_strings is empty

move cases 10, 13, and 51 to before the check for being in the middle
of a multi-line comment

consolidate handling comments (both new C++-type and old C-type comments) 

use NAME instead of FUNCTION in $function_call hash

don't include keyword when passing on text before keyword for scanning

call clear_statement when finished scanning file to clear out info

use hash for processing "-fn:" option

weed out "throw" for case 2

do not include strings with colon, ':', for case 2 to prevent
including case labels

add more sample code to descriptions of typos

=for html <br>

=item Aug 02 1999

Move system command to get list of files into its own variable so
it can be changed in one spot instead of requiring a global search
and replace.

Add -optiondir option to specify directories to search for option files
so you don't have to specify absolute paths.

Reduce case 2 false positives from bitfield declarations

Catch as part of case 3:

 if (x |= Y)

=for html <br>

=item Aug 07 1999

Keep count of number of files scanned and print out total in -showtime output

=for html <br><br>

=item Aug 09 1999

Add FILES scanned count

=for html <br><br>

=item Aug 15 1999

Clean up for public release

=for html <br><br>

=item Sep 16 1999

case 53 added

=for html <br><br>

=item Apr 04 2000

updated copyrights to 2000

fixed -string:DISALLOW checking

fixed disabling new'd objects via NO_TYPO

=for html <br>

=item Apr 20 2000

added case 54

don't report if we find cast in case 47

For case 22, modified check for any hex number >= 6 digits and != 8 digits
long which may indicate a mistyped 32-bit number.


=for html <br>

=item Jul 08 2000

tweaked case 22 to warn for numbers whose length are near multiples of 8

tweak case 53 to not warn if the bitwise-OR'd expression was in a function call

for case 35, added EnterCriticalSection, InitializeCriticalSectionAndSpinCount, 
LeaveCriticalSection, etc. as functions that can raise an exception

added warning if no option files are specified

added -log_functions option to output current function that is scanned [external contribution]

clarified case 11 for modulus operator, %, and +/-.

=item Dec 04 2000

case 55 added

case 56 added

added -fn:BUFFERCHARS: option to support case 56

skip asm statements and blocks

=item Dec 10 2000

updated location of Perl binaries

=for html <br><br>

=item Feb 02 2001

added -ignore_result option

=for html <br><br>

=item Feb 24 2001

added -use_build_dat option to only scan files that are specified in build.dat

=for html <br><br>

=item Jun 21 2001

tweaked case 53 to not report C<(X & (Y | Z)) == 0)> as a possible error

added case 57 (supported by the C<-fn:REG:> option) which flags Registry functions
that don't check the function result with C<ERROR_SUCCESS>.

added case 58 which checks that a NULL DACL is not passed to C<SetSecurityDescriptorDacl>

added case 59 which checks that code doesn't check for non-NULL ptr before calling
a memory-deallocator function that handles NULL ptrs. Size matters!

added case 60 which emits a warning if the expression becomes too long [default=2048 chars].

=item Jun 24 2001

added case 61 to check for using C<HWND_BROADCAST> with C<SendMessage>

reworked code to output typos to console from a centralized point
and most of the typo descriptions are stored in one place.

display number of typos found in output for C<-showtime> option

remove bugs found by running typo.pl with -w switch

added C<-output_xml> option to output results in XML format 

added links in docs for each typo 

=for html <br>

=item Aug 27 2001

fixed problem when neither C<-output_xml> or C<-showtime> options were specified and no typos were found

fixed problem with case 27 when variables were assigned inside an try-catch

added case 62 to catch using C<NonPagedPoolMustSucceed> or C<NonPagedPoolCacheAlignedMustS> flags with
with the C<ExAllocatePool> class of allocation APIs. 

=back

=head1 RELATED INFORMATION

=for html
<a href="http://www.perl.com">Perl</a><br>
<a href="http://www.activestate.com/Products/ActivePerl/index.html">Win32 version of Perl</a><br>
<a href="http://research.microsoft.com/sbt/asttoolkit/ast.htm">AST Toolkit</a><br>
<a href="http://www.gimpel.com/lintinfo.htm">Gimpel's PC-lint</a><br>
<a href="http://lclint.cs.virginia.edu/index.html">LCLint</a><br>
<a href="http://www.softwareautomation.com/index.htm">Panorama</a><br>
<a href="http://www.soft.com/Products/Advisor/static.html">STATIC</a><br>
<a href="http://www.pts.com/static/prolint.html">ProLint</a><br>

=cut

=pod OSNAMES

MSWin32

=pod SCRIPT CATEGORIES

Development\Debugging

=pod README

Typo.pl is a Perl script which scans 
C/C++ source code for possible errors.

The script was originally written to locate various typing errors, 
i.e. C<X == Y;> instead of C<X = Y;>

The L<list of possible errors|"ERRORS"> reported by the script has grown considerably.

=cut
