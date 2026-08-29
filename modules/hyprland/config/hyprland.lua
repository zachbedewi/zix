require("hyprland.general")
require("hyprland.rules")

require("modules/10-monitors")
require("modules/40-binds")

local monitorsExist = pcall(require, "monitors")
if not monitorsExist then
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = 1,
    })
end
