use Irssi 20020217; # Irssi 0.8.0
$VERSION = "1.1";
%IRSSI = (
    authors     =>  "Matti 'qvr' Hiljanen",
    contact     =>  "matti\@hiljanen.com",
    name        =>  "wkb",
    description =>  "A simple word kickbanner",
    license     =>  "Public Domain",
    url         =>  "http://matin.maapallo.org/softa/irssi",
);

use strict;
use Irssi;

my @channels =
  qw(#foo2 #macintosh);

my @words =
  qw(bad_word lol);

my @gods =
  qw(qvr other_gods);
  
sub sig_public {
    my ($server, $msg, $nick, $address, $target) = @_;

    return if $nick eq $server->{nick};

    $msg =~ s/[\000-\037]//g;
    my $rmsg = $msg;
    $msg = lc($msg);

    # bad word
    my $nono = 0;
    foreach (@words) { $nono = 1 if $msg =~ /$_/ }
    return unless $nono;
       
    # channel? 
    my $react = 0;
    foreach (@channels) { $react = 1 if lc($target) eq lc($_) }
    return unless $react;

    # god-like person?
    my $jumala = 0;
    foreach (@gods) { $jumala = 1 if lc($nick) =~ /$_/ }
    return if $jumala;
    
    # voiced or op'd?
    return if $server->channel_find($target)->nick_find($nick)->{op} || $server->channel_find($target)->nick_find($nick)->{voice};

    $server->command("kickban $target $nick no lol, plz");
    
    Irssi::print("Word kick: Kicking $nick from $target. (He said $rmsg)");
}

Irssi::signal_add_last('message public', 'sig_public');


