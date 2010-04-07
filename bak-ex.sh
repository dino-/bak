#! /bin/bash

dryRun=--dry-run

src=/
dest=user@domain:/var/local/backup/system


log () {
   echo "$(date +"%F %T")> $1"
}


command="rsync --archive --verbose --delete --delete-excluded --filter '. /etc/bak/bak-system.filter' $dryRun $src $dest 2>&1"

log "Backup started"
log "$command"
eval $command
log "Done"
