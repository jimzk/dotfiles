case "$OSTYPE" in
    darwin* )
        alias ls='ls -F -G'
        alias less='/usr/local/bin/less'  # use less that brew installed
        alias proxy="_proxy; info-ip"
        alias unproxy="_unproxy; info-ip"
        _proxy() {
            export http_proxy=http://127.0.0.1:1087
            export https_proxy=http://127.0.0.1:1087
        }
        _unproxy() {
            unset http_proxy
            unset https_proxy
        }
        _proxy
        ;;
    linux* )
        alias ls='ls -F --color=auto'
        alias open="_f(){ open_command ${@:-.} }; _f" # `open_command` is zsh builtin functions
        ;;
    * )
        ;;
esac

# clear
alias cl='clear'
alias cls='clear'

# ls
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -Al'
# only list directories
alias lld='_f(){ (cd ${1:-.}; _fs=( $(find . -maxdepth 1 -type d -not -path "." | xargs -I _ basename _) ); [ -n "$_fs" ] && ls -adl $_fs 2>/dev/null) }; _f'
alias lsd='_f(){ (cd ${1:-.}; _fs=( $(find . -maxdepth 1 -type d -not -path "." | xargs -I _ basename _) ); [ -n "$_fs" ] && ls -ad $_fs 2>/dev/null) }; _f'
# only list hidden files (dotfiles)
alias l.='_f(){ (cd ${1:-.}; ls -d .*)}; _f'
alias ls.='l.'
alias ll.='_f(){ (cd ${1:-.}; ls -ld .??*)}; _f'
# only list symlinks
alias ls-symlink='_f(){ (cd ${1:-.}; _fs=( $(find . -maxdepth 1 -type l | xargs -I _ basename _) ); [ -n "$_fs" ] && ls -adl $_fs) }; _f'

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
        ls -a $dir | grep -i $1
    }; _f'
alias 'll?'='_f() {
        local dir=$PWD
        [[ "$#" != 1 ]] && dir=$1 && shift
        ls -al $dir | grep -i $1
    }; _f'
alias 'ps?'='_quick_grep "ps aux" $@'
alias 'alias?'='_quick_grep "_alias_format" $@'
alias 'a?'='alias?'
alias 'alias?g'='_quick_grep "git alias" $@'
alias 'a?g'='alias?g'
alias 'env?'='_quick_grep "env" $@'
alias 'path?'='_quick_grep "_list_path" $@'
alias 'bin?'='_quick_grep "_list_my_bin" $@'
alias 'bindkey?'='_quick_grep "bindkey" $@'
alias 'brew-list?'='_quick_grep "_brew_list" $@'
alias 'zstyle?'='_quick_grep "zstyle -L" $@'

# more efficient
alias 'vim$'="vim -c \"normal '0\""  # open last file
alias ':q'='exit'
alias h="fc -l"
alias srcz='source ~/.zshrc'
alias tmux-new='_f(){ tmux new-session -t ${1:-default} }; _f'

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
alias l='exa --color=always -Fh --git --time-style=long-iso'
alias navi='navi --path $DOTFILES_HOME/cheatsheets/navi/main'
alias o=open
alias app='open "$(ls /Applications | fzf)"'
alias ipy=ipython
alias pip=pip3
alias timestamp='date "+%Y%m%dT%H%M%S"'
# -N show Chinese characters, -C print with color, -a show hidden files, -I exclude files, --dirsfirst show directory first
alias tree='_f(){ tree -aNC -I ".git|node_modules|bower_components|.DS_Store" --dirsfirst "$@" | less -FRX }; _f'
alias cleanup='brew cleanup && pip cache purge'
[ -n "$(command -v bat)" ] && alias cat=bat
alias diff='colordiff'    # diff with color
alias -s md='open -a Typora'    # open *.md with Typora by default

# git
alias g='git'
alias gti='git'

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

# escape single quotes in content "alias" prints, e.g. 'alia?'=
function _alias_format() {
    alias | sed "s/^'//" | sed "s/'=/=/" | sort
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
