# bak


## Synopsis

Script for automating nightly machine backups using rsync (bash)


## Description

I do nightly backups with rsync. Over time a simple shell script wrapper plus
rsync filter file has emerged from this effort. This project exists to share
that work. I hope it's useful.


## Installing

### With systemd

Install files

    # install -Dm0644 etc/systemd/system/bak-hostname.timer /etc/systemd/system/bak-hostname.timer
    # install -Dm0644 etc/systemd/system/bak@.service /etc/systemd/system/bak@.service
    # install -Dm0754 etc/bak/bak-system.sh /etc/bak/bak-$(hostname).sh
    # install -Dm0644 etc/bak/bak-system.filter /etc/bak/bak-$(hostname).filter

- Set the run time in `bak-hostname.timer`
- Set up optional failure messaging in `bak@.service`

### Without systemd

If you're not on a system with systemd, these techniques can be used to start
this service and manage the logs.

Put something like this in your root user's crontab:

    30 02 * * * sh -c '/etc/bak/bak-system.sh > /var/log/bak-system.log' || echo "ERROR exit code $?"

Perhaps get logrotate involved to keep the log from getting out of control. A
file like `/etc/logrotate.d/bak` containing:

    /var/log/bak-system.log {
       rotate 7
       daily
       compress
       delaycompress
       missingok
       notifempty
    }


## Post-installation

In the script, modify the `src` and `dest` variables and possibly command
switches to reflect your backup needs. Specify the proper path to the filter
file if necessary.

DON'T FORGET to comment out the `--dry-run` switch assignment once you think
it's ready!

It might be nice to name these files and things `bak-HOSTNAME.sh` etc. As well
as the log file if you're logging without systemd.


## Getting source

Get the source with git:

    $ git clone https://github.com/dino-/bak.git

Or [browse the source](https://github.com/dino-/scripts)


## 2020-07-07 development notes

Added files and documentation to invoke these backup scripts with systemd
timers and services. This is in-progress still.

Tentative file list:

    /etc/bak/   # Can these be made more generic? Some kind of conf.
      bak-system.sh
      bak-system.filter
    /etc/systemd/system/
      bak-hostname.timer
      bak@.service
    /usr/local/bin/
      bak-log.sh  # Currently in ~/bin/, uses `rsync-errors.sh`
      rsync-errors.sh  # Currently in the scripts project

Requires `rsync` to be installed on the system.

Also, be mindful of the timeout part in the sh script.

Make installers for this for both Arch Linux and Debian-based.


## Contact

Dino Morelli <mailto:dino@ui3.info>
