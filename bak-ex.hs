#! /usr/bin/env runhaskell

{- Script for executing rsync backup
   Dino Morelli <dino@ui3.info>  2009-03-12

   http://ui3.info/d/proj/bak.html
   Installation instructions at end of this script
-}

import Control.Monad ( liftM )
import Data.List ( intercalate )
import System.IO ( BufferMode ( NoBuffering )
                 , hSetBuffering, stdout, stderr )
import System.Locale ( defaultTimeLocale )
import System.Process ( runCommand, waitForProcess )
import System.Time ( formatCalendarTime
                   , getClockTime, toCalendarTime )
import Text.Printf ( printf )



-- Switches for rsync

switches = intercalate " "
   [ "--archive"  -- -a
   , "--verbose"  -- -v
--   , "--relative" -- -R
   , "--delete"
   , "--delete-excluded"
   , "--filter '. /abs/path/to/file.filter'"
   , "--dry-run"  -- -n
   ]


-- Source and destination paths

-- Trailing / on src dir means DON'T include the last dir from src
src = "/top/level/src/dir"

--dest = "/locally/mounted/dest/dir"
dest = "user@host.blah:/remote/dest/dir"


-- This one redirects all errors to stdout, but otherwise lets the
-- invoker deal with logging it or not
output = "2>&1"

-- Some other possible uses of this:
--output = "2>&1 | tee -a /var/tmp/bak-foo.log"
--output = "2>&1 >> /var/log/bak-foo.log"


-- Logging functions

date :: IO String
date = liftM
   ( formatCalendarTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" )
   $ getClockTime >>= toCalendarTime

logMsg :: String -> IO ()
logMsg msg = do
   d <- date
   printf "%s> %s\n" d msg


-- All the work happens here

main = do
   -- No buffering, it messes with the order of output
   mapM_ (flip hSetBuffering NoBuffering) [ stdout, stderr ]

   logMsg "started"

   let command = printf "rsync %s %s %s %s"
         switches src dest output

   logMsg command

   runCommand command >>= waitForProcess

   logMsg "stopped"


{- Installation:

- Place a copy of this script somewhere important like
  /etc/bak/bak-foo.hs
  You may want to make sure it's executable.

- Modify the src, dest, etc data to reflect your backup needs.
  DON'T FORGET to turn off the --dry-run switch above once you think
  it's ready!

- Put something like this in your root user's crontab:
   30 02 * * * /etc/bak/bak-foo.hs >> /var/log/bak-foo.log

- Perhaps get logrotate involved to keep the log from getting out of
  control. A file like /etc/logrotate.d/bak containing:

   /var/log/bak-foo.log {
      rotate 7
      daily
      compress
      delaycompress
      missingok
      notifempty
   }

-}
