#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

. /cygdrive/c/munin-profile.sh
scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh
basename=$(basename "$0" .sh)

round()
{
  echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
};

case "$1" in

  name ) printf $basename ;;

  stats | info )
      test -n "$raw_port" || exit 102
      get_raw_data $1
    ;;

  config )
      echo "graph_title Profit/Loss"
      echo "graph_category finance"
      echo "graph_info The floating profit/losses"
      echo "graph_args --base 1000 -u 10 -l -10 --rigid"
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
