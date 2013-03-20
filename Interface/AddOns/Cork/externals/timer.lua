
local myname, ns = ...


local funcs, nextup = {}
local f = CreateFrame("Frame")
f:Hide()


local function SetNextTime()
	local besttime, bestv = math.huge
	for v in pairs(funcs) do
		if v.time < besttime then
			besttime, bestv = v.time, v
		end
	end

	if bestv then
		nextup = bestv
		f:Show()
	else
		f:Hide()
	end
end

function ns.StartTimer(endtime, func)
	local t = {time = endtime, func = func}
	funcs[t] = true
	SetNextTime()
end


f:SetScript("OnHide", function() nextup = nil end)
f:SetScript("OnUpdate", function(self)
	if not nextup then return f:Hide() end
	if GetTime() >= nextup.time then
		nextup.func()
		funcs[nextup] = nil
		SetNextTime()
	end
end)

