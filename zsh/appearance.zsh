# Zsh theme Location: $ZSH/themes
# Recommended themes：random, robbyrussell, pure, spaceship, bullet-train
# Third themes: spaceship-prompt p10k

# p10 configuration
# enable instant prompt (https://github.com/romkatv/powerlevel10k#how-do-i-enable-instant-prompt)
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit p10k.zsh.
source $DOTFILES_ZSH_HOME/p10k.zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

# zsh plugins styles
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8a8a,bold,underline"
TIMER_FORMAT='[%d]'  # timer (https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/timer)

# avoid line end with % when using `printf`
# https://unix.stackexchange.com/a/167600
export PROMPT_EOL_MARK=''
