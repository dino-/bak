#! /bin/bash

# Default to the hostname of this machine. Sometimes there's an additional backup, example:
#   $ bak-log.sh bak@ext.service
targetUnit=${1:-bak@$(hostname).service}

bakJournalCmd="journalctl --unit ${targetUnit} --since today"

{
  $bakJournalCmd | rsync-errors.sh
  echo "End of errors report"
  echo
  # Important to pipe to our own pager here or the above output will be hidden
  $bakJournalCmd
} | less
