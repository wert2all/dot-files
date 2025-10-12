#!/bin/bash

# install nvim
# sudo zypper in neovim ripgrep git stow npm-default pnpm make go
# rm -rf ~/.config/nvim && rm -rf ~/.local/share/nvim && rm -rf ~/.local/state/nvim
# git clone git@github.com:wert2all/astrovim-template.git ~/.config/nvim

# install zsh
# sudo zypper in password-store zsh tmux zoxide fzf eza
# sudo chsh -s $(which zsh) wert2all

#install nvidia driver
# sudo zypper install openSUSE-repos-Tumbleweed-NVIDIA
# sudo zypper install-new-recommends

#install i3
# sudo zypper in i3 xfce4-power-manager lxsession polybar picom sddm maim rofi nitrogen dunst
# sudo update-alternatives --set default-display-manager /usr/lib/X11/displaymanagers/sddm

#install other software
# sudo zypper in kitty btop htop lazygit git-delta flatpak

#install zen browser
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak install flathub app.zen_browser.zen

#mount nas
# sudo mkdir -p /mnt/nas1
# sudo mkdir -p /mnt/nas2
# sudo chown -R wert2all:users /mnt/nas1
# sudo chown -R wert2all:users /mnt/nas2

#install docker
# sudo zypper in docker docker-compose
# sudo systemctl enable docker
# sudo systemctl start docker
# sudo usermod -aG docker wert2all

#install nginx
sudo zypper in nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo zypper install python3-certbot-nginx
