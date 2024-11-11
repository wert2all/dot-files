#!/usr/bin/env sh

case $1 in
sql) ~/apps/Beekeeper-Studio-5.0.0-beta.2.AppImage ;;
api) ~/apps/HTTPie-2024.1.2.AppImage ;;
obsidian) ~/apps/Obsidian-1.7.4.AppImage ;;
*) print_error ;;
esac
