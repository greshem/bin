#!/usr/bin/perl -w

#
# $Id: arithmetic,v 1.2 2004/08/05 14:17:43 cwest Exp $
#
# $Log: arithmetic,v $
# Revision 1.2  2004/08/05 14:17:43  cwest
# cleanup, new version number on website
#
# Revision 1.1  2004/07/23 20:09:59  cwest
# initial import
#
# Revision 1.1  1999/03/14 07:44:35  abigail
# Initial revision
#
#

use strict;
use integer;

my ($VERSION) = '$Revision: 1.2 $' =~ /([.\d]+)/;

my $warnings = 0;

sub get_now()
{
	my $log_time;
	if($^O=~/win/i)
	{
		use POSIX 'strftime';
		$log_time=POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));
	}
	else
	{
		$log_time = POSIX::strftime('%Y-%m-%d %T',localtime(time()));
	}
	return  $log_time;

}
#windows 下 最简单的, 到d:\\log 目录
sub logger($)
{
	
	(my $log_str)=@_;
	if(! -d ("c:\\log"))
	{
		mkdir("c:\\log");
	}

	if($^O=~/win32/i)
	{
		#open(FILE, ">>  d:\\log\\vim_plug_install.log");
		open(FILE, ">> c:\\log\\算术.log") or warn("open name.log error\n");
	}
	else
	{
		open(FILE, ">>  算术.log");
	}



	use POSIX qw(strftime)  ;
	my $log_time =get_now();

	print FILE "[$log_time]:".$log_str;
	close(FILE);
}


# Print a usuage message on a unknown option.
# Requires my patch to Getopt::Std of 25 Feb 1999.
$SIG {__WARN__} = sub {
    if (substr ($_ [0], 0, 14) eq "Unknown option") {die "Usage"};
    require File::Basename;
    $0 = File::Basename::basename ($0);
    $warnings = 1;
    warn "$0: @_";
};

$SIG {__DIE__} = sub {
    require File::Basename;
    $0 = File::Basename::basename ($0);
    if (substr ($_ [0], 0,  5) eq "Usage") {
        die <<EOF;
$0 (Perl games) $VERSION
$0 [-o +-x/] [-r range]
EOF
    }
    die "$0: @_";
};

sub get_range()
{
	if(! -f "arith.ini" ) 
	{
		return 10;
	}
	open(FILE,  "arith.ini") ; 
	for(<FILE>)
	{
		if($_=~/range.*=(\d+)/)
		{
			my $range=$1;
			close(FILE);
			return $range;
		}
	}
}

sub save_range($)
{
	(my $range)=@_;
	open(FILE, ">arith.ini") or die("open  arith.ini error\n");
	print FILE  "range=$range\n";
	close(FILE);
}

# Get the options.
#     o   =>  operators.
#     r   =>  range
my $operators = "+-";
my $range     = get_range();;
while (@ARGV > 1) {
    my $opt = shift;
    if ($opt eq '-o') {
        $operators = shift;
        die "Usage" if $operators =~ m{[^-x+/]};
        next;
    }
    if ($opt eq '-r') {
        $range = shift;
        die "Usage" if $range =~ /\D/;
        next;
    }
    die "Usage";
}

# Special case the range of 0. Since the right operator can only be 0,
# division should be disallowed. die() if division was the only possible
# operator. There will be nothing left.
if ($range == 0) {
    $operators =~ s{/+}{}g;
    die "division by 0 is not allowed\n" unless $operators;
}

die "Usage" if @ARGV;

# Play the game!
my $start     = time;
my $questions = 0;
my $correct   = 0;

$SIG {INT}    = \&report;
    
logger("#============================================\n");
logger("#测验开始\n");
logger("range=$range \n");
use constant QUESTIONS => 100;  #问题总数  COUNT
use constant REMEMBER  => 100;  # One in five? *shrug* ， 记住几个.

$range ++;  # Because bounds are inclusive.
# Remember questions with wrong answers.
my %remember = map {$_ => []} split // => $operators;
while ($questions < QUESTIONS) {
    my $operator = substr $operators => rand length $operators, 1;

    my ($left, $right, $answer);

    if (@{$remember {$operator}} && rand 100 < REMEMBER) {
        # Remember something we did wrong.
        ($left, $right, $answer) =
              @{$remember {$operator} -> [rand @{$remember {$operator}}]};
    }
    else {
        # Right is always in the range; with the exception of a 0 divisor.
        do {$right = int rand $range} while $operator eq '/' && $right == 0;

        if ($operator eq '-' || $operator eq '/') {
            # Pick the answer.
            $answer = int rand $range;

            # Find the other operand.
            $left = $operator eq '-' ? $answer + $right : $answer * $right;
        }
        else {
            # Pick the other operand.
            $left = int rand $range;

            # Find the answer.
            $answer = $operator eq '+' ? $left + $right : $left * $right;
        }
    }

    my $guess;
    # Keep trying till we get something that's a number.
    LOOP: {
        print "$left $operator $right = ";
		my $string="$left $operator $right = ";
		#$string=~s/ \- /减/g;
		#$string=~s/ \+ /加/g;
		#$string=~s/ x /乘/g;
		
		$string=~s/ \- /submit/g;
		$string=~s/ \+ /add/g;
		$string=~s/ x /multi/g;
        chomp ($guess = <>);
		#print "Please type a number.\n", redo if $guess =~ /\D/;
		use Encode;
		print "$string \n";
        my $to=encode("utf-8", decode("gb2312", "\"C:\\Program Files (x86)\\eSpeak\\command_line\\espeak.exe\" -v zh $string "));
		#system("\"C:\\Program Files (x86)\\eSpeak\\command_line\\espeak.exe\" -v en $string");
        print "请输入正确答案.\n", redo if $guess =~ /\D/;
    }

    if ($guess == $answer) {
        # We got it right, forget it now.
        $remember {$operator} = [grep {$left  != $_ -> [0] ||
                                       $right != $_ -> [1]}
                                               @{$remember {$operator}}] if
                                               @{$remember {$operator}};
											   
		#print "Right!\n";
        print "正确!\n";
        $correct ++;
    }
    else 
	{
        # Remember wrong answers.
        push @{$remember {$operator}} => [$left, $right, $answer];
		print "错误?\n";
		logger("  错误：   $left  $operator  $right !=  $guess  \n");
		#print "What?\n"
    }

    $questions ++;
}

$SIG {INT} -> ();  # Terminates.

sub report {
    my $seconds = time - $start;
    my $hours   = $seconds / 3600; $seconds %= 3600;
    my $minutes = $seconds /   60; $seconds %=   60;
    my $time    = (join ", " =>
                     map {/^1 / ? $_ : $_ . "s"}
                       grep {!/^0/}
                         "$hours hour", "$minutes minute", "$seconds second") ||
                       "no time at all!"; 

	#print "\nYou had $correct answers correct, our of $questions. ",
	#"It took you $time.\n";

    print "\n 一共做对了$correct 道题目 ,  一共 $questions 道. 得分 ".int((100*$correct/$questions))."分\n" ;
	print ("一共用时 $seconds 秒\n");

    logger("\n 一共做对了$correct 道题目 ,  一共 $questions 道. 得分 ".int((100*$correct/$questions))."分\n" .
		"一共用时 $seconds 秒\n");
            #"It took you $time.\n";
	#my $save_range=$range;
	#$range++;
	save_range($range);
    exit $warnings;
}



__END__

=pod

=head1 NAME

B<arithmetic> -- improve your arithmetic skills.

=head1 SYNOPSIS

B<arithmetic> [B<-o> B<+-x/>] [B<-r> I<range>]

=head1 DESCRIPTION

B<arithmetic> prompts you with simple arithmetic exercises, and
verifies your answers. B<arithmetic> will reply with B<Right!> 
if you answered correctly, and with B<What?> if you answered incorrectly.
If B<arithmetic> thinks your answer is not a number, it will
respond with B<Please type a number!> and repeat the exercise.

After 20 questions, B<arithmetic> will tell you how many exercises you
answered correctly, and how much time it took. Interrupting the game
triggers the same reports; the game is then terminated.

If you answer an exercise incorrectly, B<arithmetic> will remember the
numbers involved, and favour those over others.

=head2 OPTIONS

B<arithmetic> accepts the following options:

=over 4

=item B<-o> B<+-x/>

By default, B<arithmetic> only asks addition exercises. By giving the
B<-o> option, B<arithmetic> will randomly choose from the given I<operators>.
If an operator is given multiple times, that operator will be picked
more often. The more it is repeated, the more it will be picked.

=item B<-r> I<range>

For I<addition> and I<multiplication>, B<arithmetic> will pick both
I<operands> in the range from 0 to I<range>, inclusively. For
I<subtraction> and I<division>, both the answer, and the right I<operand>
will be in this range. The default range is B<10>.

=back

=head1 ENVIRONMENT

The working of B<arithmetic> is not influenced by any environment variables.

=head1 BUGS

This implementation of B<arithmetic> does not respect the end of file
character.

=head1 REVISION HISTORY

    $Log: arithmetic,v $
    Revision 1.2  2004/08/05 14:17:43  cwest
    cleanup, new version number on website

    Revision 1.1  2004/07/23 20:09:59  cwest
    initial import

    Revision 1.1  1999/03/14 07:44:35  abigail
    Initial revision

=head1 AUTHOR

The Perl implementation of B<arithmetic> was written by Abigail,
I<abigail@fnx.com>.

=head1 COPYRIGHT and LICENSE

This program is copyright by Abigail 1999.

This program is free and open software. You may use, copy, modify, distribute,
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others from doing the same.

=cut

