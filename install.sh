#!/usr/bin/env sh

# Install vim-plug for vim
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Install vim-plug for neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Symlink configuration files
pwd=$(pwd)

# vim
ln -sv "${pwd}/.vimrc" "$HOME/.vimrc"

ln -sv "${pwd}/.config/nvim/init.vim" "$HOME/.config/nvim/init.vim"

# tmux
ln -sv "${pwd}/.tmux.conf" "$HOME/.tmux.conf"

# i3
i3_config_path="$HOME/.config/i3/config"
mkdir -p $(dirname "$i3_config_path")
ln -sv "${pwd}/.config/i3/config" "$i3_config_path"
