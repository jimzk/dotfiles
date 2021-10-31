case "$OSTYPE" in
    darwin* )
        alias pc=pbcopy
        alias pp=pbpaste
        alias proxy="_proxy"
        alias unproxy="_unproxy"
        _unproxy() {
            unset http_proxy https_proxy all_proxy
        }
        _proxy() {
            export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
        }
        alias 'proxy?'="_is_proxy"
        _is_proxy() {
            r=$(curl -sL -vv https://www.google.com --max-time 3 2>/dev/null)
            if [[ -z "$r" ]]; then
                echo "❗️ $(tput setaf 1)"No Proxy!"$(tput sgr0)"
            else
                echo "✅ $(tput setaf 2)"In Proxy!"$(tput sgr0)"
            fi
        }
        _proxy
        ;;
    linux* )
        alias open="_f(){ open_command ${@:-.} }; _f" # `open_command` is zsh builtin functions
        ;;
    * )
        ;;
esac

export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="l gti g"

alias cls='clear'

# ls
alias gls='gls --color=tty -F'
alias ls='exa'
alias l='exa'
alias ll='exa -lg'
alias la='exa -a'
alias lla='exa -alg'
# only list directories
alias ld='exa -D'
alias lld='exa -Dlg'
# only list hidden files (dotfiles)
alias l.='_f(){ (cd ${1:-.}; exa -ad .*)}; _f'
alias ll.='_f(){ (cd ${1:-.}; exa -algd .*)}; _f'
# only list symlinks
alias llsym='_f(){ (cd ${1:-.}; _fs=( $(find . -maxdepth 1 -type l | xargs -I _ basename _) ); [ -n "$_fs" ] && exa -algd $_fs) }; _f'

# cd
alias cdl='_f(){ cd $1; ls }; _f'  # cd and list
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
# Create a new directory and enter it
alias mkd='_f(){ mkdir -p "$@" && cd "$_" }; _f'

# quick grep
# ls? abc    - search "abc" from $PWD
# ls? ~ abc  - search "abc" from ~
alias 'ls?'='_f() {
        local dir=$PWD
        [[ "$#" != 1 ]] && dir=$1 && shift
        _fs=( $(cd $dir && fd -d1 --hidden | grep -i $1) );
        exa -ad -1 $_fs
    }; _f'
alias 'l?'='ls?'
alias 'll?'='_f() {
        local dir=$PWD
        [[ "$#" != 1 ]] && dir=$1 && shift
        _fs=( $(cd $dir && fd -d1 --hidden | grep -i $1) );
        exa -ald $_fs
    }; _f'
alias 'ps?'='_quick_grep "ps aux" $@'
alias 'path?'='_quick_grep "_list_path" $@'
alias 'bin?'='_quick_grep "_list_my_bin" $@'
alias 'bindkey?'='_quick_grep "bindkey" $@'
alias 'brew-list?'='_quick_grep "_brew_list" $@'
alias 'zstyle?'='_quick_grep "zstyle -L" $@'

# git
alias gs='git status'
alias gss='git status -sb'
alias gsh='git stash'
alias gshp='git stash push -m'
alias ga='git add'
alias gc='git commit -v'
alias gc!='git commit --amend -v'
alias gc!!='git commit --amend -v -C HEAD'
alias gco='git checkout'
alias gp='git push'
alias gp!='git push -f'
alias gb='git branch'
alias gbv='git branch -vv'
alias gd='git diff'
alias glg='git lg'
alias glgv='git lgv'
alias glgvv='git lgvv'
alias gr='git rebase'
alias gri='git rebase -i'
alias gac='_f(){ [[ "$#" == 0 ]] && echo "Error: nothing to add and commit" && return; git add $@; git commit -t <(echo "$(git log --format=%B -n 1 HEAD)" ) }; _f'
alias gac!='_f(){ [[ "$#" == 0 ]] && echo "Error: nothing to add and commit" && return; git add $@; gc! }; _f'
alias g='git'

# tmux
alias tn='tmux new -A -s main'
alias ta='tmux attach'
alias tl='tmux list-session'

# more efficient
alias 'vim$'="vim -c \"normal '0\""  # open last file
alias ':q'='exit'
alias h="fc -l"
alias srcz='source ~/.zshrc'

# show information
#alias 'info-user'="stat -c '%n %U:%G-%a' *"
alias 'info-shell-pid'='echo $$'
alias 'info-shell-name'='echo $0'
alias 'info-shell'='echo $SHELL'
alias 'info-machine'='echo "[system]: $(uname -a)" && echo "[uptime]: $(uptime)" && echo "[user]: $(whoami)" '
alias 'info-ip'='curl -s "cip.cc"'
#alias ip='curl -s "ipinfo.io" | jq'
alias 'info-cli'='_wtf'
alias wtf='_wtf'
alias 'info-user'='whoami'
alias 'info-user-all'='less /etc/passwd'

# utility
alias o=open
alias app='open "/Applications/$(exa /Applications | fzf)"'
alias man='colored man'  # supported by zsh plugin colored-man-pages
alias ipy=ipython
alias pip=pip3
# -N show Chinese characters, -C print with color, -a show hidden files, -I exclude files, --dirsfirst show directory first
alias tree='_f(){ tree -aNC -I ".git|node_modules|bower_components|.DS_Store" --dirsfirst "$@" | less -FR }; _f'
alias cleanup='brew cleanup && pip cache purge'
[ -n "$(command -v bat)" ] && alias cat=bat
alias diff='colordiff'    # diff with color
alias -s md='open -a Typora'    # open *.md with Typora by default

alias rr="hs -c 'hs.reload()' && goku; echo 'HammerSpoon, goku are reloaded!'"
alias rz="echo 'Reload zsh!'; exec zsh"

# helper functions
function _quick_grep {
    [[ "$#" == 0 ]] && exit 1
    local cmd="$1"
    shift 1

    local _delimiter=" "
    for ((i=1; i<=$#; i++)); do
        case "$@[$i]" in
            "-o" | "--or" )
                _delimiter="|"
                set -- "${@:1:$((i-1))}" "${@:$((i+1))}"  # remove -o from $@
                break
                ;;
            * )
                ;;
        esac
    done
    if [[ "$#" == 0 ]]; then
        eval "$cmd"
    else
        # join parameters with delimiter
        local _p=$(_join_by "${_delimiter}" ${@:1})
        eval "$cmd" | grep -i -E "${_p}"  # operation OR
    fi
}

function _join_by {
    # https://stackoverflow.com/a/17841619
    local d=${1-} f=${2-}; if shift 2; then printf %s "$f" "${@/#/$d}"; fi;
}

function _list_my_bin() {
    fd --type executable --max-depth 1 --exclude '_*' . "${DOTFILES_BIN_HOME}" --exec basename {} \; | sort -n
}

function _list_path() {
    echo $PATH | tr ":" "\n"
}

function _wtf() {
    command -V "$@"
    if [[ -n $(alias $@) ]]; then
        # grep text like "alias $'ls?=" or "alias 'wtf="
        PS4='+%x:%I>' zsh -i -x -c '' |& grep "alias \$\?'$1="
    else
        which "$@"
    fi
}

function _brew_list() {
    # ref: https://stackoverflow.com/a/55445034
    brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"
}
