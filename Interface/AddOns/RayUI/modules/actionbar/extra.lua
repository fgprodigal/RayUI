local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local AB = R:GetModule("ActionBar")

function AB:CreateExtraButton()
	local holder = CreateFrame('Frame', nil, UIParent)
	holder:Point("CENTER", UIParent, "BOTTOM", 500, 510)
	holder:Size(ExtraActionBarFrame:GetSize())

	ExtraActionBarFrame:SetParent(holder)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", holder, "CENTER")
	ExtraActionBarFrame.ignoreFramePositionManager  = true
	--ExtraActionButton1Cooldown:Point("TOPLEFT", 1, -1)
	--ExtraActionButton1Cooldown:Point("BOTTOMRIGHT", -1, 1)
	--ExtraActionButton1:StyleButton(true)
	for i=1, ExtraActionBarFrame:GetNumChildren() do
		if _G["ExtraActionButton"..i] then
			_G["ExtraActionButton"..i].noResize = true
			_G["ExtraActionButton"..i].pushed = true
			_G["ExtraActionButton"..i].checked = true
			
			self:Style(_G["ExtraActionButton"..i])
            _G["ExtraActionButton"..i]:StyleButton(true)
			_G["ExtraActionButton"..i.."Icon"]:SetDrawLayer("ARTWORK")
			local tex = _G["ExtraActionButton"..i]:CreateTexture(nil, "OVERLAY")
			tex:SetTexture(0.9, 0.8, 0.1, 0.3)
			tex:SetAllPoints()
			_G["ExtraActionButton"..i]:SetCheckedTexture(tex)
		end
	end

	R:CreateMover(holder, "BossButton", "BossButton", true, nil, "ALL,ACTIONBARS,RAID15,RAID25,RAID40")
end
