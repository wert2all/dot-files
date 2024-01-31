#!/bin/sh

mkdir ~/.config/ -p

mkdir ~/.config/dunst -p
mkdir ~/.config/alacritty -p
mkdir ~/.config/nitrogen -p
mkdir ~/Pictures/Wallpapers -p
mkdir ~/.config/picom -p
mkdir ~/.config/rofi -p
mkdir ~/.local/share/rofi/themes/ -p
mkdir ~/.config/polybar -p
mkdir ~/.config/i3 -p
mkdir ~/config/hypr/scripts -p
mkdir ~/.config/swww -p
mkdir ~/.config/waybar/ -p
mkdir ~/.config/nvim/ -p

cp .config/dunst/* ~/.config/dunst -r
cp .config/nitrogen/* ~/.config/nitrogen
cp wallpapers/* ~/Pictures/Wallpapers/
cp .config/picom/* ~/.config/picom
cp .config/rofi/* ~/.config/rofi
cp themes/rofi/* ~/.local/share/rofi/themes/
cp .config/polybar/* ~/.config/polybar -r
cp .config/i3/* ~/.config/i3
cp .config/alacritty/* ~/.config/alacritty
cp .config/hypr/* ~/.config/hypr/ -r
cp .config/swww/* ~/.config/swww/
cp .config/waybar/* ~/.config/waybar/ -r
cp .config/nvim/* ~/.config/nvim/ -r

cp .zshrc ~/
