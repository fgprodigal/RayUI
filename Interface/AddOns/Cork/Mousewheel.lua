
local myname, Cork = ...

-- Dynamic mousewheel binding module, originally created by Adirelle <gperreal@free.fr>

local function ClearBindings()
	if InCombatLockdown() then return end
	ClearOverrideBindings(CorkFrame)
end

function Cork:UpdateMouseBinding(event, unit)
	if InCombatLockdown() then return end
	if Cork.db.bindwheel and (event ~= "PLAYER_REGEN_DISABLED") and Corkboard:IsVisible() then
		SetOverrideBindingClick(CorkFrame, true, 'MOUSEWHEELUP', 'CorkFrame')
		SetOverrideBindingClick(CorkFrame, true, 'MOUSEWHEELDOWN', 'CorkFrame')
	else
		ClearOverrideBindings(CorkFrame)
	end
end


local frame = CreateFrame('Frame', nil, Corkboard)
frame:SetScript('OnShow', Cork.UpdateMouseBinding)
frame:SetScript('OnHide', ClearBindings)

frame:SetScript("OnEvent", Cork.UpdateMouseBinding)
frame:RegisterEvent('PLAYER_REGEN_ENABLED')
frame:RegisterEvent('PLAYER_REGEN_DISABLED')
