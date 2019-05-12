# VARIABLES
export PATH=/usr/local/bin:/usr/bin:/bin:/home/mhmd/bin:/usr/local/sbin:/usr/sbin:/home/mhmd/.local/bin
export ZSH="/home/mhmd/.oh-my-zsh"
export EDITOR='vim'

# OH-MY-ZSH CONFIG
ZSH_THEME="bira"
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
plugins=(git python zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ALIASES
alias code='vscodium'
alias vassar='ssh msafadieh@mote.cs.vassar.edu'
alias vps='ssh root@msafadieh.com'
alias pause='cmus-remote -u'
alias play='cmus-remote -p'
alias music='cmus-remote -Q'
