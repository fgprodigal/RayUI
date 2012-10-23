local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB
local BF = R:NewModule("BUFF", "AceEvent-3.0", "AceHook-3.0")
BF.modName = L["BUFF"]

local buttonsize = 30         -- Buff Size
local spacing = 4             -- Buff Spacing
local buffsperrow = 16        -- Buffs Per Row
local growthvertical = 1      -- Growth Direction. 1 = down, 2 = up
local growthhorizontal = 1    -- Growth Direction. 1 = left, 2 = right
local buffholder, debuffholder, enchantholder

local function makeitgrow(button, index, anchor, framekind)
    for i = 1, BUFF_ACTUAL_DISPLAY do 
        if growthvertical == 1 then
			if growthhorizontal == 1 then
				if index == ((buffsperrow*i)+1) then _G[button..index]:Point("TOPRIGHT", anchor, "TOPRIGHT", 0, -(buttonsize+spacing+4)*i) end
			else
				if index == ((buffsperrow*i)+1) then _G[button..index]:Point("TOPLEFT", anchor, "TOPLEFT", 0, -(buttonsize+spacing+4)*i) end
			end
        else
			if growthhorizontal == 1 then
				if index == ((buffsperrow*i)+1) then _G[button..index]:Point("TOPRIGHT", anchor, "TOPRIGHT", 0, (buttonsize+spacing+4)*i) end
			else
				if index == ((buffsperrow*i)+1) then _G[button..index]:Point("TOPLEFT", anchor, "TOPLEFT", 0, (buttonsize+spacing+4)*i) end
			end
        end
    end
    if growthhorizontal == 1 and framekind ~= 3 then
        _G[button..index]:Point("RIGHT", _G[button..(index-1)], "LEFT", -(spacing+4), 0)
    else
        _G[button..index]:Point("LEFT", _G[button..(index-1)], "RIGHT", (spacing+4), 0)
    end
end

local function formatTime(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%d", s), (s * 100 - floor(s * 100))/100
end

function BF:StyleBuffs(button, index, framekind, anchor)
	local buff = button..index
    _G[buff.."Icon"]:SetTexCoord(.1, .9, .1, .9)
    _G[buff.."Icon"]:SetDrawLayer("OVERLAY")
    _G[buff]:ClearAllPoints()
    _G[buff]:CreateShadow()
	_G[buff]:StyleButton(true)
    
	_G[buff.."Count"]:ClearAllPoints()
	_G[buff.."Count"]:Point("TOPRIGHT", 2, 2)
    _G[buff.."Count"]:SetDrawLayer("OVERLAY")
    
	_G[buff.."Duration"]:ClearAllPoints()
	_G[buff.."Duration"]:Point("CENTER", _G[buff], "BOTTOM", 2, -1)
    _G[buff.."Duration"]:SetDrawLayer("OVERLAY")
    
    if framekind == 3 then
    	_G[buff.."Count"]:SetFont(R["media"].cdfont, 10, "OUTLINE")
    	_G[buff.."Duration"]:SetFont(R["media"].cdfont, 10, "OUTLINE")
    	_G[buff]:Height(buttonsize - 8)
		_G[buff]:Width(buttonsize - 8)
    else
		_G[buff.."Count"]:SetFont(R["media"].cdfont, 14, "OUTLINE")
   		_G[buff.."Duration"]:SetFont(R["media"].cdfont, 14, "OUTLINE")
   		_G[buff]:Height(buttonsize)
		_G[buff]:Width(buttonsize)
	end

	if _G[buff.."Border"] then 
		_G[buff.."Border"]:Kill()
	end
    if framekind == 2 then
		local dtype = select(5, UnitDebuff("player",index))
		if (dtype ~= nil) then
			color = DebuffTypeColor[dtype]
		else
			color = DebuffTypeColor["none"]
		end
		_G[buff.."Icon"]:Point("TOPLEFT", 1, -1)
		_G[buff.."Icon"]:Point("BOTTOMRIGHT", -1, 1)
		_G[buff].shadow:SetBackdropColor(0, 0, 0)
		_G[buff].border:SetBackdropBorderColor(color.r, color.g, color.b, 1)
		_G[buff]:StyleButton(1)
	end
    
    if index == 1 then _G[buff]:Point("TOPRIGHT", anchor, "TOPRIGHT", 0, 0) end
    if index ~= 1 then
		makeitgrow(button, index, _G[button..1], framekind)
	end
end

function BF:UpdateBuff()
    for i = 1, BUFF_ACTUAL_DISPLAY do
        self:StyleBuffs("BuffButton", i, 1, buffholder)
    end
    for i = 1, BuffFrame.numEnchants do
        self:StyleBuffs("TempEnchant", i, 3, enchantholder)
    end
end

function BF:UpdateDebuff(buttonName, index)
    self:StyleBuffs(buttonName, index, 2, debuffholder)
end

function BF:UpdateTime(button, timeLeft)
	local duration = _G[button:GetName().."Duration"]
	if SHOW_BUFF_DURATIONS == "1" and timeLeft then
		duration:SetText(formatTime(timeLeft))
		if timeLeft<60 then
			duration:SetTextColor(0.8, 0, 0)
		end
	end
end

function BF:Initialize()
	buffholder = CreateFrame("Frame", "Buffs", UIParent)
	buffholder:Height(R:Scale(buttonsize)*2 + R:Scale(spacing))
	buffholder:Width(R:Scale(buttonsize)*buffsperrow + R:Scale(spacing)*(buffsperrow-1))
	buffholder:SetFrameStrata("BACKGROUND")
	buffholder:SetClampedToScreen(true)
	buffholder:SetAlpha(0)
	buffholder:Point("TOPRIGHT", UIParent, "TOPRIGHT", -14, -35)
	R:CreateMover(buffholder, "BuffMover", L["Buff锚点"], true)
	debuffholder = CreateFrame("Frame", "Debuffs", UIParent)
	debuffholder:Height(buttonsize)
	debuffholder:Width(R:Scale(buttonsize)*buffsperrow + R:Scale(spacing)*(buffsperrow-1))
	debuffholder:SetFrameStrata("BACKGROUND")
	debuffholder:SetClampedToScreen(true)
	debuffholder:SetAlpha(0)
	debuffholder:Point("TOPRIGHT", UIParent, "TOPRIGHT", -14, -125)
	R:CreateMover(debuffholder, "DebuffMover", L["Debuff锚点"], true)
	enchantholder = CreateFrame("Frame", "TempEnchants", UIParent)
	enchantholder:Height(buttonsize - 8)
	enchantholder:Width(buttonsize - 8)
	enchantholder:SetFrameStrata("BACKGROUND")
	enchantholder:SetClampedToScreen(true)
	enchantholder:SetAlpha(0)
	enchantholder:Point("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -30)
	R:CreateMover(enchantholder, "WeaponEnchantMover", L["武器附魔锚点"], true)
	BF:SecureHook("BuffFrame_UpdateAllBuffAnchors", "UpdateBuff")
	BF:SecureHook("DebuffButton_UpdateAnchors", "UpdateDebuff")
	BF:SecureHook("AuraButton_UpdateDuration", "UpdateTime")
	SetCVar("consolidateBuffs", 0)
	InterfaceOptionsFrameCategoriesButton12:Kill()
	InterfaceOptionsFrameCategoriesButton13:SetPoint("TOPLEFT", InterfaceOptionsFrameCategoriesButton11, "BOTTOMLEFT", 0, 0)
	TempEnchant3:Kill()
end

R:RegisterModule(BF:GetName())
