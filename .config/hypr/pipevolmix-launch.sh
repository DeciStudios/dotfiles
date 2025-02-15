#!/bin/bash

# Launch kitty with the controller
kitty --class="pipewire-controller" --title="Volume Control" --override "background_opacity=1" -e ~/.dotfiles/.local/bin/pipevolmix
