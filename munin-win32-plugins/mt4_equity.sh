#!/usr/bin/sh
set -e

scriptdir=C:/munin/
scriptname=./mt4_equity.sh

cd "$scriptdir"

case "$1" in

  name ) printf mt4_equity ;;

  stats | info )
      echo $1 sh | 
        c:/Users/IEUser/Downloads/redis-windows-x86-2.8.2400-xp/redis-cli.exe -p 6666

    ;;

  config )
      eval $($scriptname stats)
      eval $($scriptname info)
      echo "graph_title Account Equity"
      echo "graph_category finance"
      echo "graph_info The balance minus floating profit losses"
      echo "graph_args --base 1000 -l 0"
      echo "graph_vlabel $currency"
      echo "mt4_equity_c.label $account"
      echo "."
    ;;

  * )
      eval $($scriptname stats)
      echo "mt4_equity_c.value $equity"
      echo "."
    ;;

esac

