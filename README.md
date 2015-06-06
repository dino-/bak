# bak


## Synopsis

Script for automating nightly machine backups using rsync


## Description

I do nightly backups with rsync. Over time a simple shell script wrapper plus rsync filter file has emerged from this effort. This project exists to share that work. I hope it's useful.


## Installing

Place a copy of the script and filter file somewhere important like:

    /etc/bak/bak-system.sh
    /etc/bak/bak-system.filter

Make sure the script is executable.

In the script, modify the `src` and `dest` variables and possibly command switches to reflect your backup needs. Specify the proper path to the filter file if necessary.

DON'T FORGET to comment out the `--dry-run` switch assignment once you think it's ready!

It might be nice to name these files and things `bak-YOURMACHINENAME.sh` etc. As well as the log file if you're logging.

Put something like this in your root user's crontab:

    30 02 * * * sh -c '/etc/bak/bak-system.sh > /var/log/bak-system.log' || echo "ERROR exit code $?"

Perhaps get logrotate involved to keep the log from getting out of control. A file like `/etc/logrotate.d/bak` containing:

    /var/log/bak-system.log {
       rotate 7
       daily
       compress
       delaycompress
       missingok
       notifempty
    }


## Getting source

Get the source with darcs:

    $ darcs get http://hub.darcs.net/dino/bak

Or [browse the source](http://hub.darcs.net/dino/bak)


## Contact

Dino Morelli <[dino@ui3.info](mailto:dino@ui3.info)>
