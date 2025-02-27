#bindings
source "$(dirname $0)/bindings.zsh"


#Start tmux if not already open
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux # attach-session -t default || tmux new-session -s default
fi


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
