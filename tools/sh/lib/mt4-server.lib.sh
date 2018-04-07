#!/bin/sh

query()
{
  test -n "$raw_port" || exit 102
  get_raw_data $@
}

eval_query()
{
  data="$(query "$@")"
  test -n "$data" || return 1
  eval $data
}

get_raw_port()
{
  raw_port="$(grep $account_nr $acc_tab | awk '{print $2}')"
  test -n "$raw_port" || {
    echo "Failed getting account port" >&2
    exit 1
  }
}

get_raw_data()
{
  local cmd=$1 ; shift
	{
		test -e ".$account_nr.$cmd" && newer_than ".$account_nr.$cmd" 300
	} || {
    echo $cmd sh $@ | c:/redis-cli.exe -p $raw_port > ".$account_nr.$cmd"
  }
  test -s ".$account_nr.$cmd" &&
    cat ".$account_nr.$cmd" || rm ".$account_nr.$cmd"
}

reset_raw_data()
{
  TODO newer_than ".$account_nr.$1" || rm ".$account_nr.$1"
}
