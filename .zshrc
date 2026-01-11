
# Load zsh/completion
autoload -Uz compinit && compinit


# Load Antidote from ~/.config/zsh
source "$HOME/.antidote/antidote.zsh"
antidote bundle < "$HOME/.config/zsh/plugins.txt" > "$HOME/.config/zsh/plugins.zsh"
source "$HOME/.config/zsh/plugins.zsh"



# Load zsh config
source ~/.config/zsh/config.zsh

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/jackm/.dart-cli-completion/zsh-config.zsh ]] && . /home/jackm/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]
