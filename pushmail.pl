#!perl

=head1 NAME

pushmail.pl

=head1 DESCRIPTION

An Irssi script to send you an email if you receive a hilight or privmsg.

=head1 INSTALLATION

Copy into your F<~/.irssi/scripts/> directory and load with 
C</SCRIPT LOAD pushmail.pl>.

=head2 DEPENDENCIES

=over 4

=item * None yet

=back

=cut

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
    changed     => '$Date: 2013-06-12 $'
);

=head1 SETTINGS

=over 4

=item * I<pushmail_address> 

The address, where hilights/privmsgs are send to

(Defaults to C<$ENV{USER}>)

=cut 

Irssi::settings_add_str( 'misc', $IRSSI{name} . '_address', $ENV{USER} );

=item * I<pushmail_subject> 

The subject of these mails.

(Defaults to C<hilight/privmsg received>)

=cut

Irssi::settings_add_str(
    'misc',
    $IRSSI{name} . '_subject',
    'hilight/privmsg received'
);

=item * I<pushmail_mailer> 

Full path to the mailer-program you use.

(Defaults to C</usr/bin/mail -s>)

=cut

Irssi::settings_add_str(
    'misc',
    $IRSSI{name} . '_mailer',
    '/usr/bin/mail -s'
);

=back

=cut

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
    if ( $server->{usermode_away} ) {
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
Irssi::signal_add_last( "message private", "priv_msg" );
Irssi::signal_add_last( "print text",      "hilight" );

=head1 AUTHORS

Copyright E<copy> 2013 Frank Steinborn C<E<lt>steinex@nognu.deE<gt>>
    and Benjamin Stier C<E<lt>ben@unpatched.deE<gt>>

=head1 LICENSE

"THE BEER-WARE LICENSE" (Revision 42):

<steinex@nognu.de> and <ben@unpatched.de> wrote this file. As long as you
retain this notice you can do whatever you want with this stuff. If we meet
some day, and you think this stuff is worth it, you can buy us a beer in
return.
