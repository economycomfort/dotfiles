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
    welcome=(
      "Welcome to"
      "You're on"
      "All aboard"
    )
    tagline=(
      "'Sup dog"
      "Toot, toot!"
      "Hootie-hoo"
      "ATL HOE"
      "Choot 'em!"
      "ft. Ludacris"
    )
    hostname="$(hostname)"
    length=$(( ${#hostname}*2+3 )) # calc width padding for 'wideterm' font
    t_msg=${welcome[$(( $RANDOM % ${#welcome[@]} + 1 ))]} # choose a welcome logo
    b_msg=${tagline[$(( $RANDOM % ${#tagline[@]} + 1 ))]} # choose a tag line

    # make $t_msg look better if $hostname is on the longer side
    if (( $length > 22 )); then
      t_msg=$(
        for (( i=0; i<${#t_msg}; i++ )); do
          echo -n "${t_msg:$i:1}"; echo -n " " # 'text' -> 't e x t'
        done 
      )
    fi
    
    if (( $length >= ${#t_msg} )); then # print $t_msg if shorter than $length
      # turns out zsh can pad strings on left and right, see below  
      print -r - ${(l[length/2][ ]r[length-length/2-1][ ])t_msg}
    fi
    $commands[toilet] --font wideterm -F border -F gay "$hostname"
    if (( $length >= ${#t_msg} )); then # print $b_msg if shorter than $length
      print -r - ${(l[length/2][ ]r[length-length/2-1][ ])b_msg}
    fi
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
