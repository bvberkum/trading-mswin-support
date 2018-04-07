#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

basename=mt4_trades_

account_nr_from_name "$(basename $0 .sh)"
get_raw_port

case "$1" in

  name ) printf ${basename}${account_nr} ;;

  ticks )
      test -n "$2" || set -- "$1" "$markets"
      raw_port=$port get_raw_data $@
    ;;

  config )
      echo "graph_title $company $account_nr trades PL $trade_mode"
      echo "graph_category finance"
      echo "graph_info "
      echo "graph_args --base 1000 --units-exponent 0"
      echo "graph_vlabel x"
    
      get_raw_data orders | while read ticket date time d e f g h i j fees swap profit comment
      do
        test "$e" = "stop" && continue
        ticket=$(echo "$ticket" | cut -c2-)
        echo "${basename}$ticket.label $ticket $d $e $f"
      done
      echo .
    ;;

  "" )
      get_raw_data orders | while read ticket date time d e f g h i j fees swap profit comment
      do
        test "$e" = "stop" && continue
        ticket=$(echo "$ticket" | cut -c2-)
        echo "${basename}$ticket.value $(echo "$fees + $swap + $profit" | bc)"
      done
      echo .
    ;;

  * ) 
      echo "Illegal munin plugin command '$1'" >&2
      exit 1
    ;;

esac
