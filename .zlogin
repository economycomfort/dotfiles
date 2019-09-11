# ~/.zlogin
#
# Commands to run when the ZSH session starts.
#

# Run the following in the background without affecting the current session.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Run only if interactive.
[[ -o INTERACTIVE && -t 2 ]] && {

  # Print a random fortune.
  if (( $+commands[fortune] )); then
    fortune -s
    print
  fi

} >&2
