#!/usr/bin/env bash

export PATH="$PATH:/usr/local/bin"

alert() {
    # escape characters process. e.g., convert \ to \\
    # https://stackoverflow.com/a/2856010/10134408
    # msg="$(printf "%q" "$1")"
    # hs -c "hs.alert.show(\"$msg\")"
    hs -c "hs.alert.show(\"$1\")"
    # osascript -e "display notification \"$1\" with title \"Karabiner-Elements\""
}
export -f alert
