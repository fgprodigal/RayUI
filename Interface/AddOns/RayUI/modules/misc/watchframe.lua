local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
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

    WatchFrame:HookScript("OnEvent", SkinWatchFrameItems)
end

M:RegisterMiscModule("WatchFrame", LoadFunc)
