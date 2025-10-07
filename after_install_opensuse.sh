#!/bin/bash

# install nvim
sudo zypper in neovim ripgrep git stow npm-default pnpm make go
rm -rf ~/.config/nvim && rm -rf ~/.local/share/nvim && rm -rf ~/.local/state/nvim
git clone git@github.com:wert2all/astrovim-template.git ~/.config/nvim

# install zsh
sudo zypper in password-store zsh tmux zoxide fzf eza
sudo chsh -s $(which zsh) wert2all

#install nvidia driver
sudo zypper install openSUSE-repos-Tumbleweed-NVIDIA
sudo zypper install-new-recommends

#install i3
sudo zypper in i3 xfce4-power-manager lxsession polybar picom sddm maim rofi nitrogen
sudo update-alternatives --set default-display-manager /usr/lib/X11/displaymanagers/sddm

#install other software
sudo zypper in kitty btop htop lazygit git-delta flatpak

#install zen browser
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub app.zen_browser.zen
