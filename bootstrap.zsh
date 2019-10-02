#!/bin/zsh
#
# Bootstraps a fresh zsh environment.
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
    echo "(---) Creating backup directory: $backupdir"
    mkdir -p $backupdir

    # Install oh-my-zsh framework
    if [ -d $HOME/.oh-my-zsh ]; then
        echo "(---) oh-my-zsh appears to already be installed; skipping."
    else
        sh -c "$(curl -fsSL $URL_OHMYZSH) --unattended"
    fi  
    
    # Install powerlevel10k theme
    if [ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]; then
        echo "(---) powerlevel10k appears to already be installed; skipping."
    else
        git clone $URL_P10K ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi

    # Install zsh-syntax-highlighting plugin
    if [ -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
        echo "(---) zsh-syntax-highlighting plugin appears to already be installed; skipping."
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
    echo "(---) Symlinking done.  Originals backed up in $backupdir."

}

### Install additional OS-specific tools where needed.
install_tools () {

    OS=`uname`

    # MacOS
    if [[ $OS == "Darwin" ]]; then
        echo "(---) No MacOS-specific tools to install."
    fi

    # Linux
    if [[ $OS == "Linux" ]]; then
        echo "(---) No Linux-specific tools to install."
    fi

}

cat << EOF
This script will set up a ZSH environment and symlink several dotfiles into 
$HOME.

The prompt theme for ZSH may require a nerdfont-patched font for certain 
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
        install_tools
        echo "Done!"
        ;;
    *)
        echo "Cancelled by user."
        exit 1
        ;;
esac
