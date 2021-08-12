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
_fzf_navi_widget() {
    local input=$(__trim_string $LBUFFER)
    local ending
    local commands

    [[ $input[-1] == "|" ]] && input="$input "
    commands=(${(s:|:)input})  # split input by |
    local last_command=$(__trim_string $commands[-1])
    # only get command after last $( if any
    if [[ $last_command == *'$('* ]]; then
        last_command="$last_command "
        commands=(${(s:$(:)last_command})  # split input by $(
        last_command=$(__trim_string $commands[-1])
        ending=' )'
    fi
    local prev_command=$(__trim_string ${input%%$last_command})

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
    LBUFFER=$(__trim_string $output)
    region_highlight=("P0 100 bold")
    zle redisplay
}

# ref: https://github.com/junegunn/fzf/wiki/Examples-(completion)#zsh-complete-git-co-for-example
#      https://junegunn.kr/2016/07/fzf-git
_fzf_git_branch_widget() {
    git rev-parse HEAD > /dev/null || return
    COMMAND="git branch --color=always -a"
    local branches=$(
        eval $COMMAND | fzf --preview 'git lga {-1} -20' \
                            --height=50% --preview-window='down,60%,wrap,border' \
                            --header='^d delete branch' \
                            --bind "ctrl-d:execute(git branch -d {-1} > /dev/null)+reload(eval $COMMAND)"
    )
    branches=$(echo $branches | awk '{print $NF}' | sed -e 's/remotes\///' | tr '\n' ' ')
    branches=$(__trim_string $branches)

    local input=$LBUFFER
    zle kill-whole-line
    LBUFFER=$input$branches
    region_highlight=("P0 100 bold")
    zle redisplay
}
_fzf_git_file_widget() {
    git rev-parse HEAD > /dev/null || return

    COMMAND="git -c color.status=always status --short | xargs -L1"
    PREVIEW_DIFF_INDEX='git ls-files --error-unmatch {-1} >/dev/null 2>&1 && (git diff --color=always -- {-1} | sed 1,4d) || bat --style=plain {-1}'
    PREVIEW_DIFF_HEAD='git ls-files --error-unmatch {-1} >/dev/null 2>&1 && (git diff --color=always HEAD -- {-1} | sed 1,4d) || bat --style=plain {-1}'

    local files=$(
        eval $COMMAND | fzf --nth 2.. --preview "$PREVIEW_DIFF_INDEX" \
                            --height=90% --preview-window down,84%,wrap \
                            --header='^a add; ^h vs. HEAD (vs. index by default)' \
                            --bind "ctrl-a:execute(git add {-1} > /dev/null)+reload(eval $COMMAND)" \
                            --bind "ctrl-h:preview($PREVIEW_DIFF_HEAD)"
    )
    files=$(echo $files | awk '{print $NF}' | tr '\n' ' ')
    files=$(__trim_string $files)

    local input=$LBUFFER
    zle kill-whole-line
    LBUFFER=$input$files
    region_highlight=("P0 100 bold")
    zle redisplay
}
_fzf_git_commit_widget() {
    git rev-parse HEAD > /dev/null || return

    # format placeholder ("git show --help" for more)
    # %h abbreviated commit hash
    # %s subject
    # %b body, %B raw body (unwrapped subject and body)
    # %cr committer date, relative
    # %an author name
    # %n newline
    # >(40) padding on the left to make the next placeholder take at least 40 columns
    COMMAND='git log --color --pretty=format:"%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
    # -p: generat path (changed content)
    PREVIEW_DEFAULT='git show --stat --color {1}'
    PREVIEW_FULL='git show --stat --color -p {1}'
    # PREVIEW='git show --stat --color --pretty=format:"%Cred%h%Creset%n%B%>(40)%Cgreen(%cr)%C(bold blue) <%an>%Creset%n" {1}'

    local commits=$(
        eval $COMMAND | fzf-tmux --preview "$PREVIEW_DEFAULT" \
                            --height=90% --preview-window down,70%,wrap \
                            --header='^f details' \
                            --bind "ctrl-f:preview($PREVIEW_FULL)"
    )
    commits=$(echo $commits | awk '{print $1}' | tr '\n' ' ')
    commits=$(__trim_string $commits)

    local input=$LBUFFER
    zle kill-whole-line
    LBUFFER=$input$commits
    region_highlight=("P0 100 bold")
    zle redisplay
}

zle -N _fzf_navi_widget
zle -N _fzf_git_branch_widget
zle -N _fzf_git_file_widget
zle -N _fzf_git_commit_widget
bindkey -r '^g'
bindkey '^g^g' _fzf_navi_widget
bindkey '^g^b' _fzf_git_branch_widget
bindkey '^g^f' _fzf_git_file_widget
bindkey '^g^h' _fzf_git_commit_widget
# todo: bindkey '^g^t' _git_tag_widget

# todo: bindkey '^[g^[e' _env_widget
# todo: bindkey '^[g^[g' _cheatsheets_widget

__trim_string() {
    # trim space (https://stackoverflow.com/a/68288735)
    echo "${(MS)@##[[:graph:]]*[[:graph:]]}"
}
