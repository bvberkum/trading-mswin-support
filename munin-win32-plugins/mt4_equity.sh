#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

. /cygdrive/c/profile.sh
scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

case "$1" in

  name ) printf mt4_equity ;;

  stats | info )
      query $1 || echo "No $1 for $account_nr" >&2
    ;;

  config )
      echo "graph_title Account Equity"
      echo "graph_category finance"
      echo "graph_info Equity"
      echo "graph_args --base 1000 -l 0"
      echo "graph_vlabel EUR"

      for account_nr in $accounts
      do
        get_raw_port
        eval_query info || echo "No info for $account_nr" >&2
        echo "mt4_equity_${account_nr}.label $company $account $trade_mode"
      done
      echo "."
    ;;

  "" )
      for account_nr in $accounts
      do
        get_raw_port
        eval_query stats || echo "No stats for $account_nr" >&2
        echo "mt4_equity_${account_nr}.value $equity"
      done
      echo "."
    ;;

  * ) 
      echo "Illegal munin plugin command '$1'" >&2
      exit 1
    ;;

esac
