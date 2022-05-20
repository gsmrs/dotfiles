#!/usr/bin/env sh

# Install vim-plug
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Symlink configuration files
pwd=$(pwd)

# vim
ln -s "${pwd}/.vimrc" "$HOME/.vimrc"

# tmux
ln -s "${pwd}/.tmux.conf" "$HOME/.tmux.conf"

# i3
i3_config_path="$HOME/.config/i3/config"
mkdir -p $(dirname "$i3_config_path")
ln -s "${pwd}/.config/i3/config" "$i3_config_path"
