#!/usr/bin/perl

#
# An implementation of the 'id' utility in Perl.  Written for the Perl Power
# Tools (PPT) project by Theo Van Dinter (felicity@kluge.net).
#
# $Id: id,v 1.2 2004/08/05 14:17:43 cwest Exp $
#

use strict;
use Getopt::Std;
use vars qw($opt_G $opt_n $opt_u $opt_g $opt_r $opt_a $opt_p $opt_h);

&help unless getopts('Gnuagraph');
&help if ( $opt_h );
if ( ($opt_G + $opt_g + $opt_p + $opt_u) > 1 ) {
	print STDERR "You may only choose one of -G, -g, -p, or -u.  Doh!\n\n";
	&help;
}

my($user,$pw,$uid,$gid,$tp);

if ( @ARGV ) { # user specified
	($user,$pw,$uid,$gid) = getpwnam $ARGV[0];
	($user,$pw,$uid,$gid) = getpwuid $ARGV[0] unless ( $uid );
	die "id: $ARGV[0]: No such user\n" unless ( $uid );
}

if ( $opt_u ) { # print uid
	$tp = ($uid)?$uid:($opt_r)?$<:$>;
	$tp = scalar getpwuid $tp || $tp if ( $opt_n );
}
elsif ( $opt_g ) { # print gid
	$tp = ($gid)?$gid:(split(/\s+/,($opt_r)?$(:$)))[0];
	$tp = scalar getgrgid $tp || $tp if ( $opt_n );
}
elsif ( $opt_p ) { # human-readable form (names when possible, etc.)
	my($rgid,@rgids);
	if ( $user ) {
		$tp.="uid $user\n";
		$tp.="rgid $gid\n";
		@rgids=($gid);
		while ( my($name,$pw,$gid,$members) = getgrent ) {
			push(@rgids,$gid) if ( grep($_ eq $user,split(/\s+/,$members)) );
		}
	}
	else {
		my($login) = getlogin || die "getlogin failed!";
	
		$tp.="login $login\n" if ( $login ne scalar getpwuid $< );
	
		my($uid) = scalar getpwuid $< || $<;
		$tp.="uid $uid\n";
	
		my($euid) = scalar getpwuid $> || $>;
		$tp.="euid $euid\n" if ( $< != $> );
	
		($rgid,@rgids)=split(/\s+/,$();
		my($egid)=split(/\s+/,$));
		my($nrgid) = scalar getgrgid $rgid || $rgid;
		my($negid) = scalar getgrgid $egid || $egid;
		$tp.="rgid $nrgid\n";
		$tp.="egid $negid\n" if ( $rgid != $egid );
	}
	my(%done);
	foreach ( @rgids ) {
		$done{$_} = scalar getgrgid $_ || $_;
	}
	$tp.=join(" ","groups",values %done);
}
elsif ( $opt_G ) { # print full group info
	my(%done);
	my(@rgids);

	if ( $user ) {
		@rgids=($gid);
		while ( my($name,$pw,$gid,$members) = getgrent ) {
			push(@rgids,$gid) if ( grep($_ eq $user,split(/\s+/,$members)) );
		}
	}
	else {
		@rgids = split(/\s+/, $();
	}
	foreach ( @rgids ) {
		if ( $opt_n ) {
			$done{$_} = scalar getgrgid $_ || $_;
		}
		else {
			$done{$_} = $_;
		}
	}
	$tp=join(" ",values %done);
}
else { # uid=#(name) gid=#(name) euid=#(name) egid=#(name) groups=#(name) ...
	my($rgid,@rgids,$egid,$nruid,$neuid,$nrgid,$negid);

	if ( $user ) {
		$egid = $rgid = $gid;
		@rgids=($gid);
		while ( my($name,$pw,$gid,$members) = getgrent ) {
			push(@rgids,$gid) if ( grep($_ eq $user,split(/\s+/,$members)) );
		}
		$nruid = $user;
		$nrgid = scalar getgrgid $gid;
	}
	else {
		($rgid,@rgids)=split(/\s+/,$();
		$egid = (split(/\s+/,$)))[0];
		$nruid = scalar getpwuid $<;
		$neuid = scalar getpwuid $>;
		$nrgid = scalar getgrgid $rgid;
		$negid = scalar getgrgid $egid;
	}

	$tp=join("=","uid",($user)?$uid:$<);
	$tp.=($nruid)?"($nruid) ":" ";

	if ( !($user) && ($< != $>) ) {
		$tp.="euid=$>";
		$tp.=($neuid)?"($neuid) ":" ";
	}

	$tp.=join("=","gid",($user)?$gid:$rgid);
	$tp.=($nrgid)?"($nrgid) ":" ";

	if ( $rgid != $egid ) {
		$tp.="egid=$egid";
		$tp.=($negid)?"($negid) ":" ";
	}

	my(%done);
	$tp.="groups=";
	foreach ( @rgids ) {
		my($i) = scalar getgrgid $_;
		my($i2) = "$_";
		$i2 .= "($i)" if ( $i );
		$done{$_} = "$i2";
	}
	$tp.=join(",",values %done);
}

print "$tp\n";	
exit 0;

sub help {
	print STDERR
"usage:	id [user]
	id -G [-n] [user]
	id -g [-nr] [user]
	id -u [-nr] [user]
	id -p [user]
	id -h
	id -a
";
	exit 1;
}

=head1 NAME

id - show user information

=head1 SYNOPSIS

id [-Gnuagraph] [user]

=head1 DESCRIPTION

id displays the user and group names and numeric IDs of the calling
process.  If the real and effective IDs are different, both are displayed,
otherwise only the real ID is displayed.

If a user (username or user ID) is specified, the information about that user
is displayed instead of the information from the calling process.

=head1 OPTIONS AND ARGUMENTS

=item I<-G>	
Display all of the group IDs (effective, real, etc) separated by a space.
The IDs are not in a given order.

=item I<-a>	
Nothing.  The option is included for compatibility with some versions of id.

=item I<-g>	
Display the effective group ID.

=item I<-h>	
Display the usage help message.

=item I<-n>	
Force the options C<-G>, C<-g> and C<-u> to display the matching name
instead of the number for the user and group IDs.  If any of the ID
numbers do not have a matching name, the number will be displayed
as usual.

=item I<-p>	
Display the user/group information on seperate lines.  If the username
returned by getlogin is different than the username associated with
the calling program's user ID, it is displayed preceded by the phrase
"login".  The real ID, effective user ID (if different), real group ID,
and effective group ID (if different) are displayed preceded by "uid",
"euid", "rgid", and "egid" respectively.  Finally, group membership
is displayed with each group separated by a space.  All information is
displayed as names unless there is no name matching the ID.  Then the
ID is shown as usual.

=item I<-r>	
Force the options C<-g> and <-u> to display the information associated
with the real user/group IDs instead of the effective ID information.

=item I<-u>	
Display the effective user ID.

=head1 NOTES

id returns 0 on success or 1 if an error occurred.

=head1 AUTHOR

Theo Van Dinter (felicity@kluge.net)

=head1 SEE ALSO

who(1)
