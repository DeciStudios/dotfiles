DIRECTORY_ZSH_CONFIG=$(dirname $0)


#========= Starship ==========
export STARSHIP_CONFIG="$DIRECTORY_ZSH_CONFIG/themes/pure.toml"
eval "$(starship init zsh)"
#=============================




#bindings
source "$DIRECTORY_ZSH_CONFIG/bindings.zsh"


#Start tmux if not already open
# source "$DIRECTORY_ZSH_CONFIG/tmux.zsh"


# Adding FNM and .local/bin
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.fnm:$HOME/.nimble/bin:$PATH"

# Aliases
alias vim="nvim"
alias vi="nvim"
alias yay="paru"

# Setup Playdate SDK
export PLAYDATE_SDK_PATH="$HOME/.local/share/playdate-sdk/"
export PLAYDATE_LUACATS_PATH="$HOME/.local/share/playdate-luacats/"

export PATH=$PATH:$PLAYDATE_SDK_PATH/bin
# Setup devkitpro
export DEVKITPRO="/opt/devkitpro"
export DEVKITARM="/opt/devkitpro/devkitARM"
export DEVKITPPC="/opt/devkitpro/devkitPPC"

#setup espup
#. /home/jackm/export-esp.sh

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

