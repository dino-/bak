#! /bin/bash

# FIXME Parameterize this to take an optional HOST and use hostname if it's not supplied
bakJournalCmd="journalctl -u bak@$(hostname) --since today"

{
  $bakJournalCmd | rsync-errors.sh
  echo "End of errors report"
  echo
  # Important to pipe to our own pager here or the above output will be hidden
  $bakJournalCmd
} | less
