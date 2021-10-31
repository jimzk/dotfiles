#!/usr/bin/env bash

. "$(dirname -- $0)/env.sh"

# reload HammerSpoon
hs -c "hs.reload()"

# reload goku
sleep 1
msg="$(goku 2>&1)"
if [ "$msg" != "Done!" ]; then
    alert "⚠️Fail to Reload Goku!"
    exit
else
    alert "Goku Config Reloaded"
fi
