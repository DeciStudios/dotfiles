#!/bin/bash

ln -sf "$PWD/.zshrc" ~/.zshrc
mkdir -p ~/.config
ln -sfn "$PWD/.config/zsh" ~/.config/zsh
ln -sfn "$PWD/.config/tmux" ~/.config/tmux
ln -sfn "$PWD/.config/nvim" ~/.config/nvim
ln -sfn "$PWD/.config/ghostty" ~/.config/ghostty


