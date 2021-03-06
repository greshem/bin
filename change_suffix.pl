#! /usr/bin/perl
my $version="0.9";
# -*-Perl-*-
# $Id: chsuf.pl,v 0.18 2002/02/10 12:50:04 wilde Exp $

##########################################################################
#                                                                        #
#  chsuf - change suffix of files                                        #
#  Copyright (C) 2001, 2002 Sascha Wilde (wilde@diebrain.de)             #
#                                                                        #
#  This program is free software; you can redistribute it and/or modify  #
#  it under the terms of the GNU General Public License as published by  #
#  the Free Software Foundation; either version 2 of the License, or     #
#  (at your option) any later version.                                   #
#                                                                        #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
#                                                                        #
#  You should have received a copy of the GNU General Public License     #
#  along with this program; if not, write to the Free Software           #
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.             #
#                                                                        #
##########################################################################

=head1 NAME

chsuf - changes the suffix of files


=head1 SYNOPSIS

B<chsuf> S<[ OPTION ]...>  S<B<--append=>I<suffix>>  F<file> F<...>

B<chsuf> S<[ OPTION ]...>  S<B<--delete>[=I<suffix>]>  F<file> F<...>

B<chsuf> S<[ OPTION ]...>  S<[ B<--from=>I<oldsuffix> ]>  S<B<--to=>I<newsuffix>>  F<file> F<...>

B<chsuf> S<[ B<--version> ]>


=head1 DESCRIPTION

B<chsuf> changes the suffix of files and/or directories.  It also can be used to add or remove a suffix to/from a list of files.

B<chsuf> might be useful to change DOS-style three character extensions to more readable variations (eg I<htm> to I<html>), or to add an extension to filenames for later use on platforms which depend on them.


=head1 OPTIONS

=over 8

=item B<--append>=I<suffix>

Add the suffix given by B<--append> to the name of all given files.  B<--from>, B<--to> and B<--delete> will be ignored when this option is used.

=item B<--delete>[ =I<suffix> ]

Delete the specified suffix from the name of all given files.  When no suffix is, the shortest arbitrary suffix (if any) will be deleted.

=item B<-i, --interactive>

Prompt whether or not to overwrite existing regular destination files.

=item B<-r, --recursive>

Recursively enter directories to change suffixes.

=item B<-d, --rename-dirs>

Modify directory names as well as file names.

=item B<-v, --verbose>

Be verbose and print every filename changed.

=item B<-V, --version>

Show the release version of chsuf.  All other options will be ignored.

=item B<--from>=I<oldsuffix>

In conjuction with B<--to> specifies the suffix to be changed, omitting period.  Files with other suffixes will not be renamed.  When B<--append> or B<--delete> is used this will be ignored.

=item B<--to>=I<newsuffix>

This is the suffix to change to, omitting the period.  When no suffix is given by using B<--from>, the shortest arbitrary suffix (if any) will be changed. When B<--append> or B<--delete> is used this will be ignored.

=back


=head1 EXAMPLES

You may have some HTML-files from different sources; some ending I<.htm>, some ending I<.html>.  As a GNU/Linux/Unix (whatever) user you want to only use I<.html> so you can type:

    chsuf --from="htm" --to="html" *

If you also want to change the files in subdirectories, you would use:

    chsuf -r --from="htm" --to="html" *

Finally, if you would like to be told what's being done add B<-v> or B<--verbose>:

    chsuf -rv --from="htm" --to="html" *


Let's say you want to export a bunch of text files to a system which expects the names of textfiles to end with I<.txt>.  To do this you can use:

    chsuf -v --append="txt" texts/*


In case you have files from a lousy system which requires such extensions and you want to get rid of the annoying I<.txt> suffixes you will type:

    chsuf -v --delete="txt" texts/*


if you want to remove all the suffixes of all the files in the directory and all sub-directories use:

    chsuf -v --rename-dirs --recursive --delete *

or, for short:

    chsuf -vdr --delete *


=head1 BUGS

Many, for sure! This is still a beta, you know...


=head1 NOTES

A more general tool using regexps to rename files would be much more powerful but also much harder to use.


=head1 SEE ALSO

I<mv>(1), I<cp>(1)


=head1 AUTHORS

Sascha Wilde <swilde@users.sourceforge.net>, Daniel Roberge <droberge@users.sourceforge.net>


=head1 THANKS

To Phil Williams <phil@subbacultcha.demon.co.uk> for beta-testing, ideas and suggestions.

=cut

# be a nice guy use strict...
use strict;
# we need to parse option-switches
use Getopt::Long;
use vars qw/ %option /;
my $any="";

# configure GetOptions to use bundling
# might be a bad idea, but i like it... :)
Getopt::Long::Configure("bundling");

# First we need to parse any --delete[=...] options, which can't be
# done by GetOptions, because GetOptions cant handle optional
# parameters this way (we want to force the "=")
for (0 .. $#ARGV) {
    if ( $ARGV[$_] =~ /^--delete(.*)/ ) {
	if ( ! $1 ) {
	    $option{"delete"} = "";
	    $any = 1;
	}
	elsif ( $1 =~ /=(.+)/ ) {
	    $option{"delete"} = $1;
	}
	# now delete the option from @ARGV - GetOptions would throw an
	# error
	splice(@ARGV, $_, 1);
    }
}

# get all the fancy flags
GetOptions(\%option, 
	   "append=s",
	   "from=s",
	   "to=s",
	   "interactive|i",
	   "recursive|r",
	   "rename-dirs|d",
	   "verbose|v",
	   "version|V",
	   "debug");

my @suffix_options = qw(from to append delete);


# some debugging stuff...
print "f was set to ->$option{from}<-\n" if $option{"debug"};
print "t was set to ->$option{to}<-\n" if $option{"debug"};
print "r was set!\n" if $option{"recursive"} && $option{"debug"};
print "d was set!\n" if $option{"rename-dirs"} && $option{"debug"};
print "delete was set to ->$option{delete}<-\n" if $option{"delete"} && $option{"debug"};


######################################################################
# main                                                               #
######################################################################

if ( $option{version} ) {	# version number requested?

    # This was substituted by the autoconf-package-version
    # automaticly added by the make-process
    # '$Revision: 0.18 $' =~ /Revision:\s*(\S+.*\S+)\s*\$/;
    # print "chsuf version $1\n";
    print "chsuf version $version\n";

} else {

    # when --to but no --from is set we assume that any suffix shall
    # be changed

    $any=1 if ( defined($option{to}) && (! defined($option{from}) ) );

    ( defined($option{from}) ||	# --from 
	      defined($any)  &&	        # or any
	      defined($option{to}) ) 
      || exists($option{delete})      
      || defined($option{append})      
      || die "You must give --to \nor --from and --to \nor --delete or --append!\n";

    # the suffix-parameters must not be interpreted by regexps
    # and check if suffixes are legal
    my $test_opt;
    foreach $test_opt (qw(from delete)) {
	$option{$test_opt}=quotemeta($option{$test_opt}) if ( $option{$test_opt} );
    }
    foreach $test_opt (@suffix_options) {
	if ( $option{$test_opt} =~ /\// ) {
	    die "$0: illegal character in $test_opt suffix definition\n";
	}
    }
    
    if ($#ARGV ge 0) {
	rename_files(@ARGV);
    } else {
	die "$0: you have to give some files\n";
    }

}

sub rename_files {
    my @files=@_;
    
    for (@files) {		# now process the given file-names

	print "\nprocessing $_\n" if $option{"debug"};

	if (! m[^.*/\.\.?$] ) {	# dont work on "." and ".." !

	    if ( (-d $_) && $option{"recursive"} ) { # if -r dive into dirs
		if ( opendir(DIR, $_) ) {
		    my $current_dir = $_;
		    rename_files( map("$current_dir/$_", readdir(DIR) ) );
		    closedir DIR;
		} else {
		    print STDERR "$0: Can't open \"$_\" for recursive action!";
		}
	    }

	    if ( (-f $_ || -l $_) ||		# is it a plain file or symlink ?
		 ( (-d $_) && $option{"rename-dirs"} ) # or a directory and -d is set?
		 ) {
		if ( $option{append} ) {
		    $option{to} = $option{append};
		    rename_file($_,$_);
		} elsif ( $any ) {
		    rename_file($_,$1) if ( /(.+)\.[^.\/]+[^\/]*$/ ); # (love LTS)
		} else {
		    $option{from} = $option{delete} if $option{delete};
                    # has the file the suffix we want to change?
		    if ( /(.+)\.$option{from}$/ ) {  
			rename_file($_,$1);
		    }
		}
	    }
	}
    }
}

sub rename_file {
    my $old = shift;		# old file-name
    my $base = shift;		# base of new file-name
    my $new_name;
    if ( exists($option{delete}) ) {
	$new_name = "$base";
    } else {			# else newname = base + --to
	$new_name = "$base.$option{to}";
    }
    print "$old -> $new_name\n" if $option{"verbose"};
    # now test if we are going to overwrite an existing file
    if (( -e $new_name ) && $option{interactive} ) {
	# in interactive mode we ask
	if (confirm($new_name)) 
	{
		printf("$old ->  $new_name \n");
	    (rename $old, $new_name) || print STDERR "$0: Can't rename \"$_\" !!!\n";
	}
    } else 
	{
		printf("$old ->  $new_name \n");
		(rename $old, $new_name) || print STDERR" $0: Can't rename \"$_\" !!!\n";
    }
}

sub confirm {
    my $file_name = shift;
    print "$0: Overwrite \"$file_name\"? ";
    my $inpt = lc(<STDIN>);
    chomp $inpt;
    if ( $inpt eq "y") {
	return 1;
    } else {
	return 0;
    }
}
sub usage_in_cygwin()
{
	print <<EOF
	 perl c:\\bin\\change_suffix.pl --from DAT  --to mp3 *.DAT
EOF
;
}
