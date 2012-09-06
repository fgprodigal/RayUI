--[[----------------------------------------------------------------------------

  LiteMount/UIOptionsFrame.lua

  Options frame to plug in to the Blizzard interface menu.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

function LiteMountOptions_OnLoad(self)
    LiteMount_Frame_AutoLocalize(self)

    local version = GetAddOnMetadata("LiteMount", "Version")
    if string.find(version, "project.version") then
        version = "Developer Work-in-Progress"
    end

    local author = GetAddOnMetadata("LiteMount", "Author")

    self.name = "LiteMount"

    self.title:SetText("LiteMount")
    self.version:SetText(version)
    self.author:SetText(author or "")

    InterfaceOptions_AddCategory(self)
end

function LiteMountOptions_OnShow(self)
    LiteMountOptions.CurrentOptionsPanel = self
end

