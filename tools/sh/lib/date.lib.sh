#!/bin/sh


newer_than()
{
  test $(( $(date +%s) - $2 )) -lt $(filemtime "$1") && return 0 || return 1
}

older_than()
{
  test $(( $(date +%s) - $2 )) -gt $(filemtime "$1") && return 0 || return 1
}
