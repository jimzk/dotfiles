#!/usr/bin/env bash

#set -e    # exit script when error happens
#set -u    # report error if visiting undeclared variable

echo_start() {
    echo "$(tput setaf 6)------$(tput sgr0) $*"
}
echo_ask() {
    echo "[ $(tput setaf 3)??$(tput sgr0) ] $*"
}
echo_info() {
    echo "[ $(tput setaf 5)..$(tput sgr0) ] $*"
}

safe_ln() {
    local -r target=$1
    local -r symlink=$2
    [[ ! -e $target ]] && echo "$(tput setaf 1)target $target does not exsit. Won't do symlink!$(tput sgr0)" && return

    local yn="y"
    if [[ -e $symlink ]]; then
        yn="n"
        echo_ask "$(tput setaf 2)$symlink$(tput sgr0) exists. Overwrite it? [y/n]"
        read -rn 1 yn
    fi
    if [[ $yn == "y" ]]; then
        rm "$symlink"
        ln -sf "$target" "$symlink"
        # \b to delete previous char
        echo -e "\bCreate symlink $(tput setaf 2)$symlink$(tput sgr0) -> $(tput setaf 5)$target$(tput sgr0)"
    else
        echo -e "\bWon't overwrite $(tput setaf 2)$symlink$(tput sgr0)"
    fi
}

prepare() {
    export DOTFILES_HOME=$HOME/.dotfiles
    [[ ! -e $DOTFILES_HOME ]] && git clone https://github.com/fjchen7/dotfiles "$DOTFILES_HOME"
    export XDG_CONFIG_HOME=$HOME/.config
    [[ ! -d $XDG_CONFIG_HOME ]] && mkdir -p "$XDG_CONFIG_HOME"
    # soft link oh-my-zsh custom configuration
    rm -rf $DOTFILES_HOME/config/oh-my-zsh/custom
    ln -sf $DOTFILES_ZSH_HOME/custom $DOTFILES_HOME/config/oh-my-zsh/custom
}

setup_zsh() {
    echo_start "Start to setup zsh"
    local local_configs=(zshenv zshrc)
    for i in "${local_configs[@]}"; do
        local file=$DOTFILES_HOME/zsh/$i.local
        [[ ! -e $file ]] && cp "$file.example" "$file" && echo "Create $file"
    done
}

setup_git() {
    echo_start "Start to setup git"

    local file=$DOTFILES_HOME/git/gitconfig.local
    [[ ! -e $file ]] && cp "$file.example" "$file" && echo "Create $file"

    # -q quiet
    if grep -Fq "USERNAME" "$file"; then
        echo 'setup gitconfig.local'
        echo_ask ' - What is your github user name?'
        read -re user_name
        echo_ask ' - What is your github user email?'
        read -re user_email

        sed -i '' -e "s/USERNAME/$user_name/g" -e "s/USEREMAIL/$user_email/g" "$file"
        echo 'Git user name and email are configured.'
    fi
}

setup_cheatsheets() {
    echo_start "Start to setup cheatsheet"
    CHEATSHEETS_HOME=$DOTFILES_HOME/cheatsheets
    local yn="n"
    if [[ -e $CHEATSHEETS_HOME ]]; then
        echo "$CHEATSHEETS_HOME exits. Won't do anything."
    else
        echo_ask "Create $CHEATSHEETS_HOME? [y/n]"
        read -rn 1 yn
    fi
    [[ $yn != "y" ]] && return

    local target=
    echo_ask "Prepare to crate symlink $CHEATSHEETS_HOME, please input the target directory: "
    read -r target
    safe_ln "$target" "$CHEATSHEETS_HOME"
}

setup_tools() {
    echo_start "Start to setup tools"
    echo_ask "Setup tools? [y/n]"
    read -rn 1 yn
    [[ $yn != 'y' ]] && echo_info "Won't steup tools" && return

    # install formulas
    brew update
    # basic
    brew install zsh starship tmux autojump bash vim less ripgrep exa fd fzf navi bat jq httpie procs gh git-extras git-delta koekeishiya/formulae/yabai yqrashawn/goku/goku
    # good tools
    brew install tree thefuck tokei beeftornado/rmtree/brew-rmtree pstree dust duf nnn
    # dev tools
    brew install python shellcheck yarn node cmake openssl
    # gnu replacement
    brew install coreutils findutils gnutls gnu-sed gnu-which gawk grep gnu-tar gzip watch
    # macos utility
    brew install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize suspicious-package apparency qlvideo

    # install nodejs package
    npm install -g tldr
}

setup_config() {
    echo_start "Start to setup ~/.config"

    safe_ln "$DOTFILES_HOME/config" "$XDG_CONFIG_HOME"
    local -r home_configs=( $(find "$XDG_CONFIG_HOME/HOME" -mindepth 1) )
    for file_path in "${home_configs[@]}"; do
        safe_ln "$file_path" "$HOME/.$(basename "$file_path")"
    done
}

prepare
setup_config
setup_tools
setup_zsh
setup_git
setup_cheatsheets
