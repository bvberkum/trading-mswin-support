#!/bin/sh


account_nr_from_name()
{
  account_nr="$(echo "$1" | cut -c$(( 1 + ${#basename} ))- )"
  test -n "$account_nr" || {
    echo "Failed getting account nr" >&2
    exit 1
  }
}

account_nr_market_from_name()
{
  suffix="$(echo "$1" | cut -c$(( 1 + ${#basename} ))- )"
  account_nr="$(echo "$suffix" | cut -d '_' -f 1 )"
  market="$(echo "$suffix" | cut -d '_' -f 2 )"
  test -n "$account_nr" -a -n "$market" || {
    echo "Failed getting account nr or market" >&2
    exit 1
  }
}
