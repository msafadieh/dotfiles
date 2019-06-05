# VARIABLES
export PATH=/usr/local/bin:/usr/bin:/bin:/home/mhmd/bin:/usr/local/sbin:/usr/sbin:/home/mhmd/.local/bin
export ZSH="/home/mhmd/.oh-my-zsh"
export EDITOR='vim'
export GPG_TTY=$(tty)

# OH-MY-ZSH CONFIG
ZSH_THEME="bira"
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
plugins=(git python zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ALIASES
alias ssh='kitty +kitten ssh'
alias dualdis='xrandr --output VGA-1 --pos 1920x0 --output HDMI-1 --pos 0x0 --output LVDS-1 --off'
alias code='vscodium'
alias vassar='ssh msafadieh@mote.cs.vassar.edu'
alias vps='ssh mhmd@msafadieh.com'
alias eduroam='sh ~/.scripts/setup_eduroam.sh'

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

