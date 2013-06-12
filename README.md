# DESCRIPTION

An Irssi script to send you an email if you receive a hilight or privmsg.

# INSTALLATION

Copy into your `~/.irssi/scripts/` directory and load with 
`/SCRIPT LOAD pushmail.pl`.

## DEPENDENCIES

- None yet

# SETTINGS

- _pushmail\_address_ 

    The address, where hilights/privmsgs are send to

    (Defaults to `$ENV{USER}`)

- _pushmail\_subject_ 

    The subject of these mails.

    (Defaults to `hilight/privmsg received`)

- _pushmail\_mailer_ 

    Full path to the mailer-program you use.

    (Defaults to `/usr/bin/mail -s`)

# AUTHORS

Copyright &copy; 2013 Frank Steinborn `<steinex@nognu.de>`
    and Benjamin Stier `<ben@unpatched.de>`

# LICENSE

"THE BEER-WARE LICENSE" (Revision 42):

<steinex@nognu.de> and <ben@unpatched.de> wrote this file. As long as you
retain this notice you can do whatever you want with this stuff. If we meet
some day, and you think this stuff is worth it, you can buy us a beer in
return.
