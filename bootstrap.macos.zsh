#!/bin/zsh
#
# Bootstraps a fresh macos environment.
#

### Some user-defined variables, change if necessary.
EXCLUDE="./exclude"     # List of files to exclude from bootstrap.

### Initialize our environment.
init () {
    
    # Does the exclude list exist?  
    # If so, read it into an array. If not, bail out because you probably need it.
    if [[ -f $EXCLUDE ]]; then
        exclude_list=(`cat $EXCLUDE`)
    else
        echo "Exclude list \"${EXCLUDE}\" not found.  Aborting."
        exit 1
    fi

    # Make a directory to store backups of original files.
    local datestamp=`date +%Y%m%d-%H%M`
    backupdir="~/.dotfiles.orig.$datestamp"
    mkdir -p $backupdir

}

### Link our files.
link () {

    echo "This utility will symlink the files in this repo to $HOME."
	echo "Proceed? (y/n)"
	read local resp
	
    case $resp in
        [Yy])
            for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ) ; do
                ln -sv "$PWD/$file" "$HOME"
            done
            ;;
        *)
            echo "Cancelled by user."
            rm $backupdir
            exit 1
            ;;
    esac        

}

# Clone our ZFS framework of choice.
#git clone --recursive https://github.com/changs/slimzsh.git ~/.slimzsh
