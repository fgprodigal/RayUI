local L = LibStub("AceLocale-3.0"):GetLocale("Skada", false) --localization
local Skada = Skada
local mod = Skada:NewModule("BrokerDisplay")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

mod.name = "Broker Display"
Skada.displays["broker"] = mod

function mod:Create(win, isnew)
    if not win.obj then
        win.obj = ldb:NewDataObject(win.db.name, {
            type = "data source", 
            text = "",
            OnTooltipShow = function (tooltip)
                if not win.obj then
                    return
                end
                    
                -- Default color.
                local color = win.db.textcolor
                    
                tooltip:AddLine(win.metadata.title)
                tooltip:AddLine(" ")

                self:SortDataset(win)
                if #win.dataset > 0 then
                    for i, data in ipairs(win.dataset) do
                        if data.id and not data.ignore and i < 30 then
                            local label = self:FormatLabel(win, data)
                            local value = self:FormatValue(win, data)
                                
                            if win.metadata.showspots and Skada.db.profile.showranks then
                                label = (("%2u. %s"):format(i, label))
                            end

                            tooltip:AddDoubleLine(label or "", value or "", color.r, color.g, color.b, color.r, color.g, color.b)
                                
                        end
                    end
                end

                tooltip:AddLine(" ")
                tooltip:AddLine(L["Hint: Left-Click to set active mode."], 0, 1, 0)
                tooltip:AddLine(L["Right-click to set active set."], 0, 1, 0)
                tooltip:AddLine(L["Shift + Left-Click to open menu."], 0, 1, 0)

                tooltip:Show()
            end,
            OnClick = function (self, button)
                if not win.obj then
                    return
                end
                    
                if button=="LeftButton" and IsShiftKeyDown() then
                    Skada:OpenMenu(win)
                elseif button=="LeftButton" then
                    Skada:ModeMenu(win)
                elseif button=="RightButton" then
                    Skada:SegmentMenu(win)
                end
                    
            end
        })
    end
end

function mod:IsShown(win)
    return not win.db.hidden
end

function mod:Show(win)
end

function mod:Hide()
end

function mod:Destroy(win)
    win.obj.text = " "
    win.obj = nil
end

function mod:Wipe(win) 
    win.text = " "
end

function mod:SetTitle(win, title)
end

function mod:SortDataset(win)
    table.sort(win.dataset, function (a, b)
        if not a or a.value == nil then
            return false
        elseif not b or b.value == nil then
            return true
        else
            return a.value > b.value
        end
    end)
end

function mod:FormatLabel(win, data)
    local label = ""
    if win.db.isusingclasscolors and data.class then
        label = "|c"
        label = label..RAID_CLASS_COLORS[data.class].colorStr
        label = label..data.label
        label = label.."|r"
    else
        label = data.label
    end
    return label
end

function mod:FormatValue(win, data)
    return data.valuetext
end

function mod:Update(win)
    win.obj.text = ""
    self:SortDataset(win)
    if #win.dataset > 0 then
        local data = win.dataset[1]
        if data.id then
            local label = (self:FormatLabel(win, data) or "").." - "..(self:FormatValue(win, data) or "")
            
            win.obj.text = label
        end
    end
end

function mod:OnInitialize()	
end

function mod:ApplySettings(win)
    self:Update(win)
end

function mod:AddDisplayOptions(win, options)
    local db = win.db
    options.main = {
        type = "group",
        name = "Text",
        order = 3,
        args = {
            
			classcolortext = {
			        type="toggle",
			        name=L["Class color text"],
			        desc=L["When possible, bar text will be colored according to player class."],
			        order=31,
			        get=function() return db.isusingclasscolors end,
			        set=function()
			        		db.isusingclasscolors = not db.isusingclasscolors
		         			Skada:ApplySettings()
			        	end,
			},
			color = {
				type="color",
				name=L["Text color"],
				desc=L["Choose the default color."],
				hasAlpha=true,
				get=function(i)
						local c = db.textcolor
						return c.r, c.g, c.b, c.a
					end,
				set=function(i, r,g,b,a)
						db.textcolor = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
						Skada:ApplySettings()
					end,
				order=21,
			},
            
        }
    }
end


