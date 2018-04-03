#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

. ./env.sh
. ./lib.sh

scriptname=./$(basename $0)
basename=mt4_account_

account_nr_from_name "$(basename $0 .sh)"
get_raw_port

case "$1" in

  name ) printf mt4_account_${account_nr} ;;

  stats | info )
      #echo "Fetching '$1' for '$account_nr' at port '$raw_port'" >&2
      echo $1 sh | 
        c:/Users/IEUser/Downloads/redis-windows-x86-2.8.2400-xp/redis-cli.exe \
        -p $raw_port
    ;;

  config )
      eval $($scriptname stats)
      eval $($scriptname info)

      echo "graph_title $account_nr $company $trade_mode"
      echo "graph_category finance"
      echo "graph_info Account allocation"
      echo "graph_args --base 1000"
      echo "graph_vlabel $currency"

      echo "equity.label Equity"
      echo "equity.type GAUGE"
      echo "equity.draw AREA"

      echo "profit.label Profit"
      echo "profit.type GAUGE"
      echo "profit.draw STACK"

      echo "balance.label Balance"
      echo "balance.type GAUGE"
      echo "balance.draw LINE2"

      echo "free_margin.label Free Margin"
      echo "free_margin.type GAUGE"
      echo "free_margin.draw LINE1"

      echo "."
    ;;

  * )
      eval $($scriptname stats)

      echo equity.value $equity
      echo profit.value $profit
      echo balance.value $balance
      echo free_margin.value $margin_free

      echo "."
    ;;

esac
