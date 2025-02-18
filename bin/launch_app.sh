#!/usr/bin/env sh

case $1 in
sql) ~/apps/Beekeeper-Studio-5.0.9.AppImage ;;
api) ~/apps/HTTPie-2025.1.0.AppImage ;;
obsidian) ~/apps/Obsidian-1.7.4.AppImage ;;
bruno) ~/apps/bruno_1.39.0_x86_64_linux.AppImage ;;
*) print_error ;;
esac
