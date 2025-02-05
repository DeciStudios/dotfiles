# Detect OS type
os_type="Windows"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set the ZSH theme
ZSH_THEME="robbyrussell"

# OS-specific configurations
# if [[ "$os_type" == "Windows" ]]; then
#   # Windows-specific configurations
#   export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
# fi

# Enable plugins
plugins=(
  git
  common-aliases
  node
  npm
  rand-quote
  sudo
  yarn
  z
  colored-man-pages
  colorize
  cp
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Add additional configurations
# .zshrc
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure

# Source other custom scripts
. ~/.zsh/z/z.sh

# User configuration

# Aliases
# alias gksu='pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY'

# NVM setup for Windows
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Preferred editor for local and remote sessions
# Uncomment and customize if needed
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi