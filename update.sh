#!/bin/sh

mkdir ~/.config/ -p

mkdir ~/.config/dunst -p
mkdir ~/.config/kitty -p
mkdir ~/.config/nitrogen -p
mkdir ~/Pictures/Wallpapers -p
mkdir ~/.config/picom -p

cp .config/dunst/* ~/.config/dunst
cp .config/nitrogen/* ~/.config/nitrogen
cp wallpapers/* ~/Pictures/Wallpapers/
cp .config/picom/* ~/.config/picom