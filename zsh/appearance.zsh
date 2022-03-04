# Zsh theme Location: $ZSH/themes
# Recommended themes：random, robbyrussell, pure, spaceship, bullet-train
# Third themes: spaceship-prompt p10k
# ZSH_THEME=random

# https://github.com/starship/starship
eval "$(starship init zsh)"

# zsh plugins styles
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8a8a,bold,underline"
TIMER_FORMAT='[%d]'  # timer (https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/timer)

# avoid line end with % when using `printf`
# https://unix.stackexchange.com/a/167600
export PROMPT_EOL_MARK=''
