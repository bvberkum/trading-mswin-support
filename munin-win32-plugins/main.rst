Requires MT4, a customized MT4 Server, cygwin, Munin Node for Windows, 
and redis-cli.

::

  [ExternalPlugin]
  equity="C:\cygwin\bin\bash.exe /cygdrive/c/munin/mt4_equity.sh"
  profit="C:\cygwin\bin\bash.exe /cygdrive/c/munin/mt4_profit.sh"

