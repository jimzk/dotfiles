#!/usr/bin/env bash

installers=$(find $DOTFILES_HOME/tools/installers -type f -name "*")
flag=
case "$OSTYPE" in
    darwin* )
        flag="#darwin"
        ;;
    linux* )
        flag="#linux"
        ;;
    * )
        # exit with error when platform is not macOS or Ubuntu
        _print_fail "Platform should be macOS or Ubuntu"
        exit 1
        ;;
esac
for file in ${installers[@]}; do
    cmd=$(grep -A1 "#cmd" ${file} | tail -n -1)
    # if command is existent, then no need to install and step into the next
    # note: if cmd is empty, it will go on to install
    [ ! -z "$(command -v $cmd)" ] && continue
    start_line_number=$(grep -n "$flag" $file | cut -f1 -d:)  # line number of flag is #darwin or #linux
    if [[ ! -z $start_line_number ]]; then
        # start to execute command from flag like #darwin or #linux, and break when meeting empty line.
        # awk "NR > X && NR < Y file" ${file} is to retrieve lines between X and Y
        awk "NR > $start_line_number" $file | while read -r line; do if [[ ! -z $line ]]; then sh -c "$line"; else break; fi; done
    fi
done
