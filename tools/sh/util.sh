#!/bin/sh
fnmatch() { case "$1" in $2 ) return ;; esac ; return 1 ; }
. $scriptpath/tools/sh/lib/os.lib.sh
. $scriptpath/tools/sh/lib/date.lib.sh
. $scriptpath/tools/sh/lib/mt4-server.lib.sh
. $scriptpath/tools/sh/lib/munin.lib.sh
