#!/bin/bash

git config --global core.excludesfile $HOME/.gitignore_global

dconf load /org/gnome/terminal/ < .gnome_terminal

# chsh -s /usr/bin/zsh $(whoami)
