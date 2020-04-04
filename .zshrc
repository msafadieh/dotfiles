# ENV VARIABLES
export PATH=$HOME/.local/bin:$PATH
export HISTFILE=$HOME/.cache/zsh_history
export ZSH=$HOME/.oh-my-zsh
export EDITOR='vim'
export SYSTEMD_EDITOR=$EDITOR
export WEECHAT_HOME=$HOME/.config/weechat
export LC_ALL=en_US.UTF-8
export MOZ_ENABLE_WAYLAND=1
export XDG_CURRENT_DESKTOP=Unity

# ALIASES
alias vassar='ssh -p 443 msafadieh@mote.cs.vassar.edu'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias x='aunpack'

# colored man output
man() {
	LESS_TERMCAP_md=$'\e[01;31m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_se=$'\e[0m' \
	LESS_TERMCAP_so=$'\e[01;44;33m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[01;32m' \
	command man "$@"
}

# gpg stuff
export GNUPGHOME=$HOME/.config/gnupg
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null

# start X
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  mkdir -p ~/.cache/sway
  exec sway >> ~/.cache/sway/stdout 2>> ~/.cache/sway/stderr
fi

# autocompletion
autoload -U compaudit compinit
ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"
compinit -u -C -d "${ZSH_COMPDUMP}"
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES
zstyle ':completion::complete:*' gain-privileges 1

# vi key bindings
bindkey -v
export KEYTIMEOUT=1

# enable line search on arrow up/down
autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# spaceship prompt
autoload -U promptinit
promptinit
export SPACESHIP_ROOT=/usr/lib/spaceship-prompt/
prompt spaceship

PLUGINS=( $HOME/.local/lib/history.zsh
	  /usr/share/LS_COLORS/dircolors.sh
	  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	  /usr/share/z/z.sh )

for plugin in $PLUGINS; do
	[[ -r "$plugin" ]] && . "$plugin"
done
