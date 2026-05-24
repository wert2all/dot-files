-- # CURSOR
hl.env("XCURSOR_SIZE", "28")

hl.env("HYPRCURSOR_THEME", "oreo")
hl.env("HYPRCURSOR_SIZE", "28")

hl.on("hyprland.start", function()
	-- exec = gsettings set org.gnome.desktop.interface icon-theme 'Ark'
	-- exec = gsettings set org.gnome.desktop.interface gtk-theme 'Ant-Bloody'
	-- exec = gsettings set org.gnome.desktop.wm.preferences theme 'Ant-Bloody'
	-- exec = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

	-- exec = gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Amber'
	-- exec = gsettings set org.gnome.desktop.interface cursor-size 28

	hl.exec_cmd("hyprctl setcursor oreo 28")
end)

hl.config({
	general = { gaps_in = 6, gaps_out = 0, border_size = 0 },
	decoration = {
		rounding = 0,
		blur = {
			enabled = true,
			special = true,
			size = 4,
			ignore_opacity = true,
			passes = 3,
		},
		inactive_opacity = 0.8,
		shadow = {
			range = 12,
			render_power = 50,
			color = 0xee1a1a1a,
		},
		dim_special = 0.8,
	},
})

-- exec = gsettings set org.gnome.desktop.interface font-name 'CaskaydiaCove Nerd Font 12'
-- exec = gsettings set org.gnome.desktop.interface document-font-name 'CaskaydiaCove Nerd Font 10'
-- exec = gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10'
-- exec = gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
-- exec = gsettings set org.gnome.desktop.interface font-hinting 'full'
