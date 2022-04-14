HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# aliases
alias vim=nvim
alias vi=nvim
alias ssh="kitty +kitten ssh"

# exports
export ZSH=~/.oh-my-zsh
export ZSH_THEME="bwb"
export DEFAULT_USER=ben

# oh-my-zsh plugins (before sourcing)
plugins=(rust git)

source $ZSH/oh-my-zsh.sh
