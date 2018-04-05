#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

basename=mt4_markets_spread_
. ./env.sh
scriptname=./$(basename $0)
. ./lib.sh

case "$1" in

  name ) printf ${basename}${account_nr} ;;

  ticks )
      test -n "$2" || set -- "$1" "$markets"
      raw_port=$port get_raw_data $@
    ;;

  config )
      echo "graph_title Exchange spreads"
      echo "graph_category finance"
      echo "graph_info "
      echo "graph_args --base 1000 --units-exponent 0"
      echo "graph_vlabel x"
    
      for market in $markets_3digits $markets_5digits
      do
        echo ${basename}${market}.label $market Spread
      done
      echo .
    ;;

  "" )
      account_nr=3digits raw_port=$port get_raw_data ticks $markets_3digits | while read tick_data
      do
        eval $tick_data
        echo ${basename}${symbol}.value $(echo "scale=5; ( $ask - $bid ) / 100" | bc)
      done
      account_nr=5digits raw_port=$port get_raw_data ticks $markets_5digits | while read tick_data
      do
        eval $tick_data
        echo ${basename}${symbol}.value $(echo "$ask - $bid" | bc)
      done
      echo .
    ;;

  * ) 
      echo "Illegal munin plugin command '$1'" >&2
      exit 1
    ;;

esac
