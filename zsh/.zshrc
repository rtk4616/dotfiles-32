kgg]c
    source ~/.zplug/zplug
    zplug "b4b4r07/zplug"

    # Triaging
    zplug "tarruda/zsh-autosuggestions"
    zplug "uvaes/fzf-marks"
    zplug "zsh-users/zsh-history-substring-search"
    zplug "zsh-users/zsh-completions"

    # Cannot use right now, breaks tmux initial cwd
    # zplug "b4b4r07/enhancd", of:enhancd.sh

    # Syntax highlighting
    zplug "zsh-users/zsh-syntax-highlighting"

    # Completions etc.
    zplug "plugins/git", from:oh-my-zsh

    # VIM key-mappings for zsh
    zplug "plugins/vi-mode", from:oh-my-zsh
    zplug "hchbaw/opp.zsh", of:opp.zsh
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down

    # Liquid prompt
    LP_ENABLE_TIME=1
    LP_USER_ALWAYS=1
    zplug "nojhan/liquidprompt"

    # Navigate to the .git project root
    zplug "mollifier/cd-gitroot"
    alias cdu='cd-gitroot'

    zplug check || zplug install
    zplug load --verbose
fi

# Exports
export EDITOR='vim'
export KEYTIMEOUT=1
export DISABLE_AUTO_TITLE=true
export PATH="/usr/local/bin:$PATH"

# Aliases
alias _='sudo'
alias tmux='tmux -2'
alias emacs='TERM=xterm-256color emacs -nw'
alias cdu='cd-gitroot'
if type rlwrap > /dev/null; then
    alias node='rlwrap node'
fi

# FZF
if [[ -f ~/.fzf.zsh ]]; then
    echo "Loading fzf..."
    source ~/.fzf.zsh
fi
export FZF_COMPLETION_TRIGGER='~~'
export FZF_TMUX=1
export FZF_DEFAULT_COMMAND='
  (git ls-tree -r --name-only HEAD ||
   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      sed s/^..//) 2> /dev/null'

# Node - Node.js
PATH="$PATH:.node/bin"

# Go - The go language
export GOPATH=~/go
export PATH="$PATH:$GOPATH/bin"
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/usr/local/opt/go/libexec/bin"

# Nvm - Node version manager
export NVM_DIR=~/.nvm
if [[ -f ~/.nvm/nvm.sh ]]; then
    echo "Loading nvm..."
    source ~/.nvm/nvm.sh
    nvm use 0.12
fi

# Fuck - command correction
if type thefuck > /dev/null; then
    echo "Loading thefuck..."
    eval $(thefuck --alias)
fi

# Explicitely set language
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

clear
