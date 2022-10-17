# +---------+
# | Options |
# +---------+
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt ALWAYS_TO_END        # Move cursor to end if word had one match
setopt LIST_PACKED          # completion menu takes less spaces

# +---------+
# | zstyles |
# +---------+
# Some example:
#     https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh
#     https://github.com/Phantas0s/.dotfiles/blob/master/zsh/completion.zsh
# Set applied completers and the applied order
zstyle ':completion:*' completer _extensions _complete _approximate
# Enbale menu
zstyle ':completion:*' menu select
# Use cache for completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Colors for files and directories
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Descriptions -- color is not compatible with fzf-tab
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format '[%d]'  # show group name
# zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' verbose yes

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group matches
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''  # group results by category
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands

# Sort file by modification time (newest first), and use the target timestamp for symlinks (the option follow)
zstyle ':completion:*' file-sort modification follow

# Expand // to /
zstyle ':completion:*' squeeze-slashes true

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
    dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
    hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
    mailman mailnull mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
    operator pcap postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# prevent duplicates (look like a bug of _git completion) when completing git alias
# zstyle ':completion:*:*:git:*' tag-order 'common-commands' 'alias-commands' 'all-commands'
# zstyle ':completion:*:*:git:*' complete-options false

# +---------+
# | fzf-tab |
# +---------+
zstyle ':fzf-tab:complete:*' fzf-flags --tac --no-sort --color=16,hl:green,header:bold --height=30% --preview-window right,75%,wrap,hidden
zstyle ':fzf-tab:complete:*' fzf-preview 'less $realpath'
zstyle ':fzf-tab:complete:*' query-string ''  # empty query string
zstyle ':fzf-tab:*' switch-group 'F1' 'F2'
# ref: https://github.com/Aloxaf/fzf-tab/wiki/Configuration#group-colors
FZF_TAB_GROUP_COLORS=(
    $'\033[94m' $'\033[38;5;75m' $'\033[33m' $'\033[35m' $'\033[31m' $'\033[38;5;27m' $'\033[36m' \
    $'\033[38;5;100m' $'\033[38;5;98m' $'\033[91m' $'\033[38;5;80m' $'\033[92m' \
    $'\033[38;5;214m' $'\033[38;5;165m' $'\033[38;5;124m' $'\033[38;5;120m'
)
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS
zstyle ':fzf-tab:*' single-group color
zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' continuous-trigger 'ctrl-g'

# environment variables
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'command -v $word 2>/dev/null || eval echo \$$word'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-flags --tac --no-sort --color=16,hl:green --height=30% --preview-window down,30%,wrap

# preview for cd/ls
zstyle ':fzf-tab:complete:(cd|ls):*' fzf-flags --tac --no-sort --color=16,hl:green,header:bold --height=35% --preview-window right,75%,wrap --header='^E Edit, ^O Open'
zstyle ':fzf-tab:complete:(cd|ls):*' fzf-bindings \
    'ctrl-e:execute-silent({_FTB_INIT_}code "$realpath")+abort' \
    'ctrl-o:execute-silent({_FTB_INIT_}open "$realpath")+abort'

# preview for kill/ps
# zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:*:*:*:processes' command "ps -ef"
# zstyle ':completion:*:*:(kill|ps):*' complete-options false
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-preview $'[[ $group == "[process ID]" ]] && ps -f -p $word'  # only show items in group 'process ID'
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-flags --tac --no-sort --height=60% --color=16,hl:green --preview-window=down:18%:wrap
