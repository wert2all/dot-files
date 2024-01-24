# dot-files

my linux dot-files

1. install dependencies

   #### Arch

   paru -S htop i3-wm dunst alacritty nitrogen picom rofi polybar pavucontrol xfce4-power-manager cava playerctl bluetuith lxsession spotify polybar-spotify-module gnome-keyring libsecret qemu-base libvirt bridge-utils swww eza gruvbox-plus-icon-theme-git

   #### Opensuse

   sudo zypper in htop btop i3 dunst alacritty nitrogen picom rofi polybar pavucontrol cava playerctl bluetuith lxsession gnome-keyring libsecret-1-0 qemu-kvm libvirt bridge-utils swww eza

2. start spotify service

   systemctl --user enable spotify-listener

   systemctl --user start spotify-listener

3. check

   cat /etc/systemd/logind.conf | grep -i "HandleLidSwitch"

   should be

   HandleLidSwitch=suspend

4. install fonts from https://github.com/adi1090x/polybar-themes/tree/master/fonts
