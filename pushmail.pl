#!perl
use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '0.2';
%IRSSI   = (
    authors     => 'Frank Steinborn, Benjamin Stier',
    contact     => 'steinex@nognu.de, ben@unpatched.de',
    name        => 'pushmail',
    description => 'push a mail on hilight/privmsg',
    license     => 'Beerware',
    changed     => '$Date: 2013-01-31 $'
);

# Settings:
# /set pushmail_address $ENV{USER}
# /set pushmail_subject hilight/privmsg received
# /set pushmail_mailer /usr/bin/mail -s

# pushmail_address: The address, where hilights/privmsgs are send to
Irssi::settings_add_str( 'misc', $IRSSI{name} . '_address', $ENV{USER} );

# pushmail_subject: The subject of these mails
Irssi::settings_add_str(
    'misc',
    $IRSSI{name} . '_subject',
    'hilight/privmsg received'
);

# pushmail_mailer: Full path to the mailer-program you use
Irssi::settings_add_str(
    'misc',
    $IRSSI{name} . '_mailer',
    '/usr/bin/mail -s'
);

my $away;

sub catch_away {
    my $server = shift;

    if ( $server->{usermode_away} ) {
        $away = 1;
    }
    else {
        $away = 0;
    }
}

sub priv_msg {
    my ( $server, $msg, $nick, $address, $target ) = @_;
    filewrite( "<" . $nick . ">" . " " . $msg );
}

sub hilight {
    my ( $dest, $text, $stripped ) = @_;
    if ( $dest->{level} & MSGLEVEL_HILIGHT ) {
        filewrite( $dest->{target} . " " . $stripped );
    }
}

sub filewrite {
    if ( $away eq "1" ) {
        my ($text) = @_;
        my $date = `date`;
        open( FILE, ">$ENV{HOME}/.irssi/pushmail" );
        print FILE "\n" . $date . $text . "\n\n";
        close(FILE);
        my $mail
            = "cat $ENV{HOME}/.irssi/pushmail | "
            . Irssi::settings_get_str( $IRSSI{name} . '_mailer' ) . " "
            . Irssi::settings_get_str( $IRSSI{name} . '_subject' ) . " "
            . Irssi::settings_get_str( $IRSSI{name} . '_address' );
        `$mail`;
    }
}

# Catch signals
Irssi::signal_add( "away mode changed", "catch_away" );
Irssi::signal_add_last( "message private", "priv_msg" );
Irssi::signal_add_last( "print text",      "hilight" );

# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <steinex@nognu.de> and <ben@unpatched.de> wrote this file. As long as you
# retain this notice you can do whatever you want with this stuff. If we meet
# some day, and you think this stuff is worth it, you can buy us a beer in
# return
# ----------------------------------------------------------------------------
