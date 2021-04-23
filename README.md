# dotfiles
Various dotfiles for personal use.

## Description
Collection of personal dotfiles for use on my own systems.  Mostly 
leverages others' work, plus customizations added by myself. 

- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- Powerlevel10k zsh theme by [Roman Perepelitsa](https://github.com/romkatv/powerlevel10k)
- Oh My Tmux by [Gregory Pakosz](https://github.com/gpakosz/.tmux)
- Various bits and pieces by [myself](https://github.com/zerobaud)

Dotfiles here can be installed on most any unix-like system utilizing the 
included bootstrap.sh script.  Run `bootstrap.sh -h` for usage.  Existing 
files will be backed up into `~/.dotfiles.bak.$date`.

Tested on MacOS Mojave and Debian Stretch using recent versions of zsh.
Not tested on BSD, but should work just fine.
Cygwin?  All bets are off, you monster.

## Components
For now:

- zsh (.zshrc, .zshenv, .zprofile, .zlogin, .zlogout)
- vim (.vimrc)
- tmux (.tmux.conf, .tmux.conf.local
- bootstrap.sh (installs required files, makes backups in `$HOME/.dotfiles.bak.$date`)

The `bootstrap.sh` script will check out oh-my-zsh and powerlevel10k if needed.

## Installation
Should be easy:

1. Ensure you have `zsh`, `curl`, and `git` installed.
2. Clone this repository.  Make sure you check it out recursively!

	`git clone --recursive https://github.com/zerobaud/dotfiles.git`
 
3. Run `bootstrap.sh`.

## Enjoy!
