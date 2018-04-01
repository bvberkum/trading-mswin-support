#!/usr/bin/sh
set -e

scriptdir=C:/munin/
scriptname=./mt4_profit.sh

cd "$scriptdir"

case "$1" in

  name ) printf mt4_profit ;;

  stats | info )
      echo $1 sh | 
        c:/Users/IEUser/Downloads/redis-windows-x86-2.8.2400-xp/redis-cli.exe -p 6666

    ;;

  config )
      eval $($scriptname stats)
      eval $($scriptname info)
      echo "graph_title PL"
      echo "graph_category finance"
      echo "graph_info The floating profit/losses"
      echo "graph_args --base 1000 -l -100 -u 100 "
      echo "graph_vlabel $currency"
      echo "mt4_profit_c.label $account"
      echo "."
    ;;

  * )
      eval $($scriptname stats)
      echo mt4_profit_c.value $profit
      echo "."
    ;;

esac

