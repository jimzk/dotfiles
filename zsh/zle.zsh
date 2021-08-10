# zsh does not read `readline`, which means that it is not compatible with .inputrc. (https://superuser.com/a/278807)
# zsh has its own alternative solution: Zsh Line Editor (ZLE)
#
# [zle introduction]
#     https://sgeb.io/posts/2014/04/zsh-zle-custom-widgets/
# [reference]
#     https://superuser.com/questions/269464/understanding-control-characters-in-inputrc
#     http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
#     https://www.csse.uwa.edu.au/programming/linux/zsh-doc/zsh_19.html
#
# [Quick Guide]
#     - `showkey -a`: show the escape sequence that the pressed keys send.
#     - ^[v stands for <alt-v>, ^z for <ctrl-z>
# [list keymap]
#     there are eight keymaps: emacs, viins, vicmd, viopp, visual, isearch, command, .safe
#     - `bindkey -M <keymap>`: list all the bindings in a given key map.
#     - `bindkey '\eb'`: see <alt-b> maps to which zle widget.
#     - `zle -la`: list all available zle widges.

# use `emacs' keymap
bindkey -e

# zsh navi widget
_navi_call() {
    local result="$(navi --print "$@" </dev/tty)"
    [[ -n "$result" ]] && printf "%s" "$result"
}
_navi_widget() {
    local input=$(_trim_string $LBUFFER)
    local ending
    local commands

    [[ $input[-1] == "|" ]] && input="$input "
    commands=(${(s:|:)input})  # split input by |
    local last_command=$(_trim_string $commands[-1])
    # only get command after last $( if any
    if [[ $last_command == *'$('* ]]; then
        last_command="$last_command "
        commands=(${(s:$(:)last_command})  # split input by $(
        last_command=$(_trim_string $commands[-1])
        ending=' )'
    fi
    local prev_command=$(_trim_string ${input%%$last_command})

    # local replacement
    if [ -n "$last_command" ]; then
        replacement="$(_navi_call --query "$last_command")"
    else
        replacement="$(_navi_call --fzf-overrides '--no-select-1')"
    fi

    if [[ -n "$replacement" ]]; then
        output="$prev_command $replacement$ending"
    else
        output="$input"
    fi

    zle kill-whole-line
    LBUFFER=$(_trim_string $output)
    region_highlight=("P0 100 bold")
    zle redisplay
}

zle -N _navi_widget
bindkey '^g' _navi_widget

_trim_string() {
    # trim space (https://stackoverflow.com/a/68288735)
    echo "${(MS)@##[[:graph:]]*[[:graph:]]}"
}
