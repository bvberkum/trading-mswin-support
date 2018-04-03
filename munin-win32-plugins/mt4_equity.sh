#!/usr/bin/sh
set -e

scriptdir=C:/munin/
scriptname=./mt4_equity.sh

cd "$scriptdir"

. ./env.sh
. ./lib.sh

case "$1" in

  name ) printf mt4_equity ;;

  stats | info )
      echo $1 sh | 
        c:/Users/IEUser/Downloads/redis-windows-x86-2.8.2400-xp/redis-cli.exe \
        -p $port
    ;;

  config )
      echo "graph_title Account Equity"
      echo "graph_category finance"
      echo "graph_info Equity"
      echo "graph_args --base 1000 -l 0"
      echo "graph_vlabel EUR"

      for acc in $accounts
      do
        account_nr=$acc get_raw_port
        eval $(port=$raw_port $scriptname info)
        echo "mt4_equity_${acc}.label $account"
      done
      echo "."
    ;;

  * )
      for acc in $accounts
      do
        account_nr=$acc get_raw_port
        eval $(port=$raw_port $scriptname stats)
        echo "mt4_equity_${acc}.value $equity"
      done
      echo "."
    ;;

esac

