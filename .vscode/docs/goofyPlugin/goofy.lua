---@class goofy
goofy = {}

---@alias goofy.GUIElement string
---| "CHAT"
---| "HOTBAR"
---| "JUMP_METER"
---| "EXPERIENCE_BAR"
---| "SELECTED_ITEM_NAME"
---| "SCOREBOARD_SIDEBAR"
---| "PLAYER_HEALTH"
---| "VEHICLE_HEALTH"
---| "TEXTURE_OVERLAY"
---| "SPYGLASS_OVERLAY"
---| "VIGNETTE"
---| "PORTAL_OVERLAY"
---| "BOSSBAR"

---@param GUIElement goofy.GUIElement
---@param disable boolean
---@return nil
function goofy:setDisableGUIElement(GUIElement, disable)
end
