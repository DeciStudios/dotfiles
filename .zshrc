# If you come from bash, you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Detect OS type
os_type=$(uname)

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set the ZSH theme
ZSH_THEME="robbyrussell"
# OS-specific configurations
if [[ "$os_type" == "Linux" ]]; then
  # Linux-specific configurations
  export PATH="/usr/local/share/npm/bin:$PATH"
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/radeon_icd.x86_64.json"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$os_type" == "Darwin" ]]; then
	source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# Enable plugins
plugins=(
  git
  brew
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
)



# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Add additional configurations
if [[ "$os_type" == "Linux" ]]; then
	fpath+="$HOME/.zsh/pure"
elif [[ "$os_type" == "Darwin" ]]; then
	fpath+=("$(brew --prefix)/share/zsh/site-functions")
fi
autoload -U promptinit; promptinit
prompt pure

# Source other custom scripts
. ~/.zsh/z/z.sh

# User configuration
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias gksu='pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY'
if [[ "$os_type" == "Linux" ]]; then
	# NVM setup
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
elif [[ "$os_type" == "Darwin" ]]; then
	# NVM MacOs/Brew setup
	export NVM_DIR="$HOME/.nvm"
	[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
	[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
fi
# Preferred editor for local and remote sessions
# Uncomment and customize if needed
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
