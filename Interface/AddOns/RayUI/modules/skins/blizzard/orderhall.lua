local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function HandleCommandBar()
    R.UIParent:SetPoint("BOTTOM", UIParent, "BOTTOM");
    OrderHallCommandBar:HookScript("OnShow", function()
            local height = OrderHallCommandBar:GetHeight()
            R.UIParent:ClearAllPoints()
            R.UIParent:SetPoint("BOTTOM")
            R.UIParent:SetPoint("LEFT")
            R.UIParent:SetPoint("RIGHT")
            R.UIParent:SetPoint("TOP", UIParent, "TOP", 0, -height)
        end)
    OrderHallCommandBar:HookScript("OnHide", function()
            R.UIParent:ClearAllPoints()
            R.UIParent:SetAllPoints()
        end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
        if event == "ADDON_LOADED" and addon == "Blizzard_OrderHallUI" then
            if InCombatLockdown() then
                self:RegisterEvent("PLAYER_REGEN_ENABLED")
            else
                HandleCommandBar()
            end
            self:UnregisterEvent(event)
        elseif event == "PLAYER_REGEN_ENABLED" then
            HandleCommandBar()
            self:UnregisterEvent(event)
        end
    end)

local function LoadSkin()
    local classColor = S["media"].classcolours[R.myclass]
    -- CommandBar
	HandleCommandBar()
    OrderHallCommandBar:StripTextures()
    OrderHallCommandBar:CreateShadow("Background")
    OrderHallCommandBar.ClassIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
    OrderHallCommandBar.ClassIcon:SetSize(46, 20)
    OrderHallCommandBar.CurrencyIcon:SetAtlas("legionmission-icon-currency", false)
    OrderHallCommandBar.AreaName:SetVertexColor(classColor.r, classColor.g, classColor.b)
    OrderHallCommandBar.WorldMapButton:Kill()

    -- MissionFrame
    OrderHallMissionFrame.ClassHallIcon:Kill()
    OrderHallMissionFrame:StripTextures()
    OrderHallMissionFrame.GarrCorners:Hide()
    S:SetBD(OrderHallMissionFrame)
    S:ReskinClose(OrderHallMissionFrame.CloseButton)
    for i = 1, 3 do
        S:CreateTab(_G["OrderHallMissionFrameTab" .. i])
    end
    OrderHallMissionFrameMissions:StripTextures()
    OrderHallMissionFrameMissionsListScrollFrame:StripTextures()
    OrderHallMissionFrame.MissionTab:StripTextures()
    S:ReskinScroll(OrderHallMissionFrameMissionsListScrollFrameScrollBar)
    S:Reskin(OrderHallMissionFrameMissions.CombatAllyUI.InProgress.Unassign)
    S:ReskinClose(OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CloseButton)
    S:Reskin(OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.StartMissionButton)
    for _, Button in pairs(OrderHallMissionFrame.MissionTab.MissionList.listScroll.buttons) do
        if not Button.isSkinned then
            Button:StripTextures()
            -- Button:SetTemplate()
            S:Reskin(Button)
            Button.LocBG:Hide()
            Button.isSkinned = true
        end
    end
    -- Followers
    local FollowerList = OrderHallMissionFrame.FollowerList
    local FollowerTab = OrderHallMissionFrame.FollowerTab
    FollowerList:StripTextures()
    FollowerList.MaterialFrame:StripTextures()
    S:ReskinInput(FollowerList.SearchBox)
    S:ReskinScroll(OrderHallMissionFrame.FollowerList.listScroll.scrollBar)
    hooksecurefunc(FollowerList, "ShowFollower", function(self)
            local abilities = self.followerTab.AbilitiesFrame.Abilities
            if self.numAbilitiesStyled == nil then
                self.numAbilitiesStyled = 1
            end
            local numAbilitiesStyled = self.numAbilitiesStyled
            local ability = abilities[numAbilitiesStyled]
            while ability do
                local icon = ability.IconButton.Icon
                S:ReskinIcon(icon)
                icon:SetDrawLayer("BORDER", 0)
                numAbilitiesStyled = numAbilitiesStyled + 1
                ability = abilities[numAbilitiesStyled]
            end
            self.numAbilitiesStyled = numAbilitiesStyled
            local weapon = self.followerTab.ItemWeapon
            local armor = self.followerTab.ItemArmor
            if not weapon.skinned then
                S:ReskinIcon(weapon.Icon)
                weapon.Border:SetTexture(nil)
                weapon.skinned = true
            end
            if not armor.skinned then
                S:ReskinIcon(armor.Icon)
                armor.Border:SetTexture(nil)
                armor.skinned = true
            end
            local xpbar = self.followerTab.XPBar
            xpbar:StripTextures()
            xpbar:SetStatusBarTexture(R["media"].gloss)
            -- xpbar:CreateShadow("Background")
        end)
    FollowerTab:StripTextures()
    FollowerTab.Class:SetSize(50, 43)
    FollowerTab.XPBar:StripTextures()
    FollowerTab.XPBar:SetStatusBarTexture(.08, .92, .08, .92)
    FollowerTab.XPBar:CreateShadow("Background")
    -- Missions
    local MissionTab = OrderHallMissionFrame.MissionTab
    local MissionList = MissionTab.MissionList
    local MissionPage = MissionTab.MissionPage
    local ZoneSupportMissionPage = MissionTab.ZoneSupportMissionPage
    S:ReskinScroll(MissionList.listScroll.scrollBar)
    MissionList.CompleteDialog:StripTextures()
    S:SetBD(MissionList.CompleteDialog)
    S:Reskin(MissionList.CompleteDialog.BorderFrame.ViewButton)
    MissionList:StripTextures()
    MissionList.listScroll:StripTextures()
    S:Reskin(OrderHallMissionFrameMissions.CombatAllyUI.InProgress.Unassign)
    S:ReskinClose(MissionPage.CloseButton)
    S:Reskin(MissionPage.StartMissionButton)
    S:ReskinClose(ZoneSupportMissionPage.CloseButton)
    S:Reskin(ZoneSupportMissionPage.StartMissionButton)
    S:Reskin(OrderHallMissionFrame.MissionComplete.NextMissionButton)
    -- TalentFrame
    local TalentFrame = OrderHallTalentFrame
    TalentFrame:StripTextures()
    TalentFrame.LeftInset:StripTextures()
    S:SetBD(TalentFrame)
    TalentFrame.CurrencyIcon:SetAtlas("legionmission-icon-currency", false)
    S:ReskinClose(TalentFrame.CloseButton)
end
S:AddCallbackForAddon("Blizzard_OrderHallUI", "OrderHall", LoadSkin)
