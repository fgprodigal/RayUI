--[[   ____    ______      
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___ 
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/
 
 [=====================================]
 [  Author: Dandraffbal-Stormreaver US ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2014. All Rights Reserved.        ]
 [====================================]]
 
local ADDON_NAME, addon = ...

-- Shorten my handle
local x = addon.engine
local Spam = { }
x.Spam = Spam

-- upvalues
local table = table
local tinsert, tremove = table.insert, table.remove

-- table pool
local tablePool = {}

local function new( )
  if #tablePool > 0 then
    local t = tablePool[1]
    tremove(tablePool, 1)
    return t
  end
  return {}
end

local function delete( t )
  for i in pairs( t ) do
    t[i] = nil
  end
  
  tinsert( tablePool, t )
end


-- module variables
Spam.update = CreateFrame("Frame")

local spam = {
  -- Frame,
    -- Spell ID,
      -- Values,
}

local spamindex = {
  -- frame,
    -- current index
    -- index to spellID
}

local frameDB = { }

function Spam:Initiate( )
  self:RegisterFrameName("general", "xCT_PlusgeneralFrame")
  self:RegisterFrameName("outgoing", "xCT_PlusoutgoingFrame")
  self:RegisterFrameName("critical", "xCT_PluscriticalFrame")
  self:RegisterFrameName("damage", "xCT_PlusdamageFrame")
  self:RegisterFrameName("healing", "xCT_PlushealingFrame")
  self:RegisterFrameName("power", "xCT_PluspowerFrame")
  self:RegisterFrameName("procs", "xCT_PlusprocsFrame")
  self:RegisterFrameName("loot", "xCT_PluslootFrame")
end

function Spam:RegisterFrameName( frameName, globalName )
  if frameDB[frameName] then error("xCT+ says another frame is already called " .. frameName .. "!" ) end
  frameDB[frameName] = globalName
end

function Spam:AddSpamMessage( frame, index, value )
  if not spam[frame] then error( "xCT+ says there is no frame named " .. frame .. "!" ) end
  
  if not spam[frame][index] then
    spam[frame][index] = { }
    tinsert(spamindex, index)
  end

  local entry = new()
  entry.value = value
  tinsert(spam[frame][index], entry)
end

function Spam:Start( )
  self.udpate:SetScript( "OnUpdate", self.OnUpdate_SpamMerger )
end

function Spam:Stop( )
  self.update:SetScript( "OnUpdate", nil )
end

Spam.OnUpdate_SpamMerger = function( e )
  
end





