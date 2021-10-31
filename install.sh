#!/usr/bin/env bash

#set -e    # exit script when error happens
#set -u    # report error if visiting undeclared variable

prepare() {
    export DOTFILES_HOME=$HOME/.dotfiles

    [[ ! -e $DOTFILES_HOME ]] && git clone https://github.com/fjchen7/dotfiles $DOTFILES_HOME
    source $DOTFILES_HOME/zsh/zshenv  # load environment varibales
    source $DOTFILES_HOME/bin/_msg    # helper functions for print
}

setup_zsh() {
    local configs=(zshrc zshenv)
    for i in "${configs[@]}"; do
        local softlink=$HOME/.$i
        local target=$DOTFILES_ZSH_HOME/$i
        local yn="y"
        if [[ -e $softlink ]]; then
            _print_ask "Do you want to overwrite $softlink? [y/n]"
            read -n 1 yn
        fi
        [[ $yn != 'y' ]] && _print_info "Won't overwrite $softlink" && continue
        ln -sf $target $softlink && _print_info "create soft link $softlink"
    done

    local local_configs=(zshenv zshrc)
    for i in "${local_configs[@]}"; do
        local file=$DOTFILES_ZSH_HOME/$i.local
        [[ ! -e $file ]] && cp $file.example $file
    done
    # install oh-my-zsh
    [[ ! -d $HOME/.config ]] && mkdir -p $HOME/.config
    ZSH=$HOME/.config/oh-my-zsh
    ZSH_CUSTOM=$ZSH/custom
    if [[ ! -d $ZSH ]]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        mv $HOME/.oh-my-zsh $ZSH
    fi
    ln -sf $DOTFILES_HOME/zsh/custom $ZSH_CUSTOM
}

setup_cheatsheets() {
    _print_info "Start setting up cheatsheet"
    local yn="n"
    if [[ -e $CHEATSHEETS_HOME ]]; then
        _print_info "$CHEATSHEETS_HOME exits. Won't do anything."
    else
        _print_ask "Do you want to create $CHEATSHEETS_HOME? [y/n]"
        read -n 1 yn
    fi
    [[ yn != "y" ]] && return

    local target=
    _print_ask "Prepare to crate soft link $CHEATSHEETS_HOME, please input the target directory: "
    read target
    [[ ! -e $target ]] && _print_fail "target cheatsheet directory $target does not exsit!" && return
    ln -s $target $CHEATSHEETS_HOME

    _print_info "End setting up cheatsheets"
}

setup_git() {
    _print_info "Start setting up git"
    local DOTFILES_GIT_HOME=$DOTFILES_HOME/git
    local configs=(gitconfig gitignore)
    for i in "${configs[@]}"; do
        local softlink=$HOME/.$i
        local target=$DOTFILES_GIT_HOME/$i
        local yn="y"
        if [[ -e $softlink ]]; then
            _print_ask "Do you want to overwrite $softlink? [y/n]"
            read -n 1 yn
        fi
        [[ $yn != 'y' ]] && _print_info "Won't overwrite $softlink" && continue
        ln -sf $target $softlink && _print_info "create soft link $softlink"
    done

    local file=$DOTFILES_GIT_HOME/gitconfig.local
    [[ ! -e $file ]] && cp $file.example $file
    # -q quiet
    if grep -Fq "USERNAME" $file; then
        _print_info 'setup gitconfig.local'
        _print_ask ' - What is your github user name?'
        read -e user_name
        _print_ask ' - What is your github user email?'
        read -e user_email

        sed -i '' -e "s/USERNAME/$user_name/g" -e "s/USEREMAIL/$user_email/g" $file
        _print_info 'Git user name and email configured.'
    fi
    if [[ -z "$(command -v diff-so-fancy)" ]]; then
        git clone https://github.com/so-fancy/diff-so-fancy $HOME/.local/diff-so-fancy
        ln -s $HOME/.local/diff-so-fancy/diff-so-fancy /usr/local/bin/diff-so-fancy
    fi
    _print_info "End setting up git"
}

setup_vim() {
    _print_ask "Do you want to set up vim? [y/n]"
    read -n 1 yn
    [[ $yn != 'y' ]] && return

    _print_info "Start setting up vim"
    [[ ! -e $XDG_CACHE_HOME/vim ]] && mkdir -p $XDG_CACHE_HOME/vim
    [[ ! -e $XDG_CONFIG_HOME/vim ]] && ln -s $DOTFILES_HOME/vim $XDG_CONFIG_HOME/vim
    [[ ! -e $HOME/.vim ]] && ln -s $DOTFILES_HOME/vim $HOME/.vim
    [[ ! -e $HOME/.vimrc ]] && ln -s $DOTFILES_HOME/vim/vimrc $HOME/.vimrc
    [[ ! -e $HOME/.ideavimrc ]] && ln -s $DOTFILES_HOME/vim/ideavimrc $HOME/.ideavimrc

    # install vim plugin manager
    local vim_bundle=$XDG_CONFIG_HOME/vim/bundle
    [[ ! -e $vim_bundle ]] && mkdir -p $vim_bundle
    [[ ! -e $vim_bundle/Vundle.vim ]] && git clone https://github.com/VundleVim/Vundle.vim.git $vim_bundle/Vundle.vim
    vim +PluginInstall +qall  # install vim plugins from CLI
    _print_info "End setting up vim"
}

setup_tmux() {
    _print_info "Start setting up tmux configuration"
    local DOEFILES_TMUX_HOME=$DOTFILES_HOME/tmux
    ln -s $DOEFILES_TMUX_HOME/tmux.conf $HOME/.tmux.conf
    ln -s $DOEFILES_TMUX_HOME/tmux.conf.local $HOME/.tmux.conf.local

    _print_info "End setting up tmux configuration"
}

setup_tools() {
    ln -s $DOTFILES_HOME/hammerspoon $HOME/.hammerspoon
    ln -s $DOTFILES_HOME/karabiner/karabiner.edn $XDG_CONFIG_HOME/karabiner.edn

    _print_ask "Do you want to set up tools? [y/n]"
    read -n 1 yn
    [[ $yn != 'y' ]] && return

    _print_info "Start setting up tools"

    [ -z "$(command -v python3)" ] && sudo apt-get -y install python3.8
    [ -z "$(command -v pip3)" ] && sudo apt-get -y install python3-pip
    [[ -z "$(command -v tmux)" ]] && sudo apt-get -y install tmux

    while read -r line; do
        bash -c "$line"
    done < <(cat $DOTFILES_HOME/tools/install.sh)

    setup_tools_config

    _print_info "End setting up tools"
}

setup_tools_config() {
    _print_info "Start setting up tools configuration"
    local DOEFILES_CONFIG_HOME=$DOTFILES_HOME/config

    [[ ! -e $XDG_CONFIG_HOME/bat ]] && mkdir $XDG_CONFIG_HOME/bat
    ln -s $DOEFILES_CONFIG_HOME/bat.config $XDG_CONFIG_HOME/bat/config
    ln -s $DOEFILES_CONFIG_HOME/tldrrc $HOME/.tldrrc

    _print_info "End setting up tools configuration"
}

prepare
setup_zsh
setup_git
setup_vim
setup_tmux
setup_cheatsheets
setup_tools
