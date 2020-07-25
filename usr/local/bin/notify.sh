#! /bin/sh

# Script for sending email to the root user to be called by the notify@.service
# unit.
#
# For this to work, root will need to be mapped to a real email address in
# /etc/aliases and you will need a functioning sendmail-like installed.

unitName="$1"
host=$(hostname)
log=$(journalctl -u "$unitName" | tail)

sendmail -t <<MESSAGE
From: root@${host}
To: root
Subject: Service $unitName on $host has failed

log excerpt:

$log

See more with 'journalctl -u $unitName'
MESSAGE
