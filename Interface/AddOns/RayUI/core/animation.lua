local R, L, P = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB

local UIFrameFadeOut = UIFrameFadeOut
local UIFrameFadeIn = UIFrameFadeIn
local InCombatLockdown = InCombatLockdown

local function OnUpdate(self)
	if self.parent:GetAlpha() == 0 then
		if InCombatLockdown() and self.lock then return end
		self:Hide()
		self.hiding = false
		self.parent:hide()
	end
end

local function to_hide(self)
	if self.hiding == true then return end
	if self:GetAlpha() == 0 then self:hide() return end
	UIFrameFadeOut(self,self.time,self.state_alpha,0)
	self.hiding = true
	self.pl_watch_frame:Show()
end

local function to_show(self)
	if self:IsShown() and not(self.hiding) then return end
	if self.showing then return end
	self.hiding = false
	self.pl_watch_frame:Hide()
	UIFrameFadeIn(self,self.time,0,self.state_alpha)
end

function R.make_plav(self,time,lock,alpha)
	if self.pl_watch_frame then return end
	self.pl_watch_frame = CreateFrame("Frame",nil,self)
	self.pl_watch_frame:Hide()
	self.pl_watch_frame.lock = lock
	self.pl_watch_frame.parent = self
	self.state_alpha = alpha or self:GetAlpha()
	self.hide = self.Hide
	self.time = time
	self.Hide = to_hide
	self.show = to_show
	self.pl_watch_frame:SetScript("OnUpdate",OnUpdate)
end

local function smooth(mode,x,y,z)
	return mode == true and 1 or max((10 + abs(x - y)) / (88.88888 * z), .2) * 1.1
end

function R.simple_move(self,t)
	self.pos = self.pos + t * self.speed * smooth(self.smode,self.limit,self.pos,.5)
	self:SetPoint(self.point_1,self.parent,self.point_2,self.hor and self.pos or self.alt or 0,not(self.hor) and self.pos or self.alt or 0)
	if self.pos * self.mod >= self.limit * self.mod then
		self:SetPoint(self.point_1,self.parent,self.point_2,self.hor and self.limit or self.alt or  0,not(self.hor) and self.limit or self.alt or 0)
		self.pos = self.limit
		self:SetScript("OnUpdate",nil)
		if self.finish_hide then
			self:Hide()
		end
		if self.finish_function then
			self:finish_function()
		end
	end
end

function R.simple_width(self,t)
	self.wpos = self.wpos + t * self.wspeed * smooth(self.smode,self.wlimit,self.wpos,1)
	self:SetWidth(self.wpos)
	if self.wpos * self.wmod >= self.wlimit * self.wmod then
		self:SetWidth(self.wlimit)
		self.wpos = self.wlimit
		self:SetScript("OnUpdate",nil)
		if self.wfinish_hide then
			self:Hide()
		end
		if self.finish_function then
			self:finish_function()
		end
	end
end

function R.simple_height(self,t)
	self.hpos = self.hpos + t * self.hspeed * smooth(self.smode,self.hlimit,self.hpos,1)
	self:SetHeight(self.hpos)
	if self.hpos * self.hmod >= self.hlimit * self.hmod then
		self:SetHeight(self.hlimit)
		self.hpos = self.hlimit
		self:SetScript("OnUpdate",nil)
		if self.hfinish_hide then
			self:Hide()
		end
		if self.finish_function then
			self:finish_function()
		end
	end
end

function R:Slide(frame, direction, length, speed)
	local p1, rel, p2, x, y = frame:GetPoint()
	frame.mod = ( direction == "LEFT" or direction == "DOWN" ) and -1 or 1
	frame.limit = x + frame.mod * length
	frame.speed = frame.mod * speed
	frame.point_1 = p1
	frame.point_2 = p2
	frame.pos = x
	frame.hor = ( direction == "LEFT" or direction == "RIGHT" ) and true or false
	frame.alt = y
	frame:SetScript("OnUpdate",R.simple_move)
end

local frameFadeManager = CreateFrame("FRAME")
local FADEFRAMES = {}

function R:UIFrameFade_OnUpdate(elapsed)
	local index = 1
	local frame, fadeInfo
	while FADEFRAMES[index] do
		frame = FADEFRAMES[index]
		fadeInfo = FADEFRAMES[index].fadeInfo
		-- Reset the timer if there isn't one, this is just an internal counter
		if ( not fadeInfo.fadeTimer ) then
			fadeInfo.fadeTimer = 0
		end
		fadeInfo.fadeTimer = fadeInfo.fadeTimer + elapsed

		-- If the fadeTimer is less then the desired fade time then set the alpha otherwise hold the fade state, call the finished function, or just finish the fade 
		if ( fadeInfo.fadeTimer < fadeInfo.timeToFade ) then
			if ( fadeInfo.mode == "IN" ) then
				frame:SetAlpha((fadeInfo.fadeTimer / fadeInfo.timeToFade) * (fadeInfo.endAlpha - fadeInfo.startAlpha) + fadeInfo.startAlpha)
			elseif ( fadeInfo.mode == "OUT" ) then
				frame:SetAlpha(((fadeInfo.timeToFade - fadeInfo.fadeTimer) / fadeInfo.timeToFade) * (fadeInfo.startAlpha - fadeInfo.endAlpha)  + fadeInfo.endAlpha)
			end
		else
			frame:SetAlpha(fadeInfo.endAlpha)
			-- If there is a fadeHoldTime then wait until its passed to continue on
			if ( fadeInfo.fadeHoldTime and fadeInfo.fadeHoldTime > 0  ) then
				fadeInfo.fadeHoldTime = fadeInfo.fadeHoldTime - elapsed
			else
				-- Complete the fade and call the finished function if there is one
				R:UIFrameFadeRemoveFrame(frame)
				if ( fadeInfo.finishedFunc ) then
					fadeInfo.finishedFunc(fadeInfo.finishedArg1, fadeInfo.finishedArg2, fadeInfo.finishedArg3, fadeInfo.finishedArg4)
					fadeInfo.finishedFunc = nil
				end
			end
		end
		
		index = index + 1
	end
	
	if ( #FADEFRAMES == 0 ) then
		frameFadeManager:SetScript("OnUpdate", nil)
	end
end

-- Generic fade function
function R:UIFrameFade(frame, fadeInfo)
	if (not frame) then
		return
	end
	if ( not fadeInfo.mode ) then
		fadeInfo.mode = "IN"
	end
	local alpha
	if ( fadeInfo.mode == "IN" ) then
		if ( not fadeInfo.startAlpha ) then
			fadeInfo.startAlpha = 0
		end
		if ( not fadeInfo.endAlpha ) then
			fadeInfo.endAlpha = 1.0
		end
		alpha = 0
	elseif ( fadeInfo.mode == "OUT" ) then
		if ( not fadeInfo.startAlpha ) then
			fadeInfo.startAlpha = 1.0
		end
		if ( not fadeInfo.endAlpha ) then
			fadeInfo.endAlpha = 0
		end
		alpha = 1.0
	end
	frame:SetAlpha(fadeInfo.startAlpha)

	frame.fadeInfo = fadeInfo
	if not frame:IsProtected() then
		frame:Show()
	end
	
	local index = 1
	while FADEFRAMES[index] do
		-- If frame is already set to fade then return
		if ( FADEFRAMES[index] == frame ) then
			return
		end
		index = index + 1
	end
	tinsert(FADEFRAMES, frame)
	frameFadeManager:SetScript("OnUpdate", R.UIFrameFade_OnUpdate)
end

-- Convenience function to do a simple fade in
function R:UIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {}
	fadeInfo.mode = "IN"
	fadeInfo.timeToFade = timeToFade
	fadeInfo.startAlpha = startAlpha
	fadeInfo.endAlpha = endAlpha
	R:UIFrameFade(frame, fadeInfo)
end

-- Convenience function to do a simple fade out
function R:UIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {}
	fadeInfo.mode = "OUT"
	fadeInfo.timeToFade = timeToFade
	fadeInfo.startAlpha = startAlpha
	fadeInfo.endAlpha = endAlpha
	R:UIFrameFade(frame, fadeInfo)
end

function R:tDeleteItem(table, item)
	local index = 1
	while table[index] do
		if ( item == table[index] ) then
			tremove(table, index)
		else
			index = index + 1
		end
	end
end

function R:UIFrameFadeRemoveFrame(frame)
	R:tDeleteItem(FADEFRAMES, frame)
end
