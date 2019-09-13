#!/bin/zsh
#
# Bootstraps a fresh zsh environment.
#
set -e

# Filename patterns to exclude from symlinking.
EXCLUDE="bootstrap.*|\.exclude*|\.swp|\.git$|\.gitignore|.*.md"


### Initialize our environment.
init () {
    
    # Make a directory to store backups of original files.
    local datestamp=`date +%Y%m%d-%H%M`
    backupdir="${HOME}/.dotfiles.orig.$datestamp"
    echo "BOOTSTRAP: Creating backup directory: $backupdir"
    mkdir -p $backupdir

    # Clone our ZFS framework (slimzsh)
    if [[ ! -d $HOME/.slimzsh ]]; then 
        echo "BOOTSTRAP: Cloning SlimZSH into $HOME/.slimzsh:"
        git clone --recursive https://github.com/changs/slimzsh.git $HOME/.slimzsh
    else
        echo "BOOTSTRAP: (!!) SlimZSH appears to already be installed.  Skipping."
    fi
}

### Link our files.
link () {

	echo -n "BOOTSTRAP: This utility will install dotfiles into $HOME. Proceed? [y/n]: "
	read resp

    case $resp in
        Y|y)
            for file in $( ls -A | grep -vE $EXCLUDE ) ; do
                if [ -f ${HOME}/${file} ]; then  
                    mv "${HOME}/${file}" $backupdir
                fi
                ln -sf $PWD/$file $HOME || echo "BOOTSTRAP: (!!) Unable to symlink $HOME/$file."
            done
            echo "BOOTSTRAP: Symlinking complete."
            echo "BOOTSTRAP: Originals backed up in $backupdir."
            ;; 
        *)
            echo "BOOTSTRAP: (!!) Cancelled by user."
            rmdir $backupdir
            exit 1
            ;;
    esac        
}

### Install OS-specific tools where needed.
install_tools () {

    OS=`uname`

    # MacOS
    if [[ $OS == "Darwin" ]]; then
        echo "BOOTSTRAP: No MacOS-specific tools to install."
    fi

    # Linux
    if [[ $OS == "Linux" ]]; then
        echo "BOOTSTRAP: No Linux-specific tools to install."
    fi
}


init
link
install_tools
echo "BOOTSTRAP: Bye!"
