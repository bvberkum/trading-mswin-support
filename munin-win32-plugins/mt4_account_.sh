#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

. /cygdrive/c/munin-profile.sh
scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

basename=mt4_account_

account_nr_from_name "$(basename $0 .sh)"
get_raw_port

case "$1" in

  name ) printf mt4_account_${account_nr} ;;

  stats | info )
      test -n "$raw_port" || exit 102
      get_raw_data $1
    ;;

  config )
      eval_query stats || echo "No stats for $account_nr" >&2
      eval_query info || echo "No info for $account_nr" >&2

      echo "graph_title $company $account_nr $trade_mode"
      echo "graph_category finance"
      echo "graph_info Account allocation"
      echo "graph_args --base 1000 -l 0"
      echo "graph_vlabel $currency"

      echo "equity.label Equity"
      echo "equity.type GAUGE"
      echo "equity.draw AREA"

      echo "floating.label Floating PL"
      echo "floating.type GAUGE"
      echo "floating.draw STACK"

      echo "balance.label Balance"
      echo "balance.type GAUGE"
      echo "balance.draw LINE1"

      echo "free_margin.label Free Margin"
      echo "free_margin.type GAUGE"
      echo "free_margin.draw LINE1"

      echo "."
    ;;

  * )
      eval_query stats || echo "No stats for $account_nr" >&2

      echo equity.value $equity
      test "$(printf -- "$profit" | cut -c1 )" = "-" && {
        # Negative PL, Equity is below balance. Remove sign and plot
        # floating PL value between.
        echo floating.value $(printf -- "$profit" | cut -c2- )
      } || {
        # Floating PL is included within Equity graph, equity is above balance.
        echo floating.value 0
      }
      echo balance.value $balance
      echo free_margin.value $margin_free

      echo "."
    ;;

esac
