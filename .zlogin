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
  echo
  
  # Hostname toilet art (only if SSH)
  if (( $+commands[toilet] )) && [[ $SSH_TTY ]]; then
    msg=(
      "Welcome to"
      "You're on"
      "'Sup dog"
      "Ay bay bay"
      "Toot, toot!"
      "Hootie-hoo"
      "All aboard"
    )
    hostname="$(hostname)"
    length=$(( ${#hostname}*2+3 )) # calc width padding for 'wideterm' font
    welcome=${msg[$(( $RANDOM % ${#msg[@]} + 1 ))]} # choose a random msg

    # make things look better if $hostname is on the longer side
    if (( $length > 22 )); then
      welcome=$(
        for (( i=0; i<${#welcome}; i++ )); do
          echo -n "${welcome:$i:1}"; echo -n " " # 'text' -> 't e x t'
        done 
      )
    fi
    
    if (( $length >= ${#welcome} )); then # print welcome msg if shorter than length
      # turns out zsh can pad strings on left and right, see below  
      print -r - ${(l[length/2][ ]r[length-length/2-1][ ])welcome}
    fi
    $commands[toilet] --font wideterm -F gay -F border $hostname
    echo
  
  elif (( ! $+commands[toilet] )) && [[ $SSH_TTY ]]; then
    echo "Missing login art? Install the 'toilet' package."
    echo
  
  fi

  # Print a random fortune.
  if (( $+commands[fortune] )); then
    fortune -s
    echo
  fi

} >&2
