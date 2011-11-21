Configuration
==========================
For ease of my personal configuration deployment.
It installs miiiCasa default .vimrc, .zshrc, .gitconfig, .tmux.conf and VIM plugins.

Installation
------------
Automatically install it without cloning this repository.

1. Backup your original configuration files if necessary.

     mv .gitconfig .gitconfig.bak;
     mv .vim .vim.bak;
     mv .vimrc .vimrc.bak;
     mv .zshrc .zshrc.bak;
     mv .tmux.conf .tmux.conf.bak;
     mv git_diff_wrapper git_diff_wrapper.bak;
     
1. Install everything with one-line command.

     wget -O - https://raw.github.com/miiicasa/linux-config/master/install.sh | sh
