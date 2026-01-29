# bak

## !!!!! ATTENTION !!!!!

This project has been permanently moved to Codeberg
([bak](https://codeberg.org/dinofp/bak)) and is no longer actively
maintained on Github. Do not use the Issues system on Github to report to us.
Don't bother forking or getting source from here as it will not be updated.

Microsoft is not a friend of open-source and we do ourselves a disservice
giving them this impressive power over our work.

Never forget 2020 when Github (a Microsoft product) removed the popular
open-source `youtube-dl` project, sparking enormous controversy. The issue is
not that pushback eventually prompted reinstatement - Github can and will act
like this against us at any time.

## !!!!! ATTENTION !!!!!

## Synopsis

Script for automating nightly machine backups using rsync (bash)


## Description

I do nightly backups with rsync. Over time a simple shell script wrapper plus
rsync filter file has emerged from this effort. This project exists to share
that work. I hope it's useful.


## Installing

### With systemd

Install files

You can install files with the `install.sh` script or the commands below but I
recommend against it. Try using a package for your distro. We provide packaging
for both Debian-based (.deb file) and Arch Linux (.pkg.tar.zst)

    # install -Dm0644 bak-hostname.timer "/etc/systemd/system/bak-hostname.timer"
    # install -Dm0644 bak@.service "/etc/systemd/system/bak@.service"
    # install -Dm0754 bak-ex.sh "/etc/bak/bak-ex.sh"
    # install -Dm0644 bak-ex.filter "/etc/bak/bak-ex.filter"
    # install -Dm0754 bak-log.sh "/usr/local/bin/bak-log.sh"
    # install -Dm0754 rsync-errors.sh "/usr/local/bin/rsync-errors.sh"

- Set the run time in `bak-hostname.timer`
- Set up optional failure messaging in `bak@.service`

### Without systemd

If you're not on a system with systemd, these techniques can be used to start
this service and manage the logs.

And you won't want to install the systemd unit files above into /etc/systemd

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

What are the issues?

- Each bak-HOSTNAME.sh script is a one-off with hand-made adjustments for the specific machine (or whatever backup it is). I'd like to see it use a config file so the static code can be left alone.
- Parsing and validating a config file with bash sounds like a bad idea
- In fact, using a real industrial language (like Haskell) would let us handle things like the `timeout` procedure with threads, fwiw
- Utility binaries like this shouldn't be located in `/etc/`
- In fact, this software should have real installation and packaging for at least Debian and Arch
- There may be too many programs now what with the other two (bak-log.sh, rsync-errors.sh). Can/should this all be rolled up into one tool to perform backups and report on the results from logging?
- Instead of hand picking the method of writing a currently-installed package list for the distro, code should determine the distro and perform the appropriate command
- The package list should explain that it was made by this software, especially because it sits in a directory below `/var/lib`, which isn't clearly owned by anyone other than root.

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

Eventual installation shape?

    /etc/bak/
      bak-HOSTNAME.filter   # Used by bak-HOSTNAME.sh
    /usr/bin/
      bak-log.sh
      rsync-errors.sh
    /usr/lib/systemd/system/
      bak-hostname.timer
      bak@.service
    /usr/share/bak/
      bin/bak-ex.sh         # Copied to /usr/local/bin/bak-HOSTNAME.sh
      bak-ex.filter         # Copied to /etc/bak/bak-HOSTNAME.filter


Requires `rsync` to be installed on the system.

Also, be mindful of the timeout part in the sh script.

Make installers for this for both Arch Linux and Debian-based.

`rsync-errors.sh`:

- Why no args case?
- Replace `function` with `f () {}` style
- Use `warn` and `die` instead of `echo` and `exit`

Real args and usage for `bak-log.sh`

These settings will try to start between 03:00 and 04:50 and seem reasonable for about a half-dozen backups that take much less than 10 minutes each to perform.

    [Timer]
    OnCalendar=*-*-* 03:00:00
    RandomizedDelaySec=6600
    Persistent=true

## Contact

Dino Morelli <mailto:dino@ui3.info>
