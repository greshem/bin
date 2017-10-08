#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
labrea.x86_64 : Tarpit (slow to a crawl) worms and port scanners
aide.x86_64 : Intrusion detection environment
bro.i686 : Open-source, Unix-based Network Intrusion Detection System
bro.x86_64 : Open-source, Unix-based Network Intrusion Detection System
kismet.x86_64 : WLAN detector, sniffer and IDS
kismet-plugins.x86_64 : Plugins for kismet
libnids.i686 : Implementation of an E-component of Network Intrusion Detection System
libnids.x86_64 : Implementation of an E-component of Network Intrusion Detection System
mod_security.x86_64 : Security module for the Apache HTTP Server
nebula.x86_64 : Intrusion signature generator
psad.x86_64 : Port Scan Attack Detector (psad) watches for suspect traffic
sectool-gui.x86_64 : GUI for sectool - security audit system and intrusion detection system
sectool.x86_64 : A security audit system and intrusion detection system
suricata.i686 : Intrusion Detection System
suricata.x86_64 : Intrusion Detection System
tripwire.x86_64 : IDS (Intrusion Detection System)


