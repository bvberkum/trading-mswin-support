#!/usr/bin/sh
set -e

scriptdir=C:/munin/
cd "$scriptdir"

. /cygdrive/c/munin-profile.sh
scriptpath=~/project/trading/lib/trading-mswin-support
. $scriptpath/tools/sh/env.sh

basename=munin_proc_support

case "$1" in

  name ) printf ${basename} ;;

  config )
      echo "graph_title Open Munin support procs"
      echo "graph_category "
      echo "graph_info Processes"
      echo "graph_args --base 1000 -l 0"
      echo "graph_vlabel count"

      echo "proc_bash.label Bash"
      echo "proc_bash.type GAUGE"
      echo "proc_bash.draw LINE1"

      echo "proc_redis_client.label Redis CLI"
      echo "proc_redis_client.type GAUGE"
      echo "proc_redis_client.draw LINE1"

      echo "."
    ;;

  "" )
      # WMIC path win32_process get Caption,Processid,Commandline|grep redis

      redis_cnt="$(ps -W | awk '/redis-cli/,NF=1' | wc -l | awk '{print $1}')"
      echo proc_bash.value $(ps -W | awk '/bash/,NF=1' | wc -l | awk '{print $1}')
      echo proc_redis_client.value $redis_cnt
      echo "."

      test $redis_cnt -lt 30 || {
        ps -W | awk '/redis-cli/,NF=1' | xargs kill -f
      }
    ;;

  * ) echo "'$1'?" >&2 ; exit 1 ;;

esac
