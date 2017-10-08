#!/usr/bin/perl
# HUNT THE WUMPUS
#
# $Id: wump,v 1.2 2004/08/05 14:17:44 cwest Exp $
#
# Perl port by Amir Karger (karger@post.harvard.edu), March 1999.
# See documentation for LICENSE etc.
#
use strict; # what good BASIC programmer wouldn't?
my $F; # main status variable
my $L; # main location variable (not the same as @L!!!)
my $A; # number of arrows

# 5 REM *** HUNT THE WUMPUS *** 
my @P; 						#10 DIM P(5) 
print "INSTRUCTIONS (Y-N) ";     		#15 PRINT "INSTRUCTIONS (Y-N)"; 
my $I = uc(<>); chomp($I); 			#20 INPUT I$ 
&instructions unless ($I eq "N"); 		#25 IF I$="N" THEN 35 
                                  		#30 GOSUB 375 
                                  		#35 GOTO 80  (what's this for?)

# 80 REM *** SET UP CAVE (DODECAHEDRAL NODE LIST) *** 
my ($J, $K);
my @S;						#85 DIM S(20,3) 
my @temp; while (<DATA>) {chomp;push @temp, (split(",",$_))}
for $J (1..20) { 				#90 FOR J=1 TO 20 
    for $K (1..3) {				#95 FOR K=1 TO 3 
        $S[$J][$K] = shift(@temp);		#100 READ S(J,K) 
    }						#105 NEXT K 
}						#110 NEXT J 
sub fna {int(rand() * 20) + 1}			#135 DEF FNA(X)=INT(20*RND(1))+1
sub fnb {int(rand() * 3) + 1}			#140 DEF FNB(X)=INT(3*RND(1))+1 
sub fnc {int(rand() * 4) + 1}			#145 DEF FNC(X)=INT(4*RND(1))+1 

# 150 REM *** LOCATE L ARRAY ITEMS *** 
# 155 REM *** 1-YOU, 2-WUMPUS, 3&4-PITS, 5&6-BATS *** 
my @L;						# 160 DIM L(6) 
my @M;						# 165 DIM M(6) 
my $locate = 1; # avoid gotos

while (1) {
    LOCATE: {
	last LOCATE unless $locate; # avoid gotos
	for $J (1..6) {				# 170 FOR J=1 TO 6 
	    $L[$J] = &fna;			# 175 L(J)=FNA(0) 
	    $M[$J] = $L[$J];			# 180 M(J)=L(J) 
	}					# 185 NEXT J 

	# 190 REM *** CHECK FOR CROSSOVERS (IE L(1)=L(2), ETC) *** 
	for $J (1..6) {				# 195 FOR J=1 TO 6 
	    for $K (1..6) {			# 200 FOR K=1 TO 6 
		unless ($J==$K) {		# 205 IF J=K THEN 215 
		    redo LOCATE if $L[$J]==$L[$K]; # 210 IF L(J)=L(K) THEN 170 
		}
	    }					# 215 NEXT K 
	}					# 220 NEXT J 
    }

    # 225 REM *** SET NO. OF ARROWS *** 
    $A = 5;					# 230 A=5 
    $L = $L[1];					# 235 L=L(1) 

    # 240 REM *** RUN THE GAME *** 
    print "HUNT THE WUMPUS\n";			# 245 PRINT "HUNT THE WUMPUS" 

    # 250 REM *** HAZARD WARNING AND LOCATION *** 
    HAZARD: {
	&hazard; 				# 255 GOSUB 585 

	# 260 REM *** MOVE OR SHOOT *** 
	my $O = &shoot_or_move; 		# 265 GOSUB 670 
	if ($O == 1) {				# 270 ON O GOTO 280,300 
	    # 275 REM *** SHOOT *** 
	    &shoot;				# 280 GOSUB 715 
	    redo HAZARD unless $F;		# 285 IF F=0 THEN 255 
	} elsif ($O == 2) {			# 290 GOTO 310 
	    # 295 REM *** MOVE *** 
	    &move; 				# 300 GOSUB 975 
	    redo HAZARD unless $F;		# 305 IF F=0 THEN 255 
	}
    } # end HAZARD

    unless ($F>0) {				# 310 IF F>0 THEN 335 
	# 315 REM *** LOSE *** 
	print "HA HA HA - YOU LOSE!\n"; 	# 320 PRINT "..." 
    } else {					# 325 GOTO 340 
	# 330 REM *** WIN *** 
	# 335 PRINT "HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!" 
	print "HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n" 
    }
    for $J (1..6) {				# 340 FOR J=1 TO 6 
	$L[$J]=$M[$J];				# 345 L(J)=M(J) 
    }						# 350 NEXT J 
    print "SAME SETUP (Y-N) ";			# 355 PRINT "SAME SETUP (Y-N)"; 
    $I = uc(<>); chomp($I);			# 360 INPUT I$ 
    $locate = ($I ne "Y");			# 365 IF I$<>"Y"THEN 170 
}						# 370 GOTO 230 

##################
# 375 REM *** INSTRUCTIONS *** 
sub instructions { 
# removed original BASIC lines to save space
print <<"INSTRUCTIONS1";
WELCOME TO 'HUNT THE WUMPUS';
 THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM
HAS 3 TUNNELS LEADING TO OTHER ROOMS. (LOOK AT A
DODECAHEDRON TO SEE HOW THIS WORKS-IF YOU DON'T KNOW
WHAT A DODECAHEDRON IS, ASK SOMEONE)

 HAZARDS:
 BOTTOMLESS PITS - TWO ROOMS HAVE BOTTOMLESS PITS IN THEM 
 IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)
 SUPER BATS - TWO OTHER ROOMS HAVE SUPER BATS. IF YOU
 GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER
 ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)
TYPE AN E THEN RETURN
INSTRUCTIONS1
<>; 					# 440 INPUT "TYPE AN E THEN RETURN ";W9 
print <<"INSTRUCTIONS2";
 WUMPUS: 
 THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER 
 FEET AND IS TOO BIG FOR A BAT TO LIFT). USUALLY 
 HE IS ASLEEP. TWO THINGS WAKE HIM UP: YOU SHOOTING AN 
ARROW OR YOU ENTERING HIS ROOM. 
 IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM 
 OR STAYS STILL (P=.25). AFTER THAT, IF HE IS WHERE YOU 
 ARE, HE EATS YOU UP AND YOU LOSE! 

 YOU: 
 EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW 
 MOVING: YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL) 
 ARROWS: YOU HAVE 5 ARROWS. YOU LOSE WHEN YOU RUN OUT 
 EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY 
 THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO. 
 IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT 
 AT RANDOM TO THE NEXT ROOM. 
 IF THE ARROW HITS THE WUMPUS, YOU WIN. 
 IF THE ARROW HITS YOU, YOU LOSE. 
TYPE AN E THEN RETURN
INSTRUCTIONS2
<>; 					# 540 INPUT "TYPE AN E THEN RETURN ";W9 
print <<"INSTRUCTIONS3";
 WARNINGS: 
 WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD, 
 THE COMPUTER SAYS: 
 WUMPUS: 'I SMELL A WUMPUS' 
 BAT : 'BATS NEARBY' 
 PIT : 'I FEEL A DRAFT' 
INSTRUCTIONS3
 					# 580 RETURN 
} # end sub instructions

############
# 585 REM *** PRINT LOCATION & HAZARD WARNINGS *** 
sub hazard {
    print "\n";					# 590 PRINT 
    for $J (2..6) {				# 595 FOR J=2 TO 6 
        for $K (1..3) {				# 600 FOR K=1 TO 3 
            next if $S[$L[1]][$K] != $L[$J];   # 605 IF S(L(1),K)<>L(J) THEN 640
	    print (("",                    # 610 ON J-1 GOTO 615,625,625,635,635
	        "I SMELL A WUMPUS!",      	# 615 PRINT "I SMELL A WUMPUS!" 
						# 620 GOTO 640 
                (("I FEEL A DRAFT") x 2),       # 625 PRINT "I FEEL A DRAFT"
    						# 630 GOTO 640 
                (("BATS NEARBY!") x 2)          # 635 PRINT "BATS NEARBY!" 
	    )[$J-1], "\n");
        }					# 640 NEXT K 
    }						# 645 NEXT J 
    print "YOU ARE IN ROOM ",$L[1],"\n";        # 650 PRINT "... ",L(1)
         # 655 PRINT "TUNNELS LEAD TO ",S(L,1);S(L,2);S(L,3) 
    print "TUNNELS LEAD TO ", join(" ",@{$S[$L]}[1..3]),"\n"; 
    print "\n";					# 660 PRINT 
    return;					# 665 RETURN 
} # end sub hazard

############
# 670 REM *** CHOOSE OPTION *** 
sub shoot_or_move {
    while (1) { my $O;
	print "SHOOT OR MOVE (S-M) ";		# 675 PRINT "..."; 
	$I = uc(<>); chomp($I);			# 680 INPUT I$ 
        if ($I eq "S") { 			# 685 IF I$<>"S" THEN 700 
	    $O = 1;				# 690 O=1 
            return $O; 				# 695 RETURN 
        } elsif ($I eq "M") {			# 700 IF I$<>"M" THEN 675 
            $O = 2;				# 705 O=2 
            return $O;				# 710 RETURN 
	}
    }
} # end sub shoot_or_move

############
# 715 REM *** ARROW ROUTINE *** 
sub shoot {
    my (@P, $K1, $J9);
    $F = 0;					# 720 F=0 

    # 725 REM *** PATH OF ARROW *** 
    {
	print "NO. OF ROOMS (1-5) ";            #735 PRINT "NO. OF ROOMS (1-5)";
	$J9 = <>; chomp($J9); 			# 740 INPUT J9 
	redo if $J9 < 1;			# 745 IF J9<1 THEN 735 
	redo if $J9 > 5;			# 750 IF J9>5 THEN 735 
    }
    for $K (1..$J9) {				# 755 FOR K=1 TO J9 
	print "ROOM # ";			# 760 PRINT "ROOM #"; 
	$_=uc(<>); chomp; $P[$K]=$_;		# 765 INPUT P(K) 
        next if $K <= 2;			# 770 IF K<=2 THEN 790 
        next if $P[$K] != $P[$K-2]; 		# 775 IF P(K)<>P(K-2) THEN 790 
        print "ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n" ; # 780 PRINT...
        redo; 					# 785 GOTO 760 
    }						# 790 NEXT K 

# Note: The logic here is just too complicated, with too many gotos.
# I had to move a few of the lines around.
# Specifically, lines 900-930 became a continue block, so that line 920,
# which does a "THEN 840" (if you don't die), sends you back to the beginning
# of the "for $K" loop.
    # 795 REM *** SHOOT ARROW *** 
    $L = $L[1];					# 800 L=L(1) 
    PATH:for $K (1..$J9) {			# 805 FOR K=1 TO J9 
        for $K1 (1..3) {			# 810 FOR K1=1 TO 3 
    	    if ($S[$L][$K1]==$P[$K]) {		# 815 IF S(L,K1)=P(K) THEN 895 
		$L = $P[$K];			# 895 L=P(K) 
		next PATH; # go to continue block (line 900)
	    }
        }					# 820 NEXT K1 

	# 825 REM *** NO TUNNEL FOR ARROW *** 
        $L = $S[$L][&fnb];			# 830 L=S(L,FNB(1)) 

    } continue {				# 835 GOTO 900

	# 890 REM *** SEE IF ARROW IS AT L(1) OR AT L(2) 
	if ($L==$L[2]) {			# 900 IF L<>L(2) THEN 920 
	    print "AHA! YOU GOT THE WUMPUS!\n"; # 905 PRINT "AHA!..." 
	    $F = 1;				# 910 F=1 
	    return;				# 915 RETURN 
	} elsif ($L==$L[1]) { 			# 920 IF L<>L(1) THEN 840 
	    print "OUCH! ARROW GOT YOU!\n";	# 925 PRINT "OUCH! ..." 
	    $F=-1; return;			# 930 GOTO 880 
	}
    }						# 840 NEXT K 

    print "MISSED\n";				# 845 PRINT "MISSED" 
    $L = $L[1];					# 850 L=L(1) 

    # 855 REM *** MOVE WUMPUS *** 
    &move_wumpus;				# 860 GOSUB 935 

    # 865 REM *** AMMO CHECK *** 
    $A--;					# 870 A=A-1 
    unless ($A>0) {				# 875 IF A>0 THEN 885 
        $F=-1;					# 880 F=-1 
    }
    return;					# 885 RETURN 
} # end sub shoot

###############
# 935 REM *** MOVE WUMPUS ROUTINE *** 
sub move_wumpus {
    $K = &fnc;					# 940 K=FNC(0) 
    unless ($K==4) { 				# 945 IF K=4 THEN 955 
        $L[2] = $S[$L[2]][$K] 			# 950 L(2)=S(L(2),K) 
    }
    if ($L[2]==$L) {				# 955 IF L(2)<>L THEN 970 
        print "TSK TSK TSK - WUMPUS GOT YOU!\n";# 960 PRINT ... 
        $F = -1;				# 965 F=-1 
    }
    return;					# 970 RETURN 
} # end sub move_wumpus

#################
# 975 REM *** MOVE ROUTINE *** 
sub move {
    $F = 0;					# 980 F=0 
    MOVE: while (1) {
	print "WHERE TO ";			# 985 PRINT "WHERE TO"; 
	$_= <>;chomp; $L = $_;			# 990 INPUT L 
	next if $L < 1;				# 995 IF L<1 THEN 985 
	next if $L > 20;			# 1000 IF L>20 THEN 985 

	for $K (1..3) {				# 1005 FOR K=1 TO 3 
	    # 1010 REM *** CHECK IF LEGAL MOVE *** 
	    last MOVE if $S[$L[1]][$K]==$L;	# 1015 IF S(L(1),K)=L THEN 1045
	}					# 1020 NEXT K 
	last if $L==$L[1];			# 1025 IF L=L(1) THEN 1045 
	print "NOT POSSIBLE - ";		# 1030 PRINT "NOT POSSIBLE -"; 
    }						# 1035 GOTO 985 

    CHECKMOVE: { # needed so we can say "next" (because of bats)
	# 1040 REM *** CHECK FOR HAZARDS *** 
	$L[1] = $L;				# 1045 L(1)=L 

	# 1050 REM *** WUMPUS *** 
	if ($L==$L[2]) { 			# 1055 IF L<>L(2) THEN 1090 
	    print "... OOPS! BUMPED A WUMPUS!\n"; # 1060 PRINT...

	    # 1065 REM *** MOVE WUMPUS *** 
	    &move_wumpus;			# 1070 GOSUB 940 
	    return unless $F==0;		# 1075 IF F=0 THEN 1090 
						# 1080 RETURN 
	}

	# 1085 REM *** PIT *** 
	if ($L==$L[3] ||			# 1090 IF L=L(3) THEN 1100 
	    $L==$L[4]) {			# 1095 IF L<>L(4) THEN 1120 
	    print "YYYYIIIIEEEE . . . FELL IN PIT\n";  # 1100 PRINT...
	    $F = -1;				# 1105 F=-1 
	    return;				# 1110 RETURN 
	}

	# 1115 REM *** BATS *** 
	if ($L==$L[5] ||			# 1120 IF L=L(5) THEN 1130 
	    $L==$L[6]) {			# 1125 IF L<>L(6) THEN 1145 
	    print "ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n";# 1130 ...
	    $L=&fna;				# 1135 L=FNA(1) 
	    redo CHECKMOVE;			# 1140 GOTO 1045 
	}
    }

    return;					#1145 RETURN 
} # end sub move

exit; 						# 1150 END 

# Had to move these to end of file
#115 DATA 2,5,8,1,3,10,2,4,12,3,5,14,1,4,6 
#120 DATA 5,7,15,6,8,17,1,7,9,8,10,18,2,9,11 
#125 DATA 10,12,19,3,11,13,12,14,20,4,13,15,6,14,16 
#130 DATA 15,17,20,7,16,18,9,17,19,11,18,20,13,16,19 
__DATA__
2,5,8,1,3,10,2,4,12,3,5,14,1,4,6
5,7,15,6,8,17,1,7,9,8,10,18,2,9,11
10,12,19,3,11,13,12,14,20,4,13,15,6,14,16
15,17,20,7,16,18,9,17,19,11,18,20,13,16,19

=pod

=head1 NAME

wump - Perl port of the "Hunt the Wumpus" game

=head1 SYNOPSIS

wump

=head1 DESCRIPTION

Move around the tunnels and shoot the wumpus. Don't get eaten by the wumpus,
don't fall into a pit, don't hit yourself with an arrow, watch out for bats.

The game gives more instructions. (Embedded documentation! Could this be a
precursor to POD?)

=head1 NOTES

=head2 Perl Port

Because "Hunt the Wumpus" is one of the classics of early BASIC coding, I
decided to stick as closely as possible to the original BASIC code. In this
way, this program can serve not only as a fun way to while away the hours while
waiting for batch jobs; but it can also be useful to teach the hordes of coders
currently moving from 1970's BASIC to Perl. 

I was mostly able to get a 1:1 correspondence between lines. You may notice
that the Perl code is a bit longer, which I guess proves that BASIC is more
powerful and concise. The only places I cheated were to remove goto's (although
I was sorely tempted to use a "goto EXPR" for the "ON ... GOTO"s).

Inputs are changed into upper case for your gaming convenience.

=head2 Miscellaneous

"Wumpus" can be found in the Jargon File. Some have gone so far as to say that
this was the "first text adventure". In that case, I'm glad text adventures
have developed since then.

=head1 BUGS

I have faithfully ported the lack of a "Quit" option. Also the spelling
mistakes, and any bugs in the original. For example, you can shoot an arrow to
go through rooms "1 2 2", which shouldn't be legal. But faithful porting means
faithful porting.

Error message under B<-w>

=head1 COPYRIGHT and LICENSE

This program is copyright (C) Amir Karger 1999. (Although I can't imagine why)

This program is free and open software. You may use, copy, modify, distribute
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others to do the same.

=head1 AUTHORS

Apparently, many of them.

Some web sites claim this game was originally written by Gregory Yob,
and published in Creative Computing Magazine in the September/October
1975 issue. The OpenBSD man pages say it was "People's Computer Company"
in 1973.  The BASIC code I used may or may not be the text that
appeared in David Ahl's book "101 BASIC Computer Games".

Ported by Amir Karger karger@post.harvard.edu March, 1999

=cut
