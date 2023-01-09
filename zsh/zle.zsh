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
# zsh-autosuggestion
bindkey '^o' autosuggest-execute

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
    local prev_commands=$(__trim_string ${input%%$last_command})

    # local replacement
    if [ -n "$last_command" ]; then
        replacement="$(_navi_call --path "$DOTFILES_HOME/cheatsheets/navi" --query "$last_command")"
    else
        replacement="$(_navi_call --path "$DOTFILES_HOME/cheatsheets/navi")"
    fi

    if [[ -n "$replacement" ]]; then
        output="$prev_commands $replacement$ending"
    else
        output="$input"
    fi

    zle kill-whole-line
    LBUFFER=$(__trim_string $output)
    region_highlight=("P0 100 bold")
    zle redisplay
}

_fzf_navi_shortcut_widget() {
    output=$(_navi_call --path "$DOTFILES_HOME/cheatsheets/shortcut")
    if [[ -n "$output" ]]; then
        echo "$output\n"
    fi
    zle redisplay
}

GIT_WIDGET_PAGER="delta -w ${FZF_PREVIEW_COLUMNS:-$COLUMNS}"
# ref: https://github.com/junegunn/fzf/wiki/Examples-(completion)#zsh-complete-git-co-for-example
#      https://junegunn.kr/2016/07/fzf-git
_fzf_git_branch_widget() {
    local error=$(git rev-parse HEAD 2>&1 >/dev/null)
    [[ -n $error ]] && printf "\033[0;31mfatal\033[0m: fail to list \033[0;32mbranch\033[0m, not a git repository!" && zle accept-line && return

    # --sort=-committerdate: sort by latest commit date
    COMMAND="git branch --sort=-committerdate --color=always -a"
    local branches=$(
        eval $COMMAND |
        fzf --query '!remote ' --preview 'git lg {-1} -20' \
            --height=70% --preview-window down,70%,wrap,border \
            --header='^d delete branch' \
            --bind "ctrl-d:execute(git branch -d {-1} > /dev/null)+reload(eval $COMMAND)" |
        awk '{print $NF}' |  # get last column
        sed -e 's/remotes\///' |
        __join_lines)
    __redraw $branches
}

_fzf_git_file_widget() {
    local error=$(git rev-parse HEAD 2>&1 >/dev/null)
    [[ -n $error ]] && printf "\033[0;31mfatal\033[0m: fail to list \033[0;32mchanged files\033[0m, not a git repository!" && zle accept-line && return

    COMMAND="git -c color.status=always status --short | xargs -L1"
    # We need to use `delta` explicitly while git diff won't use pager here (in fzf preview),
    # delta fails to extend full width in fzf preview, which can be solve by -w
    # See https://github.com/dandavison/delta/issues/368
    PREVIEW_DIFF="git ls-files --error-unmatch {-1} >/dev/null 2>&1 && (git diff --color=always -- {-1} | $GIT_WIDGET_PAGER) || bat --style=plain {-1}"
    PREVIEW_DIFF_HEAD="git ls-files --error-unmatch {-1} >/dev/null 2>&1 && (git diff --color=always HEAD -- {-1} | $GIT_WIDGET_PAGER) || bat --style=plain {-1}"
    PREVIEW_DIFF_CACHED="git ls-files --error-unmatch {-1} >/dev/null 2>&1 && (git diff --cached --color=always -- {-1} | $GIT_WIDGET_PAGER) || bat --style=plain {-1}"

    local files=$(git -c color.status=always status --short | xargs -L1)
    [[ -z $files ]] && >&2 printf "\033[0;31merror\033[0m: no git changed files!" && zle accept-line && return

    local files=$(
        echo $files |
        fzf --nth 2.. --preview "$PREVIEW_DIFF" \
            --height=90% --preview-window down,84%,wrap \
            --header='^a add | ^l unstaged changes (default) | ^s staged changes | ^h changes vs. HEAD' \
            --bind "ctrl-a:execute(git add {-1} > /dev/null)+reload(eval $COMMAND)" \
            --bind "ctrl-l:preview($PREVIEW_DIFF)" \
            --bind "ctrl-h:preview($PREVIEW_DIFF_HEAD)" \
            --bind "ctrl-s:preview($PREVIEW_DIFF_CACHED)" |
        awk '{print $NF}' | # get last column
        __join_lines)
    __redraw $files
}
_fzf_git_commit_widget() {
    local error=$(git rev-parse HEAD 2>&1 >/dev/null)
    [[ -n $error ]] && printf "\033[0;31mfatal\033[0m: fail to list \033[0;32mcommits\033[0m, not a git repository!" && zle accept-line && return

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
    PREVIEW_FULL="$PREVIEW_DEFAULT -p | $GIT_WIDGET_PAGER"
    # PREVIEW='git show --stat --color --pretty=format:"%Cred%h%Creset%n%B%>(40)%Cgreen(%cr)%C(bold blue) <%an>%Creset%n" {1}'

    local commits=$(
        eval $COMMAND |
        fzf --no-cycle --preview "$PREVIEW_FULL" \
            --height=80% --preview-window down,65%,wrap \
            --header='^f short info' \
            --bind "ctrl-f:preview($PREVIEW_DEFAULT)" |
        awk '{print $1}' | __join_lines)
    __redraw $commits
}
_fzf_git_file_commit_widget() {
    local error=$(git rev-parse HEAD 2>&1 >/dev/null)
    [[ -n $error ]] && printf "\033[0;31mfatal\033[0m: fail to list \033[0;32mfile commits\033[0m, not a git repository!" && zle accept-line && return
    local file=$(fd -H -E .git | fzf --header="Choose the file to show commits history" \
                        --preview 'git log --color --pretty=format:"%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" -- {1}' \
                        --preview-window 70%,wrap)
    [[ -z $file ]] && __redraw && return
    local commits=$(git log --color --pretty=format:"%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" -- $file |
                    fzf --height=80% \
                        --header="Commits History for file <$file>" \
                        --preview "git show --stat --color {1} -p $file | $GIT_WIDGET_PAGER" \
                        --preview-window down,65% |
                    awk '{print $1}' | __join_lines)
    # local commits=$(git log --format=%h -- $file | fzf --height=80% --preview "git show --stat --color {} -p $file | diff-so-fancy --colors" --preview-window 'down,65%')

    __redraw $commits
}
_fzf_git_tag_widget() {
    local error=$(git rev-parse HEAD 2>&1 >/dev/null)
    [[ -n $error ]] && printf "\033[0;31mfatal\033[0m: fail to list \033[0;32mtags\033[0m, not a git repository!" && zle accept-line && return

    local tags=$(git tag --list --color=always --format='%(refname:strip=2) %(creatordate:short)' | sort -k2 -r | column -t -s' ')
    [[ -z $tags ]] && >&2 printf "\033[0;31merror\033[0m: no git tags!" && zle accept-line && return

    local tags=$(
        echo $tags |
        fzf --height=70% --preview 'git lg {1} -20' --preview-window down,70%,wrap,border |
        awk '{print $1}' |  # get first column
        __join_lines)
    __redraw $tags
}

_fzf_git_stash_widget() {
    local error=$(git rev-parse HEAD 2>&1 >/dev/null)
    [[ -n $error ]] && printf "\033[0;31mfatal\033[0m: fail to list \033[0;32mstashes\033[0m, not a git repository!" && zle accept-line && return

    local stashes=$(git stash list)
    [[ -z $stashes ]] && >&2 printf "\033[0;31merror\033[0m: no git stashed changes!" && zle accept-line && return

    local stash=$(
        echo $stashes |
        fzf --reverse -d: --preview "git show --color=always {1} | $GIT_WIDGET_PAGER" \
            --no-multi --reverse \
            --height=80% --preview-window down,85%,wrap \
            --header='^d drop stash' \
            --bind='ctrl-d:execute(git stash drop {1} > /dev/null)+reload(git stash list)' |
        cut -d':' -f1)
    __redraw $stash
}

_fzf_env_widget() {
    local envs=$(
        env | grep '=' | sed -e 's/=.*//' |
        fzf --preview "eval echo '\${}'" \
            --preview-window down,40%,wrap |
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
        fd --color=always --hidden --follow --exclude .git --maxdepth=10 . |
        fzf --preview '([[ -d {} ]] && echo "[DIRECTORY]" && tree -CNFl -L 5 {} | head -200) || (echo "[FILE]" && bat --style=plain --color=always {})' --preview-window right,75%,wrap,hidden |
        __join_lines)
    # files=$(__trim_string $files)
    __redraw $files
}

zle -N _fzf_navi_widget
zle -N _fzf_navi_shortcut_widget
zle -N _fzf_git_branch_widget
zle -N _fzf_git_file_widget
zle -N _fzf_git_commit_widget
zle -N _fzf_git_file_commit_widget
zle -N _fzf_git_tag_widget
zle -N _fzf_env_widget
zle -N _fzf_alias_widget
zle -N _fzf_cht_widget
zle -N _fzf_file_widget
zle -N _fzf_git_stash_widget
bindkey -r '^g'
bindkey '^gc' _fzf_navi_widget
bindkey '^gg' _fzf_navi_shortcut_widget
bindkey '^gb' _fzf_git_branch_widget
bindkey '^gd' _fzf_git_file_widget
bindkey '^gl' _fzf_git_commit_widget
bindkey '^gh' _fzf_git_file_commit_widget
bindkey '^gt' _fzf_git_tag_widget
bindkey '^gs' _fzf_git_stash_widget
bindkey '^ge' _fzf_env_widget
bindkey '^ga' _fzf_alias_widget
bindkey '^gv' _fzf_cht_widget
bindkey '^gf' _fzf_file_widget

__trim_string() {
    # trim space (https://stackoverflow.com/a/68288735)
    # echo -n "${(MS)@##[[:graph:]]*[[:graph:]]}"
    echo -n "$@" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
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

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line -w
  else
    zle push-input -w
    zle clear-screen -w
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# https://stackoverflow.com/questions/12382499/looking-for-altleftarrowkey-solution-in-zsh
# Alt + left / right move word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
