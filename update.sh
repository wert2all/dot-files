#!/bin/sh

mkdir ~/.config/ -p

mkdir ~/.config/dunst -p
mkdir ~/.config/alacritty -p
mkdir ~/Pictures/Wallpapers -p
mkdir ~/.config/wofi -p
mkdir ~/.config/waybar -p
mkdir ~/.config/hypr -p

cp .config/dunst/* ~/.config/dunst
cp wallpapers/* ~/Pictures/Wallpapers/
cp .config/alacritty/* ~/.config/alacritty
cp .config/wofi/* ~/.config/wofi
cp .config/waybar/* ~/.config/waybar
cp .config/hypr/* ~/.config/hypr
