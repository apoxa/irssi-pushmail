# NAME

pushmail.pl

# DESCRIPTION

An Irssi script to send you an email if you receive a hilight or privmsg.

# INSTALLATION

Copy into your `~/.irssi/scripts/` directory and load with
`/SCRIPT LOAD pushmail.pl`.

## DEPENDENCIES

- Mail::Send

# SETTINGS

- _pushmail\_to\_address_

    The address, where hilights/privmsgs are send to

    (Defaults to `$ENV{USER}`)

- _pushmail\_from\_address_

    The address, which is shown as the sender of the mail.

    (Defaults to `$ENV{USER}`)

- _pushmail\_subject_

    The subject of these mails.

    (Defaults to `hilight/privmsg received`)

# AUTHORS

Copyright &copy; 2013 Frank Steinborn `<steinex@nognu.de>`
    and Benjamin Stier `<ben@unpatched.de>`

# LICENSE

"THE BEER-WARE LICENSE" (Revision 42):

<steinex@nognu.de> and <ben@unpatched.de> wrote this file. As long as you
retain this notice you can do whatever you want with this stuff. If we meet
some day, and you think this stuff is worth it, you can buy us a beer in
return.
