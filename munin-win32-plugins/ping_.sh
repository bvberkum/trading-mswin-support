#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

. /cygdrive/c/munin-profile.sh
scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

basename=ping_
one_arg_from_name "$(basename $0 .sh)"
id=$(printf "$arg1" | tr -c 'A-Za-z0-9_-' '_')

case "$1" in

  name ) printf ${basename}${arg1} ;;

  config )
      echo "graph_title Ping times to $arg1"
      echo "graph_category network"
      echo "graph_info "
      echo "graph_args --base 1000"
      echo "graph_vlabel ms"

      echo "ping_$id.label $arg1"
      echo .
    ;;

  "" )
      eval $(ping -n 1 $arg1 | grep Reply | cut -d ':' -f 2 | tr '<' '=')
      echo "ping_$id.value $(echo $time | tr -dc '0-9')"
      echo .
    ;;

  * ) 
      echo "Illegal munin plugin command '$1'" >&2
      exit 1
    ;;

esac
