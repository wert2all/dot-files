#!/bin/sh

mkdir ~/.config/ -p

mkdir ~/.config/dunst -p
mkdir ~/.config/kitty -p
mkdir ~/.config/nitrogen -p
mkdir ~/Pictures/Wallpapers -p
mkdir ~/.config/picom -p
mkdir ~/.config/rofi -p
mkdir ~/.local/share/rofi/themes/ -p
mkdir ~/.config/polybar -p

cp .config/dunst/* ~/.config/dunst
cp .config/nitrogen/* ~/.config/nitrogen
cp wallpapers/* ~/Pictures/Wallpapers/
cp .config/picom/* ~/.config/picom
cp .config/rofi/* ~/.config/rofi
cp themes/rofi/* ~/.local/share/rofi/themes/
cp .config/polybar/* ~/.config/polybar -r