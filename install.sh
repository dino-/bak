#! /bin/bash

version="1.0"

ROOTDIR=${ROOTDIR:-"bak-${version}"}
PREFIX=${PREFIX:-"$ROOTDIR/usr/local"}
# unitDir="$PREFIX/lib/systemd/system"
unitDir="$ROOTDIR/etc/systemd/system"
shareDir="$PREFIX/share/bak"

install -Dm0644 bak-hostname.timer "$unitDir/bak-hostname.timer"
install -Dm0644 bak@.service "$unitDir/bak@.service"
install -Dm0754 bak-ex.sh "$PREFIX/bin/bak-$(hostname).sh"
install -Dm0644 bak-ex.filter "$ROOTDIR/var/lib/bak/bak-$(hostname).filter"
install -Dm0754 bak-log.sh "$PREFIX/bin/bak-log.sh"
install -Dm0754 rsync-errors.sh "$PREFIX/bin/rsync-errors.sh"
install -Dm0644 "LICENSE" "${shareDir}/doc/LICENSE"
install -Dm0644 "README.md" "${shareDir}/doc/README.md"

# install -Dm0755 failmsg.sh "$PREFIX/bin/failmsg.sh"
# install -Dm0644 "failmsg@.service" "$unitDir/failmsg@.service"
# install -Dm0644 service.d_toplevel-override.conf "$unitDir/service.d/toplevel-override.conf"
# install -Dm0644 failmsg@.service.d_toplevel-override.conf "$unitDir/failmsg@.service.d/toplevel-override.conf"
# install -Dm0644 "LICENSE" "${shareDir}/doc/LICENSE"
# install -Dm0644 "README.md" "${shareDir}/doc/README.md"
# install -Dm0644 "always-fails.service" "${shareDir}/always-fails.service"
