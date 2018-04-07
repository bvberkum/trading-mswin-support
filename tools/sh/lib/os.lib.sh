#!/bin/sh

# Use `stat` to get modification time
filemtime() # File..
{
  while test $# -gt 0
  do
    case "$uname" in

      Darwin )
          stat -L -f '%m' "$1" || return 1
        ;;

      CYGWIN_NT-* | Linux )
          stat -L -c '%Y' "$1" || return 1
        ;;
    esac; shift
  done
}
