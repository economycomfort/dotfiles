# dotfiles
Various dotfiles for personal use.

## Description
Collection of personal dotfiles for use on my own systems.  Probably nothing terribly unique or exciting, but should set up a decent ZSH environment and include some usable configs for vim, tmux, and other utilities as I need them.

Tested on MacOS Mojave and Debian Stretch using recent versions of ZSH.
Not tested on BSD, but should work just fine.
Cygwin?  All bets are off, you monster.

## Components
For now:

- ZSH (.zshrc, .zshenv, .zprofile, .zlogin, .zlogout)
- vim (.vimrc)
- bootstrap.sh (installs required components where necessary, symlinks dotfiles from the repo back into $HOME)

## Installation

1. Clone this repository.
2. Ensure you have zsh, curl, and git installed.
3. Run bootstrap.zsh.

Backups of any existing symlinked files will be saved in $HOME/.dotfiles.orig.$datestamp.

## Enjoy!
