# dotfiles
Various configuration files for personal use.

## Description
Collection of personal dotfiles for use on my own systems.  Mostly 
leverages others' work. 

- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) zsh theme by Roman Perepelitsa
- [Oh My Tmux](https://github.com/gpakosz/.tmux) by Gregory Pakosz
- Various bits and pieces by [myself](https://github.com/economycomfort)

Dotfiles here can be installed on most any Unix-like environment utilizing the included 
`install` script.  Run `install -h` for usage; there is some optional 
functionality.  Existing files will be backed up into `~/.dotfiles.bak.$date`.

Tested on recent versions of MacOS, Debian, and Ubuntu using recent versions of zsh.  I don't 
see why it wouldn't work on most anything, really.  Cygwin?  All bets are off, you monster.

## Components
For now:

- zsh: `.zshrc`, `.zshenv`, `.zprofile`, `.zlogin`, `.zlogout`
- vim: `.vimrc`
- tmux: `.tmux.conf`, `.tmux.conf.local`
- install: installs required files, makes backups in `$HOME/.dotfiles.bak.$date`

The `install` script will clone Oh My Zsh and Powerlevel10k if needed.

## Installation
Should be easy:

1. Ensure you have `zsh`, `curl`, and `git` installed.
2. Clone this repository:

	`git clone https://github.com/economycomfort/dotfiles.git ~/.dotfiles`
 
3. Run `install`.

4. Enjoy!

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Licensed under the MIT License.
See [LICENSE](LICENSE) file.
