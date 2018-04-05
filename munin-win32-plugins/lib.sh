
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

get_raw_port()
{
  raw_port="$(grep $account_nr $acc_tab | awk '{print $2}')"
  test -n "$raw_port" || {
    echo "Failed getting account port" >&2
    exit 1
  }
}

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

newer_than()
{
  test $(( $(date +%s) - $2 )) -lt $(filemtime "$1") && return 0 || return 1
}

older_than()
{
  test $(( $(date +%s) - $2 )) -gt $(filemtime "$1") && return 0 || return 1
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
