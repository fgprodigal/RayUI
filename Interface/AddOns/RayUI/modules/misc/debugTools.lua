local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local, GlobalDB
local M = R:GetModule("Misc")

local function LoadFunc()
	--Enhanced debugtools from ElvUI
	local D = R:NewModule("DebugTools", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
	local S = R:GetModule("Skins")

	local showErrorButton = CreateFrame("Button", nil, Minimap)
	showErrorButton:Hide()
	showErrorButton:Size(15, 15)
	showErrorButton:SetPoint("RIGHT", -1, 0)
	showErrorButton:SetScript("OnClick", function(self)
		ScriptErrorsFrame:SetParent(UIParent)
		D.MessagePrinted = nil
		self:Hide()
	end)
	local showErrorButtonText = showErrorButton:CreateFontString(nil, "OVERLAY")
	showErrorButtonText:SetPoint("CENTER", 2, 1)
	showErrorButtonText:SetFont(R["media"].pxfont,R.mult*10, "OUTLINE,MONOCHROME")
	showErrorButtonText:SetText("|cffff0000E|r")

	function D:ModifyErrorFrame()
		ScriptErrorsFrameScrollFrameText.cursorOffset = 0
		ScriptErrorsFrameScrollFrameText.cursorHeight = 0
		ScriptErrorsFrameScrollFrameText:SetScript("OnEditFocusGained", nil)
		
		local Orig_ScriptErrorsFrame_Update = ScriptErrorsFrame_Update
		ScriptErrorsFrame_Update = function(...)
			if GetCVarBool("scriptErrors") ~= 1 then
				Orig_ScriptErrorsFrame_Update(...)
				return
			end
			
			-- Sometimes the locals table does not have an entry for an index, which can cause an argument #6 error
			-- in Blizzard_DebugTools.lua:430 and then cause a C stack overflow, this will prevent that
			local index = ScriptErrorsFrame.index
			if( not index or not ScriptErrorsFrame.order[index] ) then
				index = #(ScriptErrorsFrame.order)
			end

			if( index > 0 ) then
				ScriptErrorsFrame.locals[index] = ScriptErrorsFrame.locals[index] or L["没有本地变量转存"]
			end
			
			Orig_ScriptErrorsFrame_Update(...)
			
			-- Stop text highlighting again
			ScriptErrorsFrameScrollFrameText:HighlightText(0, 0)
		end	
		
		-- Unhighlight text when focus is hit
		ScriptErrorsFrameScrollFrameText:HookScript("OnEscapePressed", function(self)
			self:HighlightText(0, 0)
		end)	
		
		
		ScriptErrorsFrame:Size(500, 300)
		ScriptErrorsFrameScrollFrame:Size(ScriptErrorsFrame:GetWidth() - 45, ScriptErrorsFrame:GetHeight() - 71)
		
		local BUTTON_WIDTH = 75
		local BUTTON_HEIGHT = 24
		local BUTTON_SPACING = 2
		
		-- Add a first button
		local firstButton = CreateFrame("Button", nil, ScriptErrorsFrame, "UIPanelButtonTemplate")
		firstButton:SetPoint("BOTTOM", ScriptErrorsFrame, "BOTTOM", -((BUTTON_WIDTH + BUTTON_WIDTH/2) + (BUTTON_SPACING * 4)), 8)
		firstButton:SetText(L["第一页"])
		firstButton:SetHeight(BUTTON_HEIGHT)
		firstButton:SetWidth(BUTTON_WIDTH)
		firstButton:SetScript("OnClick", function(self)
			ScriptErrorsFrame.index = 1
			ScriptErrorsFrame_Update()
		end)
		ScriptErrorsFrame.firstButton = firstButton
		S:Reskin(firstButton)

		-- Also add a Last button for errors
		local lastButton = CreateFrame("Button", nil, ScriptErrorsFrame, "UIPanelButtonTemplate")
		lastButton:SetPoint("BOTTOMLEFT", ScriptErrorsFrame.next, "BOTTOMRIGHT", BUTTON_SPACING, 0)
		lastButton:SetHeight(BUTTON_HEIGHT)
		lastButton:SetWidth(BUTTON_WIDTH)
		lastButton:SetText(L["最后页"])
		lastButton:SetScript("OnClick", function(self)
			ScriptErrorsFrame.index = #(ScriptErrorsFrame.order)
			ScriptErrorsFrame_Update()
		end)
		ScriptErrorsFrame.lastButton = lastButton
		S:Reskin(lastButton)

		ScriptErrorsFrame.previous:ClearAllPoints()
		ScriptErrorsFrame.previous:SetPoint("BOTTOMLEFT", firstButton, "BOTTOMRIGHT", BUTTON_SPACING, 0)
		ScriptErrorsFrame.previous:SetWidth(BUTTON_WIDTH)
		ScriptErrorsFrame.previous:SetHeight(BUTTON_HEIGHT)
		
		ScriptErrorsFrame.next:ClearAllPoints()
		ScriptErrorsFrame.next:SetPoint("BOTTOMLEFT", ScriptErrorsFrame.previous, "BOTTOMRIGHT", BUTTON_SPACING, 0)
		ScriptErrorsFrame.next:SetWidth(BUTTON_WIDTH)
		ScriptErrorsFrame.next:SetHeight(BUTTON_HEIGHT)
		
		ScriptErrorsFrame.close:ClearAllPoints()
		ScriptErrorsFrame.close:SetPoint("BOTTOMRIGHT", ScriptErrorsFrame, "BOTTOMRIGHT", -8, 8)	
		ScriptErrorsFrame.close:Size(75, BUTTON_HEIGHT)
		
		ScriptErrorsFrame.indexLabel:ClearAllPoints()
		ScriptErrorsFrame.indexLabel:SetPoint("BOTTOMLEFT", ScriptErrorsFrame, "BOTTOMLEFT", -6, 8)	
	end

	function D:ScriptErrorsFrame_UpdateButtons()
		local numErrors = #ScriptErrorsFrame.order
		local index = ScriptErrorsFrame.index
		if ( index == 0 ) then
			ScriptErrorsFrame.lastButton:Disable()
			ScriptErrorsFrame.firstButton:Disable()
		else
			if ( numErrors == 1 ) then
				ScriptErrorsFrame.lastButton:Disable()
				ScriptErrorsFrame.firstButton:Disable()		
			else
				ScriptErrorsFrame.lastButton:Enable()
				ScriptErrorsFrame.firstButton:Enable()				
			end
		end
	end

	function D:ScriptErrorsFrame_OnError(_, keepHidden)
		if keepHidden or self.MessagePrinted or ScriptErrorsFrame:GetParent()==UIParent --[[ or not InCombatLockdown() ]] or GetCVarBool("scriptErrors") ~= 1 then return end

		PlaySoundFile(R["media"].errorsound)
		R:Print(L['|cFFE30000接收到Lua错误. 可以通过点击小地图的"E"按钮查看错误.'])
		showErrorButton:Show()
		self.MessagePrinted = true
	end

	function D:PLAYER_REGEN_DISABLED()
		ScriptErrorsFrame:SetParent(self.HideFrame)
	end

	function D:TaintError(event, addonName, addonFunc)
		if GetCVarBool("scriptErrors") ~= 1 or not R:IsDeveloper() or addonName ~= "RayUI" then return end
		ScriptErrorsFrame_OnError(L["%s: %s 尝试调用保护函数 '%s'."]:format(event, addonName or "<name>", addonFunc or "<func>"), false)
	end
	
	function D:ShowScriptErrorsFrame()
		ScriptErrorsFrame:Show()
		ScriptErrorsFrame:SetParent(UIParent)
	end

	D.HideFrame = CreateFrame("Frame")
	D.HideFrame:Hide()

	if( not IsAddOnLoaded("Blizzard_DebugTools") ) then
		LoadAddOn("Blizzard_DebugTools")
	end
	ScriptErrorsFrame:SetParent(D.HideFrame)

	ScriptErrorsFrame:HookScript("OnHide", function(self)
		self:SetParent(D.HideFrame)
	end)

	D:ModifyErrorFrame()
	D:SecureHook("ScriptErrorsFrame_UpdateButtons")
	D:SecureHook("ScriptErrorsFrame_OnError")
	D:RegisterEvent("PLAYER_REGEN_DISABLED")
	-- D:RegisterEvent("ADDON_ACTION_BLOCKED", "TaintError")
	D:RegisterEvent("ADDON_ACTION_FORBIDDEN", "TaintError")
	D:RegisterChatCommand("error", "ShowScriptErrorsFrame")

	SetCVar("scriptErrors", 1)
end

M:RegisterMiscModule("DebugTools", LoadFunc)
