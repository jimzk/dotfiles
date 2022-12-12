#!/usr/bin/env bash

. "$(dirname -- $0)/env.sh"

# reload HammerSpoon
hs -c "hs.reload()"

# reload goku
sleep 1
msg="$(/opt/homebrew/bin/goku 2>&1)"
if [ "$msg" != "Done!" ]; then
    alert "⚠️Fail to reload Goku: $msg"
else
    alert "Goku configuratioin reloaded"
fi

# /opt/homebrew/bin/brew services restart yabai > /dev/null 2>&1
# if [ $? -eq 1 ]; then
#     alert "⚠️Fail to restart yabai"
# else
#     alert "Yabai restarted"
# fi
