#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

case "$1" in

  name ) printf mt4_profit_log ;;

  stats | info )
      test -n "$raw_port" || exit 102
      get_raw_data $1
    ;;

  config )

      echo "graph_title Profit/Loss"
      echo "graph_category finance"
      echo "graph_info The floating profit/losses"
      #echo "graph_args --base 1000 --logarithmic --rigid --lower-limit '-2500' --upper-limit 100"
      echo "graph_args --base 1000 --lower-limit '-2500' --upper-limit 100"
      echo "graph_vlabel EUR"

      for account_nr in $accounts
      do
        get_raw_port
        eval_query info || echo "No info for $acc" >&2
        echo "mt4_profit_${account_nr}_log.label $account"
      done
      echo "."
    ;;

  "" )
      for account_nr in $accounts
      do
        get_raw_port
        eval_query stats || echo "No stats for $account_nr" >&2
        echo "mt4_profit_${account_nr}_log.value $profit"
      done
      echo "."
    ;;

  * ) 
      echo "Illegal munin plugin command '$1'" >&2
      exit 1
    ;;
esac
