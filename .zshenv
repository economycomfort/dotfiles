# ~/.zshenv
#
# Defines default ZSH environment variables.
# 

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Updates $PATH for Google Cloud SDK.
if [ -f $HOME/Documents/GCP/google-cloud-sdk/path.zsh.inc ]; then
    . $HOME/Documents/GCP/google-cloud-sdk/path.zsh.inc
fi

# Enables command completion for Google Cloud SDK.
if [ -f $HOME/Documents/GCP/google-cloud-sdk/completion.zsh.inc ]; then
    . $HOME/Documents/GCP/google-cloud-sdk/completion.zsh.inc
fi

# Some user-defined, nonstandard binary locations.
if [ -d $HOME/.local/bin ]; then
    PATH="$PATH:$HOME/.local/bin"
fi

# Export the $PATH (should always be last, probably)
export $PATH

