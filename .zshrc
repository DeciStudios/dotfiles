
# Load zsh/completion
autoload -Uz compinit && compinit


# Load Antidote from ~/.config/zsh
source "$HOME/.antidote/antidote.zsh"
antidote bundle < "$HOME/.config/zsh/plugins.txt" > "$HOME/.config/zsh/plugins.zsh"
source "$HOME/.config/zsh/plugins.zsh"



# Load zsh config
source ~/.config/zsh/config.zsh
