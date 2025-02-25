# Load zsh/completion
autoload -Uz compinit && compinit


# Load Antidote from ~/.config/zsh
source "$HOME/.antidote/antidote.zsh"
antidote bundle < "$HOME/.config/zsh/plugins.txt" > "$HOME/.config/zsh/plugins.zsh"
source "$HOME/.config/zsh/plugins.zsh"

# Load Starship prompt
export STARSHIP_CONFIG="$HOME/.config/zsh/starship.toml"
eval "$(starship init zsh)"



# Adding FNM and .local/bin
export PATH="$HOME/.local/bin:$HOME/.fnm:$PATH"

# Aliases
alias vim="nvim"
alias vi="nvim"
alias yay="paru"

# Setup fnm
eval "$(fnm env)"

# Setup EMSDK/Emscripten
eval "$(EMSDK_QUIET=1 /usr/lib/emsdk/emsdk_env.sh)"

# Setup Qt theme
export QT_STYLE_OVERRIDE=Kvantum
