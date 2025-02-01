if [ "$TERM" = "xterm-kitty" ]; then
   alias icat="kitty +kitten icat"
   alias ssh="kitty +kitten ssh"
   precmd () { print -Pn "\033]0;Kitty\a" }
fi

HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000

ZSH_THEME="robbyrussell"
DISABLE_AUTO_TITLE="true"

# zsh-newuser-install configuration
setopt autocd beep nomatch
unsetopt extendedglob
bindkey -v

zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines configured by zsh-newuser-install

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Environment variables
export ZSH="$HOME/.oh-my-zsh"
export ANDROID_HOME=/home/matteo/Android/Sdk
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/Documents/scripts
export MANPATH="/usr/local/man:$MANPATH"
export EDITOR="nvim"
export ARCHFLAGS="-arch x86_64"
export NVM_LAZY_LOAD=true

lf_enhanced() {
	export LF_TEMPDIR="$(mktemp -d -t lf-XXXXXX)"

	cd "$(command lf -print-last-dir "$@")"

	rm -rf "$LF_TEMPDIR"
	unset LF_TEMPDIR
}
alias lf=lf_enhanced

# zsh completions
autoload -U compinit
compinit

# ssh-agent initialization	
zstyle :omz:plugins:ssh-agent identities ~/.ssh/private_keys/*
zstyle :omz:plugins:ssh-agent quiet yes

# zsh plugins
plugins=(
   fzf-tab
   zsh-autosuggestions
   zsh-syntax-highlighting
   shellfirm
   zsh-nvm
   autoupdate
   ssh-agent
)
export DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh

#source /usr/share/nvm/init-nvm.sh

# Prompt
eval "$(oh-my-posh init --config $HOME/.config/oh-my-posh/oh-my-posh.toml zsh)"
#eval "$(starship init zsh)"

# history
eval "$(atuin init zsh)"
alias history="history | cut -c 8-" # remove the line number 

# init fzf 
source ~/.config/fzf/fzf.sh

# cd
eval "$(zoxide init zsh --cmd cd)"

alias open="xdg-open"
neofetch
