local ADDON_NAME = "attackdistancedisplay"


local UpdateTime, LastUpdate = 0.50, 0
ADDISPLAY = {}

local playerClass = string.upper(UnitClass('player'));

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
end
 
local function displayupdate(show, message)
    if show == 1 then
        ADDISPLAY.f1.text:SetText(message)
        ADDISPLAY.f1:Show()
    elseif show == 2 then
        ADDISPLAY.f1:Hide()
    else
        ADDISPLAY.f1:Hide()
    end
end

local function displayString()
    local ret = UnitXP("distanceBetween", "player", "target", "meleeAutoAttack")
    if ret == nil then
        ret = 'nil'
    else
        ret = floor(ret * 10) / 10
    end
    return "|cffffffff AD ".. ret
end

-- f1:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
-- f1:RegisterEvent("PLAYER_TALENT_UPDATE")
-- f1:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
-- f1:RegisterEvent("PLAYER_REGEN_DISABLED")
-- f1:RegisterEvent("PLAYER_REGEN_ENABLED")
ADDISPLAY.f1:RegisterEvent("ADDON_LOADED")
-- f1:RegisterEvent("PLAYER_ENTERING_WORLD")
-- ADDISPLAY.f1:RegisterEvent("UNIT_INVENTORY_CHANGED")
-- ADDISPLAY.f1:RegisterEvent("UNIT_AURA")

ADDISPLAY.f1:SetScript("OnUpdate", function()
    -- arg1 is elapsed
    LastUpdate = LastUpdate + arg1
    if LastUpdate < UpdateTime then return end
    displayupdate(1, displayString())
    LastUpdate = 0
end)

ADDISPLAY.f1:SetScript("OnEvent", function()
    displayupdate(1, displayString())
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A attack distance display:|r Loaded",1,1,1)
            ADDISPLAY:Init()
        end
    end
end);
