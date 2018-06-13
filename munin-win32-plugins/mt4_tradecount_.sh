#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

. /cygdrive/c/munin-profile.sh
scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

basename=$(basename $0 .sh)

case "$1" in

  name ) printf ${basename} ;;

  config )
      echo "graph_title Number of trades"
      echo "graph_category finance"
      #echo "graph_info "
      echo "graph_args --base 1000"
      echo "graph_vlabel x"
    
      for account_nr in $accounts
      do
        echo "$basename${account_nr}.label $account_nr"
        echo "$basename${account_nr}.type GAUGE"
      done
      echo .
    ;;

  "" )
      for account_nr in $accounts
      do
        get_raw_port
        count=$(get_raw_data orders | grep -v '^\s*$' | wc -l | awk '{print $1}')
        echo "$basename${account_nr}.value $count"
      done
      echo .
    ;;

  * ) 
      echo "Illegal munin plugin command '$1'" >&2
      exit 1
    ;;

esac
