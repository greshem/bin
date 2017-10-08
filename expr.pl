#!/usr/bin/perl

#
# perl implementation of expr(1)
# Michael Robinson (smrf@sans.vuw.ac.nz) 1999-03-03
# 

# use strict;

sub debug { 1; }
# sub debug { print @_; }
$SIG{__DIE__} = sub { 
    print STDERR "expr: ", $_[0], "\n";
    exit 2;
};

@ARGV || print STDERR "usage: expr expression\n" && exit 1;

# check that it is a number 
sub num($) { 
    $_[0] =~ /^-?[0-9]+$/ or die "non numeric-argument"; 
    $_[0]; 
}

# table of operators
my @global_ops = (
    # logical or
    { 	"|" => sub { $_[0] unless $_[1]; } 
    },
    # logical and
    { 	"&" => sub { ($_[0] && $_[1]) ? $_[0] : 0; },
    },
    # comparison
    { 	">"  => sub { $_[0] >  $_[1] || 0; },
	"<=" => sub { $_[0] <= $_[1] || 0; },
	"="  => sub { $_[0] == $_[1] || 0; },
	"==" => sub { $_[0] == $_[1] || 0; },
	">=" => sub { $_[0] <= $_[1] || 0; },
	"!=" => sub { $_[0] != $_[1] || 0; },
	"<"  => sub { $_[0] <  $_[1] || 0; },
    },
    # add, subtract
    { 	"+"  => sub { num($_[0]) + num($_[1]) || 0; },
	"-"  => sub { num($_[0]) - num($_[1]) || 0; },
    },
    # multiplication, division, modulo
    { 	"*"  => sub { num($_[0]) * num($_[1]) || 0; },
	"/"  => sub { int(num($_[0]) / num($_[1])) || 0; },
	"%"  => sub { num($_[0]) % num($_[1]) || 0; }, 
    },
    # regexp match
    { 	":"  => sub { ($_[0] =~ /^$_[1]/) ? ($1 ? $1 : length $&) : 0; }, 
    }
    # should we handle GNUish match, index, etc?
);

my @stack = @ARGV;	# yuck, a global to handle the argument stack
			# could just use @ARGV, but it'd look ugly
sub evaluate(@); 	# protect us from use strict
sub evaluate(@) {
    my ($op, @ops) = @_;

    # if we're passed an operator to test...
    if ($op) {
	die "syntax error" if $op->{$stack[0]};

	return evaluate @ops unless $op->{$stack[1]}; # recurse

	my $retval = evaluate @ops;
	while ($op->{$stack[0]}) {		      # handle equal precendence
	    my $o = shift @stack;
	    $retval = $op->{$o}->($retval, evaluate @ops);
	}
	return $retval;
    } 

    defined $stack[0] or die "syntax error";

    # handle brackets, the lowest precedence and not a binary operator
    if ($stack[0] eq "(") {
	shift @stack; 				# remove the bracket
	my $retval = evaluate @global_ops; 	# restart
	$stack[0] eq ")" or die "syntax error";
	shift @stack; 				# remove the bracket
	return $retval;
    } 

    return shift @stack; # remove the primitive and return as value
}

my $retval = evaluate @global_ops;
die "syntax error" if (@stack);
print $retval || 0, "\n";
exit ($retval ? 0 : 1);

__END__;

=pod

=head1 NAME

expr -- evaluate expression

=head1 SYNOPSIS

expr expression

=head1 DESCRIPTION

The expr utility evaluates expression and writes the result
on standard output.

All operators are separate arguments to the expr utility.  Characters
special to the command interpreter must be escaped.

Operators are listed below in order of increasing precedence.  Operators
with equal precedence are grouped within { } symbols.

=over 4

=item expr1 | expr2

Returns the evaluation of expr1 if it is neither an empty string
nor zero; otherwise, returns the evaluation of expr2.

=item expr1 & expr2

Returns the evaluation of expr1 if neither expression evaluates
to an empty string or zero; otherwise, returns zero.

=item expr1 {=, >, >=, <, <=, !=} expr2

Returns the results of integer comparison if both arguments are
integers; otherwise, returns the results of string comparison us-
ing the locale-specific collation sequence.  The result of each
comparison is 1 if the specified relation is true, or 0 if the
relation is false.

=item expr1 {+, -} expr2

Returns the results of addition or subtraction of integer-valued
arguments.

=item expr1 {*, /, %} expr2

Returns the results of multiplication, integer division, or re-
mainder of integer-valued arguments.

=item expr1 : expr2

The ``:'' operator matches expr1 against expr2, which must be
a regular expression.  The regular expression is anchored to
the beginning of the string with an implicit ``^''.  The
regular expression language is perlre(1).

If the match succeeds and the pattern contains at least one regu-
lar expression subexpression ``(...)'', the string correspond-
ing to ``$1'' is returned; otherwise the matching operator re-
turns the number of characters matched.  If the match fails and
the pattern contains a regular expression subexpression the null
string is returned; otherwise 0.

Parentheses are used for grouping in the usual manner.

=head1 EXAMPLES

=over 4

=item 1.

The following example adds one to the variable a.

 a=`expr $a + 1`

=item 2.

The following example returns the filename portion of a pathname
stored in variable a.  The // characters act to eliminate ambiguity
with the division operator.

 expr //$a : '.*/\(.*\)'

=item 3.

The following example returns the number of characters in variable a.

 expr $a : '.*'

=back

=head1 DIAGNOSTICS

The expr utility exits with one of the following values:

 0       the expression is neither an empty string nor 0.
 1       the expression is an empty string or 0.
 2       the expression is invalid.

=head1 STANDARDS

The expr utility conforms to IEEE Std1003.2 (``POSIX.2'').

=cut
