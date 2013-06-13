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

=item * Mail::Send

=back

=cut

use strict;
use warnings;
use vars qw($VERSION %IRSSI);

use POSIX;
use Mail::Send;
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

=item * I<pushmail_to_address>

The address, where hilights/privmsgs are send to

(Defaults to C<$ENV{USER}>)

=cut

Irssi::settings_add_str( 'pushmail', $IRSSI{name} . '_to_address',
    $ENV{USER} );

=item * I<pushmail_from_address>

The address, which is shown as the sender of the mail.

(Defaults to C<$ENV{USER}>)

=cut

Irssi::settings_add_str( 'pushmail', $IRSSI{name} . '_from_address',
    $ENV{USER} );

=item * I<pushmail_subject>

The subject of these mails.

(Defaults to C<hilight/privmsg received>)

=cut

Irssi::settings_add_str(
    'pushmail',
    $IRSSI{name} . '_subject',
    'hilight/privmsg received'

);

=back

=cut

my $away = 0;

# Catch away mode change
sub catch_away {
    my $server = shift;
    $away = ( $server->{usermode_away} ? 1 : 0 );
}

# Handler for private messages
sub priv_msg {
    my ( $server, $msg, $nick, $address, $target ) = @_;
    send_mail( "<" . $nick . ">" . " " . $msg );
}

# Handler for hilights
sub hilight {
    my ( $dest, $text, $stripped ) = @_;
    if ( $dest->{level} & MSGLEVEL_HILIGHT ) {
        send_mail( $dest->{target} . " " . $stripped );
    }
}

# Function to send the mail
sub send_mail {

    # Only send mail, if user is away
    return unless $away;

    my ($text) = @_;
    my $date = POSIX::strftime( "%c", localtime );
    $text = "$date\n$text";    # Prepend date to text
                               # If external mailer is set, open a handle
    my $msg = Mail::Send->new();
    $msg->to( Irssi::settings_get_str( $IRSSI{name} . '_to_address' ) );
    $msg->subject( Irssi::settings_get_str( $IRSSI{name} . '_subject' ) );
    $msg->set( 'From',
        Irssi::settings_get_str( $IRSSI{name} . '_from_address' ) );
    my $MAILER = $msg->open();
    print {$MAILER} $text;
    $MAILER->close or warn "cannot close Mail::Send: $!";
}

# Catch signals
Irssi::signal_add_last( "away mode changed", "catch_away" );
Irssi::signal_add_last( "message private",   "priv_msg" );
Irssi::signal_add_last( "print text",        "hilight" );

=head1 AUTHORS

Copyright E<copy> 2013 Frank Steinborn C<E<lt>steinex@nognu.deE<gt>>
    and Benjamin Stier C<E<lt>ben@unpatched.deE<gt>>

=head1 LICENSE

"THE BEER-WARE LICENSE" (Revision 42):

<steinex@nognu.de> and <ben@unpatched.de> wrote this file. As long as you
retain this notice you can do whatever you want with this stuff. If we meet
some day, and you think this stuff is worth it, you can buy us a beer in
return.
