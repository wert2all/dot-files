# dot-files

my linux dot-files

1. install dependencies

   #### Arch

   paru -S htop i3-wm dunst kitty nitrogen picom rofi polybar pavucontrol xfce4-power-manager cava playerctl bluetuith lxsession spotify polybar-spotify-module gnome-keyring libsecret qemu-base libvirt bridge-utils

   #### Opensuse

   sudo zypper in htop

2. start spotify service

   systemctl --user enable spotify-listener

   systemctl --user start spotify-listener

3. check

   cat /etc/systemd/logind.conf | grep -i "HandleLidSwitch"

   should be

   HandleLidSwitch=suspend
