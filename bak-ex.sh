#! /bin/bash

# Make sure you comment this to actually perform backups
dryRun=--dry-run

src=/
dest=user@domain:/var/local/backup/system

# How long to wait for the backup to finish before failing
# see man timeout (1), values like 37s, 10m, 1h and 2d
timeoutDuration=2h


log () {
   echo "$(date +"%F %T")> $1"
}


command="rsync --archive --verbose --delete --delete-excluded --filter '. /etc/bak/bak-system.filter' $dryRun $src $dest 2>&1"

log "Backup started"
log "$command"
timeout $timeoutDuration sh -c "$command"
exitCode=$?
log "Done"
exit $exitCode
