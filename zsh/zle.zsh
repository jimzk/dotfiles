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
    local result="$(navi --fzf-overrides '--tiebreak=begin,length' --print "$@" </dev/tty)"
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
        replacement="$(_navi_call)"
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
        eval $COMMAND |
        fzf --preview 'git lg {-1} -20' \
            --height=70% --preview-window='down,70%,wrap,border' \
            --header='^d delete branch' \
            --bind "ctrl-d:execute(git branch -d {-1} > /dev/null)+reload(eval $COMMAND)" |
        awk '{print $NF}' |  # get last column
        sed -e 's/remotes\///' |
        __join_lines
    )
    __redraw $branches
}

_fzf_git_file_widget() {
    git rev-parse HEAD > /dev/null || return

    COMMAND="git -c color.status=always status --short | xargs -L1"
    PREVIEW_DIFF_INDEX='git ls-files --error-unmatch {-1} >/dev/null 2>&1 && (git diff --color=always -- {-1} | sed 1,4d) || bat --style=plain {-1}'
    PREVIEW_DIFF_HEAD='git ls-files --error-unmatch {-1} >/dev/null 2>&1 && (git diff --color=always HEAD -- {-1} | sed 1,4d) || bat --style=plain {-1}'

    local files=$(
        eval $COMMAND |
        fzf --nth 2.. --preview "$PREVIEW_DIFF_INDEX" \
            --height=90% --preview-window down,84%,wrap \
            --header='^a add; ^h vs. HEAD (vs. index by default)' \
            --bind "ctrl-a:execute(git add {-1} > /dev/null)+reload(eval $COMMAND)" \
            --bind "ctrl-h:preview($PREVIEW_DIFF_HEAD)" |
        awk '{print $NF}' | # get last column
        __join_lines
    )
    __redraw $files
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
    PREVIEW_FULL="$PREVIEW_DEFAULT -p | diff-so-fancy --colors"
    # PREVIEW='git show --stat --color --pretty=format:"%Cred%h%Creset%n%B%>(40)%Cgreen(%cr)%C(bold blue) <%an>%Creset%n" {1}'

    local commits=$(
        eval $COMMAND |
        fzf-tmux --preview "$PREVIEW_DEFAULT" \
            --height=90% --preview-window down,70% \
            --header='^f details' \
            --bind "ctrl-f:preview($PREVIEW_FULL)" |
        awk '{print $1}' | __join_lines
    )
    __redraw $commits
}
_fzf_git_stash_widget() {
    git rev-parse HEAD > /dev/null || return
    local stash=$(
        git stash list |
        fzf --reverse -d: --preview 'git show --color=always {1} | diff-so-fancy --colors | less ' \
            --no-multi --reverse \
            --height=80% --preview-window down,85% \
            --header='^d drop stash' \
            --bind='ctrl-d:execute(git stash drop {1} > /dev/null)+reload(git stash list)' |
        cut -d':' -f1
    )
    __redraw $stash
}

_fzf_env_widget() {
    local envs=$(
        env |
        sed -e 's/=.*//' |
        fzf --preview "eval echo '\${}'" \
            --preview-window down,25%,wrap |
        awk '{print "$"$1}' |
        __join_lines)
    __redraw $envs
}
_fzf_alias_widget() {
    # escape single quotes in content "alias" prints, e.g. 'alia?'=
    all_aliases=$(alias | sed "s/^'//" | sed "s/'=/=/" | sort)
    local alias=$(
        echo -E $all_aliases |
        fzf --no-multi --preview "echo {}" \
            --height=45% --preview-window down,35%,wrap \
            --header='^g git alias' \
            --bind="ctrl-g:reload(git alias)" |
        sed -e 's/\=.*//')
    __redraw $alias
}

_fzf_cht_widget() {
    $DOTFILES_BIN_HOME/_cht
    zle accept-line -w
}

_fzf_file_widget() {
    local files=$(
        fd --color=always --hidden --follow --exclude .git --maxdepth=1 . |
        fzf --preview '([[ -d {} ]] && echo "[DIRECTORY]" && tree -CNFl -L 2 {} | head -200) || (echo "[FILE]" && bat --style=plain --color=always {})' --preview-window 'right,75%,wrap' |
        __join_lines)
    # files=$(__trim_string $files)
    __redraw $files
}

zle -N _fzf_navi_widget
zle -N _fzf_git_branch_widget
zle -N _fzf_git_file_widget
zle -N _fzf_git_commit_widget
zle -N _fzf_env_widget
zle -N _fzf_alias_widget
zle -N _fzf_cht_widget
zle -N _fzf_file_widget
zle -N _fzf_git_stash_widget
bindkey -r '^g'
bindkey '^gg' _fzf_navi_widget
bindkey '^gb' _fzf_git_branch_widget
bindkey '^gd' _fzf_git_file_widget
bindkey '^gh' _fzf_git_commit_widget
bindkey '^gs' _fzf_git_stash_widget
# todo: bindkey '^g^t' _git_tag_widget
bindkey '^ge' _fzf_env_widget
bindkey '^ga' _fzf_alias_widget
bindkey '^gt' _fzf_cht_widget
bindkey '^gf' _fzf_file_widget

__trim_string() {
    # trim space (https://stackoverflow.com/a/68288735)
    echo "${(MS)@##[[:graph:]]*[[:graph:]]}"
}
__redraw() {
    local input=$LBUFFER
    zle kill-whole-line
    LBUFFER=$input$@
    region_highlight=("P0 100 bold")
    zle redisplay
}
__join_lines() {
    tr '\n' ' ' | sed -e 's/ *$//'
}
