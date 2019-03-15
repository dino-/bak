#! /bin/bash

# Make sure you comment this out to actually perform backups
dryRun=--dry-run


# Source and dest directories for backups, these are sent as-is to rsync

# Pay attention to the trailing slash on src. Trailing slash means DO NOT
# create the src directory on dest. Usually you want this.
src=/
dest=user@domain:/var/local/backup/system


# It's handy to back up the list of installed packages on the system. These
# commands will generate that list right now before backup starts. Leave one of
# them uncommented.

# for Arch Linux
pkgListCmd="pacman -Qqe | grep -Fvx \"\$(pacman -Qqm)\" > /var/lib/pacman/installed-packages"

# for Debian
# pkgListCmd="dpkg --get-selections > /var/lib/dpkg-sel-backup"


# How long to wait for the backup to finish before failing
# see man 1 timeout, values like 37s, 10m, 1h and 2d
timeoutDuration=2h


# Assembling the command to perform the backup and assigning it to a variable
backupCmd="rsync --archive --verbose --delete --delete-excluded --filter '. /etc/bak/bak-system.filter' $dryRun $src $dest 2>&1"


# A simple function for logging messages with a timestamp
log () {
   echo "$(date +"%F %T")> $1"
}


# The backup procedure starts here

log "Backup started"

log "Executing command: $pkgListCmd"
eval $pkgListCmd

log "Executing command: $backupCmd"
timeout $timeoutDuration sh -c "$backupCmd"
exitCode=$?

log "Backup finished"

exit $exitCode
