# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set the ZSH theme (choose one)
ZSH_THEME="robbyrussell"
# If you want Pure prompt instead, disable the theme and uncomment below:
# fpath+="$HOME/.zsh/pure"
# autoload -U promptinit; promptinit
# prompt pure

# Enable plugins (remove "z" if you choose not to load the external z.sh)
plugins=(
  git
  common-aliases
  rand-quote
  sudo
  yarn
  colored-man-pages
  colorize
  cp
  # Remove z from here if using an external z.sh OR remove external source instead
  zsh-z
)

# Source Oh My Zsh
source "$ZSH/oh-my-zsh.sh"
# Linux-specific configuration
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
# Environment setup
export PATH="$HOME/.local/bin:$HOME/.fnm:$PATH"
alias vi="nvim"
alias yay="paru"

eval "$(fnm env)"
eval "$(EMSDK_QUIET=1 /usr/lib/emsdk/emsdk_env.sh)"
