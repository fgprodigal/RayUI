local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function SkinAce3()
	local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
	if not AceGUI then return end
	if not S.db.ace3 then return end
	local oldRegisterAsWidget = AceGUI.RegisterAsWidget

	local r, g, b = S["media"].classcolours[R.myclass].r, S["media"].classcolours[R.myclass].g, S["media"].classcolours[R.myclass].b

	AceGUI.RegisterAsWidget = function(self, widget)
		local TYPE = widget.type
		--print(TYPE)
		if TYPE == "MultiLineEditBox" then
			local frame = widget.frame
			S:Reskin(widget.button)
			S:ReskinScroll(widget.scrollBar)
		elseif TYPE == "CheckBox" then
			widget.checkbg:Kill()
			widget.highlight:Kill()
			widget.frame:SetHighlightTexture(R["media"].gloss)
			local hl = widget.frame:GetHighlightTexture()
			hl:Point("TOPLEFT", widget.checkbg, 5, -5)
			hl:Point("BOTTOMRIGHT", widget.checkbg, -5, 5)
			hl:SetVertexColor(r, g, b, .2)

			if not widget.skinnedCheckBG then
				widget.skinnedCheckBG = CreateFrame('Frame', nil, widget.frame)
				widget.skinnedCheckBG:Point('TOPLEFT', widget.checkbg, 'TOPLEFT', 4, -4)
				widget.skinnedCheckBG:Point('BOTTOMRIGHT', widget.checkbg, 'BOTTOMRIGHT', -4, 4)
				S:CreateBD(widget.skinnedCheckBG, 0)
				S:CreateBackdropTexture(widget.skinnedCheckBG)
			end

			if widget.skinnedCheckBG.oborder then
				widget.check:SetParent(widget.skinnedCheckBG.oborder)
			else
				widget.check:SetParent(widget.skinnedCheckBG)
			end
			widget.check:SetDesaturated(true)
			widget.check:SetVertexColor(r, g, b)
		elseif TYPE == "Dropdown" then
			local frame = widget.dropdown
			local button = widget.button
			local text = widget.text
			frame:StripTextures()
			local bg = CreateFrame("Frame", nil, frame)
			bg:Point("TOPLEFT", 16, 0)
			bg:Point("BOTTOMRIGHT", -15, 0)
			bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S:CreateBD(bg, 0)
			S:CreateBackdropTexture(bg)
			bg.backdropTexture:Point("TOPLEFT", bg, "TOPLEFT", 0, -1)
			bg.backdropTexture:Point("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -1, 0)

			S:Reskin(button)
			button:Size(25, 25)
			button:ClearAllPoints()
			button:Point("TOPRIGHT", frame, "TOPRIGHT", -15, 0)
			button:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -15, 0)

			button:SetDisabledTexture(R["media"].gloss)
			local dis = button:GetDisabledTexture()
			dis:SetVertexColor(0, 0, 0, .3)
			dis:SetDrawLayer("OVERLAY")

			local downtex = button:CreateTexture(nil, "ARTWORK")
			downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
			downtex:Size(8, 8)
			downtex:SetPoint("CENTER")
			downtex:SetVertexColor(1, 1, 1)

			button:SetParent(bg)
			text:SetParent(bg)
			button:HookScript('OnClick', function(this)
				local self = this.obj
				S:CreateBD(self.pullout.frame)
			end)
		elseif TYPE == "LSM30_Font" or TYPE == "LSM30_Sound" or TYPE == "LSM30_Border" or TYPE == "LSM30_Background" or TYPE == "LSM30_Statusbar" then
			local frame = widget.frame
			local button = frame.dropButton
			local text = frame.text
			frame:StripTextures()

			S:Reskin(button)
			button:Size(20, 20)

			button:SetDisabledTexture(R["media"].gloss)
			local dis = button:GetDisabledTexture()
			dis:SetVertexColor(0, 0, 0, .3)
			dis:SetDrawLayer("OVERLAY")

			local downtex = button:CreateTexture(nil, "ARTWORK")
			downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
			downtex:Size(8, 8)
			downtex:SetPoint("CENTER")
			downtex:SetVertexColor(1, 1, 1)
			frame.text:ClearAllPoints()
			frame.text:Point('RIGHT', button, 'LEFT', -2, 0)

			if not frame.backdrop then
				frame.backdrop = CreateFrame("Frame", nil, frame)
				frame.backdrop:Point("TOPLEFT", -3, 3)
				frame.backdrop:Point("BOTTOMRIGHT", 3, -3)
				S:CreateBackdropTexture(frame.backdrop)
				S:CreateBD(frame.backdrop)
				if frame:GetFrameLevel() - 1 >= 0 then
					frame.backdrop:SetFrameLevel(frame:GetFrameLevel() - 1)
				else
					frame.backdrop:SetFrameLevel(0)
				end
				if TYPE == "LSM30_Font" then
					frame.backdrop:Point("TOPLEFT", 20, -20)
				elseif TYPE == "LSM30_Sound" then
					frame.backdrop:Point("TOPLEFT", 20, -20)
					widget.soundbutton:SetParent(frame.backdrop)
					widget.soundbutton:ClearAllPoints()
					widget.soundbutton:Point('LEFT', frame.backdrop, 'LEFT', 2, 0)
				elseif TYPE == "LSM30_Statusbar" then
					frame.backdrop:Point("TOPLEFT", 20, -20)
					widget.bar:ClearAllPoints()
					widget.bar:Point('TOPLEFT', frame.backdrop, 'TOPLEFT', 2, -2)
					widget.bar:Point('BOTTOMRIGHT', frame.backdrop, 'BOTTOMRIGHT', -2, 2)
					widget.bar:SetParent(frame.backdrop)
				elseif TYPE == "LSM30_Border" or TYPE == "LSM30_Background" then
					frame.backdrop:Point("TOPLEFT", 42, -20)
				end

				frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 3)
			end
			button:SetParent(frame.backdrop)
			button:ClearAllPoints()
			button:Point("TOPRIGHT", frame, "TOPRIGHT", -8, -20)
			button:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 3)
			text:SetParent(frame.backdrop)
			button:HookScript('OnClick', function(this, button)
				local self = this.obj
				if self.dropdown then
					S:CreateBD(self.dropdown)
				end
			end)
		elseif TYPE == "EditBox" then
			local frame = widget.editbox
			local button = widget.button
			-- frame:StripTextures()
			if _G[frame:GetName()..'Left'] then
				_G[frame:GetName()..'Left']:Kill()
			end
			if _G[frame:GetName()].Left then
				_G[frame:GetName()].Left:Kill()
			end
			if _G[frame:GetName()..'Middle'] then
				_G[frame:GetName()..'Middle']:Kill()
			end
			if _G[frame:GetName()].Middle then
				_G[frame:GetName()].Middle:Kill()
			end
			if _G[frame:GetName()..'Right'] then
				_G[frame:GetName()..'Right']:Kill()
			end
			if _G[frame:GetName()].Right then
				_G[frame:GetName()].Right:Kill()
			end
			S:ReskinInput(frame)
			button:ClearAllPoints()
			button:SetPoint("RIGHT", frame, "RIGHT", -7, 0)
			button:SetParent(frame)
			S:Reskin(button)
		elseif TYPE == "Button" then
			local frame = widget.frame
			S:Reskin(frame)
			frame.backdropTexture:Point("TOPLEFT", frame, "TOPLEFT", 0, -1)
			frame.backdropTexture:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 0)
		elseif TYPE == "Slider" then
			local frame = widget.slider
			local editbox = widget.editbox
			local lowtext = widget.lowtext
			local hightext = widget.hightext
			local HEIGHT = 12

			frame:StripTextures()
			S:CreateBD(frame, 0)
			frame:Height(HEIGHT)
			S:CreateBackdropTexture(frame)

			local slider = frame:GetThumbTexture()
			slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			slider:SetBlendMode("ADD")

			S:CreateBD(editbox, 0)
			editbox.SetBackdropColor = R.dummy
			editbox.SetBackdropBorderColor = R.dummy
			editbox:Height(15)
			editbox:Point("TOP", frame, "BOTTOM", 0, -1)
			S:CreateBackdropTexture(editbox)

			lowtext:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 2, -2)
			hightext:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -2, -2)


			--[[elseif TYPE == "ColorPicker" then
			local frame = widget.frame
			local colorSwatch = widget.colorSwatch
			]]
		elseif TYPE == "Heading" then
			widget.left:Height(1)
			widget.left:SetTexture(.4, .4, .4)
			widget.left:SetGradientAlpha("HORIZONTAL", .8, .8, .8, 0, .8, .8, .8, 1)
			widget.right:Height(1)
			widget.right:SetTexture(.4, .4, .4)
			widget.right:SetGradientAlpha("HORIZONTAL", .8, .8, .8, 1, .8, .8, .8, 0)
		end
		return oldRegisterAsWidget(self, widget)
	end

	local oldRegisterAsContainer = AceGUI.RegisterAsContainer

	AceGUI.RegisterAsContainer = function(self, widget)
		local TYPE = widget.type
		if TYPE == "ScrollFrame" then
			local frame = widget.scrollbar
			frame:StripTextures()
			S:ReskinScroll(frame)
		elseif TYPE == "InlineGroup" or TYPE == "TreeGroup" or TYPE == "TabGroup" or TYPE == "SimpleGroup" or TYPE == "Frame" or TYPE == "DropdownGroup" then
			local frame = widget.content:GetParent()
			frame:SetBackdrop(nil)
			-- S:CreateBD(frame, .3)
			if TYPE == "Frame" then
				frame:StripTextures()
				for i=1, frame:GetNumChildren() do
					local child = select(i, frame:GetChildren())
					if child:GetObjectType() == "Button" and child:GetText() then
						S:Reskin(child)
					else
						child:StripTextures()
					end
				end
				S:SetBD(frame)
			end

			if widget.treeframe then
				widget.treeframe:SetBackdrop(nil)
				-- S:CreateBD(widget.treeframe, .3)
				frame:Point("TOPLEFT", widget.treeframe, "TOPRIGHT", 1, 0)
			end

			if TYPE == "TabGroup" then
				local oldCreateTab = widget.CreateTab
				widget.CreateTab = function(self, id)
					local tab = oldCreateTab(self, id)
					tab:StripTextures()
					return tab
				end
			end

			if widget.scrollbar then
				S:ReskinScroll(widget.scrollbar)
			end
		end
		return oldRegisterAsContainer(self, widget)
	end
end

S:RegisterSkin("RayUI", SkinAce3)
