#!/usr/bin/perl

# -------------------------------------------------------- Documentation notice
# Run "perldoc ./make_rpm.pl" in order to best view the software documentation
# internalized in this program.

# --------------------------------------------------------- License Information
# The LearningOnline Network with CAPA
# make_rpm.pl - make RedHat package manager file (A CLEAN AND CONFIGURABLE WAY)
#
# $Id$
#
# Written by Scott Harrison, harris41@msu.edu
#
# Copyright Michigan State University Board of Trustees
#
# This file was written to help the LearningOnline Network with CAPA (LON-CAPA)
# project.
#
# LON-CAPA is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# LON-CAPA is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with LON-CAPA; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# http://www.lon-capa.org/
#
# YEAR=2000
# 9/30,10/2,12/11,12/12,12/21 - Scott Harrison
# YEAR=2001
# 1/8,1/10,1/13,1/23,5/16 - Scott Harrison
# YEAR=2002
# 1/4,1/8,1/9,2/13,4/7,12/18 - Scott Harrison
###############################################################################
# example :              find /etc |perl make_rpm-2.0.pl qian 2.33 3.4
###

# make_rpm.pl automatically generate RPM software packages
# from a target image directory and file listing.  POD
# documentation is at the end of this file.

###############################################################################
##                                                                           ##
## ORGANIZATION OF THIS PERL SCRIPT                                          ##
##                                                                           ##
## 1. Check to see if RPM builder application is available                   ##
## 2. Read in command-line arguments                                         ##
## 3. Generate temporary directories (subdirs of first command-line argument)##
## 4. Initialize some variables                                              ##
## 5. Create a stand-alone rpm building environment                          ##
## 6. Perform variable initializations and customizations                    ##
## 7. Print header information for .spec file                                ##
## 8. Process file list and generate information                             ##
## 9. Generate SRPM and BinaryRoot Makefiles                                 ##
## 10. mirror copy (BinaryRoot) files under a temporary directory            ##
## 11. roll everything into an rpm                                           ##
## 12. clean everything up                                                   ##
## 13. subroutines                                                           ##
## 13a. find_info - recursively gather information from a directory          ##
## 13b. grabtag - grab a tag from an XML string                              ##
## 14. Plain Old Documentation                                               ##
##                                                                           ##
###############################################################################

my $VERSION = 2.0;

use strict;

# ------------------------ Check to see if RPM builder application is available

unless (-e '/usr/lib/rpm/rpmrc') # part of the expected rpm software package
  {
    print(<<END);
**** ERROR **** This script only works with a properly installed RPM builder
application.  
Cannot find /usr/lib/rpm/rpmrc, so cannot generate customized rpmrc file.
Script aborting.
END
    exit(1);
  }

# ---------------------------------------------- Read in command-line arguments

my ($tag,$version,$release,$configuration_files,$documentation_files,
    $pathprefix,$customize)=@ARGV;
@ARGV=(); # read standard input based on a pipe, not a command-line argument

# standardize pathprefix argument
$pathprefix=~s/\/$//; # OTHERWISE THE BEGINNING SLASH MIGHT BE REMOVED

if (!$version) # version should be defined and string length greater than zero
  {
    print(<<END);
See "perldoc make_rpm.pl" for more information.

Usage: 
           <STDIN> | perl make_rpm.pl <TAG> <VERSION> <RELEASE>
	   [CONFIGURATION_FILES] [DOCUMENTATION_FILES] [PATHPREFIX]
	   [CUSTOMIZATION_XML]

Standard input provides the list of files to work with.
TAG, required descriptive tag.  For example, a kerberos software
package might be tagged as "krb4". (This value is also used in
the generation of a temporary directory; you cannot have
a pre-existing directory named ./TAG.)
VERSION, required version.  Needed to generate version information
for the RPM.  It is recommended that this be in the format N.M where N and
M are integers.  For example, 0.3, 4.1, and 8.9 are all valid version numbers.
RELEASE, required release number.  Needed to generate release information
for the RPM.  This is typically an integer, but can also be given descriptive
text such as 'rh7' or 'mandrake8a'.
CONFIGURATION_FILES, optional comma-separated listing of files to
be treated as configuration files by RPM (and thus subject to saving
during RPM upgrades).
DOCUMENTATION_FILES, optional comma-separated listing of files to be
treated as documentation files by RPM (and thus subject to being
placed in the /usr/doc/RPM-NAME directory during RPM installation).
PATHPREFIX, optional path to be removed from file listing.  This
is in case you are building an RPM from files elsewhere than
root-level.  Note, this still depends on a root directory hierarchy
after PATHPREFIX.
CUSTOMIZATION_XML, allows for customizing various pieces of information such
as vendor, summary, name, copyright, group, autoreqprov, requires, prereq,
description, and pre-installation scripts (see more in the POD,
"perldoc make_rpm.pl").
END
    exit(1);
  }

# ----- Generate temporary directories (subdirs of first command-line argument)

# Do some error-checking related to important first command-line argument.
if ($tag=~/[^\w-]/) # non-alphanumeric characters cause problems
  {
    print(<<END);
**** ERROR **** Invalid tag name "$tag"
(The first command-line argument must be alphanumeric characters without
spaces.)
END
    exit(1);
  }
if (-e $tag) # do not overwrite or conflict with existing data
  {
    print(<<END);
**** ERROR **** a file or directory "./$tag" already exists
(This program needs to generate a temporary directory named "$tag".)
END
    exit(1);
  }

print('Generating temporary directory ./'.$tag."\n");
mkdir($tag,0755) or die("**** ERROR **** cannot generate $tag directory\n");
mkdir("$tag/BuildRoot",0755);
mkdir("$tag/SOURCES",0755);
mkdir("$tag/SPECS",0755);
mkdir("$tag/BUILD",0755);
mkdir("$tag/SRPMS",0755);
mkdir("$tag/RPMS",0755);
mkdir("$tag/RPMS/i386",0755);

# -------------------------------------------------------- Initialize variables

my $file;
my $binaryroot=$tag.'/BinaryRoot';
my ($type,$size,$octalmode,$user,$group);

my $currentdir=`pwd`; chomp($currentdir); my $invokingdir=$currentdir;
$currentdir.='/'.$tag;

# ------------------------------- Create a stand-alone rpm building environment

print('Creating stand-alone rpm build environment.'."\n");
open(IN,'</usr/lib/rpm/rpmrc') or die('Cannot open /usr/lib/rpm/rpmrc'."\n");
my @lines=<IN>;
close(IN);

open(RPMRC,">$tag/SPECS/rpmrc");
foreach my $line (@lines)
  {
    if ($line=~/^macrofiles/)
      {
	chomp($line);
	$line.=":$currentdir/SPECS/rpmmacros\n";
      }
    print(RPMRC $line);
  }
close(RPMRC);

open(RPMMACROS,">$tag/SPECS/rpmmacros");
print(RPMMACROS <<END);
\%_topdir $currentdir
\%__spec_install_post    \\
    /usr/lib/rpm/brp-strip \\
    /usr/lib/rpm/brp-strip-comment-note \\
\%{nil}
END
close(RPMMACROS);

# ------------------------- Perform variable initializations and customizations

my $cu=''; # string that holds customization XML file contents
if (length($customize)>0)
  {
    print('Reading in XML-formatted customizations from '.$customize."\n");
    open(IN,"<$customize") or
    (
     print(`cd $invokingdir; rm -Rf $tag`) and
     die('Cannot open customization file "'.$customize.'"'."\n")
    );
    my @clines=(<IN>);
    $cu=join('',@clines);
    close(IN);
  }

# tv - temporary variable (if it exists inside the XML document) then use it,
# otherwise don't overwrite existing values of variables
my $tv='';

# (Sure. We could use HTML::TokeParser here... but that wouldn't be fun now,
# would it?)
my $name=$tag;
# read in name from customization if available
$tv=grabtag('name',$cu,1); $name=$tv if $tv;
$name=~s/\<tag \/\>/$tag/g;

# (When in doubt, be paranoid about overwriting things.)
if (-e "$name-$version-1.i386.rpm")
  {
    print(`cd $invokingdir; rm -Rf $tag`); # clean temporary filespace in use
    die("**** ERROR **** $name-$version-1.i386.rpm already exists.\n");
  }

my $requires='';
# read in relevant requires info from customization file (if applicable)
# note that "PreReq: item" controls order of CD-ROM installation (if you
# are making a customized CD-ROM)
# "Requires: item" just enforces dependencies from the command-line invocation
$tv=grabtag('requires',$cu,1); $requires=$tv if $tv;
# do more require processing here
$requires=~s/\s*\<\/item\>\s*//g;
$requires=~s/\s*\<item\>\s*/\n/g;
$requires=~s/^\s+//s;

my $summary='Files for the '.$name.' software package.';
# read in summary from customization if available
$tv=grabtag('summary',$cu,1); $summary=$tv if $tv;
$summary=~s/\<tag \/\>/$tag/g;

my $autoreqprov='no';
# read in autoreqprov from customization if available
$tv=grabtag('autoreqprov',$cu,1); $autoreqprov=$tv if $tv;

my $copyright="not specified here";
# read in copyright from customization if available
$tv=grabtag('copyright',$cu,1); $copyright=$tv if $tv;
$copyright=~s/\<tag \/\>/$tag/g;

my $rpmgroup="Utilities/System";
# read in copyright from customization if available
$tv=grabtag('group',$cu,1); $rpmgroup=$tv if $tv;
$rpmgroup=~s/\<tag \/\>/$tag/g;

my $vendor='Me';
# read in vendor from customization if available
$tv=grabtag('vendor',$cu,1); $vendor=$tv if $tv;
$vendor=~s/\<tag \/\>/$tag/g;

my $description="$name software package";
# read in description from customization if available
$tv=grabtag('description',$cu,0); $description=$tv if $tv;
$description=~s/\<tag \/\>/$tag/g;

my $pre='';
# read in pre-installation script if available
$tv=grabtag('pre',$cu,0); $pre=$tv if $tv;
$pre=~s/\<tag \/\>/$tag/g;

# ------------------------------------- Print header information for .spec file
print('Print header information for .spec file'."\n");

open(SPEC,">$tag/SPECS/$name-$version.spec");
print(SPEC <<END);
Summary: $summary
Name: $name
Version: $version
Release: $release
Vendor: $vendor
BuildRoot: $currentdir/BuildRoot
Copyright: $copyright
Group: $rpmgroup
Source: $name-$version.tar.gz
AutoReqProv: $autoreqprov
$requires
# requires: filesystem
\%description
$description

\%prep
\%setup

\%build
rm -Rf "$currentdir/BuildRoot"

\%install
make ROOT="\$RPM_BUILD_ROOT" SOURCE="$currentdir/BinaryRoot" directories
make ROOT="\$RPM_BUILD_ROOT" SOURCE="$currentdir/BinaryRoot" files
make ROOT="\$RPM_BUILD_ROOT" SOURCE="$currentdir/BinaryRoot" links

\%pre
$pre

\%post
\%postun

\%files
END

# ------------------------------------ Process file list and gather information
print('Process standard input file list and gather information.'."\n");

my %BinaryRootMakefile;
my %Makefile;
my %dotspecfile;

foreach my $file (<>)
  {
    chomp($file);
    my $comment="";
    if ($file=~/\s+\#(.*)$/)
      {
	$file=~s/\s+\#(.*)$//;
	$comment=$1;
      }
    my $directive="";
    if ($comment=~/config\(noreplace\)/)
      {
	$directive="\%config(noreplace) ";
      }
    elsif ($comment=~/config/)
      {
	$directive="\%config ";
      }
    elsif ($comment=~/doc/)
      {
	$directive="\%doc";
      }
    if (($type,$size,$octalmode,$user,$group)=find_info($file))
      {
	$octalmode="0" . $octalmode if length($octalmode)<4;
	if ($pathprefix)
          {
	    $file=~s/^$pathprefix//;
	  }
	if ($type eq "files")
          {
	    push(@{$BinaryRootMakefile{$type}},"\tinstall -D -m $octalmode ".
		 "$pathprefix$file $binaryroot$file\n");
	    push(@{$Makefile{$type}},"\tinstall -D -m $octalmode ".
		 "\$(SOURCE)$file \$(ROOT)$file\n");
	    push(@{$dotspecfile{$type}},"$directive\%attr($octalmode,$user,".
		 "$group) $file\n");
	  }
	elsif ($type eq "directories")
          {
	    push(@{$BinaryRootMakefile{$type}},"\tinstall -m $octalmode -d ".
		 "$binaryroot$file\n");
	    push(@{$Makefile{$type}},"\tinstall -m $octalmode -d ".
		 "\$(SOURCE)$file \$(ROOT)$file\n");
	    push(@{$dotspecfile{$type}},"\%dir \%attr($octalmode,$user,".
		 "$group) $file\n");
	  }
	elsif ($type eq "links")
          {
	    my $link=$size; # I use the size variable to pass the link value
                            # from the subroutine find_info
	    $link=~s/^$pathprefix//;
	    push(@{$BinaryRootMakefile{$type}},
	         "\tln -s $link $binaryroot$file\n");
	    push(@{$Makefile{$type}},"\tln -s $link \$(ROOT)$file\n");
	    push(@{$dotspecfile{$type}},"\%attr(-,$user,$group) $file\n");
	  }
      }
  }

# -------------------------------------- Generate SRPM and BinaryRoot Makefiles
print('Generate SRPM and BinaryRoot Makefiles.'."\n");

# Generate a much needed directory.
# This directory is meant to hold all source code information
# necessary for converting .src.rpm files into .i386.rpm files.
mkdir("$tag/SOURCES/$name-$version",0755);

open(OUTS,">$tag/SOURCES/$name-$version/Makefile");
open(OUTB, ">$tag/BinaryRootMakefile");
foreach $type ("directories","files","links")
  {
    print(OUTS "$type\:\n");
    print(OUTS join("",@{$Makefile{$type}})) if $Makefile{$type};
    print(OUTS "\n");
    print(OUTB "$type\:\n");
    print(OUTB join("",@{$BinaryRootMakefile{$type}}))
	if $BinaryRootMakefile{$type};
    print(OUTB "\n");
    print(SPEC join("",@{$dotspecfile{$type}})) if $dotspecfile{$type};
  }
close(OUTB);
close(OUTS);

close(SPEC);

# ------------------ mirror copy (BinaryRoot) files under a temporary directory
print('Mirror copy (BinaryRoot) files.'."\n");

`make -f $tag/BinaryRootMakefile directories`;
`make -f $tag/BinaryRootMakefile files`;
`make -f $tag/BinaryRootMakefile links`;

# ------------------------------------------------- roll everything into an RPM
print('Build a tarball and then run the rpm -ba command.'."\n");
my $command="cd $currentdir/SOURCES; tar czvf $name-$version.tar.gz ".
    "$name-$version";
print(`$command`);

# ----------------------------------------- Define commands to be executed.
# command1a works for rpm version <=4.0.2
# command1b works for rpm version >4.0.4

my $arch = 'i386';

my $command1a="cd $currentdir/SPECS; rpm --rcfile=./rpmrc --target=$arch -ba ".
    "$name-$version.spec";

my $rpmcommand = 'rpm';
if (`rpmbuild --version`) {$rpmcommand = 'rpmbuild';}
my $command1b="cd $currentdir/SPECS; $rpmcommand --rcfile=./rpmrc ".
    "-ba --target $arch ".
    "$name-$version.spec";

# ---------------------------------------------- Run the "rpm -ba" command.
# The strategy here is to...try one approach, and then the other.
print "$command1a\n";
print (`$command1a`);
if ($?!=0)
  {
    print(<<END);
**** WARNING **** RPM compilation failed for rpm version 4.0.2 command syntax
(...trying another command syntax...)
END
    print "$command1b\n";
    print (`$command1b`);
    if ($?!=0)
      {
   	print(<<END);
**** ERROR **** RPM compilation failed for rpm version 4.0.4 command syntax
(...no more syntax choices to try...)
END
        exit(1);
      }
  }

# -------------------------------------------------------- Retrieve binary rpm.
$command="cd $currentdir/RPMS/$arch; cp -v ".
    "$name-$version-$release.$arch.rpm $invokingdir/.";
print(`$command`);

# --------------------------------------------------------- clean everything up
print('Removing temporary ./'.$tag.' directory'."\n");
print(`cd $invokingdir; rm -Rf $tag`);

# -------------------------------------------------------- Yeah! We're all done
print('Success. Script complete.'."\n");

# ----------------------------------------------------------------- SUBROUTINES
# ----- Subroutine: find_info - recursively gather information from a directory
sub find_info
  {
    my ($file)=@_;
    my $line='';
    my $safefile = $file;
    $safefile =~ s/\+/\\+/g; # Better regular expression matching.
    if (($line=`find $file -type f -prune`)=~/^$safefile\n/)
      {
	$line=`find $file -type f -prune -printf "\%s\t\%m\t\%u\t\%g"`;
	return("files",split(/\t/,$line));
      }
    elsif (($line=`find $file -type d -prune`)=~/^$safefile\n/)
      {
	$line=`find $file -type d -prune -printf "\%s\t\%m\t\%u\t\%g"`;
	return("directories",split(/\t/,$line));
      }
    elsif (($line=`find $file -type l -prune`)=~/^$safefile\n/)
      {
	$line=`find $file -type l -prune -printf "\%l\t\%m\t\%u\t\%g"`;
	return("links",split(/\t/,$line));
      }
    die("**** ERROR **** $file is neither a directory, soft link, or file.\n");
  }

# ------------------------- Subroutine: grabtag - grab a tag from an xml string
sub grabtag
  {
    my ($tag,$text,$clean)=@_;
    # meant to be quick and dirty as opposed to a formal state machine parser
    my $value='';
    $cu=~/\<$tag\>(.*?)\<\/$tag\>/s; 
    $value=$1; $value=~s/^\s+//;
    if ($clean==1)
      {
	$value=~s/\n\s/ /g;
	$value=~s/\s\n/ /g;
	$value=~s/\n/ /g;
	$value=~s/\s+$//;
      }
    return($value);
  }

# ----------------------------------------------------- Plain Old Documentation

=pod

=head1 NAME

make_rpm.pl - cleanly generate an rpm in a simple one-line command

=head1 SYNOPSIS

Usage: <STDIN> | make_rpm.pl <TAG> <VERSION> <RELEASE>
       [CONFIGURATION_FILES] [DOCUMENTATION_FILES]
       [PATHPREFIX] [CUSTOMIZATION_XML]

=head2 The standard input stream

I<STDIN>, the standard input stream, provides the list of files to work
with.  This list of file names must give the complete filesystem
path starting from '/'.

=over 4

=item * For instance, the following is invalid:

 romeodir/file1.txt # ** INVALID! ** missing leading filesystem path
 romeodir/file2.txt
 romeodir/file3.txt

=item * Whereas, the following is valid:

 /home/joe/romeodir/file1.txt
 /home/joe/romeodir/file2.txt
 /home/joe/romeodir/file3.txt

=item * In terms of the B<find> command,

 "find romeodir | perl make_rpm.pl [COMMAND-LINE ARGUMENTS]"

is incorrect, whereas

 "find /home/joe/romeodir |perl make_rpm.pl [COMMAND-LINE ARGUMENTS]"

or

 "find `pwd`/romeodir |perl make_rpm.pl [COMMAND-LINE ARGUMENTS]"

is correct.

=back

The standard input stream can also
specify configuration files and documentation files through
'#'-style commenting.

For example, the following file listing encodes some of these directives:

 /home/joe/romeodir/buildloc/etc/romeo/user.conf # config(noreplace)
 /home/joe/romeodir/buildloc/etc/romeo/juliet.conf # config
 /home/joe/romeodir/buildloc/doc/man/man.1/romeo.1 # doc
 /home/joe/romeodir/buildloc/doc/man/man.1/romeo_talks.1 # doc
 /home/joe/romeodir/buildloc/usr/local/bin/where_art_thou
 /home/joe/romeodir/buildloc/usr/local/bin/romeo_talks

The I<config> directive controls how files are replaced
and/or backed up when a user attempts to install (B<rpm -i>) the F<.rpm>
file generated by B<make_rpm.pl>.  The I<doc> directive controls how a
given file is placed inside special documentation directories
on the filesystem during rpm installation (B<rpm -i>).
(If you want to learn more on how the B<rpm> tool gives configuration and
documentation files special treatment, you should read about "Directives"
in Edward Bailey's well-known "Maximum RPM" book available online
at http://www.rpm.org/max-rpm/s1-rpm-inside-files-list-directives.html.)

=head2 Description of command-line arguments

I<TAG> ($tag), B<required> descriptive tag.  For example, a kerberos software
package might be tagged as "krb4".

I<VERSION> ($version), B<required> version.  Needed to generate version
information for the RPM.  This should be in the format N.M where N and M are
integers.

I<RELEASE> ($release), B<required> release number.  Needed to generate release
information for the RPM.  This is typically an integer, but can also be given
descriptive text such as 'rh7' or 'mandrake8a'.

I<CONFIGURATION_FILES>, B<optional> comma-separated listing of files to
be treated as configuration files by RPM (and thus subject to saving
during RPM upgrades).  Configuration files can also be specified in
the standard input stream (as described in L<"The standard input stream">).

I<DOCUMENTATION_FILES>, B<optional> comma-separated listing of files to be
treated as documentation files by RPM (and thus subject to being
placed in the F</usr/doc/RPM-NAME> directory during RPM installation).
Documentation files can also be specified in
the standard input stream (as described in L<"The standard input stream">).

I<PATHPREFIX>, B<optional> path to be removed from file listing.  This
is in case you are building an RPM from files elsewhere than
root-level.  Note, this still depends on a root directory hierarchy
after PATHPREFIX.

I<CUSTOMIZATION_XML>, B<optional> filename where XML-ish information exists.
Allows for customizing various pieces of information such
as vendor, summary, name, copyright, group, autoreqprov, requires, prereq,
description, and pre-installation scripts
(see L<"Customizing descriptive data of your RPM software package">).

=head2 Examples

 bash$ find /notreallyrootdir | perl make_rpm.pl \
       makemoney 3.1 1 '' \
       '/usr/doc/man/man3/makemoney.3' \
       /notreallyrootdir
 would generate makemoney-3.1-1.i386.rpm

 bash$ find /usr/local/bin | \
       perl make_rpm.pl mybinfiles 1.0 2
 would generate mybinfiles-1.0-2.i386.rpm

 bash$ echo '/sycamore33/tree.txt' | \
       perl make_rpm.pl sycamore 1.0 2 '' '' '/sycamore33'
 would generate sycamore-1.0-2.i386.rpm
 Note that the generated sycamore rpm would install files at the root
 '/' directory (not underneath /sycamore33); thus a file named
 '/tree.txt' is created, NOT '/sycamore33/tree.txt'.

 bash$ find /home/joe/romeodir/buildloc | \
       perl make_rpm.pl romeo \
       1.0 3 '' '' '/home/joe/romeodir/buildloc' customize.xml
 would generate romeo with customizations from customize.xml.
 Note that the generated romeo rpm would install files at the root
 '/' directory (not underneath /home/joe/romedir/buildloc).

The I<CUSTOMIZATION_XML> argument represents a way to customize the
numerous variables associated with RPMs.  This argument represents
a file name.  (Parsing is done in an unsophisticated fashion using
regular expressions.)  See
L<"Customizing descriptive data of your RPM software package">.

=head1 Customizing descriptive data of your RPM software package

RPMS can be (and often are) packaged with descriptive data 
describing authorship, dependencies, descriptions, etc.

The following values can be tagged inside an XML file
(specified by the 6th command-line argument)
and made part of the RPM package information
(B<rpm -qi E<lt>package-nameE<gt>>).

=over 4

=item * vendor

=item * summary

=item * name

(overrides the <TAG> argument value; see 
L<"Description of command-line arguments>)

=item * copyright

=item * group

(the software package group;
e.g. Applications/System, User Interface/X, Development/Libraries,
etc.)

=item * requires

Contains all the dependency information (see the example below).

=item * description

=item * pre

Commands to be executed prior to software package installation.

=back

Here is an example (note that B<make_rpm.pl> automatically substitutes
any "<tag />" string with the first command-line argument described
in L<"Description of command-line arguments">):

 <vendor>
 Laboratory for Instructional Technology Education, Division of
 Science and Mathematics Education, Michigan State University.
 </vendor>
 <summary>Files for the <tag /> component of LON-CAPA</summary>
 <name>LON-CAPA-<tag /></name>
 <copyright>Michigan State University patents may apply.</copyright>
 <group>Utilities/System</group>
 <AutoReqProv>no</AutoReqProv>
 <requires tag='setup'>
 <item>PreReq: setup</item>
 <item>PreReq: passwd</item>
 <item>PreReq: util-linux</item>
 </requires>
 <requires tag='base'>
 <item>PreReq: LON-CAPA-setup</item>
 <item>PreReq: apache</item>
 <item>PreReq: /etc/httpd/conf/access.conf</item>
 </requires>
 <requires>
 <item>Requires: LON-CAPA-base</item>
 </requires>
 <description>
 This package is automatically generated by the make_rpm.pl perl
 script (written by the LON-CAPA development team, www.lon-capa.org,
 Scott Harrison). This implements the <tag /> component for LON-CAPA.
 For more on the LON-CAPA project, visit http://www.lon-capa.org/.
 </description>
 <pre>
 echo "************************************************************"
 echo "LON-CAPA  LearningOnline with CAPA"
 echo "http://www.lon-capa.org/"
 echo " "
 echo "Laboratory for Instructional Technology Education"
 echo "Michigan State University"
 echo " "
 echo "** Michigan State University patents may apply **"
 echo " "
 echo "This installation assumes an installation of Redhat 6.2"
 echo " "
 echo "The files in this package are for the <tag /> component."
 echo "***********************************************************"
 </pre>

=head1 DESCRIPTION

Automatically generate an RPM software package from a list of files.

B<make_rpm.pl> builds the RPM in a very clean and configurable fashion.
(Finally!  Making RPMs outside of F</usr/src/redhat> without a zillion
file intermediates left over!)

B<make_rpm.pl> generates and then deletes temporary
files needed to build an RPM with.
It works cleanly and independently from pre-existing
directory trees such as F</usr/src/redhat/*>.

Input to the script is simple.  B<make_rpm.pl> accepts five kinds of
information, three of which are mandatory:

=over 4

=item *

(required) a list of files that are to be part of the software package;

=item *

(required) the absolute filesystem location of these files
(see L<"The standard input stream">);

=item *

(required) a descriptive tag, version tag, and release tag for the naming of
the RPM software package;

=item *

(optional) documentation and configuration files;

=item *

and (optional) an XML file that defines the additional metadata
associated with the RPM software package.

=back

A temporary directory named $tag (first argument described in
L<"Description of command-line arguments">) is

=over 4

=item *

generated under the directory from which you run B<make_rpm.pl>.

For example, user "joe" running

 cat file_list.txt | make_rpm.pl krb4 1.0 1

would temporarily generate F</home/joe/krb4/>.

=item *

F</home/joe/krb4/> is deleted after the *.rpm
file is generated.

=back

The RPM will typically be named $name-$version.i386.rpm
where $name=$tag.  (The $name can be overridden in the customization
XML file; see
L<"Customizing descriptive data of your RPM software package">.)

Here are some of the items are generated inside
the $tag directory during the construction of an RPM:

=over 4

=item *

RPM .spec file (F<./$tag/SPECS/$name-$version.spec>)

=item *

RPM Makefile (F<./$tag/SOURCES/$name-$version/Makefile>)

This is the Makefile that is called by the rpm
command in building the .i386.rpm from the .src.rpm.
The following directories are generated and/or used:

=over 4

=item *

SOURCE directory: F<./$tag/BinaryRoot/>

=item *

TARGET directory: F<./$tag/BuildRoot/>

=back

=item *

BinaryRootMakefile (F<./$tag/BinaryRootMakefile>)

This is the Makefile that this script creates and calls
to build the F<$tag/BinaryRoot/> directory from the existing
filesystem.
The following directories are generated and/or used:

=over 4

=item *

SOURCE directory: / (your entire filesystem)

=item *

TARGET directory: F<./$tag/BinaryRoot/>

=back

=back

The final output of B<make_rpm.pl> is a binary F<.rpm> file.
The F<./tag> directory is deleted (along with the F<.src.rpm>
file).  The typical file name generated by B<make_rpm.pl> is
F<$tag-$version.i386.rpm>.

B<make_rpm.pl> is compatible with either rpm version 3.* or rpm version 4.*.

=head1 README

Automatically generate an RPM software package from a list of files.

B<make_rpm.pl> builds the RPM in a very clean and configurable fashion.
(Making RPMs "the simple way" in a one-line command.)

B<make_rpm.pl> generates and then deletes temporary
files (and binary root directory tree) to build an RPM with.
It is designed to work cleanly and independently from pre-existing
directory trees such as /usr/src/redhat/*.

=head1 PREREQUISITES

This script requires the C<strict> module.

=head1 AUTHOR

 Scott Harrison
 harris41@msu.edu

Please let me know how/if you are finding this script useful and
any/all suggestions.  -Scott

=head1 LICENSE

Written by Scott Harrison, harris41@msu.edu

Copyright Michigan State University Board of Trustees

This file is part of the LearningOnline Network with CAPA (LON-CAPA).

This is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This file is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

The GNU Public License is available for review at
http://www.gnu.org/copyleft/gpl.html.

For information on the LON-CAPA project, please visit
http://www.lon-capa.org/.

=head1 OSNAMES

Linux

=head1 SCRIPT CATEGORIES

UNIX/System_administration

=cut

