autoload -U colors
colors
autoload -U compinit
compinit
# Report command running time if it is more than 3 seconds
REPORTTIME=3
# Keep a lot of history
HISTFILE=~/.zhistory
HISTSIZE=50000
SAVEHIST=50000
# Add commands to history as they are entered, don't wait for shell to exit
setopt INC_APPEND_HISTORY
# Also remember command start time and duration
setopt EXTENDED_HISTORY
# Do not keep duplicate commands in history
setopt HIST_IGNORE_ALL_DUPS
# Do not remember commands that start with a whitespace
setopt HIST_IGNORE_SPACE
# Correct spelling of all arguments in the command line
setopt CORRECT_ALL
setopt share_history

# Changing directories
setopt auto_cd
setopt auto_pushd
unsetopt pushd_ignore_dups
setopt pushdminus

setopt auto_menu
setopt always_to_end
setopt complete_in_word
unsetopt flow_control
unsetopt menu_complete
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

_setup_ps1() {
  GLYPH="▲"
  [ "x$KEYMAP" = "xvicmd" ] && GLYPH="▼"
  PS1="%(?.%F{green}.%F{magenta})$GLYPH%f"
}
_setup_ps1

# Vi mode
zle-keymap-select() {
  _setup_ps1
  zle reset-prompt
}
zle -N zle-keymap-select
zle-line-init() {
  zle -K viins
}
zle -N zle-line-init
bindkey -v
SHELL=/bin/zsh
export EDITOR="vi"
export VISUAL="vi"
NEWLINE=$'\n'
export HISTCONTROL=ignoreboth

certcheck() {
  echo | openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null | openssl x509 -inform pem -noout -text
}
certexpire() {
  echo | openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null | openssl x509 -inform pem -noout -text | grep 'Not After'
}

export PATH=$PATH:$HOME/bin:/usr/local/sbin
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:$GOPATH/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
