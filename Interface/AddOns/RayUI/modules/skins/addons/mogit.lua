local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function SkinMogIt()
	if not S.db.mogit then return end
	local MogIt = MogIt
	--Skinning MogIt Frames
	MogItFrame:StripTextures()
	S:SetBD(MogItFrame)
	MogItFrameInset:StripTextures()
	S:CreateBD(MogItFrameInset)
	MogItFilters:StripTextures()
	MogItFilters:CreateShadow("Background")
	MogItFiltersInset:StripTextures()
	MogItFiltersInset:CreateShadow("Background")

	--Skin the Buttons
	S:Reskin(MogItFrameFiltersDefaults)
	MogItFrameFiltersDefaults:StripTextures()
	MogItFrameFiltersDefaults:CreateShadow("Background")

	S:ReskinClose(MogItFrameCloseButton)
	S:ReskinClose(MogItFiltersCloseButton)

	--Skin the Scrollbars
	S:ReskinScroll(MogItScroll)
	S:ReskinScroll(MogItFiltersScrollScrollBar)

	local _CreatePreview = MogIt.CreatePreview
	function MogIt.CreatePreview()
		local f = _CreatePreview()
		f:StripTextures()
		f.Inset:Kill()
		S:Reskin(f.activate)
		S:SetBD(f)
		for i = 1, 13 do
			local slotIndex = MogIt:GetSlot(i)
			f.slots[slotIndex]:StripTextures()
			f.slots[slotIndex]:StyleButton(1)
			_G[f.slots[slotIndex]:GetName().."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
			_G[f.slots[slotIndex]:GetName().."IconTexture"]:SetInside(nil, 1, 1)
			S:CreateBD(f.slots[slotIndex])
		end

		return f
	end

	local _CreateModelFrame = MogIt.CreateModelFrame
	function MogIt:CreateModelFrame(parent)
		local f = _CreateModelFrame(self, parent)
		S:CreateBD(f.model, 0)

		return f
	end
end

S:RegisterSkin("MogIt", SkinMogIt)