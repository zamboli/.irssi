use Irssi;
use strict;
use Time::Local;
use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
    authors     => 'zamboli',
    name        => 'PizzaGen 9000',
    contact	=> '',
    description => 'pizza generator',
    license     => 'Public Domain',
    changed	=> 'HAHAHA'
);

use Inline Python => <<'END_PYTHON';
def pizza():
    import random
    
    def random_line(afile):
        line = next(afile)
        for num, aline in enumerate(afile):
            if random.randrange(num + 2): continue
            line = aline
        return line

    noun_file = open('/Users/greg/nouns.txt', 'r')
    pizza = "pizza %s" % str(random_line(noun_file)).rstrip()
    noun_file.close()
    return pizza

END_PYTHON

    
my $start_time = time();
Irssi::signal_add 'message public', 'sig_message_public';

sub sig_message_public {
    my ($server, $msg, $nick, $nick_addr, $target) = @_;
    if ($target =~ m/#(?:macintosh|chanB)/ && (time() > $start_time + 30000)) { 
        # only operate in these channels
	my $pizza = pizza();
	$server->command("msg $target $pizza");
        # if ($msg =~ m/hello/i);
    }
}
