#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

basename=mt4_markets_ticks_

case "$1" in

  name ) printf ${basename}${account_nr} ;;

  ticks )
      test -n "$2" || set -- "$1" "$markets"
      raw_port=$port get_raw_data $@
    ;;

  config )
      echo "graph_title Exchange sell price"
      echo "graph_category finance"
      echo "graph_info "
      echo "graph_args --base 1000 --units-exponent 0"
      echo "graph_vlabel x"
    
      for market in $markets
      do
        echo ${basename}${market}_sell.label $market Bid/Sell price
      done
      echo .
    ;;

  "" )
      account_nr=3digits
      raw_port=$port get_raw_data ticks $markets_3digits | while read tick_data
      do
        eval $tick_data
        echo ${basename}${symbol}_sell.value $( echo "scale=5; $bid / 100.0" | bc )
      done
      account_nr=5digits
      raw_port=$port get_raw_data ticks $markets_5digits | while read tick_data
      do
        eval $tick_data
        echo ${basename}${symbol}_sell.value $bid
      done
      echo .
    ;;

  * ) 
      echo "Illegal munin plugin command '$1'" >&2
      exit 1
    ;;

esac
