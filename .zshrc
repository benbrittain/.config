# History
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000

# Aliases
alias vim=nvim
alias vi=nvim
alias ssh="kitty +kitten ssh"
alias ls='ls --color=auto'

# Path
PATH=~/.cargo/bin:$PATH

# Enable completions
autoload -Uz compinit
compinit

# Enable zsh-autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(completion history)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable fancy everforest LS_COLORS
# generated using https://github.com/benbrittain/vivid
# cargo run -- generate everforest > ~/.config/ls_colors
export LS_COLORS=$(cat ~/.config/ls_colors)

# Enable colors on autocomplete
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Completion menu
zstyle ':completion:*' menu select

# jj autocompletions
source <(jj util completion zsh)

# Enable starship prompt
eval "$(starship init zsh)"

# Make delete work
bindkey "^[[3~" delete-char

# Pager configuration
export LESS="FRX"

# Bash ctrl-w works on words
autoload -U select-word-style
select-word-style bash
