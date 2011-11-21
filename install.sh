#!/bin/sh
CONFIG_HOME=~/.config

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

[ -e "~/.config" ] && die "~/.config already exists."

git clone git://github.com/miiicasa/linux-config.git "$CONFIG_HOME"

cd "$CONFIG_HOME"
git submodule update --init

cd ~
ln -s .config/.vim .vim
ln -s .config/.vim/.vimrc .vimrc
ln -s .config/.zshrc .zshrc
ln -s .config/.tmux.conf .tmux.conf
ln -s .config/.gitconfig .gitconfig
ln -s .config/git_diff_wrapper git_diff_wrapper

echo -n "Please input your user name for Git configuration (ex. Joseph Chiang): "
read user_name
git config -g user.name $user_name
echo -n "Please input your email for Git configuration (ex. joseph_chiang@miiicasa.com): "
read user_email
git config -g user.email $user_email

cd "${CONFIG_HOME}/.vim"
git submodule update --init

echo "miiiCasa configuration file has been installed."
