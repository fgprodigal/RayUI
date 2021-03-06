----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Raid")


local RA = _Raid
local UF = R.UnitFrames

local _, ns = ...
local RayUF = ns.oUF


function RA:Hex(r, g, b)
    if(type(r) == "table") then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
end

function RA:UpdateThreat(event, unit)
    if(unit ~= self.unit) then return end

    local status = UnitThreatSituation(unit)

    if(status and status > 1) then
        local r, g, b = GetThreatStatusColor(status)
        if not R.PixelMode then
            self.Health.shadow:SetBackdropBorderColor(r, g, b, 1)
        else
            self.Health.border:SetBackdropBorderColor(r, g, b, 1)
        end
    else
        if not R.PixelMode then
            self.Health.shadow:SetBackdropBorderColor(0, 0, 0)
        else
            self.Health.border:SetBackdropBorderColor(0, 0, 0)
        end
    end
    self.ThreatIndicator:Show()
end

function RA:PostHealth(unit)
    local curhealth, maxhealth
    local owner = self.__owner
    local name = UnitName(unit)

    if owner.isForced then
        maxhealth = UnitHealthMax(unit)
        curhealth = math.random(1, maxhealth)
        self:SetValue(curhealth)
    end

    local suffix = owner:GetAttribute"unitsuffix"
    if suffix == "pet" or unit == "vehicle" or unit == "pet" then
        return
    end

    if UF.db.healthColorClass then
        self.colorClass=true
        self.bg.multiplier = .2
        R:SetStatusBarGradient(self)
        self:GetParent().gradient:Hide()
    elseif UF.db.transparent then
        self.backdropTexture:Hide()
        if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
            self.bg:Hide()
            self:GetParent().gradient:SetGradientAlpha("VERTICAL", .6, .6, .6, .6, .4, .4, .4, .6)
        else
            self.bg:Show()
            if not curhealth then
                curhealth, maxhealth = UnitHealth(unit), UnitHealthMax(unit)
            end
            local r, g, b = RayUF.ColorGradient(curhealth, maxhealth, unpack(RayUF.colors.smooth))
            self.bg:SetVertexColor(r, g, b)
            self.bg:SetGradient("VERTICAL", R:GetGradientColor(r, g, b))
            self:GetParent().gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
        end
    else
        if not curhealth then
            curhealth, maxhealth = UnitHealth(unit), UnitHealthMax(unit)
        end
        local r, g, b
        if UF.db.smoothColor then
            r,g,b = RayUF.ColorGradient(curhealth, maxhealth, 1, 0, 0, .85, .8, .45, .05, .05, .05)
        else
            r,g,b = .12, .12, .12, 1
        end

        if(b) then
            self:SetStatusBarColor(r, g, b, 1)
        end
        if UF.db.smoothColor then
            if UnitIsDeadOrGhost(unit) or (not UnitIsConnected(unit)) then
                self:SetStatusBarColor(.5, .5, .5)
                self.bg:SetVertexColor(.5, .5, .5)
            else
                local mu = self.bg.multiplier
                self.bg:SetVertexColor(r * mu, g * mu, b * mu)
            end
        end
    end

    if not owner:IsElementEnabled("ReadyCheckIndicator") then
        RA.Logger:Info(owner:GetName() .. "ReadyCheck Disabled")
        owner:EnableElement("ReadyCheckIndicator")
    end
end

function RA:UpdateHealth(hp)
    hp:SetStatusBarTexture(R["media"].normal)
    hp:SetOrientation("HORIZONTAL")
    hp.bg:SetTexture(R["media"].normal)
    hp.Smooth = UF.db.smooth
    hp.colorReaction = nil
    hp.colorClass = nil
    if UF.db.transparent then
        hp:SetStatusBarColor(0, 0, 0, 0)
        hp.bg:ClearAllPoints()
        hp.bg:Point("BOTTOMLEFT", hp:GetStatusBarTexture(), "BOTTOMRIGHT")
        hp.bg:Point("TOPRIGHT", hp)
    elseif UF.db.healthColorClass then
        hp.colorReaction = true
        hp.colorClass = true
        hp.bg.multiplier = .2
    elseif not UF.db.smoothColor then
        hp.colorReaction = true
        hp.colorClass = true
        hp.bg.multiplier = .8
    else
        hp:SetStatusBarColor(.12, .12, .12)
        hp.bg:SetVertexColor(.33, .33, .33)
        hp.bg.multiplier = .15
    end

    hp:ClearAllPoints()
    hp:SetPoint("TOP")
    hp:SetPoint("LEFT")
    hp:SetPoint("RIGHT")
end

local tokens = { [0] = "MANA", "RAGE", "FOCUS", "ENERGY", "RUNIC_POWER" }
function RA:PostPower(unit, min, max)
    local owner = self.__owner
    local _, ptype = UnitPowerType(unit)
    local _, class = UnitClass(unit)

    owner.Health:Point("BOTTOM", owner.Power, "TOP", 0, 1)

    local perc = RayUF.Tags.Methods["perpp"](unit)

    if owner.isForced then
        ptype = math.random(0, 4)
        local color = RayUF.colors.power[tokens[ptype]]
        min = math.random(1, UnitPowerMax(unit))
        self:SetValue(min)

        if not self.colorClass then
            self:SetStatusBarColor(color[1], color[2], color[3])
            local mu = self.bg.multiplier or 1
            self.bg:SetVertexColor(color[1] * mu, color[2] * mu, color[3] * mu)
        end
    end

    if (perc < 10 and UnitIsConnected(unit) and ptype == "MANA" and not UnitIsDeadOrGhost(unit)) then
        owner.ThreatIndicator:SetBackdropBorderColor(0, 0, 1, 1)
    else
        -- pass the coloring back to the threat func
        RA.UpdateThreat(owner, nil, unit)
    end

    if UF.db.powerColorClass then
        self.colorClass=true
        self.bg.multiplier = .2
    else
        self.colorPower=true
        self.bg.multiplier = .2
    end
end

function RA:UpdatePower(power)
    power:Show()
    power.PostUpdate = RA.PostPower
    power:SetStatusBarTexture(R["media"].normal)
    power:SetOrientation("HORIZONTAL")
    power.bg:SetTexture(R["media"].normal)
    power.colorClass = nil
    power.colorReaction = nil
    power.colorPower = nil
    power.bg.multiplier = .2
    if UF.db.powerColorClass then
        power.colorReaction = true
        power.colorClass = true
    else
        power.colorPower = true
        power.colorReaction = true
        power:SetStatusBarColor(.12, .12, .12)
        power.bg:SetVertexColor(.12, .12, .12)
    end

    power:ClearAllPoints()
    power:SetPoint("LEFT")
    power:SetPoint("RIGHT")
    power:SetPoint("BOTTOM")
end

function RA:UnitFrame_OnShow(event)
    if event ~= "OnShow" then return end
    local parent = self:GetParent()
    if parent.label then parent.label:Show() end
end

function RA:UnitFrame_OnHide()
    local parent = self:GetParent()
    if not parent.label then return end
    for i = 1, #parent do
        local unit = parent[i]
        if unit:IsShown() then return end
    end
    parent.label:Hide()
end

-- Show Mouseover highlight
function RA:UnitFrame_OnEnter()
    if RA.db.tooltip and not InCombatLockdown() then
        UnitFrame_OnEnter(self)
    else
        GameTooltip:Hide()
    end

    if RA.db.highlight then
        self.Highlight:Show()
    end

    if RA.db.arrow and RA.db.arrowmouseover then
        RA:arrow(self, self.unit)
    end
end

function RA:UnitFrame_OnLeave()
    if RA.db.tooltip then
        UnitFrame_OnLeave(self)
    end
    self.Highlight:Hide()

    if(self.RayUFArrow and self.RayUFArrow:IsShown()) and RA.db.arrowmouseover then
        self.RayUFArrow:Hide()
    end
end

local counterOffsets = {
    ["TOPLEFT"] = {9, 0},
    ["TOPRIGHT"] = {-7, 0},
    ["BOTTOMLEFT"] = {9, 0},
    ["BOTTOMRIGHT"] = {-7, 0},
    ["LEFT"] = {9, 0},
    ["RIGHT"] = {-7, 0},
    ["TOP"] = {0, 0},
    ["BOTTOM"] = {0, 0},
}

function RA:ConfigureAuraWatch(frame)
    local buffs = {}
    local auras = frame.AuraWatch
    auras:Show()

    if not _AuraWatchList[R.myclass] then _AuraWatchList[R.myclass] = {} end

    if frame.unit == "pet" and _AuraWatchList.PET then
        for _, value in pairs(_AuraWatchList.PET) do
            tinsert(buffs, value)
        end
    else
        for _, value in pairs(_AuraWatchList[R.myclass]) do
            tinsert(buffs, value)
        end
    end

    if auras.icons then
        for spell in pairs(auras.icons) do
            local matchFound = false
            for _, spell2 in pairs(buffs) do
                if spell2["id"] then
                    if spell2["id"] == spell then
                        matchFound = true
                    end
                end
            end

            if not matchFound then
                auras.icons[spell]:Hide()
                auras.icons[spell] = nil
            end
        end
    end

    for _, spell in pairs(buffs) do
        local icon
        if spell["id"] then
            local name, _, image = GetSpellInfo(spell["id"])
            if name then
                if not auras.icons[spell.id] then
                    icon = CreateFrame("Frame", nil, auras)
                else
                    icon = auras.icons[spell.id]
                end
                icon.name = name
                icon.image = image
                icon.spellID = spell["id"]
                icon.anyUnit = spell["anyUnit"]
                icon.onlyShowMissing = spell["onlyShowMissing"]
                if spell["onlyShowMissing"] then
                    icon.presentAlpha = 0
                    icon.missingAlpha = 1
                else
                    icon.presentAlpha = 1
                    icon.missingAlpha = 0
                end
                icon:Width(RA.db.indicatorsize)
                icon:Height(RA.db.indicatorsize)
                icon:ClearAllPoints()
                icon:SetPoint(spell["point"], 0, 0);

                if not icon.icon then
                    icon.icon = icon:CreateTexture(nil, "BORDER");
                    icon.icon:SetAllPoints(icon);
                end

                icon.icon:SetTexture(R["media"].blank);

                if (spell["color"]) then
                    icon.icon:SetVertexColor(spell["color"].r, spell["color"].g, spell["color"].b);
                else
                    icon.icon:SetVertexColor(0.8, 0.8, 0.8);
                end

                if not icon.cd then
                    icon.cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
                    icon.cd:SetAllPoints(icon)
                    icon.cd:SetReverse(true)
                    icon.cd:SetDrawEdge(true)
                    icon.cd:SetFrameLevel(icon:GetFrameLevel())
                end

                if not icon.border then
                    icon.border = icon:CreateTexture(nil, "BACKGROUND")
                    icon.border:SetOutside(icon, 1, 1)
                    icon.border:SetTexture(R["media"].blank)
                    icon.border:SetVertexColor(0, 0, 0)
                end

                if not icon.count then
                    icon.count = icon:CreateFontString(nil, "OVERLAY")
                    icon.count:Point("CENTER", unpack(counterOffsets[spell["point"]]))
                end
                icon.count:SetFont(R["media"].font, RA.db.indicatorsize + 4, "THINOUTLINE")

                if spell["enabled"] then
                    auras.icons[spell.id] = icon
                    if auras.watched then
                        auras.watched[spell.id] = icon
                    end
                else
                    auras.icons[spell.id] = nil
                    if auras.watched then
                        auras.watched[spell.id] = nil
                    end
                    icon:Hide()
                    icon = nil
                end
            end
        end
    end

    if frame.AuraWatch.Update then
        frame.AuraWatch.Update(frame)
    end

    buffs = nil
end

function RA:Construct_RaidDebuffs(frame)
    local raidDebuffs = CreateFrame("Frame", nil, frame.RaisedElementParent)
    raidDebuffs:SetFrameLevel(frame.RaisedElementParent:GetFrameLevel() + 20)
    raidDebuffs:SetPoint("BOTTOM", frame.Health)
    raidDebuffs:SetTemplate("Default")
    raidDebuffs:Size(self.db.aurasize, self.db.aurasize-4)

    raidDebuffs.icon = raidDebuffs:CreateTexture(nil, "OVERLAY")
    raidDebuffs.icon:SetTexCoord(.08, .92, .28, .72)
    raidDebuffs.icon:SetInside()

    raidDebuffs.count = raidDebuffs:CreateFontString(nil, "OVERLAY")
    raidDebuffs.count:SetFont(R["media"].font, 12, "OUTLINE")
    raidDebuffs.count:SetJustifyH("RIGHT")
    raidDebuffs.count:SetPoint("BOTTOMRIGHT", 4, -2)

    raidDebuffs.time = raidDebuffs:CreateFontString(nil, "OVERLAY")
    raidDebuffs.time:SetFont(R["media"].font, 12, "OUTLINE")
    raidDebuffs.time:SetJustifyH("CENTER")
    raidDebuffs.time:SetPoint("CENTER", 1, 0)
    raidDebuffs.time:SetTextColor(1, .9, 0)

    return raidDebuffs
end

function RA:Construct_AuraWatch(frame)
    local auraWatch = CreateFrame("Frame", nil, frame.RaisedElementParent)
    auraWatch:SetFrameLevel(frame.RaisedElementParent:GetFrameLevel() + 25)
    auraWatch:SetInside(frame.Health)
    auraWatch.presentAlpha = 1
    auraWatch.missingAlpha = 0
    auraWatch.strictMatching = true
    auraWatch.icons = {}
    return auraWatch
end

function RA:Construct_ReadyCheck(frame)
    local readyCheck = frame.RaisedElementParent:CreateTexture(nil, "OVERLAY", nil, 7)
    readyCheck:SetPoint("RIGHT", frame.Health)
    readyCheck:SetSize(RA.db.leadersize + 4, self.db.leadersize+ 4)
    readyCheck.PostUpdate = RA.UpdateReadyCheck
    return readyCheck
end

function RA:UpdateReadyCheck(status)
    if self.__owner.isForced then
        local rnd = math.random(1, 3)
        status = rnd == 1 and "waiting" or (rnd == 2 and "notready" or (rnd == 3 and "ready"))
        if(status == "ready") then
			self:SetTexture(self.readyTexture or READY_CHECK_READY_TEXTURE)
		elseif(status == "notready") then
			self:SetTexture(self.notReadyTexture or READY_CHECK_NOT_READY_TEXTURE)
		else
			self:SetTexture(self.waitingTexture or READY_CHECK_WAITING_TEXTURE)
		end
		self:Show()
    end
end

function RA:Construct_RaidRoleFrames(frame)
    local anchor = CreateFrame("Frame", nil, frame.RaisedElementParent)

    frame.LeaderIndicator = anchor:CreateTexture(nil, "OVERLAY")
    frame.LeaderIndicator:SetPoint("TOPLEFT", frame, 0, 8)
    frame.LeaderIndicator:SetSize(RA.db.leadersize, RA.db.leadersize)

    frame.AssistantIndicator = anchor:CreateTexture(nil, "OVERLAY")
    frame.AssistantIndicator:SetPoint("TOPLEFT", frame, 0, 8)
    frame.AssistantIndicator:SetSize(RA.db.leadersize, RA.db.leadersize)

    frame.MasterLooterIndicator = anchor:CreateTexture(nil, "OVERLAY")
    frame.MasterLooterIndicator:SetSize(RA.db.leadersize, RA.db.leadersize)
    frame.MasterLooterIndicator:SetPoint("LEFT", frame.Leader, "RIGHT")

    return anchor
end

function RA:UpdateTargetBorder()
    if UnitIsUnit("target", self.unit) then
        self.Health.border:SetBackdropBorderColor(.8, .8, .8, 1)
    else
        self.Health.border:SetBackdropBorderColor(0, 0, 0, 1)
    end
end

function RA:Construct_HealthBar(frame)
    local health = CreateFrame("StatusBar", nil, frame)
    health:CreateShadow("Background")
    health.border:SetFrameLevel(health:GetFrameLevel() + 1)
    health:SetFrameStrata("LOW")
    health.frequentUpdates = true
    health.PostUpdate = RA.PostHealth

    health.bg = health:CreateTexture(nil, "OVERLAY", nil, 2)

    frame.gradient = health:CreateTexture(nil, "OVERLAY", nil, 1)
    frame.gradient:SetAllPoints(health)
    frame.gradient:SetTexture(R["media"].blank)
    frame.gradient:SetGradientAlpha("VERTICAL", .2, .2, .2, 0, .25, .25, .25, .6)

    RA:UpdateHealth(health)

    health.bg:Point("BOTTOMLEFT", health:GetStatusBarTexture(), "BOTTOMRIGHT")
    health.bg:Point("TOPRIGHT", health)

    return health
end

function RA:Construct_PowerBar(frame)
    local power = CreateFrame("StatusBar", nil, frame)
    power:CreateShadow("Background")
    power:SetFrameStrata("LOW")
    power.bg = power:CreateTexture(nil, "BORDER")
    power.bg:SetAllPoints(power)
    power.frequentUpdates = false
    power:Height(frame:GetHeight()*RA.db.powerbarsize)
    RA:UpdatePower(power)
    R:SetStatusBarGradient(power, true)
    return power
end

function RA:Construct_NameText(frame)
    local name = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
    name:SetPoint("CENTER", frame.Health, 0, 2)
    name:SetJustifyH("CENTER")
    name:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
    name.overrideUnit = true
    frame:Tag(name, "[RayUFRaid:name]")
    return name
end

function RA:Construct_Threat(frame)
    local threat = CreateFrame("Frame", nil, frame)
    threat:SetFrameStrata("BACKGROUND")
    threat:Point("TOPLEFT", frame, "TOPLEFT", -5, 5)
    threat:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, -5)
    threat:SetFrameLevel(0)
    threat:SetBackdrop(RA.glowBorder)
    threat:SetBackdropColor(0, 0, 0, 0)
    if not R.PixelMode then
        threat:SetBackdropBorderColor(0, 0, 0, 1)
    else
        threat:SetBackdropBorderColor(0, 0, 0, 0)
    end
    threat.Override = RA.UpdateThreat
    return threat
end

function RA:Construct_HealText(frame)
    local healtext = frame.RaisedElementParent:CreateFontString(nil, "ARTKWORK")
    healtext:SetPoint("BOTTOM", frame.Health)
    healtext:SetShadowOffset(1.25, -1.25)
    healtext:SetFont(R["media"].font, R["media"].fontsize - 2, R["media"].fontflag)
    healtext:SetPoint("LEFT")
    healtext:SetPoint("RIGHT")
    frame:Tag(healtext, "[RayUIRaid:stat]")
    return healtext
end

function RA:Construct_Highlight(frame)
    local highlight = frame.RaisedElementParent:CreateTexture(nil, "OVERLAY")
    highlight:SetAllPoints(frame)
    highlight:SetTexture(R["media"].blank)
    highlight:SetVertexColor(1,1,1,.1)
    highlight:SetBlendMode("ADD")
    highlight:Hide()

    return highlight
end

function RA:Construct_RaidIcon(frame)
    local ricon = frame:CreateTexture(nil, "OVERLAY")
    ricon:SetPoint("TOP", frame, 0, 5)
    ricon:SetSize(RA.db.leadersize+2, RA.db.leadersize+2)
    ricon:SetTexture("Interface\\AddOns\\RayUI\\media\\raidicons.blp")

    return ricon
end

function RA:Construct_RoleIcon(frame)
    local role = frame.RaisedElementParent:CreateTexture(nil, "OVERLAY")
    role:SetSize(RA.db.leadersize, RA.db.leadersize)
    role:SetPoint("RIGHT", frame, "LEFT", RA.db.leadersize/2, 0)
    role:SetTexture("Interface\\AddOns\\RayUI\\media\\lfd_role")
    role.PostUpdate = RA.UpdateRoleIcon
    return role
end

function RA:UpdateRoleIcon(role)
    if self.__owner.isForced and role == "NONE" then
        local rnd = math.random(1, 3)
        role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
        self:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
		self:Show()
    end
end

function RA:Construct_ResurectionIcon(frame)
    local resurrectIcon = frame.RaisedElementParent:CreateTexture(nil, "OVERLAY")
    resurrectIcon:SetPoint("TOP", frame, 0, -2)
    resurrectIcon:SetSize(16, 16)
    return resurrectIcon
end

function RA:Construct_AFKText(frame)
    local afktext = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
    afktext:SetPoint("TOP", frame, "TOP")
    afktext:SetShadowOffset(1.25, -1.25)
    afktext:SetFont(R["media"].font, R["media"].fontsize - 2, R["media"].fontflag)
    afktext:SetPoint("LEFT", frame, "LEFT")
    afktext:SetPoint("RIGHT", frame, "RIGHT")
    afktext.frequentUpdates = 1
    frame:Tag(afktext, "[RayUIRaid:afk]")
    return afktext
end
