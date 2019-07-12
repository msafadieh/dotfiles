# VARIABLES
export PATH=/usr/bin:~/.local/bin:~/.cargo/bin
export ZSH="/home/mhmd/.oh-my-zsh"
export EDITOR='vim'
export GPG_TTY=$(tty)
export LC_ALL=en_US.UTF-8

# OH-MY-ZSH CONFIG
ZSH_THEME="lambda-gitster"
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
plugins=(git python zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ALIASES
alias ld-off='xrandr --output eDP --off'
alias vassar='ssh msafadieh@mote.cs.vassar.edu'
alias vps='ssh -p 961 mhmd@msafadieh.com'
alias eduroam='sh ~/.scripts/setup_eduroam.sh'
alias gpg-pass='sh ~/.scripts/get-gpg.sh' 
alias check-bat='upower -i /org/freedesktop/UPower/devices/battery_BAT0'

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

