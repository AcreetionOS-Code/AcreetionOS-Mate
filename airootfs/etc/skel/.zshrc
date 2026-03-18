# AcreetionOS Zsh Config

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# Keybindings
bindkey -e
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Prompt
PROMPT='%F{green}User%F{white}:%F{blue}%n %F{green}Path%F{white}: %F{blue}%~ 
%F{white}[=--> %f'

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias update='sudo pacman -Syyu'
alias fupdate='flatpak update'
alias fastfetch='fastfetch -l /etc/AcreetionOS.txt'

# Load fastfetch on start
if [[ -o interactive ]]; then
    clear
    fastfetch
fi
