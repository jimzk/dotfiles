# p10k configuration
# enable instant prompt (https://github.com/romkatv/powerlevel10k#how-do-i-enable-instant-prompt)
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit p10k.zsh.
source $DOTFILES_ZSH_HOME/p10k-configuration.zsh
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

typeset -g POWERLEVEL9K_DIR_BACKGROUND=153
typeset -g POWERLEVEL9K_DIR_FOREGROUND=236
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=1
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=234
typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=1

typeset -g POWERLEVEL9K_STATUS_OK=true
typeset -g POWERLEVEL9K_STATUS_ERROR=true
typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true

ZSH_THEME="powerlevel10k/powerlevel10k"
