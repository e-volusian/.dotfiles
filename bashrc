# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files
# (in the package bash-doc) for examples

# Exit if not running interactively
case $- in
  *i*) ;;
  *) return;;
esac

# next line effectively makes tmux your shell
# If not running interactively, do not do anything
# [[ -z "$TMUX" ]] && exec env TERM=screen tmux
# [[ $- != *i* ]] && return
# [[ -z "$TMUX" ]] && exec tmux

# ======================================================================| HISTORY

HISTCONTROL=ignoredups:erasedups  # no duplicate entries
HISTSIZE=9876                     # default usually 1k
HISTFILESIZE=98765                # big big history
shopt -s histappend               # append to history, don't overwrite it

# Save and reload the history after each command finishes
# https://www.gnu.org/software/bash/manual/html_node/Bash-History-Builtins.html
PROMPT_COMMAND="history -a;history -c;history -r;"

# ======================================================================| COLOR

# This variable will control color accross the board
COLORIZE=yes # yes or no

# Enable color support for ls (related aliases in ~/.alias)
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && \
      eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Make sure always in 256-color mode
# export TERM=xterm-256color

# ======================================================================| PROMPT

if [ $UID -eq 0 ] ; then PS1INDICATOR="#" ; else PS1INDICATOR="$" ; fi
if [ "$COLORIZE" = yes ]; then
  BLACK="\[$(tput setaf 0)\]"
  REDDD="\[$(tput setaf 1)\]"
  GREEN="\[$(tput setaf 2)\]"
  YELLO="\[$(tput setaf 3)\]"
  BLUEE="\[$(tput setaf 4)\]"
  MAGEN="\[$(tput setaf 5)\]"
  CYANN="\[$(tput setaf 6)\]"
  WHITE="\[$(tput setaf 7)\]"
  RESET="\[$(tput sgr0)\]"
  PTIME="${CYANN}\t${RESET}"
  PHOST="${GREEN}\h${RESET}"
  PSDIR="${YELLO}\w${RESET}"
  PS1="$PTIME $PHOST:$PSDIR"
else
  PS1="\t \h:\w"
fi
PS1="$PS1 $PS1INDICATOR "

# ======================================================================| MISC

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
# essentially what this does is provide logical results from…
#   commands such as "less example.tar" ; instead of saying…
#   "example.tar" may be a binary file.  See it anyway?
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Load aliases
if [ -f ~/.alias ]; then . ~/.alias ; fi

# Load fucntions
if [ -f ~/.functions ]; then . ~/.functions ; fi

# Load global environment
if [ -f /etc/environment ]; then . /etc/environment ; fi

# If using sshrc, pick up the most recent changes to .bashrc and .alias
if [ -f ~/bin/sshrc ]; then
  cat ~/.bashrc > ~/.sshrc
  echo -e '\n\n\n' >> ~/.sshrc
  cat ~/.alias >> ~/.sshrc
fi

# ======================================================================| INACTIVE

# Utilities for corporate proxy mgmt
# source $HOME/.proxy && proxy_check

# Enable spacing between commands
# NEXT LINE MUST BE THE LAST COMMAND IN BASHRC (if using)
# [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
# preexec() { echo ; }

# ======================================================================| FUNCTIONS

function command_exists () { type "$1" &> /dev/null ; }

# ======================================================================| PLATFORM-SPECIFIC

if grep -q Microsoft /proc/version ; then
  # running in bash.exe on windows (Windows Subsystem for Linux)
  # resolv.conf may populate incorrectly causing 30+ second login times
  # fix here
  # 2085d366e327d1307802955ff298041c2897fd79  /etc/resolv.conf
  CRC="2085d366e327d1307802955ff298041c2897fd79"
  R=$(sha1sum /etc/resolv.conf | grep -q $CRC)
  H=$(hostname)
  if [[ "$H" == *"SPEARE"* ]] && $R ; then
#    echo "Fixing broken resolv.conf..."
#    echo -e "nameserver 16.110.135.51\nnameserver 192.168.1.1\n" | sudo tee /run/resolvconf/resolv.conf > /dev/null
    touch /tmp/nop
  fi
fi

# ======================================================================| USER

PATH="$PATH:$HOME/.rbenv/bin:$HOME/bin:/n/scripts/sh" 
EDITOR="/usr/bin/vim"
PROMPT_DIRTRIM=3
if type -t rbenv > /dev/null ; then eval "$(rbenv init -)" ; fi 
if [ -f ~/.commacd.bash  ]; then . ~/.commacd.bash  ; fi
if command_exists sshrc ; then alias ssh=sshrc ; fi

cd $HOME
