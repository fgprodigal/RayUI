local _, ns = ...
local ycc = ns.ycc

--Cache global variables
--Lua functions
local getglobal = getglobal

--WoW API / Variables
local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local GetRealZoneText = GetRealZoneText
local GetGuildInfo = GetGuildInfo
local UnitRace = UnitRace
local GetWhoInfo = GetWhoInfo
local UIDropDownMenu_GetSelectedID = UIDropDownMenu_GetSelectedID

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: WhoListScrollFrame, WHOS_TO_DISPLAY, WhoFrameDropDown

hooksecurefunc('WhoList_Update', function()
        local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)

        local playerZone = GetRealZoneText()
        local playerGuild = GetGuildInfo("player")
        local playerRace = UnitRace("player")

        for i=1, WHOS_TO_DISPLAY, 1 do
            local index = whoOffset + i
            local nameText = getglobal('WhoFrameButton'..i..'Name')
            local levelText = getglobal('WhoFrameButton'..i..'Level')
            local classText = getglobal('WhoFrameButton'..i..'Class')
            local variableText = getglobal('WhoFrameButton'..i..'Variable')

            local name, guild, level, race, class, zone, classFileName = GetWhoInfo(index)
            if(name) then
                if zone == playerZone then
                    zone = '|cff00ff00' .. zone
                end
                if guild == playerGuild then
                    guild = '|cff00ff00' .. guild
                end
                if race == playerRace then
                    race = '|cff00ff00' .. race
                end
                local columnTable = { zone, guild, race }

                local c = ycc.classColorRaw[classFileName]
                nameText:SetTextColor(c.r, c.g, c.b)
                levelText:SetText(ycc.diffColor[level] .. level)
                variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
            end
        end
    end)
