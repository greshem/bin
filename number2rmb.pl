#!/usr/bin/perl    
    use Lingua::ZH::Numbers::Currency 'big5';
    Lingua::ZH::Numbers::Currency->charset('gb');
    my $shuzi = Lingua::ZH::Numbers::Currency->new( $ARGV[0] );
    print $shuzi->get_string."\n";

    #my $lingyige_shuzi = Lingua::ZH::Numbers::Currency->new;
    #$lingyige_shuzi->parse( 7340 );
    #$chinese_string = $lingyige_shuzi->get_string;

    # Function style
    #print currency_to_zh( 345 );	# automatically exported

    # Change output format


