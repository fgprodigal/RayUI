----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local D = R:NewModule("Debug", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")


D.Prefix = {
	[1] = "|cff808080[%s] [DEBUG] [%s] ",
	[2] = "|cff008000[%s] [INFO] [%s] ",
	[3] = "|cffff0000[%s] [WARN] [%s] ",
}

local function Debug(mod, logLevel, msg, ...)
	mod = mod.GetName and mod:GetName() or mod

	local time = date("%X")
	local pre = D.Prefix[logLevel]:format(time, mod);

	if select("#", ...) > 0 then
		msg = msg:format(...)
	end

	msg = pre..msg

	if logLevel >= R.global.general.logLevel then
		local ChatFrame = DEFAULT_CHAT_FRAME
		for _, frameName in pairs(CHAT_FRAMES) do
			local cf = _G[frameName]
			if cf.name:upper() == "DEBUG" then
				ChatFrame = cf
				break
			end
		end
		ChatFrame:AddMessage(msg, nil, nil, nil, nil, true)
		FCF_StartAlertFlash(ChatFrame)
	end
end
R.Debug = Debug

function D:Initialize()
	for i = 1, #R["RegisteredModules"] do
		local module = R:GetModule(R["RegisteredModules"][i])
		module.Debug = Debug
	end
end

R:RegisterModule(D:GetName())
