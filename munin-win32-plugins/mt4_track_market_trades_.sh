#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

basename=mt4_track_market_trades_

account_nr_market_from_name "$(basename $0 .sh)"
get_raw_port

case "$1" in

  name ) printf $basename${account_nr}_$market ;;

  config )
      eval_query info || echo "No info for $account_nr" >&2

      echo "graph_title $company $account_nr trades $trade_mode"
      echo "graph_category finance"
      echo "graph_info Trades in $market Market"
      echo "graph_args --base 1000 -l 0"
      echo "graph_vlabel $currency"

      query orders | grep $market | \
        while read \
          ticket open_date open_time buy_sell lots market open_price take_profit stop_loss current_price commission swap pl x
      do
          ticket=$(echo "$ticket" | cut -c2-)
          echo trade_${ticket}_pips.label Ticket ${ticket} $buy_sell
          echo trade_${ticket}_pips.type GAUGE
          echo trade_${ticket}_pips.draw LINE1
      done
      echo market_buy.label $market Buy price
      echo market_sell.label $market Sell price
      echo "."
    ;;

  "" )
      eval_query stats || echo "No stats for $account_nr" >&2

      query orders | grep $market | \
        while read \
          ticket open_date open_time buy_sell lots market open_price take_profit stop_loss current_price commission swap pl x
      do
        ticket=$(echo "$ticket" | cut -c2-)
        #echo trade_${ticket}_$buy_sell.value $(echo "$lots / ( $current_price + $pl )" | bc)
        #echo trade_${ticket}_currency.value $pl
        #echo trade_${ticket}_currency.value $(echo "$pl / 100000 * $lots" | bc)
        test "$buy_sell" = "sell" && {

          #echo trade_${ticket}_pips.value $(echo "$open_price - $current_price" | bc)
          #echo trade_${ticket}_pip_lots.value $(echo "( $open_price - $current_price ) * $lots" | bc)
          echo market_sell.value $current_price
        } || {

          #echo trade_${ticket}_pips.value $(echo "$current_price - $open_price" | bc)
          #echo trade_${ticket}_pip_lots.value $(echo "( $current_price - $open_price ) * $lots" | bc)
          echo market_buy.value $current_price
        }
      done
      echo "."
    ;;

  * ) 
      echo "Illegal munin plugin command '$1'" >&2
      exit 1
    ;;
esac
