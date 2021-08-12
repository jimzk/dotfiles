
# auto completion via fzf
# I use multiple completion mechanism while no one can meet my needs in invidually.
# priority order: zsh completion -> fzf-tab -> fzf completion (high)

export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap"
export FZF_ALT_C_COMMAND="fd --hidden --follow --exclude .git --maxdepth=1 ."
# todo: alt-c to simulate "/" in faz-tab
export FZF_ALT_C_OPTS="--preview 'tree -CNFl -L 2 {} | head -200'"
# ref: https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
export FZF_COMPLETION_OPTS="$FZF_BASE_OPTS"
export FZF_COMPLETION_TRIGGER=';'

# Functions to customize fzf completion
#     _fzf_compgen_path, _fzf_compgen_dir: customize default path and dir candidates
#     _fzf_complete_xx: customize candidates for specified command "xx"
#     _fzf_comprun: customize preview and output according to command
# ref: https://github.com/junegunn/fzf#settings

# Use fd to generate the candidates for list completion
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    # todo: fix $<tab> cannot show environment when setting FZF_COMPLETION_TRIGGER=''
    fd --hidden --max-depth 1 --exclude ".git" --exclude "\.Trash*" . "$1"
}
# Use fd to generate the candidates for directory completion
_fzf_compgen_dir() {
    fd --type d --max-depth 2 --hidden --exclude ".git" . "$1"
}

# # Advanced customization of fzf options via _fzf_comprun function
# _fzf_comprun() {
#     local command=$1
#     shift
#     # FZF_DEFAULT_OPTS will be overwritten by the same flag sent by _fzf_complete in _fzf_complete_command if any
#     case "$command" in
#         'cd' )
#             # todo: implement fzf-tab -like "/"
#             fzf "$@" --preview 'tree -CNFl -L 2 {} | head -200' ;;
#         'export' | 'unset' )
#             fzf "$@" --preview "eval 'echo \$'{}" ;;
#         'ssh' )
#             fzf "$@" --preview 'dig {}' ;;
#         'git' | 'g' )
#             FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS/ --select-1/}  # remove --select-1
#             while read -r line; do
#                 __fzf_comprun_git $_git_sub_command $line
#             done < <(
#                 fzf "$@"
#             ) ;;
#         * )
#             fzf "$@" ;;
#   esac
# }

# __fzf_comprun_git() {
#     local command=$1
#     local fzf_output=$(echo $2 | xargs)

#     case "$command" in
#         $_GIT_SUB_COMMAND_ENUM_CHECKOUT )
#         # 'checkout' )
#             echo $fzf_output | sed "s/^\t*\*//" | tr -s " " | awk '{print $1}'
#             # echo $f
#             ;;
#         $_GIT_SUB_COMMAND_ENUM_REBASE )
#             # commit=$(echo $line | cut -d' ' -f1)
#             # echo "${commit}~"
#             echo $fzf_output | awk '{print $1"~"}'
#             ;;
#         $_GIT_SUB_COMMAND_ENUM_ADD )
#             echo $fzf_output | awk '{print $2}'
#             ;;
#         * )
#             echo $fzf_output
#     esac
# }

# # git completion via fzf
# # ref: https://github.com/junegunn/fzf/wiki/Examples-(completion)#zsh-complete-git-co-for-example
# #      https://junegunn.kr/2016/07/fzf-git
# _git_sub_command=  # global variable to store git sub-command, which will be sent to _fzf_comprun
# _GIT_SUB_COMMAND_ENUM_CHECKOUT=1
# _GIT_SUB_COMMAND_ENUM_REBASE=2
# _GIT_SUB_COMMAND_ENUM_ADD=3
# _fzf_complete_git() {
#     # "Nothing to see here, move along"
#     # todo: send error msg at non-git reposirtoy
#     $(git rev-parse HEAD 2>&1 > /dev/null) || return
#     # $@ is not an array but a string
#     ARGS=$(echo $@ | cut -d' ' -f2-)
#     # todo: environment set for default opt
#     local DEFAULT_OPTS_HEIGHT="--height=90%"
#     local DEFAULT_OPTS_PREVIEW_WINDOW="--preview-window=down,75%,wrap"
#     case "$ARGS" in
#         'co '* | 'checkout '* )
#             _git_sub_command=$_GIT_SUB_COMMAND_ENUM_CHECKOUT
#             local branches=$(git branch -vv --all)
#             # tr -s " ": replace multiple spaces with only one
#             # cut -d" " -f1: output 1st column seperated by " "
#             _fzf_complete $DEFAULT_OPTS_HEIGHT $DEFAULT_OPTS_PREVIEW_WINDOW --preview 'b=$(echo {} | sed "s/^\t*\*//" | tr -s " " | xargs | cut -d" " -f1); git lga $b -10' -- "$@" < <(
#                 echo $branches
#             )
#             ;;
#         'rebase '* | 'rbi '* )
#             _git_sub_command=$_GIT_SUB_COMMAND_ENUM_REBASE
#             # format placeholder ("git show --help" for more)
#             # %h abbreviated commit hash
#             # %s subject
#             # %b body, %B raw body (unwrapped subject and body)
#             # %cr committer date, relative
#             # %an author name
#             # %n newline
#             # >(40) padding on the left to make the next placeholder take at least 40 columns
#             local commits=$(git log --color --pretty=format:"%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset")
#             _fzf_complete $DEFAULT_OPTS_HEIGHT $DEFAULT_OPTS_PREVIEW_WINDOW --preview 'git show --stat --color --pretty=format:"%Cred%h%Creset%n%B%>(40)%Cgreen(%cr)%C(bold blue) <%an>%Creset%n" {1}' -- "$@" < <(
#                 echo $commits
#             )
#             ;;
#         'add '* | 'diff'* )
#             _git_sub_command=$_GIT_SUB_COMMAND_ENUM_ADD
#             COMMAND="git -c color.status=always status --short | xargs -L1"
#             local files=$(eval $COMMAND)
#             # "git ls-files --error-unmatch FILE" will exit 1 if file is inexistent
#             _fzf_complete $DEFAULT_OPTS_HEIGHT --multi --nth 2.. --preview-window right,70%,wrap --preview 'git ls-files --error-unmatch {-1} >/dev/null 2>&1 && (git diff --color=always -- {-1} | sed 1,4d) || bat --style=plain {-1}' -- "$@" < <(
#                 echo $files
#             )
#             ;;
#         * )
#             eval "zle ${fzf_default_completion:-expand-or-complete}"
#             ;;
#     esac
#     _git_sub_command=  # reset
# }

# _fzf_complete_g() { _fzf_complete_git "$@" }
