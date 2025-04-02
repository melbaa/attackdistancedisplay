local ADDON_NAME = "attackdistancedisplay"


local timer_id = nil
local timer_tick = 500  -- ms
ADDISPLAY = {}


-- Interface
ADDISPLAY.f1 = CreateFrame("Frame",nil,UIParent)
ADDISPLAY.f1:SetMovable(true)
--ADDISPLAY.f1:EnableMouse(true)
ADDISPLAY.f1:SetWidth(100) 
ADDISPLAY.f1:SetHeight(100) 
ADDISPLAY.f1:SetAlpha(.90);
ADDISPLAY.f1:SetPoint("CENTER",350,-100)
ADDISPLAY.f1.text = ADDISPLAY.f1:CreateFontString(nil,"ARTWORK") 
ADDISPLAY.f1.text:SetFont("Fonts\\ARIALN.ttf", 24, "OUTLINE")
ADDISPLAY.f1.text:SetPoint("CENTER",0,0)
ADDISPLAY.f1:RegisterForDrag("LeftButton")
ADDISPLAY.f1:SetScript("OnDragStart", function() ADDISPLAY.f1:StartMoving() end)
ADDISPLAY.f1:SetScript("OnDragStop", function()
    ADDISPLAY.f1:StopMovingOrSizing()
    point, _, rel_point, x_offset, y_offset = ADDISPLAY.f1:GetPoint()

    if x_offset < 20 and x_offset > -20 then
        x_offset = 0
    end

    add_opts.point = point
    add_opts.rel_point = rel_point
    add_opts.x_offset = floor(x_offset / 1) * 1
    add_opts.y_offset = floor(y_offset / 1) * 1
end);
ADDISPLAY.f1:Hide()

function ADDISPLAY:Init()
    if not add_opts then
        add_opts = {
            point = "CENTER",
            rel_point = "CENTER",
            x_offset = 350,
            y_offset = -100,
        }
    end

    ADDISPLAY.f1:SetPoint(add_opts.point, UIParent, add_opts.rel_point, add_opts.x_offset, add_opts.y_offset)
    ADDISPLAY.f1:Show()
end

local function displayString(dist)
    if dist == nil then
        dist = 'nil'
    else
        dist = floor(dist * 100) / 100
    end
    return "AD ".. dist
end


local function displayupdate()
    local dist = UnitXP("distanceBetween", "player", "target", "meleeAutoAttack")
    local message = displayString(dist)
    ADDISPLAY.f1.text:SetText(message)
end

ADDISPLAY.f1:RegisterEvent("ADDON_LOADED")
-- ADDISPLAY.f1:RegisterEvent("PLAYER_ENTERING_WORLD")
-- ADDISPLAY.f1:RegisterEvent("UNIT_INVENTORY_CHANGED")
-- ADDISPLAY.f1:RegisterEvent("UNIT_AURA")

function attackdistance_timer()
    displayupdate()
end

ADDISPLAY.f1:SetScript("OnEvent", function()
    displayupdate()
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A attack distance display:|r Loaded",1,1,1)
            ADDISPLAY:Init()
            if timer_id == nil then
                timer_id = UnitXP("timer", "arm", 0, timer_tick, "attackdistance_timer");
            end
        end
    elseif event == 'PLAYER_LOGOUT' then
        if timer_id ~= nil then
            UnitXP("timer", "disarm", timer_id)
        end
    end
end);
