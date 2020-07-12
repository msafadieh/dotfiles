# ENV VARIABLES
export PATH=$HOME/.local/bin:$PATH
export HISTFILE=$HOME/.cache/zsh_history
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='vim'
export SYSTEMD_EDITOR=$EDITOR
export WEECHAT_HOME=$HOME/.config/weechat
export LC_ALL=en_US.UTF-8
export MOZ_ENABLE_WAYLAND=1

# ALIASES
alias amend='git commit --amend --no-edit'
alias ls="lsd"
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

# start sway 
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec sway
fi

ZSH_THEME="robbyrussell"
plugins=(fast-syntax-highlighting git)

# vi key bindings
bindkey -v 

autoload -Uz history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -M vicmd '^[[A' history-beginning-search-backward-end \
                 '^[OA' history-beginning-search-backward-end \
                 '^[[B' history-beginning-search-forward-end \
                 '^[OB' history-beginning-search-forward-end \
				 v edit-command-line

bindkey -M viins '^[[A' history-beginning-search-backward-end \
                 '^[OA' history-beginning-search-backward-end \
                 '^[[B' history-beginning-search-forward-end \
                 '^[OB' history-beginning-search-forward-end

source $ZSH/oh-my-zsh.sh
