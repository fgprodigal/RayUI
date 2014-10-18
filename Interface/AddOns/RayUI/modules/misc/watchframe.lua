local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")

local function LoadFunc()
	local screenheight = GetScreenHeight()
	local WatchFrameHolder = CreateFrame("Frame", "WatchFrameHolder", UIParent)
	WatchFrameHolder:SetWidth(130)
	WatchFrameHolder:SetHeight(22)
	WatchFrameHolder:SetPoint("RIGHT", UIParent, "RIGHT", -80, 290)

	R:CreateMover(WatchFrameHolder, "WatchFrameMover", L["任务追踪锚点"], true)
	WatchFrameHolder:SetAllPoints(WatchFrameMover)

	WatchFrame:ClearAllPoints()
	WatchFrame:SetPoint("TOPRIGHT", WatchFrameHolder, "TOPRIGHT")
	WatchFrame:Height(screenheight / 2)

	hooksecurefunc(WatchFrame,"SetPoint",function(_,_,parent)
		if parent ~= WatchFrameHolder then
			WatchFrame:ClearAllPoints()
			WatchFrame:SetPoint("TOPRIGHT", WatchFrameHolder, "TOPRIGHT")
		end
	end)

	--进出副本自动收放任务追踪
	local autocollapse = CreateFrame("Frame")
	autocollapse:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	autocollapse:RegisterEvent("PLAYER_ENTERING_WORLD")
	autocollapse:SetScript("OnEvent", function(self)
	   if IsInInstance() then
		  WatchFrame.userCollapsed = true
		  WatchFrame_Collapse(WatchFrame)
	   else
		  WatchFrame.userCollapsed = nil
		  WatchFrame_Expand(WatchFrame)
	   end
	end)

	hooksecurefunc("WatchFrameItem_OnUpdate", function(self)
		local icon = _G[self:GetName().."IconTexture"]
		local valid = IsQuestLogSpecialItemInRange(self:GetID())
		if ( valid == 0 ) then
			icon:SetVertexColor(1.0, 0.1, 0.1)
		else
			icon:SetVertexColor(1, 1, 1)
		end
	end)

    local function SkinWatchFrameItems()
        for i=1, WATCHFRAME_NUM_ITEMS do
            local button = _G["WatchFrameItem"..i]
            if not button.skinned then
                _G["WatchFrameItem"..i.."NormalTexture"]:SetTexture(nil)
                _G["WatchFrameItem"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
                button:CreateShadow("Background")
                button:StyleButton(true)
                button.skinned = true
            end
        end 
    end

    hooksecurefunc("WatchFrame_SetLine", function(line, anchor, verticalOffset, isHeader, text, dash, hasItem, isComplete)
        if dash == 1 then
            line.hasdash = true
        else
            line.hasdash = false
        end
        if line.square then
            if line.hasdash then
                line.square:Show()
            else
                line.square:Hide()
            end
        end
        if isHeader then 
            line.text:SetTextColor(.5, 1, 1)
        else
            line.text:SetTextColor(.9, .9, .9)
        end
    end)

    -- Replace Highlight function
    WatchFrameLinkButtonTemplate_Highlight = function(self, onEnter)
        local line
        for index = self.startLine, self.lastLine do
            line = self.lines[index]
            if line then
                if index == self.startLine then
                    -- header
                    if onEnter then
                        line.text:SetTextColor(1, 1, 1)
                    else
                        line.text:SetTextColor(.5, 1, 1)
                    end
                else
                    if onEnter then
                        if (line.text.eligible) then
                            line.text:SetTextColor(1, 1, 1)
                        else
                            line.text:SetTextColor(.8, 0, 0);
                        end
                        line.square:SetBackdropColor(1, 0, 0)
                    else
                        if (line.text.eligible) then
                            line.text:SetTextColor(.9, .9, .9)
                        else
                            line.text:SetTextColor(.8, 0, 0);
                        end
                        line.square:SetBackdropColor(.8, 0, 0)
                    end
                end
            end
        end
    end

	WatchFrameTitle:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")
	WatchFrameTitle:SetTextColor(.2, .8, 1)
	--WatchFrameTitle:SetShadowColor(0, 0, 0)
	hooksecurefunc("WatchFrame_Update", function()
        SkinWatchFrameItems()
        local i = 1
        local line = _G["WatchFrameLine"..i]
        while line do
            line.text:SetFont(R["media"].font, R["media"].fontsize, "OUTLINE")
            line.text:SetSpacing(0)
            --line.text:SetShadowColor(0, 0, 0)

            line.dash:SetTextColor(0, 0, 0, 0)

            if not line.square then
                line.square = CreateFrame("Frame", nil, line)
                line.square:Point("TOPRIGHT", line, "TOPLEFT", 6, -7)
                line.square:Size(6, 6)
                line.square:SetBackdrop({
                    bgFile = R["media"].blank, 
                    edgeFile = R["media"].blank, 
                    edgeSize = R.mult, 
                })
                line.square:SetBackdropBorderColor(0, 0, 0)
                line.square:SetBackdropColor(.8, 0, 0)
            end

            if line.hasdash then
                line.square:Show()
            else
                line.square:Hide()
            end
            i = i + 1
            line = _G["WatchFrameLine"..i]
		end
	end)
end

-- M:RegisterMiscModule("WatchFrame", LoadFunc)
