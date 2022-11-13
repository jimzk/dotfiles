case "$OSTYPE" in
    darwin* )
        alias pc='tee >(pbcopy)' # copy + stdout
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
alias exa='exa -Fh --git --time-style=long-iso --sort=name'
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
alias l.='_f(){ (cd ${@:-.}; exa -ad .*)}; _f'
alias ll.='_f(){ (cd ${@:-.}; exa -algd .*)}; _f'
# only list symlinks
alias lls='_f(){ (cd ${@:-.}; _fs=( $(find . -maxdepth 1 -type l | xargs -I _ basename _) ); [ -n "$_fs" ] && exa -algd $_fs) }; _f'

# cd
alias cdl='_f(){ cd $@; ls }; _f'  # cd and list
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
alias 'key?'='_quick_grep "bindkey" $@'
alias 'brew?'='_quick_grep "_brew_list" $@'
alias 'zstyle?'='_quick_grep "zstyle -L" $@'

# git
alias gs='git status'
alias gss='git status -sb'
alias gsh='git stash'
alias gshp='git stash push -m'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -t <(sed "1 i\### Last commit\n$(git log --format=%B -n 1 HEAD)\n" ~/.dotfiles/git/gitmessage) -v'
alias gc!='git commit --amend -v'
alias gc!!='git commit --amend -v -C HEAD'
alias gk='git checkout'
alias gk-='git checkout -'
# checkout branch
alias gkb='git checkout $(git branch --sort=-committerdate --color=always -a | fzf --query "!remote " --preview "git lg {-1} -20" --height=70% --preview-window down,70%,wrap,border --header="^d delete branch" --bind "ctrl-d:execute(git branch -d {-1} > /dev/null)+reload(git branch --sort=-committerdate --color=always -a)" | awk "{print $NF}" |  sed -e "s/remotes\///" -e "s/*//")'
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
alias gac='_f(){ [[ "$#" == 0 ]] && echo "Error: nothing to add and commit" && return; git add $@; git commit -t <(sed "1 i\### Last commit\n$(git log --format=%B -n 1 HEAD)\n" ~/.dotfiles/git/gitmessage) }; _f'
alias gac.='gac .'
alias gac!='_f(){ [[ "$#" == 0 ]] && echo "Error: nothing to add and commit" && return; git add $@; gc! }; _f'
alias g='git'

# show information
alias @shell-pid='echo $$'
alias @shell-name='echo $0'
alias @shell='echo $SHELL'
# alias @sysinfo=
alias @system='echo "[System]: $(uname -a)" && echo "[Uptime]: $(uptime)" && echo "[User]: $(whoami)" '
#alias ip='curl -s "ipinfo.io" | jq'
alias @user='whoami'
alias @user-all='less /etc/passwd'
alias @file-permission="stat -c '%n %U:%G-%a' * | column -t"
alias @ip='curl -s "cip.cc"'
alias wtf='_wtf'

# more efficient
alias 'vim$'="vim -c \"normal '0\""  # open last file
alias ':q'='exit'
alias now='date +"%Y-%m-%d %T"'

# Shorter
alias o="open"
alias c="clear"
alias h="fc -l"
alias e="exit"
alias n='nnn -T d -io -P v'
alias d='_f(){ du -sh $@ | sort -h }; _f'
alias 'd*'='_f(){ du -sh * | sort -h }; _f'
alias trn='tr -d "\n"'
alias tn='tmux new -A -s main'
alias ta='tmux attach'
alias tl='tmux list-session'

# Replace default
alias rg='rg -L'
# tree: -N show Chinese characters, -C print with color, -a show hidden files, -I exclude files, --dirsfirst show directory first
# alias tree='_f(){ tree -aNC -I ".git|node_modules|bower_components|.DS_Store" --dirsfirst "$@" | less -FR }; _f'
alias tree1='tree -L 1'
alias tree2='tree -L 2'
alias tree3='tree -L 3'
alias diff='colordiff'  # diff with color
alias ping='ping -c 5'  # Stop after sending count ECHO_REQUEST packets #
alias curl='curl -SL'  # Show error && redirect
# https://twitter.com/carsonyangk8s/status/1498254329429762054
alias ping='_f(){ping -c5 $@ | nali}; _f' # -c5 Stop after sending count ECHO_REQUEST packets #
alias dig='_f(){dog $@ | nali}; _f'
alias ipy=ipython
alias pip=pip3
alias python=python3
alias py=python3

# Safety alias
# do not delete & prompt if deleting more than 3 files at a time
alias rm='rm -I --preserve-root'
# prompt before overwrite
alias mv='mv -i -v'
alias cp='cp -i -v'
alias ln='ln -i -v'
# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Others
alias cleanup='brew cleanup && pip cache purge'
alias -s md='open -a Typora'    # open *.md with Typora by default
# Blog
alias blog-deploy='hugo server --source $BLOG_HOME -e production --disableFastRender -F'
alias blog-new='_f() { hugo new -s $BLOG_HOME posts/$1.md; open $BLOG_HOME/content/posts/$1.md; }; _f'

# alias loadzsh='source ~/.zshrc'
alias loadzsh="echo 'Zsh is reloaded!'; exec zsh"
alias loadhammerspoon="hs -c 'hs.reload()'; echo 'HammerSpoon is reloaded!'"
alias loadgoku="goku; echo 'Goku is reloaded!'"
alias loadall="loadhammerspoon; loadgoku; loadzsh"
alias "]app"='open "/Applications/$(exa /Applications | fzf)"'
alias "]blog"='code $BLOG_HOME'
alias "]dot"="code ~/.dotfiles"
alias "]ssh"="code ~/.ssh"
alias "]starship"="rich $XDG_CONFIG_HOME/starship.toml"

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
