local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local RA = R:GetModule("Raid")

local oUF = RayUF or oUF

local _, class = UnitClass("player")
local indicator = "Interface\\AddOns\\RayUI\\media\\squares.ttf"
local symbols = "Interface\\AddOns\\RayUI\\media\\PIZZADUDEBULLETS.ttf"

local update = .25

local Enable = function(self)
    if(self.freebIndicators) then
        --[[self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTL:ClearAllPoints()
        self.AuraStatusTL:SetPoint("TOPLEFT", self.Health, 0, -1)
        self.AuraStatusTL:SetFont(indicator, RA.db.indicatorsize, "THINOUTLINE")
        self.AuraStatusTL.frequentUpdates = update
        self:Tag(self.AuraStatusTL, RA.classIndicators[class]["TL"])]]

        self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTR:ClearAllPoints()
        self.AuraStatusTR:SetPoint("RIGHT", self.Health, 2, 0)
        self.AuraStatusTR:SetFont(indicator, RA.db.indicatorsize, "THINOUTLINE")
        self.AuraStatusTR.frequentUpdates = update
        self:Tag(self.AuraStatusTR, RA.classIndicators[class]["TR"])

        --[[self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBL:ClearAllPoints()
        self.AuraStatusBL:SetPoint("BOTTOMLEFT", self.Health, 0, 0)
        self.AuraStatusBL:SetFont(indicator, RA.db.indicatorsize, "THINOUTLINE")
        self.AuraStatusBL.frequentUpdates = update
        self:Tag(self.AuraStatusBL, RA.classIndicators[class]["BL"])

        self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBR:ClearAllPoints()
        self.AuraStatusBR:SetPoint("BOTTOMRIGHT", self.Health, 6, -2)
        self.AuraStatusBR:SetFont(symbols, RA.db.symbolsize, "THINOUTLINE")
        self.AuraStatusBR.frequentUpdates = update
        self:Tag(self.AuraStatusBR, RA.classIndicators[class]["BR"])

        self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusCen:SetPoint("TOP")
        self.AuraStatusCen:SetJustifyH("CENTER")
        self.AuraStatusCen:SetFont(R["media"].font, R["media"].fontsize - 2, R["media"].fontflag)
        self.AuraStatusCen:SetShadowOffset(1.25, -1.25)
        self.AuraStatusCen:SetWidth(RA.db.width)
        self.AuraStatusCen.frequentUpdates = update
        self:Tag(self.AuraStatusCen, RA.classIndicators[class]["Cen"])]]
    end
end

oUF:AddElement('freebIndicators', nil, Enable, nil)
