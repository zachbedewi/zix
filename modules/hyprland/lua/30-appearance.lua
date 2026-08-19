-- Kanagawa, matching modules/kitty and modules/starship
local crystalBlue = "rgba(7e9cd8ee)"
local oniViolet   = "rgba(957fb8ee)"
local fujiGray    = "rgba(727169aa)"

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = { colors = { crystalBlue, oniViolet }, angle = 45 },
            inactive_border = fujiGray,
        },

        resize_on_border = true,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 8,

        shadow = {
            enabled = false,
        },

        blur = {
            enabled = true,
            size    = 3,
            passes  = 2,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})
