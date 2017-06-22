RayUI = {}
local _Envs = {}
local _G, rawset = _G, rawset
local _RayUIEnv = setmetatable({}, {
		__index = function(self, k)
			local v = _G[k]
			if v ~= nil then
				rawset(self, k, v)
				return v
			end
		end,
		__metatable = true,
	})
_RayUIEnv._RayUIEnv = _RayUIEnv
_RayUIEnv._AddOnName = "RayUI"

_Envs[_RayUIEnv._AddOnName] = _RayUIEnv
_Envs["Origin"] = _G

local function NewEnvironment(name)
	_Envs[name] = setmetatable({}, {
			__index = function(self, k)
				local v = _RayUIEnv[k]
				if v ~= nil then
					rawset(self, k, v)
					return v
				end
			end,
			__metatable = true,
		})
end

function RayUI:LoadEnv(module)
	module = module or _RayUIEnv._AddOnName
	if not _Envs[module] then
		NewEnvironment(module)
	end
	setfenv(2, _Envs[module])
end

function RayUI:LoadDefaultEnv(module)
	setfenv(2, _Envs["Origin"])
end

RayUI:LoadEnv()
