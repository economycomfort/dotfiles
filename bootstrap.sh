#!/usr/bin/env bash
#
# Copies various dotfiles into place.
#
# Checks to ensure git and curl are installed.
# Installs oh-my-zsh into $HOME.
# Symlinks (optionally copies) dotfiles within the same directory as this script into $HOME.
# Creates backups of any originals in $HOME/.dotfiles.bak.$datestamp.
#
# economycomfort @ github
# https://github.com/economycomfort/dotfiles
#
set -e

# A few variables to define where to grab content.
URL_OHMYZSH="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
URL_P10K="https://github.com/romkatv/powerlevel10k.git"
URL_TMUX="https://github.com/gpakosz/.tmux.git"
URL_ZSH_SYNTAX="https://github.com/zsh-users/zsh-syntax-highlighting.git"

# dotfiles to symlink
DOTFILES=(
  ".p10k.zsh"
  ".vimrc"
  ".zlogin"
  ".zlogout"
  ".zshenv"
  ".zshrc"
  "tmux/.tmux.conf"
  "tmux/.tmux.conf.local"
)

###
### Perform preflight checks.
###
preflight () {

  # Check to make sure we have the right tools installed.
  prereqs="zsh curl git"
  for i in $prereqs; do
    test -x $(which $i) || {
      echo -e "${textred}$i needs to be installed to continue.${textnorm}";
      exit 1;
    }
  done

  # We need to understand what path this script is in.
  # If not, there's a risk we destroy a home directory with useless symlinks.
  # If we're in the same directory as this script, we'll use $PWD.
  bootstrap_path=$(dirname $0)
  if [[ $bootstrap_path == "." ]]; then
    bootstrap_path=$PWD
  fi
}

###
### Setup the environment.
###
setup () {
  # Make a directory to store backups of original files.
  datestamp=$(date +%Y%m%d-%H%M)
  backupdir="${HOME}/.dotfiles.bak.$datestamp"
  
  echo -e "${textgreen}+${textnorm} Creating backup directory: $backupdir"
  mkdir -p $backupdir

  # Install oh-my-zsh framework
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    echo -e "${textwhite}-${textnorm} oh-my-zsh appears to already be installed; skipping."
  else
    sh -c "$(curl -fsSL $URL_OHMYZSH) --unattended" &>/dev/null
  fi  
  
  # Install powerlevel10k theme
  if [[ -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    echo -e "${textwhite}-${textnorm} powerlevel10k appears to already be installed; skipping."
  else
    echo -e "${textgreen}+${textnorm} Installing powerlevel10k theme"
    git clone --quiet $URL_P10K ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
  fi

  # Install zsh-syntax-highlighting plugin
  if [[ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
    echo -e "${textwhite}-${textnorm} zsh-syntax-highlighting plugin appears to already be installed; skipping."
  else
    echo -e "${textgreen}+${textnorm} zsh-syntax-highlighting plugin"
    git clone --quiet $URL_ZSH_SYNTAX ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  fi

  # Install tmux files
  if [[ -d "tmux" ]]; then
    echo -e "${textwhite}-${textnorm} tmux config files already installed; skipping."
  else
    echo -e "${textgreen}+${textnorm} Installing tmux config files"
    git clone --quiet $URL_TMUX tmux
  fi

}

###
### Link (or copy) the files.
###
placefiles () {
  # See -c command line argument
  if [[ $copyfiles == yes ]]; then
    cmd="cp -rp"
    verb="Copying"
  else
    cmd="ln -sf"
    verb="Symlinking"
  fi

  # Do it
  for file in ${DOTFILES[@]}; do
    if [[ -f "${HOME}/$(basename ${file})" ]]; then
      mv "${HOME}/$(basename ${file})" $backupdir
    fi
    $cmd "${PWD}/${file}" "${HOME}/$(basename ${file})" || fail=1

    if [[ $fail == 1 ]]; then
      echo "${textred}!${textnorm} Unable to $verb ${HOME}/$(basename $file).  Permissions?"
    fi
  done
  echo -e "${textgreen}+${textnorm} ${verb} done.  Originals backed up in $backupdir."
}

###
### Run any OS-specific operations after environment has been set up.
###
postflight () {
  case $(uname) in
    Darwin)
      echo -e "${textwhite}-${textnorm} No MacOS-specific postflight actions to take."
      ;;
    Linux)
      echo -e "${textwhite}-${textnorm} No Linux-specific postflight actions to take."
      ;;
    *BSD)
      echo -e "${textwhite}-${textnorm} No BSD-specific postflight actions to take."
      ;;
  esac
}

###
### Print usage instructions.
###
usage () {
  echo "Usage: $0 (-chsy)"
  echo
  echo "  -c: Copies dotfiles instead of symlinking them (default: symlink)"
  echo "  -s: Sets default shell to zsh (default: no, will prompt for user password)"
  echo "  -y: Do not run interactively; jump right in (default: interactive)"
  echo "  -h: Prints this help message"
  echo
}

###
### Here we go!
###
# Validate command line options
while getopts ":chqsy" options; do
  case $options in
    c)
      copyfiles="yes"
      ;;
    h)
      usage
      exit 0
      ;;
    s)
      chsh="yes"
      ;;
    y)
      interactive="no"
      ;;
    *)
      echo "Unrecognized argument: ${OPTARG}"
      usage 1>&2
      exit 1
      ;;
  esac
done

# Define a few fancy colors
textgreen="\033[1;32m"
textred="\033[1;31m"
textwhite="\033[1;37m"
textnorm="\033[0m"

# Define a user help message to display by default
info=$(cat <<-EOF

  ${textgreen}This script will:${textnorm}
      
    - Install the oh-my-zsh framework into ${HOME}/.oh-my-zsh;
    - Install the powerlevel10k zsh theme into ${HOME}/.oh-my-zsh/custom/themes;
    - Install extra zsh modules into ${HOME}/.oh-my-zsh/custom/plugins;
    - Symlink (or copy, depending on usage) several dotfiles into ${HOME};
    - Attempt to back up any existing files into ${HOME}/.dotfiles.bak.XXXXXXXX.

  ${textgreen}Note:${textnorm}

  The prompt theme for zsh may require a nerdfont-patched font for certain 
  characters to display appropriately.  Please ensure the terminal you're using 
  is using a monospaced nerdfont (I prefer SauceCodePro, but many look good.)  

  ${textwhite}For more information on patched fonts:${textnorm}

  https://www.nerdfonts.com
  
EOF
)

# Read user input (if run non-interactively, will skip - see "-y" option)
if [[ $interactive != no ]]; then
  echo -e "$info"
  echo -ne "${textwhite}Proceed? [y/n]${textnorm} "
  read resp
else
  echo -e "${textgreen}Here we go${textnorm}"
  resp="y"
fi
  
# If user agrees, or script is running non-interactively, do it.
case $resp in
  Y|y)
    preflight
    setup
    placefiles
    postflight

    if [[ $chsh == yes ]]; then
      echo -e "${textwhite}-${textnorm} Changing user shell to $(which zsh), password prompt to follow:"
      chsh -s $(which zsh) || echo -e "${textred}!${textnorm} Unable to set shell to $(which zsh)."
    else
      echo
      echo "Don't forget to set your default shell to zsh, try: chsh -s \$(which zsh)"
    fi
    echo -e "${textwhite}Done!${textnorm}"
    ;;
  *)
    echo "${textred}Cancelled by user. ${textnorm} "
    exit 1
    ;;
esac