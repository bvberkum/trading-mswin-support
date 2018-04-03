#!/usr/bin/sh
set -e

scriptdir=C:/munin/
scriptname=./mt4_profit.sh

cd "$scriptdir"

. ./env.sh
. ./lib.sh

case "$1" in

  name ) printf mt4_profit ;;

  stats | info )
      test -n "$port" || exit 102
      echo $1 sh | 
        c:/Users/IEUser/Downloads/redis-windows-x86-2.8.2400-xp/redis-cli.exe -p $port
    ;;

  config )

      echo "graph_title Profit/Loss"
      echo "graph_category finance"
      echo "graph_info The floating profit/losses"
      echo "graph_args --base 1000"
      echo "graph_vlabel EUR"

      for acc in $accounts
      do
        account_nr=$acc get_raw_port
        eval $(port=$raw_port $scriptname info)
        echo "mt4_profit_${acc}.label $account"
      done
      echo "."
    ;;

  * )
      for acc in $accounts
      do
        account_nr=$acc get_raw_port
        eval $(port=$raw_port $scriptname stats)
        echo "mt4_profit_${acc}.value $profit"
      done
      echo "."
    ;;

esac
