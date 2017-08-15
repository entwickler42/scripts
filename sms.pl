#!/usr/bin/perl -w

use strict;
use Device::Modem;

if ( @ARGV != 3 ){
	print("Usage: sms.pl [msg] [receptient] [modem]\n");
	exit 0;
}

my ($msg,$receptient,$port) = @ARGV;
my $modem = new Device::Modem( port => $port )
	or die "can't open $port !";
$modem->connect()
	or die "can't connect to $port !";
eval{
	print("Sending: $msg to $receptient trough $port\n");
	$modem->atsend("AT+CMGF=1\r\n");
	$modem->atsend("AT+CMGS=\"$receptient\"\r\n");
	$modem->atsend($msg . "\r\n\x1A");
	$modem->reset();
}; 
print $@ if $@;
$modem->disconnect();
