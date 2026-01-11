DIRECTORY_ZSH_CONFIG=$(dirname $0)


#========= Starship ==========
export STARSHIP_CONFIG="$DIRECTORY_ZSH_CONFIG/starship.toml"
eval "$(starship init zsh)"
#=============================




#=========== P10k ============
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
# source "$DIRECTORY_ZSH_CONFIG/p10k.zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k"
#=============================

#bindings
source "$DIRECTORY_ZSH_CONFIG/bindings.zsh"


#Start tmux if not already open
# source "$DIRECTORY_ZSH_CONFIG/tmux.zsh"


# Adding FNM and .local/bin
export PATH="$HOME/.local/bin:$HOME/.fnm:$HOME/.nimble/bin:$PATH"

# Aliases
alias vim="nvim"
alias vi="nvim"
alias yay="paru"

# Setup fnm
eval "$(fnm env)"

# Setup EMSDK/Emscripten
eval "$(EMSDK_QUIET=1 /usr/lib/emsdk/emsdk_env.sh)"

# Setup Playdate SDK
export PLAYDATE_SDK_PATH="$HOME/.local/share/playdate-sdk/"
export PLAYDATE_LUACATS_PATH="$HOME/.local/share/playdate-luacats/"

export PATH=$PATH:$PLAYDATE_SDK_PATH/bin
# Setup devkitpro
export DEVKITPRO="/opt/devkitpro"
export DEVKITARM="/opt/devkitpro/devkitARM"
export DEVKITPPC="/opt/devkitpro/devkitPPC"

#setup espup
. /home/jackm/export-esp.sh

# pnpm
export PNPM_HOME="/home/jackm/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Setup Qt theme
export QT_STYLE_OVERRIDE=Kvantum
