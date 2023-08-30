#! /usr/bin/env bash

version="1.0"

PREFIX=${PREFIX:-"bak-${version}"}
binDir="$PREFIX/usr/bin"
confDir="$PREFIX/etc/bak"
unitDir="$PREFIX/etc/systemd/system"
shareDir="$PREFIX/usr/share/bak"

install -Dm0644 bak-hostname.timer "${unitDir}/bak-hostname.timer"
install -Dm0644 bak@.service "${unitDir}/bak@.service"
install -Dm0754 bak-ex.sh "${confDir}/bak-ex.sh"
install -Dm0644 bak-ex.filter "${confDir}/bak-ex.filter"
install -Dm0754 bak-log.sh "${binDir}/bak-log.sh"
install -Dm0754 rsync-errors.sh "${binDir}/rsync-errors.sh"
install -Dm0644 "LICENSE" "${shareDir}/doc/LICENSE"
install -Dm0644 "README.md" "${shareDir}/doc/README.md"
