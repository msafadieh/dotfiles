# VARIABLES
export PATH=/usr/bin:~/.local/bin:~/.cabal/bin
export ZSH="/home/mhmd/.oh-my-zsh"
export EDITOR='vim'
export SYSTEMD_EDITOR='vim'
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null
export LC_ALL=en_US.UTF-8

# OH-MY-ZSH CONFIG
ZSH_THEME="lambda-gitster"
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
plugins=(git python systemd zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ALIASES
alias ld-off='xrandr --output eDP --off'
alias vassar='ssh msafadieh@mote.cs.vassar.edu'
alias vps='ssh -p 961 mhmd@msafadieh.com'
alias eduroam='sh ~/.scripts/setup_eduroam.sh'
alias vpn-off='~/.scripts/turn-off-vpn.sh'

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx -- vt1 &> /dev/null
fi
