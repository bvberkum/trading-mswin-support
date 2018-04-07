#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

. /cygdrive/c/profile.sh
scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

case "$1" in

  name ) printf mt4_profit ;;

  stats | info )
      test -n "$raw_port" || exit 102
      get_raw_data $1
    ;;

  config )
      echo "graph_title Profit/Loss"
      echo "graph_category finance"
      echo "graph_info The floating profit/losses"
      echo "graph_args --base 1000"
      echo "graph_vlabel EUR"

      for account_nr in $accounts
      do
        get_raw_port
        eval_query info || echo "No info for $acc" >&2
        echo "mt4_profit_${account_nr}.label $company $account $trade_mode"
      done
      echo "."
    ;;

  * )
      for account_nr in $accounts
      do
        get_raw_port
        eval_query stats || echo "No stats for $account_nr" >&2
        echo "mt4_profit_${account_nr}.value $profit"
      done
      echo "."
    ;;

esac
