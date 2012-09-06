--[[----------------------------------------------------------------------------

  LiteMount/AutoEventFrame.lua

  Wrappers CreateFrame with an on-event handler that looks for a function
  named for the event and calls it.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

function LM_CreateAutoEventFrame(frameType, ...)
    local f = CreateFrame(frameType, ...)
    f:SetScript("OnEvent", function (self, event, ...)
                                if self[event] then
                                    self[event](self, event, ...)
                                end
                            end)
    return f
end
