DIRECTORY_ZSH_CONFIG=$(dirname $0)
# # Load Starship prompt
# export STARSHIP_CONFIG="$HOME/.config/zsh/starship.toml"
# eval "$(starship init zsh)"
#DISABLED - USING P10K

# P10k setup

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source "$DIRECTORY_ZSH_CONFIG/p10k.zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
#bindings
source "$DIRECTORY_ZSH_CONFIG/bindings.zsh"


#Start tmux if not already open
if command -v tmux &> /dev/null w&& [ -z "$TMUX" ]; then
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
