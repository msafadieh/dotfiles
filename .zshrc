# VARIABLES
export PATH=~/.local/bin:~/.cabal/bin:$PATH
export ZSH="/home/mhmd/.oh-my-zsh"
export EDITOR='vim'
export SYSTEMD_EDITOR='vim'

# gpg stuff
export GNUPGHOME=$HOME/.config/gnupg
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null

# locale
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
alias vassar='ssh -p 443 msafadieh@mote.cs.vassar.edu'

# vi key bindings
bindkey -v
export KEYTIMEOUT=1

# enable line search on arrow up/down
bindkey -v "^[OA" up-line-or-beginning-search
bindkey -v "^[OB" down-line-or-beginning-search

mkdir -p ~/.cache/X11
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx >> ~/.cache/X11/stdout 2>> ~/.cache/X11/stderr
fi
