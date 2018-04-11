#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

. /cygdrive/c/munin-profile.sh
scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

basename=mt4_markets_spread_
name=${basename}

case "$(basename $0 .sh)" in ${basename}[0-9]* )

    name="$(basename $0 .sh)"
    account_nr_from_name "$name"
    get_raw_port
    port=$raw_port

  ;; esac

#reset_raw_data ticks

case "$1" in

  name ) printf ${name} ;;

  ticks )
      test -n "$2" || set -- "$1" "$markets"
      raw_port=$port get_raw_data $@
    ;;

  info )
      raw_port=$port get_raw_data $@
    ;;

  config )
      raw_port=$port eval_query info || echo "No info for $port" >&2

      echo "graph_title Exchange spreads ($company $trade_mode)"
      echo "graph_category finance"
      echo "graph_info "
      echo "graph_args --base 1000"
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
