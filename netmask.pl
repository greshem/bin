#!/usr/bin/perl
##
##  This program explains IPv4 addresses and netmasks, and creates subnet
##  masks given the number of networks / hosts required.
##
##  Copyright (C) 2003  D. Scott Guthridge, scott_guthridge@ieee.org
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
##

##
## for Chris...
##


###############################################################################
##
## Package IPV4Address
##	Operations on IPv4 Addresses and Masks
##
##	This package implements class IPV4Address.  This class is
##	fairly specific to the application in that it only provides
##	support for netmask calculations and display.  It wasn't
##	necessarily intended to be a general-purpose perl module.
##	It exists as a package here for modularity reasons.  
##
###############################################################################

package IPV4Address;
use strict;

#
# IPV4Address::new()
#	Constructor
#
# Example:
#	$ip = IPV4Address->new([168, 192, 0, 0]);
#
sub new {
    my $proto = shift;
    my $data  = shift;

    my $class = ref($proto) || $proto;
    if (!defined($data)) {
	return undef;
    }
    my $self = {
	data => $data
    };
    bless($self, $class);
    return $self;
}

#
# IPV4Address::scan()
#	Alternate Constructor
#
#	Parse an IP address in either decimal or hex format
#	and if successful, return a new IPV4Address instance.
#	Missing trailing octets are treated as zeros.
#
sub scan {
    my $proto = shift;
    my $line  = shift;

    my @result;

    #
    # Remove leading and trailing whitespace characters.
    #
    $line =~ s/^\s*//;
    $line =~ s/\s*$//;

    #
    # Match decimal, e.g. 192.168.0.0 notation.  Accept dot or space
    # as the separator.
    #
    if ($line =~ m/^[0-9]{1,3}((\.|\s+)[0-9]{1,3}){0,3}$/) {
	$line =~ s/\./ /g;
	@result = split(/\s+/, $line);
	while ($#result - $[ + 1 < 4) {
	    push(@result, 0);
	}
	$result[0] = int($result[0]);
	$result[1] = int($result[1]);
	$result[2] = int($result[2]);
	$result[3] = int($result[3]);
	if ($result[0] > 255 || $result[1] > 255 ||
	    $result[2] > 255 || $result[3] > 255) {
	    return undef;
	}
	return $proto->new(\@result);
    }

    #
    # Match hexadecimal notation, e.g. 0xC0A80000
    #
    if ($line =~ s/0x(([0-9A-Fa-f]{2}){1,4})$/$1/) {
	if ($line =~ m/^(..)(..)?(..)?(..)?$/) {
	    $result[0] = hex($1);
	    $result[1] = hex($2);
	    $result[2] = hex($3);
	    $result[3] = hex($4);
	    return $proto->new(\@result);
	}
    }

    #
    # Otherwise it's not well-formed.
    #
    return undef;
}

#
# IPV4Address::copy()
#	Copy Constructor
#
# Example::
#	$ip = $other->copy();
#
sub copy {
    my $proto = shift;

    my $class = ref($proto);
    if (!defined($class)) {
	return undef;
    }
    my @data = @{$proto->{data}};
    return $class->new(\@data);
}

#
# IPV4Address::not()
#	Bitwise NOT the given IPv4 address and return
#	the result as a new instance.
#
sub not {
    my $self = shift;

    my $data = $self->{data};
    my $i;
    my @result;

    for ($i = $[; $i < $[ + 4; ++$i) {
	$result[$i] = (~$$data[$i] & 0xff);
    }
    return $self->new(\@result);
}

#
# IPV4Address::and()
#	Bitwise AND the given IPv4 address with another
#	and return the result as a new instance.  Neither
#	argument is altered.
#
sub and {
    my $self  = shift;
    my $other = shift;

    my $i;
    my @result;

    for ($i = $[; $i < $[ + 4; ++$i) {
	$result[$i] = (${$self->{data}}[$i] & ${$other->{data}}[$i]);
    }
    return $self->new(\@result);
}

#
# IPV4Address::fillBits()
#	Starting from the MSB side, add the specified number
#	of one-bits where zero bits currently exist.  Return
#	the result as a new instance.
#
sub fillBits {
    my $self  = shift;
    my $count = shift;

    my @result = @{$self->{data}};
    my $bit = 31;

    while ($count > 0) {
	my $i = 3 - ($bit >> 3);
	my $b = ($bit & 0x7);
	if (($result[$i] & (1 << $b)) == 0) {
	    $result[$i] |= (1 << $b);
	    --$count;
	}
	--$bit;
	die if $bit < 0;
    }
    return $self->new(\@result);
}

#
# IPV4Address::overlayBits()
#	Modify the bits under the given mask such that
#	if the selected bits are concatenated, they form
#	the numerical value given.  Return the result as
#	a new instance.
#
sub overlayBits {
    my $self  = shift;
    my $mask  = shift;
    my $value = shift;

    my @result = @{$self->{data}};
    my $bit;

    for ($bit = 0; $bit < 32; ++$bit) {
	my $i = 3 - ($bit >> 3);
	my $b = ($bit & 0x7);
	if ((${$mask->{data}}[$i] & (1 << $b)) != 0) {
	    if (($value & 1) == 0) {
		$result[$i] &= ~(1 << $b);
	    } else {
		$result[$i] |= (1 << $b);
	    }
	    $value >>= 1;
	}
    }
    die if $value != 0;
    return $self->new(\@result);
}

#
# IPV4Address::countBits()
#	Count the number of 1-bits in the IPv4 address.
#
sub countBits {
    my $self = shift;

    my @temp_data = @{$self->{data}};
    my $i;
    my $count = 0;

    for ($i = $[; $i < $[ + 4; ++$i) {
	while ($temp_data[$i] != 0) {
	    $temp_data[$i] &= $temp_data[$i] - 1;
	    ++$count;
	}
    }
    return $count;
}

#
# IPV4Address::bitVector()
#	Return a string representation of the IPv4 address
#	as a bit vector, divided into sections by byte.
#	Bits within the given mask are returned as '0' and
#	'1' while bits not in the mask are given as
#	whitespace.
#
sub bitVector {
    my $self = shift;
    my $mask = shift;

    my $ip_data   = $self->{data};
    my $mask_data = $mask->{data};
    my ($byte, $bit);
    my $result = "";

    for ($byte = 0; $byte < 4; ++$byte) {
	for ($bit = 7; $bit >= 0; --$bit) {
	    if (($$mask_data[$byte] & (1 << $bit)) != 0) {
		if (($$ip_data[$byte] & (1 << $bit)) != 0) {
		    $result .= " 1";
		} else {
		    $result .= " 0";
		}
	    } else {
		$result .= "  ";
	    }
	}
	if ($byte != 3) {
	    $result .= "  ";
	}
    }
    return $result;
}

#
# IPV4Address::decimal()
#	Return an ordinary dot-separated byte base 10 string
#	representation of the IPv4 address.
#
sub decimal {
    my $self = shift;

    my $data = $self->{data};
    return sprintf("%d.%d.%d.%d", $$data[0], $$data[1], $$data[2], $$data[3]);
}

#
# IPV4Address::hex()
#	Return a base-16 string representation of the IPv4 address.
#
sub hex {
    my $self = shift;

    my $data = $self->{data};
    return sprintf("0x%02X%02X%02X%02X",
	$$data[0], $$data[1], $$data[2], $$data[3]);
}

#
# IPV4Address::byte()
#	Return the value of the n'th byte of the IPv4 address.
#
sub byte {
    my $self  = shift;
    my $index = shift;

    return ${$self->{data}}[$index];
}

#
# IPV4Address::classifyNetwork()
#	Classify the IPv4 address as a class A, B, C, D or E
#	network.  Return an array containing the class, the
#	default netmask associated with the class and a mask
#	indicating the positions of the bits used to identify
#	the class.
#
sub classifyNetwork() {
    my $self = shift;

    my $address = $self->{data};
    my $class;
    my $class_netmask;
    my $class_id_mask;

    if ($$address[0] < 128) {
	$class = "A";
	$class_netmask = $self->new([255, 0, 0, 0]);
	$class_id_mask = $self->new([128, 0, 0, 0]);
    } elsif ($$address[0] < 192) {
	$class = "B";
	$class_netmask = $self->new([255, 255, 0, 0]);
	$class_id_mask = $self->new([192, 0, 0, 0]);
    } elsif ($$address[0] < 224) {
	$class = "C";
	$class_netmask = $self->new([255, 255, 255, 0]);
	$class_id_mask = $self->new([224, 0, 0, 0]);
    } elsif ($$address[0] < 240) {
	$class = "D";
	$class_netmask = $self->new([240, 0, 0, 0]);	# is this right???
	$class_id_mask = $self->new([240, 0, 0, 0]);
    } else {
	$class = "E";
	$class_netmask = $self->new([255, 0, 0, 0]);	# is this right???
	$class_id_mask = $self->new([240, 0, 0, 0]);
    }
    return ($class, $class_netmask, $class_id_mask);
}



###############################################################################
##
## MAIN Package
##
###############################################################################

package main;
use strict;

#
# display_bit_breakout()
#	Show the breakout of the bits in the resulting address.
#
sub display_bit_breakout() {
    my $class         = shift;
    my $class_id_mask = shift;
    my $class_netmask = shift;
    my $netmask       = shift;
    my $ip            = shift;

    #
    # Isolate the masks.
    #
    my $class_mask  = $class_netmask->and($class_id_mask->not());
    my $subnet_mask = $netmask->and($class_netmask->not());
    my $host_mask   = $netmask->not();

    printf("          | | | | | | | |   | | | | | | | |   " .
    	             "| | | | | | | |   | | | | | | | |\n");
    printf("Class %s: %s\n", $class,   $ip->bitVector($class_id_mask));
    printf("Network: %s\n",            $ip->bitVector($class_mask));
    printf("Subnet:  %s\n",            $ip->bitVector($subnet_mask));
    printf("Host:    %s\n",            $ip->bitVector($host_mask));
    printf("          | | | | | | | |   | | | | | | | |   " .
    	             "| | | | | | | |   | | | | | | | |\n");
}

#
# display_example_addresses()
#	Show the first, last and broadcast host addresses
#	for the given subnet.
#
sub display_example_addresses() {
    my $ip            = shift;
    my $old_netmask   = shift;
    my $new_netmask   = shift;
    my $subnet_number = shift;

    my $host;
    my $host_bits = 32 - $new_netmask->countBits();
    my $subnet = ($ip->overlayBits($new_netmask->and($old_netmask->not()),
    		    $subnet_number))->overlayBits($new_netmask->not(), 0);
    my $host_mask = $new_netmask->not();

    printf("\n");
    printf("Subnet: %s\n", $subnet->decimal());

    $host = $subnet->overlayBits($host_mask, 1);
    printf("  First host:   %s\n", $host->decimal());

    if ($host_bits > 2) {
	$host = $subnet->overlayBits($host_mask, 2);
	printf("  Second host:  %s\n", $host->decimal());

	$host = $subnet->overlayBits($host_mask, 3);
	printf("  Third host:   %s\n", $host->decimal());

	printf("  ...\n");
    }

    $host = $subnet->overlayBits($host_mask, (1 << $host_bits) - 2);
    printf("  Last host:    %s\n", $host->decimal());

    $host = $subnet->overlayBits($host_mask, (1 << $host_bits) - 1);
    printf("  Broadcast:    %s\n", $host->decimal());
}

#
# format_subnet_breakout()
#	Given number of available host bits and number of bits
#	to give to the subnet mask, format the number of subnets
#	and number of hosts per subnet.
#
sub format_subnet_breakout() {
    my $host_bits   = shift;
    my $subnet_bits = shift;

    my $subnets = 1 << $subnet_bits;
    my $hosts   = (1 << ($host_bits - $subnet_bits)) - 2;
    my $alert   = "";

    #
    # If the number of hosts is less than 2, then add the
    # zero and broadcast addresses back, but flag the number
    # with a star so it's obvious something is odd with this
    # one.
    #
    if ($hosts < 2) {
	$hosts += 2;
	$alert = "*";
    }

    return sprintf("%10d subnet%s with %10d%s host%s per subnet",
    	$subnets, ($subnets != 1) ? "s" : " ",
	$hosts, $alert, ($hosts != 1) ? "s" : " ");
}


##
## Main
##

my $progname;
$progname = $0;
$progname =~ s@.*/@@;


printf("\n");
printf("This program helps to explain IPv4 subnet masks and can\n");
printf("generate new subnet masks to meet given requirements.\n");

printf("\n");
printf("Start by entering the IP address of the network or any\n");
printf("host on the network that you want to use.  If you want a\n");
printf("non-routable network, you can use one of the special class\n");
printf("A, B or C private networks:\n\n");
printf("    class A: 10\n");
printf("    class B: 172.16    .. 172.31\n");
printf("    class C: 192.168.0 .. 192.168.255\n\n");
printf("The address can be entered as decimal numbers separated by\n");
printf("dots or spaces as above, or hexadecimal as in 0xC0A80000.\n\n");
my $entry;
my $ip;
for (;;) {
    printf("Enter IP: ");
    if (!($entry = <>)) {
	exit 1;
    }
    chop($entry);
    if (!($ip = IPV4Address->scan($entry))) {
	printf ("Malformed IP: ${entry}\n\n");
	next;
    }
    last;
}

#
# Classify the Network
#
my $class;
my $class_netmask;
my $class_id_mask;
($class, $class_netmask, $class_id_mask) = $ip->classifyNetwork();

#
# Report the network class and any special notes about the address.
#
printf("\n");
printf("%s is a ", $ip->decimal());
if ($class eq "A") {
    if ($ip->byte(0) == 0) {
	printf("class A reserved `zero network' address.  Note that\n");
	printf("this should not be used for general-purpose networking.\n");

    } elsif ($ip->byte(0) == 127) {
	printf("loopback address.\n");

    } else {
	printf("class A address.\n");
    }

} elsif ($class eq "B" || $class eq "C") {
    printf("class %s address.\n", $class);

} elsif ($class eq "D") {
    printf("class D (MULTICAST) address.  Note that the\n");
    printf("program may still be useful for explaining and generating\n");
    printf("subnets for this network and will continue on.  But keep in\n");
    printf("mind that when the word `host' is used below, it's not\n");
    printf("really a host.\n");

} else {	# class E
    if ($ip->byte(0) == 255) {
	printf("limited broadcast address.\n");

    } else {
	printf("class E (experimental) address.  This should\n");
	printf("not be used for general-purpose networking.\n");
    }
}


#
# Get the initial netmask.
#
printf("\n\n");
printf("If you already have a subnet mask that you want an explanation\n");
printf("of, or if you want the program to generate subnets within an\n");
printf("existing subnet, enter the netmask here.  If you don't want\n");
printf("either of these, hit return to accept the default mask for\n");
printf("the class of the given network.\n\n");

my $netmask;
for (;;) {
    printf("Enter netmask: [%s] ", $class_netmask->decimal());
    if (!($entry = <>)) {
	exit 1;
    }
    chop($entry);
    $entry =~ s/\s//g;
    if ($entry eq "") {
	$netmask = $class_netmask;

    } elsif (!($netmask = IPV4Address->scan($entry))) {
	printf ("Malformed netmask: ${entry}\n\n");
	next;
    }
    if (((($netmask->not())->and($class_netmask))->countBits()) != 0) {
	printf("Invalid netmask for class %s network!  Try again.\n\n",
	    $class);
	next;
    }
    last;
}

#
# Calculate the number of bits in the address available for
# subnet address and host address.
#
my $available_host_bits = 32 - $netmask->countBits();

#
# If there are at least two available host bits, then we have enough
# room to subnet and still have hosts addresses, a zero address and a
# broadcast address.  In this case, display a subnet action menu.  If
# there are fewer than two host bits, however, then there isn't enough
# room to subnet the address -- just explain what we have instead.
#
$entry = 0;					# default
if ($available_host_bits >= 2) {
    for (;;) {
	printf("\n");
	printf("Choose from the list:\n");
	printf("\n");
	printf(" 0: just explain the address and mask given above\n");

	my $i;
	for ($i = 0; $available_host_bits - $i >= 2; ++$i) {
	    printf("%2d: generate a mask for %s\n", $i + 1,
		&format_subnet_breakout($available_host_bits, $i));
	}
	printf("\nEnter choice [0]: ");
	if (!($entry = <>)) {
	    exit 1;
	}
	if ($entry < 0 || $entry > $i) {
	    printf ("Invalid entry!\n\n");
	    next;
	}
	last;
    }
}

#
# If we're explaining, then let old_netmask be the class
# netmask and let new_netmask be the given netmask.  If
# we sub-netted, however, then let old netmask be the
# beginning netmask and new_netmask be the generated
# mask.  This affects the way the example addresses are
# printed below.  When explaining an existing subnet mask,
# we show example networks within the existing mask.  When
# sub-netting, however, we only show example addresses within
# the space we just created.
#
my ($old_netmask, $new_netmask);
my ($host_bits, $subnet_bits);
if ($entry == 0) {
    $old_netmask = $class_netmask;
    $new_netmask = $netmask;
    $host_bits = 32 - $class_netmask->countBits();
} else {
    $old_netmask = $netmask;
    $new_netmask = $netmask->fillBits($entry - 1);
    $host_bits = $available_host_bits;
}
$subnet_bits = $new_netmask->countBits() - $old_netmask->countBits();

#
# Display the new submask.
#
printf("\n\n");
printf("Subnet mask is: %s\n", $new_netmask->decimal());

#
# Show how the bits break out between network, subnet and host.
#
printf("\n");
printf("The IP address is divided into network, subnet and host bits ");
printf("as illustrated:\n\n");
&display_bit_breakout($class, $class_id_mask,
    $class_netmask, $new_netmask, $ip);

#
# Summarize the properties of this mask.
#
printf("\n\n");
my $remove_extra_spaces = "This mask provides " .
    &format_subnet_breakout($host_bits, $subnet_bits);
$remove_extra_spaces =~ s/  +/ /g;
printf("%s.\n", $remove_extra_spaces);

#
# Special-case the masks that have fewer than 2 host bits.
#
if ($host_bits - $subnet_bits == 0) {
    printf("\n");
    printf("* This mask doesn't provide any host bits.  It's probably\n");
    printf("  a PPP mask where there is only one possible destination\n");
    printf("  address, no broadcast, and no `zero' address.\n");
    printf("\n");
    printf("No examples will be shown for this mask.\n");
    printf("\n");
    exit 0;

}
if ($host_bits - $subnet_bits == 1) {
    printf("\n");
    printf("* This mask only provides one host bit.  With a `zero'\n");
    printf("  address and `broadcast' taken out there is no room left\n");
    printf("  to create host addresses on this network.\n");
    printf("\n");
    printf("No examples will be shown for this mask.\n");
    printf("\n");
    exit 0;
}

#
# Show example addresses for the first two and last subnets.
#
printf("Here are some example addresses:\n");
&display_example_addresses($ip, $old_netmask, $new_netmask, 0);
if ($subnet_bits > 0) {
    &display_example_addresses($ip, $old_netmask, $new_netmask, 1);
    if ($subnet_bits > 1) {
	&display_example_addresses($ip, $old_netmask, $new_netmask, 2);
	&display_example_addresses($ip, $old_netmask, $new_netmask, 3);
	if ($subnet_bits > 2) {
	    printf("\n...\n");
	    &display_example_addresses($ip, $old_netmask, $new_netmask,
		(1 << $subnet_bits) - 1);
	}
    }
}

printf("\n");
exit 0;


=head1 NAME

netmask -- explain IPv4 subnet masks

=head1 DESCRIPTION

B<Netmask> is an interactive program that explains IPv4 addresses and
netmasks, and creates subnet masks given the number of needed networks
and/or hosts.  It's intended both as a program for teaching about IPv4
netmasks and also as a useful tool when setting up networks.  B<Netmask>
does not take any command-line options or arguments.

When generating new subnet masks, B<netmask> always generates I<sensible>
masks, i.e. the subnet part of the address is a single range of bits left
justified at the top of he host part of the address.  It can, however,
explain obfuscated masks such as 255.255.85.85 where the subnet bits are
neither contiguous nor left-justified.

=head1 AUTHOR

Scott Guthridge <scott_guthridge@ieee.org>

=pod OSNAMES

any

=pod SCRIPT CATEGORIES

Educational/ComputerScience
Networking

=cut
