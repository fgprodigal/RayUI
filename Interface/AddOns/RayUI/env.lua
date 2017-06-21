do
    local _G, rawset    = _G, rawset
    local _RayUIEnv     = setmetatable({}, {
        __index         = function(self, k)
			local v = _G[k]
			if v ~= nil then
				rawset(self, k, v)
				return v
			end
		end,
        __metatable     = true,
    })
    _RayUIEnv._RayUIEnv = _RayUIEnv
    _RayUIEnv._AddOnName = "RayUI"

	_LoadRayUIEnv_ = function()
		setfenv(2, _RayUIEnv)
	end

    setfenv(1, _RayUIEnv)
end
