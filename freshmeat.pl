#!/usr/bin/perl
use WWW::Freshmeat;

    my $fm = new WWW::Freshmeat;

    my $project = $fm->retrieve_project($ARGV[0]);

    foreach ( @projects, $project ) {
        print $_->name(), "\n";
        print $_->url(), "\n";
        print $_->version(), "\n";
        print $_->description(), "\n";
    }

