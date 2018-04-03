
account_nr_from_name()
{
  account_nr="$(echo "$1" | cut -c$(( 1 + ${#basename} ))- )"
  test -n "$account_nr" || {
    echo "Failed getting account nr" >&2
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
