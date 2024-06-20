# thefuck
load-fuck() {
    eval $(thefuck --alias)
}

fuck() {
    unset -f fuck
    load-fuck
    fuck "$@"
}


_load-atuin() {
    bindkey -r "^R"
    eval "$(atuin init zsh --disable-up-arrow)"
    # ATUIN_NOBIND=1 eval "$(atuin init zsh)"
    zle atuin-search
}
zle -N load-atuin _load-atuin
bindkey '^R' load-atuin

# https://github.com/undg/zsh-nvm-lazy-load/blob/master/zsh-nvm-lazy-load.plugin.zsh
load-nvm() {
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
}

nvm() {
  export NVM_DIR="$HOME/.nvm"
  unset -f nvm
  load-nvm
  nvm "$@"
}

