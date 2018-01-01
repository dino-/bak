#! /bin/bash

# Make sure you comment this to actually perform backups
dryRun=--dry-run

src=/
dest=user@domain:/var/local/backup/system

# for Arch Linux
pkgListCmd="pacman -Qqe | grep -Fvx \"\$(pacman -Qqm)\" > /var/lib/pacman/installed-packages"

# for Debian
#pkgListCmd="dpkg --get-selections > /var/lib/dpkg-sel-backup"

# How long to wait for the backup to finish before failing
# see man 1 timeout, values like 37s, 10m, 1h and 2d
timeoutDuration=2h

backupCmd="rsync --archive --verbose --delete --delete-excluded --filter '. /etc/bak/bak-system.filter' $dryRun $src $dest 2>&1"


log () {
   echo "$(date +"%F %T")> $1"
}


log "Backup started"

log "Executing command: $pkgListCmd"
eval $pkgListCmd

log "Executing command: $backupCmd"
timeout $timeoutDuration sh -c "$backupCmd"
exitCode=$?

log "Done"

exit $exitCode
