#!/usr/bin/sh

export PATH="/home/IEUser/.conf/script/Generic:/home/IEUser/bin:/usr/local/bin:/usr/bin:/bin:/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/Wbem:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0:/cygdrive/c/Program Files/ZeroTier/One:/cygdrive/c/Python27:/cygdrive/c/Program Files/Git LFS"

#acc_tab=/home/IEUser/project/trading/data/accounts.tab
acc_tab=/home/wtwta/project/trading/data/accounts.tab

accounts="8063363 1483126 6514695 6611745"

uname="$(uname)"

port=21014
markets_3digits="EURJPY USDJPY CADJPY"
markets_5digits="EURCAD AUDCHF EURUSD USDCHF GBPUSD EURCHF"
markets="$markets_3digits $markets_5digits"
