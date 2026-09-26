
--   ____ ___  _   _ _____ ___ ____     _____ ___ _     _____ 
--  / ___/ _ \| \ | |  ___|_ _/ ___|   |  ___|_ _| |   | ____|
-- | |  | | | |  \| | |_   | | |  _    | |_   | || |   |  _|  
-- | |__| |_| | |\  |  _|  | | |_| |   |  _|  | || |___| |___ 
--  \____\___/|_| \_|_|   |___\____|   |_|   |___|_____|_____|
--
-- Author: Pako3549
-- Contact: bellarosa.pasquale@gmail.com

--------------------------------------------------
-- MONITORS
--------------------------------------------------
-- 15s-fq2060nl 
-- hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1, })

-- ux3405ca
hl.monitor({ output = "eDP-1", mode = "2880x1800@120", position = "0x0", scale = 1.5, })

-- Home monitor
hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@60", position = "0x-1080", scale = 2, })

-- Mirroring:
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1", })


--------------------------------------------------
-- PROGRAMS
--------------------------------------------------

local terminal = "kitty"
local fileManager = "nautilus -w"
local menu = "rofi -show drun"
local powerMenu = "wlogout"

local wallpaperSetup = "awww img ~/.config/hypr/wallpapers/wallpaper.png"
local wallpaper = "awww-daemon"
local bar = "waybar"
local cliphistStartup = "wl-paste --watch cliphist store"
local kdeconnect = "kdeconnectd"

local restartWaybar = "~/.config/scripts/restart-waybar.sh"
local screenshot = "~/.config/scripts/screenshot.sh"
local windowFreezeScreenshot = "~/.config/scripts/window-freeze-screenshot.sh"
local fullScreenshot = "~/.config/scripts/full-screenshot.sh"
local colorPicker = "~/.config/scripts/color-picker.sh"
local cliphist = "~/.config/scripts/cliphist-rofi-img.sh"
local hotspot = "~/.config/scripts/hotspot.sh"
local polkitAgent = "systemctl --user start hyprpolkitagent"
-- local polkitAgent = "/usr/libexec/lxqt-policykit-agent"


--------------------------------------------------
-- AUTOSTART
--------------------------------------------------

hl.on("hyprland.start", function()
    hl.exec_cmd(
        "systemctl --user import-environment GTK_THEME PREFER_DARK_THEME && " ..
        "systemctl --user restart xdg-desktop-portal-gtk & " ..
        polkitAgent .. " & " ..
        bar .. " & " ..
        wallpaper .. " & " ..
        cliphistStartup .. " & " ..
        kdeconnect
    )
end)


--------------------------------------------------
-- ENVIRONMENT VARIABLES
--------------------------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_STYLE_OVERRIDE", "Adwaita-Dark")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")


--------------------------------------------------
-- XWAYLAND
--------------------------------------------------

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})


--------------------------------------------------
-- GENERAL
--------------------------------------------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 0,

        col = {
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
})


--------------------------------------------------
-- DECORATION
--------------------------------------------------

hl.config({
    decoration = {
        rounding = 10,
        active_opacity = 10.0,
        inactive_opacity = 1.0,

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },
})


--------------------------------------------------
-- ANIMATIONS
--------------------------------------------------

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("myBezier", {
    type = "bezier",
    points = {
        { 0.05, 0.9 },
        { 0.1, 1.05 },
    },
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 7,
    bezier = "myBezier",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 7,
    bezier = "default",
    style = "popin 80%",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "default",
})

hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 8,
    bezier = "default",
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 7,
    bezier = "default",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 6,
    bezier = "default",
})


--------------------------------------------------
-- DWINDLE
--------------------------------------------------

hl.config({
    dwindle = {
        preserve_split = true,
    },
})


--------------------------------------------------
-- MASTER
--------------------------------------------------

hl.config({
    master = {
        new_status = "master",
    },
})


--------------------------------------------------
-- MISC
--------------------------------------------------

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
})


--------------------------------------------------
-- INPUT
--------------------------------------------------

hl.config({
     input = {
         kb_layout = "it",
         kb_variant = "",
         kb_model = "",
         kb_options = "",
         kb_rules = "",
         follow_mouse = 1,
         sensitivity = 0,
 
         touchpad = {
             natural_scroll = true,
         },
     },
})


--------------------------------------------------
-- GESTURES
--------------------------------------------------

hl.config({
    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_forever = false,
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

--------------------------------------------------
-- DEVICE
--------------------------------------------------

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- Touch only on eDP-1
hl.device({
    name = "wdht1f01:00-2575:092e",
    output = "eDP-1",                              
})

-- Configure M2 pen to write precisely at 120Hz
hl.device({
    name = "wdht1f01:00-2575:092e-stylus",
    output = "eDP-1",                              
    transform = 0,
})

--------------------------------------------------
-- KEYBINDS
--------------------------------------------------

local mainMod = "SUPER"

-- Hyprlock
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))

-- Screenshot
hl.bind("PRINT", hl.dsp.exec_cmd(screenshot))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd(windowFreezeScreenshot))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd(fullScreenshot))


-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("amixer set Master 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("amixer set Master 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("amixer set Master toggle"))


-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"))

-- Power profile
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("/bin/bash /home/pako/.config/scripts/battery-profiles.sh next"))

-- Menu
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(menu))


-- Restart Waybar
hl.bind("SUPER + Y", hl.dsp.exec_cmd(restartWaybar))


-- Color picker
hl.bind("SUPER + backslash", hl.dsp.exec_cmd(colorPicker))


-- Cliphist
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd(cliphist))


-- Hotspot
hl.bind("SUPER + SHIFT + H", hl.dsp.exec_cmd(hotspot))


-- General
hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exec_cmd(powerMenu))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + R", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))


-- Move focus
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))


-- Switch workspaces
for i = 1, 9 do
    hl.bind(
        "SUPER + " .. i,
        hl.dsp.focus({ workspace = i })
    )
end

hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))


-- Move active window
for i = 1, 9 do
    hl.bind(
        "SUPER + SHIFT + " .. i,
        hl.dsp.window.move({ workspace = i })
    )
end

hl.bind(
    "SUPER + SHIFT + 0",
    hl.dsp.window.move({ workspace = 10 })
)


-- Special workspace
hl.bind(
    "SUPER + S",
    hl.dsp.workspace.toggle_special("magic")
)

hl.bind(
    "SUPER + SHIFT + S",
    hl.dsp.window.move({ workspace = "special:magic" })
)


-- Scroll
hl.bind(
    "SUPER + mouse_down",
    hl.dsp.focus({ workspace = "e+1" })
)

hl.bind(
    "SUPER + mouse_up",
    hl.dsp.focus({ workspace = "e-1" })
)


-- Move / resize
hl.bind(
    "SUPER + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(
    "SUPER + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)