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
  
  # Hostname toilet art
  if (( $+commands[toilet] )); then
    echo
    welcome="Welcome to"
    hostname="$(hostname)"
    length=$(( ${#hostname}*2+3 )) # calc width padding for 'wideterm' font
 
    # make things look better if $hostname is on the longer side
    if [[ $length > 22 ]]; then
      welcome=$(
        for (( i=0; i<${#welcome}; i++ )); do
          echo -n "${welcome:$i:1}"; echo -n " " # 'str' -> 's t r'
        done 
      )
    fi
    
    # turns out zsh can pad strings on left and right, see below  
    print -r - ${(l[length/2][ ]r[length-length/2-1][ ])welcome}
    $commands[toilet] --font wideterm -F gay -F border $hostname
  fi

  # Print a random fortune.
  if (( $+commands[fortune] )); then
    echo
    fortune -s
    echo
  fi

} >&2
