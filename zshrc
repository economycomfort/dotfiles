# ~/.zshrc
# 
# ZSH environment interactive session setup.
#

GOOGLESDK="$HOME/Documents/GCP/google-cloud-sdk"

###
### ZSH frameworks
###
# Source slimzsh.
source $HOME/.slimzsh/slim.zsh

###
### ZSH prompt customization
###
# Powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Pure
# Handled from slimzsh.
# See: https://github.com/sindresorhus/pure/tree/42d3b83647e6bc9ce9767f6f805ee054fd9710cf
#export PURE_PROMPT_SYMBOL='#'


###
### Shell customizations
###
# Set the correct terminal type.
export TERM="xterm-256color"

# Improve how ZSH handles command history.
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks   # remove superfluous blanks from history items
setopt inc_append_history   # save history entries as soon as they are entered
setopt share_history        # share history between different instances of the shell

# Auto cd
setopt auto_cd              # cd by typing directory name if it's not a command

# Autocorrect command typos
setopt correct_all          # autocorrect commands

# Improve how ZSH handles autocompletion
setopt auto_list            # automatically list choices on ambiguous completion
setopt auto_menu            # automatically use menu completion
setopt always_to_end        # move cursor to end if word had one match
zstyle ':completion:*' menu select      # select completions with arrow keys
zstyle ':completion:*' group-name ''    # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Correct behavior of delete key (in some terminals)
#bindkey '^[[3~' delete-char
#bindkey '^[3;5~' delete-char

# Make sure vim is our default editor.
#export EDITOR="vim"        # set by default in .zprofile

# Nebula scripts in $PATH
export PATH="$HOME/Documents/Vectra/scripts/nebula:$PATH"

# Google Cloud $PATH 
if [ -f "$GOOGLESDK/path.zsh.inc" ]; then
    . "$GOOGLESDK/path.zsh.inc"
fi

# Google Cloud ZSH completion
if [ -f "$GOOGLESDK/completion.zsh.inc" ]; then
    . "$GOOGLESDK/completion.zsh.inc"
fi
