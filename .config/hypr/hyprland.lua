local C = require("config")

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "auto",
	scale = "1",
})

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

	hl.exec_cmd(C.dmScripts .. "/system-reset-xdgportal.sh")
	hl.exec_cmd(C.dmScripts .. "/system-battery-notify.sh")

	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("dunst")

	hl.exec_cmd(C.dmScripts .. "re-launch-waybar.sh")
end)

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
-- hl.env("QT_QPA_PLATFORM", "QT_QPA_PLATFORM")
hl.env("QT_QPA_PLATFORM", "xcb")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

require("input")
require("keybindings")
require("animations")
require("rules")
require("theme")
