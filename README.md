# bak


## Synopsis

Script for automating nightly machine backups using rsync (bash)


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

Get the source with git:

    $ git clone https://github.com/dino-/bak.git

Or [browse the source](https://github.com/dino-/scripts)


## 2020-07-07 development notes

Add in files and documentation to invoke these backup scripts with systemd
timers and services.

Tentative file list:

    /etc/bak/   # Can these be made more generic? Some kind of conf.
      bak-system.sh
      bak-system.filter
    /etc/systemd/system/
      bak-hostname.timer
      bak@.service
      notify@.service
    /usr/local/bin/
      bak-log.sh  # Currently in ~/bin/, uses `rsync-errors.sh`
      notify.sh
      rsync-errors.sh  # Currently in the scripts project

This also requires configuration of a sendmail-like which is out of the scope
of this project. Mention `msmtp` and `msmtp-mta`?

Requires `rsync` to be installed on the system.

Also, be mindful of the timeout part in the sh script.

Make installers for this for both Arch Linux and Debian-based.


## Contact

Dino Morelli <mailto:dino@ui3.info>
