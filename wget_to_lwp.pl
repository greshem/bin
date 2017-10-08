#!/usr/bin/perl
$url=shift or die(" $0 url \n");
for(<DATA>)
{
	if($_=~/__URL__/)
	{
		$_=~s/__URL__/$url/g;
	}
	print $_;

}

__DATA__
  require LWP::UserAgent;

        my $ua = LWP::UserAgent->new;
        $ua->timeout(10);
        $ua->env_proxy;

        my $response = $ua->get('__URL__');

        if ($response->is_success) {
            print $response->decoded_content;  # or whatever
        }
        else {
            die $response->status_line;
        }


