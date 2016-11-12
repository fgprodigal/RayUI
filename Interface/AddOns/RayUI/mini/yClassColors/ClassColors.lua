--[[--------------------------------------------------------------------
	!ClassColors
	Change class colors without breaking the Blizzard UI.
	Copyright (c) 2009-2016 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/downloads/info12513-ClassColors.html
	https://mods.curse.com/addons/wow/classcolors
----------------------------------------------------------------------]]

local _, ns = ...
if CUSTOM_CLASS_COLORS then
	ns.alreadyLoaded = true
	return
end

CUSTOM_CLASS_COLORS = {}

------------------------------------------------------------------------

local L = ns.L 
L.TITLE = GetAddOnMetadata("!ClassColors", "Title")

------------------------------------------------------------------------

local callbacks = {}
local numCallbacks = 0

local function RegisterCallback(self, method, handler)
	assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :RegisterCallback (string or function expected)")
	if type(method) == "string" then
		assert(type(handler) == "table", "Bad argument #2 to :RegisterCallback (table expected)")
		assert(type(handler[method]) == "function", "Bad argument #1 to :RegisterCallback (method \"" .. method .. "\" not found)")
		method = handler[method]
	end
	-- assert(not callbacks[method] "Callback already registered!")
	callbacks[method] = handler or true
	numCallbacks = numCallbacks + 1
end

local function UnregisterCallback(self, method, handler)
	assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :UnregisterCallback (string or function expected)")
	if type(method) == "string" then
		assert(type(handler) == "table", "Bad argument #2 to :UnregisterCallback (table expected)")
		assert(type(handler[method]) == "function", "Bad argument #1 to :UnregisterCallback (method \"" .. method .. "\" not found)")
		method = handler[method]
	end
	-- assert(callbacks[method], "Callback not registered!")
	callbacks[method] = nil
	numCallbacks = numCallbacks - 1
end

local function DispatchCallbacks()
	if numCallbacks < 1 then return end
	--print("CUSTOM_CLASS_COLORS: DispatchCallbacks")
	for method, handler in pairs(callbacks) do
		local ok, err = pcall(method, handler ~= true and handler or nil)
		if not ok then
			print("ERROR:", err)
		end
	end
end

------------------------------------------------------------------------

local classes = {}
for class in pairs(RAID_CLASS_COLORS) do
	tinsert(classes, class)
end
sort(classes)

local classTokens = {}
for token, class in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	classTokens[class] = token
end
for token, class in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	classTokens[class] = token
end

local function GetClassToken(self, className)
	return className and classTokens[className]
end

------------------------------------------------------------------------

setmetatable(CUSTOM_CLASS_COLORS, { __index = function(t, k)
	if k == "GetClassToken" then return GetClassToken end
	if k == "RegisterCallback" then return RegisterCallback end
	if k == "UnregisterCallback" then return UnregisterCallback end
end })

------------------------------------------------------------------------

for i= 1, #classes do
	local class = classes[i]
	local color = RAID_CLASS_COLORS[class]
	local r, g, b = color.r, color.g, color.b
	local hex = format("ff%02x%02x%02x", r * 255, g * 255, b * 255)

	CUSTOM_CLASS_COLORS[class] = {
		r = r,
		g = g,
		b = b,
		colorStr = hex,
	}
end