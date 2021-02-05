#!/bin/zsh
#
# Bootstraps a fresh zsh environment.
#
# Checks to ensure git, curl, and zsh are installed.
# Installs oh-my-zsh into $HOME.
# Symlinks dotfiles within the same directory as this script into $HOME.
# Creates backups of any originals in $HOME/.dotfiles.orig.$datestamp.
# Sets user's default shell to zsh.
#
# David Brooks <dabrooks@outlook.com>
# https://github.com/zerobaud
#
set -e

# A few variables to define where to grab content.
URL_OHMYZSH="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
URL_P10K="https://github.com/romkatv/powerlevel10k.git"
URL_ZSH_SYNTAX_HIGHLIGHTING="https://github.com/zsh-users/zsh-syntax-highlighting.git"

# Filename patterns to exclude from symlinking.
EXCLUDE=(
    "bootstrap.*"
    "\.exclude*"
    "\.swp"
    "\.git$"
    "\.gitignore$"
    ".*.md"
)

### Perform some preflight checks.
preflight () {

    # Check to make sure we have the right tools installed.
    prereqs=(zsh curl git)
    for i in $prereqs; do
        which -s $i || {
            echo "$i needs to be installed to continue.";
            exit 1;
        }
    done

}

### Setup our environment.
setup () {
    
    # Make a directory to store backups of original files.
    datestamp=`date +%Y%m%d-%H%M`
    backupdir="${HOME}/.dotfiles.orig.$datestamp"
    echo "+ Creating backup directory: $backupdir"
    mkdir -p $backupdir

    # Install oh-my-zsh framework
    if [ -d $HOME/.oh-my-zsh ]; then
        echo "+ oh-my-zsh appears to already be installed; skipping."
    else
        sh -c "$(curl -fsSL $URL_OHMYZSH) --unattended"
    fi  
    
    # Install powerlevel10k theme
    if [ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]; then
        echo "+ powerlevel10k appears to already be installed; skipping."
    else
        git clone $URL_P10K ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi

    # Install zsh-syntax-highlighting plugin
    if [ -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
        echo "+ zsh-syntax-highlighting plugin appears to already be installed; skipping."
    else
        git clone $URL_ZSH_SYNTAX_HIGHLIGHTING ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi

}

### Link our files.
link () {

    exclude_string=`echo $EXCLUDE | sed -E 's/ /|/g'`

    for file in $( ls -A | grep -vE $exclude_string ) ; do
        if [ -f $HOME/$file ]; then  
            mv "$HOME/$file" $backupdir
        fi
        ln -sf $PWD/$file $HOME || echo "(!!!) Unable to symlink $HOME/$file."
    done
    echo "+ Symlinking done.  Originals backed up in $backupdir."

}

### Run any operations after environment has ben set up..
postflight () {

    # Any operating system-specific postflight actions.
    case `uname` in
        Darwin)
            echo "+ No MacOS-specific postflight actions to take."
            ;;
        Linux)
            echo "+ No Linux-specific postflight actions to take."
            ;;
        *BSD)
            echo "+ No BSD-specific postflight actions to take."
            ;;
    esac

    # Change user's default shell to zsh.
    chsh -s `which zsh` || echo "! Unable to set default shell to zsh."

}

cat << EOF
This script will set up a zsh environment and symlink several dotfiles into 
$HOME.

The prompt theme for zsh may require a nerdfont-patched font for certain 
characters to display appropriately.  Please ensure the terminal you're using 
is using a monospaced nerdfont (I prefer SauceCodePro, but many look good.)  

For more information:
https://www.nerdfonts.com

Proceed? [y/n]
EOF
read resp
case $resp in
    Y|y)
        preflight
        setup
        link
        postflight
        echo "Done!"
        ;;
    *)
        echo "Cancelled by user."
        exit 1
        ;;
esac
