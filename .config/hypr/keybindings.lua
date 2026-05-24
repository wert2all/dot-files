local C = require("config")

hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)"'))
hl.bind(C.mainMod .. " + Return", hl.dsp.exec_cmd(C.terminal))
hl.bind(C.mainMod .. " + SHIFT+ Q", hl.dsp.window.close())
hl.bind(
	C.mainMod .. " + E",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(C.mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(C.mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(C.mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- # Rofi keybinds
hl.bind(C.mainMod .. " + D", hl.dsp.exec_cmd(C.launcher))
hl.bind(C.mainMod .. " + A", hl.dsp.exec_cmd(C.dmScripts .. "/switch_projects.sh --tofi"))

-- # Audio control
hl.bind(C.mainMod .. " + F3", hl.dsp.exec_cmd(C.dmScripts .. "/system-volume-control.sh i"))
hl.bind(C.mainMod .. " + F2", hl.dsp.exec_cmd(C.dmScripts .. "/system-volume-control.sh d"))
hl.bind(C.mainMod .. " + F1", hl.dsp.exec_cmd(C.dmScripts .. "/system-volume-control.sh m"))
hl.bind(C.mainMod .. " + F4", hl.dsp.exec_cmd(C.dmScripts .. "/system-volume-control.sh mm"))

hl.bind("XF86AudioMute", hl.dsp.exec_cmd(C.dmScripts .. "/system-volume-control.sh m"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(C.dmScripts .. "/system-volume-control.sh mm"))
hl.bind("xf86audioraisevolume", hl.dsp.exec_cmd(C.dmScripts .. "/system-volume-control.sh i"))
hl.bind("xf86audiolowervolume", hl.dsp.exec_cmd(C.dmScripts .. "/system-volume-control.sh d"))

-- # Brightness control
hl.bind(C.mainMod .. " + F6", hl.dsp.exec_cmd(C.dmScripts .. "/system-brightness-control.sh i"))
hl.bind(C.mainMod .. " + F5", hl.dsp.exec_cmd(C.dmScripts .. "/system-brightness-control.sh d"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(C.dmScripts .. "/system-brightness-control.sh i"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(C.dmScripts .. "/system-brightness-control.sh d"))

-- # Voice recording for Gemini (hold SUPER+G)
hl.bind(C.mainMod .. " + G", hl.dsp.exec_cmd(C.dmScripts .. "/gemini-voice/start_record.sh"), { repeating = true })
hl.bind(C.mainMod .. " + G", hl.dsp.exec_cmd(C.dmScripts .. "/gemini-voice/stop_record.sh"), { release = true })

-- Move focus with C.mainMod + arrow keys
hl.bind(C.mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(C.mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(C.mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(C.mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with C.mainMod + [0-9]
-- Move active window to a workspace with C.mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(C.mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(C.mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with C.mainMod + scroll
hl.bind(C.mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(C.mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(C.mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(C.mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))

--  Resize windows with C.mainMod + arrow keys
hl.bind(C.mainMod .. " + SHIFT + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }, { repeating = true }))
hl.bind(C.mainMod .. " + SHIFT + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }, { repeating = true }))
hl.bind(C.mainMod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }, { repeating = true }))
hl.bind(C.mainMod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }, { repeating = true }))

-- Move/resize windows with C.mainMod + LMB/RMB and dragging
hl.bind(C.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(C.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(C.mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(C.mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
