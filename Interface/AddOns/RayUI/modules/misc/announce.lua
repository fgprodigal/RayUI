local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local M = R:GetModule("Misc")

local function LoadFunc()
	if not M.db.anounce then return end

	local announce = CreateFrame("Frame")
	local band = bit.band
	local font = R["media"].font -- HOOG0555.ttf 
	local fontflag = "OUTLINE" -- for pixelfont stick to this else OUTLINE or THINOUTLINE
	local fontsize = 20 -- font size
	local iconsize = 24
	local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE
	 
	-- Frame function
	local function CreateMessageFrame(name)
		local f = CreateFrame("ScrollingMessageFrame", name, UIParent)
		f:SetHeight(80)
		f:SetWidth(500)
		f:SetPoint("CENTER", 0, 120)
		f:SetFrameStrata("HIGH")
		f:SetTimeVisible(1.5)
		f:SetFadeDuration(1.5)
		f:SetMaxLines(3)
		f:SetFont(font, fontsize, fontflag)
		f:SetShadowOffset(1.5,-1.5)
		return f
	end

	local announceMessages = CreateMessageFrame("fDispelFrame")
	 
	local function OnEvent(self, event, timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
		if (eventType=="SPELL_DISPEL" or eventType=="SPELL_STOLEN" or eventType=="SPELL_INTERRUPT" or eventType=="SPELL_DISPEL_FAILED") and band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == COMBATLOG_OBJECT_AFFILIATION_MINE then
			local _, _, _, id, effect, _, etype = ...
			local msg = _G["ACTION_" .. eventType]
			local color
			local icon =GetSpellTexture(id)

			if eventType=="SPELL_INTERRUPT" then
				if GetRealNumRaidMembers() > 0 then
					SendChatMessage(msg..": "..destName.." \124cff71d5ff\124Hspell:"..id.."\124h["..effect.."]\124h\124r!", "RAID")
				elseif GetRealNumPartyMembers() > 0 then
					SendChatMessage(msg..": "..destName.." \124cff71d5ff\124Hspell:"..id.."\124h["..effect.."]\124h\124r!", "PARTY")
				end
			end

			if etype=="BUFF"then
				color={0,1,.5}
			else
				color={1,0,.5}
			end
			if icon then
				announceMessages:AddMessage(msg .. ": " .. effect .. " \124T"..icon..":"..iconsize..":"..iconsize..":0:0:64:64:5:59:5:59\124t",unpack(color))
			else
				announceMessages:AddMessage(msg .. ": " .. effect ,unpack(color))
			end
		end
	end

	announce:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	announce:SetScript('OnEvent', OnEvent)

	-----------------------------------------------
	-- enemy drinking(by Duffed)
	-----------------------------------------------
	local drinking_announce = CreateFrame("Frame")
	drinking_announce:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	drinking_announce:SetScript("OnEvent", function(self, event, ...)
		if not (event == "UNIT_SPELLCAST_SUCCEEDED" and GetZonePVPInfo() == "arena") then return end

		local unit, spellName, spellrank, spelline, spellID = ...
		if UnitIsEnemy("player", unit) and (spellID == 80167 or spellID == 94468 or spellID == 43183 or spellID == 57073 or spellName == "Drinking") then
			if GetRealNumRaidMembers() > 0 then
				SendChatMessage(UnitName(unit)..L["正在吃喝."], "RAID")
			elseif GetRealNumPartyMembers() > 0 and not UnitInRaid("player") then
				SendChatMessage(UnitName(unit)..L["正在吃喝."], "PARTY")
			else
				SendChatMessage(UnitName(unit)..L["正在吃喝."], "SAY")
			end
		end
	end)

	-------------------------------------------------------------------------------------
	-- Credit Alleykat 
	-- Entering combat and allertrun function (can be used in anther ways)
	------------------------------------------------------------------------------------
	local speed = .057799924 -- how fast the text appears
	local font = R["media"].font -- HOOG0555.ttf 
	local fontflag = "OUTLINE" -- for pixelfont stick to this else OUTLINE or THINOUTLINE
	local fontsize = 24 -- font size
	 
	local GetNextChar = function(word,num)
		local c = word:byte(num)
		local shift
		if not c then return "",num end
			if (c > 0 and c <= 127) then
				shift = 1
			elseif (c >= 192 and c <= 223) then
				shift = 2
			elseif (c >= 224 and c <= 239) then
				shift = 3
			elseif (c >= 240 and c <= 247) then
				shift = 4
			end
		return word:sub(num,num+shift-1),(num+shift)
	end
	 
	local updaterun = CreateFrame("Frame")
	 
	local flowingframe = CreateFrame("Frame",nil,UIParent)
	flowingframe:SetFrameStrata("HIGH")
	flowingframe:SetPoint("CENTER",UIParent,0, 140) -- where we want the textframe
	flowingframe:SetHeight(64)
	 
	local flowingtext = flowingframe:CreateFontString(nil,"OVERLAY")
	flowingtext:SetFont(font,fontsize, fontflag)
	flowingtext:SetShadowOffset(1.5,-1.5)
	 
	local rightchar = flowingframe:CreateFontString(nil,"OVERLAY")
	rightchar:SetFont(font,60, fontflag)
	rightchar:SetShadowOffset(1.5,-1.5)
	rightchar:SetJustifyH("LEFT") -- left or right
	 
	local count,len,step,word,stringE,a,backstep
	 
	local nextstep = function()
		a,step = GetNextChar (word,step)
		flowingtext:SetText(stringE)
		stringE = stringE..a
		a = string.upper(a)
		rightchar:SetText(a)
	end
	 
	local backrun = CreateFrame("Frame")
	backrun:Hide()
	 
	local updatestring = function(self,t)
		count = count - t
			if count < 0 then
				count = speed
				if step > len then
					self:Hide()
					flowingtext:SetText(stringE)
					rightchar:SetText()
					flowingtext:ClearAllPoints()
					flowingtext:SetPoint("RIGHT")
					flowingtext:SetJustifyH("RIGHT")
					rightchar:ClearAllPoints()
					rightchar:SetPoint("RIGHT",flowingtext,"LEFT")
					rightchar:SetJustifyH("RIGHT")
					self:Hide()
					count = 1.456789
					backrun:Show()
				else
					nextstep()
				end
			end
	end
	 
	updaterun:SetScript("OnUpdate",updatestring)
	updaterun:Hide()
	 
	local backstepf = function()
		local a = backstep
		local firstchar
			local texttemp = ""
			local flagon = true
			while a <= len do
				local u
				u,a = GetNextChar(word,a)
				if flagon == true then
					backstep = a
					flagon = false
					firstchar = u
				else
					texttemp = texttemp..u
				end
			end
		flowingtext:SetText(texttemp)
		firstchar = string.upper(firstchar)
		rightchar:SetText(firstchar)
	end
	 
	local rollback = function(self,t)
		count = count - t
			if count < 0 then
				count = speed
				if backstep > len then
					self:Hide()
					flowingtext:SetText()
					rightchar:SetText()
				else
					backstepf()
				end
			end
	end
	 
	backrun:SetScript("OnUpdate",rollback)
	 
	local allertrun = function(f,r,g,b)
		flowingframe:Hide()
		updaterun:Hide()
		backrun:Hide()
	 
		flowingtext:SetText(f)
		local l = flowingtext:GetWidth()
	 
		local color1 = r or 1
		local color2 = g or 1
		local color3 = b or 1
	 
		flowingtext:SetTextColor(color1*.95,color2*.95,color3*.95) -- color in RGB(red green blue)(alpha)
		rightchar:SetTextColor(color1,color2,color3)
	 
		word = f
		len = f:len()
		step,backstep = 1,1
		count = speed
		stringE = ""
		a = ""
	 
		flowingtext:SetText("")
		flowingframe:SetWidth(l)
		flowingtext:ClearAllPoints()
		flowingtext:SetPoint("LEFT")
		flowingtext:SetJustifyH("LEFT")
		rightchar:ClearAllPoints()
		rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
		rightchar:SetJustifyH("LEFT")
	 
		rightchar:SetText("")
		updaterun:Show()
		flowingframe:Show()
	end

	CombatText:UnregisterEvent("PLAYER_REGEN_ENABLED")
	CombatText:UnregisterEvent("PLAYER_REGEN_DISABLED")

	SetCVar("fctCombatState", "1")
	local a = CreateFrame ("Frame")
	a:RegisterEvent("PLAYER_REGEN_ENABLED")
	a:RegisterEvent("PLAYER_REGEN_DISABLED")
	a:RegisterEvent("PLAYER_ENTERING_WORLD")
	a:SetScript("OnEvent", function (self,event)
		if (UnitIsDead("player")) then return end
		if event == "PLAYER_REGEN_ENABLED" and(COMBAT_TEXT_SHOW_COMBAT_STATE=="1") then
			-- allertrun("LEAVING COMBAT",0.1,1,0.1)
			allertrun(LEAVING_COMBAT.." !",0.1,1,0.1)
		elseif event == "PLAYER_REGEN_DISABLED" and(COMBAT_TEXT_SHOW_COMBAT_STATE=="1") then
			-- allertrun("ENTERING COMBAT",1,0.1,0.1)
			allertrun(ENTERING_COMBAT.." !",1,0.1,0.1)
		elseif event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)

	local tradeSkillAnnouce = CreateFrame("Frame")
	tradeSkillAnnouce:RegisterEvent("CHAT_MSG_SKILL")
	tradeSkillAnnouce:SetScript("OnEvent", function(self, event, message)
		UIErrorsFrame:AddMessage(message, ChatTypeInfo["SKILL"].r, ChatTypeInfo["SKILL"].g, ChatTypeInfo["SKILL"].b)
	end)
end

M:RegisterMiscModule("Announce", LoadFunc)