#!/usr/bin/env sh

case $1 in
sql) ~/apps/Beekeeper-Studio-4.3.4.AppImage ;;
api) ~/apps/HTTPie-2024.1.2.AppImage ;;
obsidian) ~/apps/Obsidian-1.5.12.AppImage ;;
*) print_error ;;
esac
