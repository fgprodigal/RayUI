FRIENDSMENU_MAXBUTTONS = 20;
FRIENDSMENU_NOW_LINK_PLAYER = nil;
tinsert(UIMenus, "FriendsMenuXP");
tinsert(UIMenus, "FriendsMenuXPSecure");

function GetNameFromLink(link)
	--link is not |Hplayer:Warbaby:33|h[Warbaby]|h in 3.0, only player:Warbaby:33
	--ChatFrame1:AddMessage(string.gsub(link, "%|", "%/"));
	local _, name, lineid = strsplit(":", link);
	if ( name and (strlen(name) > 0) ) then
		name = gsub(name, "([^%s]*)%s+([^%s]*)%s+([^%s]*)", "%3");
		name = gsub(name, "([^%s]*)%s+([^%s]*)", "%2");
	end
	return name;
end

local function SetOrHookScript(frame, scriptName, func)
	if( frame:GetScript(scriptName) ) then
		frame:HookScript(scriptName, func);
	else
		frame:SetScript(scriptName, func);
	end
end

--function hooked to "FriendsFrame_ShowDropdown"
function FriendsMenuXP_ShowDropdown(name, connected, lineID)
	HideDropDownMenu(1);
	if(InCombatLockdown()) then
		FriendsMenuXP_Show(FriendsMenuXP, name, connected, lineID);
	else
		FriendsMenuXP_Show(FriendsMenuXPSecure, name, connected, lineID);
	end
end

--function hooked to "RaidGroupButton_ShowMenu"
function FriendsMenuXP_ShowRaidDropdown(self)
	local name, server = UnitName(self.unit);
	if(server and server~="") then name = name.."-"..server; end
	local connected = UnitIsConnected(self.unit);
	if(InCombatLockdown()) then
		FriendsMenuXP_Show(FriendsMenuXP, name, connected, nil, nil, "RAID");
		FriendsMenuXP:ClearAllPoints();
		if(DropDownList1:IsVisible()) then
			FriendsMenuXP:SetPoint("TOPLEFT", "DropDownList1", "TOPRIGHT");
		else
			FriendsMenuXP:SetPoint("TOPLEFT", "DropDownList1", "TOPLEFT");
		end
	else
		FriendsMenuXP_Show(FriendsMenuXPSecure, name, connected, nil, nil, "RAID");
		FriendsMenuXPSecure:ClearAllPoints();
		if(DropDownList1:IsVisible()) then
			FriendsMenuXPSecure:SetPoint("TOPLEFT", "DropDownList1", "TOPRIGHT");
		else
			FriendsMenuXPSecure:SetPoint("TOPLEFT", "DropDownList1", "TOPLEFT");
		end
	end
end

--function hooked to ChatFrames' OnHyperlinkEnter
function FriendsMenuXP_OnHyperlinkEnter(self, playerString, arg2,arg3,arg4) --playerString = "player:NAME:line";
	if ( playerString and strsub(playerString, 1, 6) == "player" ) then --|Hplayer
		FRIENDSMENU_NOW_LINK_PLAYER = GetNameFromLink(playerString);
	end;
end

--function hooked to ChatFrames' OnHyperlinkLeave
function FriendsMenuXP_OnHyperlinkLeave(self, arg1,arg2,arg3,arg4)
	FRIENDSMENU_NOW_LINK_PLAYER=nil;
end

--ClickHandler for ListMenu buttons
function FriendsMenuXPButton_OnClick(self)
	local func = self.func;
	if ( func ) then
		func(self:GetParent().NAME, self:GetParent().flags);
	end;

	self:GetParent():Hide();
	if(getglobal("DropDownList1")) then DropDownList1:Hide(); end;
	PlaySound("UChatScrollButton");
end

function FriendsMenuXP_ChatFrame_OnHyperlinkShow(self, playerString, text, button)

	if(playerString and strsub(playerString, 1, 6) == "player") then
		if ( IsAltKeyDown() ) then
			--we must do reverse action against ItemRef#SetItemRef()
			if(not IsShiftKeyDown()) then
				if (button=="RightButton") then
					HideDropDownMenu(1);
				else
					DEFAULT_CHAT_FRAME.editBox:Hide();
				end
			end

			--do our defined action
			InviteUnit(GetNameFromLink(playerString));
			return;
		end
	end
end

--deal with the hot-key click function.
function FriendsMenuXP_InitiateMaskButton()
	--Create a "mask button", to block the click to ChatHyperlink.
	local button = CreateFrame("Button", "ChatLinkMaskButton", UIParent, "SecureActionButtonTemplate");
	button:RegisterForClicks("AnyUp");
	button:SetWidth(30); button:SetHeight(10);

	--right click this button will also bring the menu
	SetOrHookScript(button, "OnClick", function(self, button)
		if(button=="RightButton") then
			FriendsMenuXP_ShowDropdown(self.NAME);
		end
	end);

	--define the SECURE actions 
	button:SetAttribute("ctrl-type1", "macro"); --ctrl+leftclick with do "/target linkname" macro.

	--define the insecure actions.
	hooksecurefunc("ChatFrame_OnHyperlinkShow", FriendsMenuXP_ChatFrame_OnHyperlinkShow);
end


function FriendsMenuXP_OnLoad(self)

	FriendsMenuXP_InitiateMaskButton();

	for i=1,7 do
		SetOrHookScript(getglobal("ChatFrame"..i), "OnHyperlinkEnter", FriendsMenuXP_OnHyperlinkEnter);
		SetOrHookScript(getglobal("ChatFrame"..i), "OnHyperlinkLeave", FriendsMenuXP_OnHyperlinkLeave);
	end

	hooksecurefunc("FriendsFrame_ShowDropdown", FriendsMenuXP_ShowDropdown);
	SetOrHookScript(getglobal("DropDownList1"), "OnHide", function()
		FriendsMenuXP:Hide();
		if(not InCombatLockdown()) then FriendsMenuXPSecure:Hide(); end
	end)

	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("ADDON_LOADED"); -- for RaidUI

	-- if(FRIENDS_MENU_XP_LOADED) then DEFAULT_CHAT_FRAME:AddMessage(FRIENDS_MENU_XP_LOADED,1,1,0); end
end

function FriendsMenuXP_OnEvent(self, event, ...)
	local arg1 = ...;
	if(event=="PLAYER_REGEN_DISABLED") then
		if(ChatLinkMaskButton and ChatLinkMaskButton:IsVisible()) then ChatLinkMaskButton:Hide(); end;
		if(FriendsMenuXPSecure:IsVisible()) then
			FriendsMenuXP_Show(FriendsMenuXP, FriendsMenuXPSecure.NAME, FriendsMenuXPSecure.connected, FriendsMenuXPSecure.lineID, FriendsMenuXPSecure);
			FriendsMenuXPSecure:Hide();
		end
		--FriendsMenuXPUpdateFrame:SetScript("OnUpdate", nil);
	elseif(event=="PLAYER_REGEN_ENABLED") then
		if(FriendsMenuXP:IsVisible()) then
			FriendsMenuXP_Show(FriendsMenuXPSecure, FriendsMenuXP.NAME, FriendsMenuXP.connected, FriendsMenuXP.lineID, FriendsMenuXP);
			FriendsMenuXP:Hide();
		end
		--FriendsMenuXPUpdateFrame:SetScript("OnUpdate", FriendsMenuXP_OnUpdate);
		if(RaidGroupButton1 and RaidGroupButton1:GetAttribute("type")~="target") then
			FriendsMenuXP_FixRaidGroupButton();
		end;
	elseif(event=="ADDON_LOADED") then -- hook the raid button click.
		if(arg1=="Blizzard_RaidUI") then
			hooksecurefunc("RaidGroupButton_ShowMenu", FriendsMenuXP_ShowRaidDropdown);
			hooksecurefunc("RaidPullout_Update", function(pullOutFrame) 
				if ( not pullOutFrame ) then
					pullOutFrame = this;
				end
				--pullOutFrame:SetScale(0.85);
				--pullOutFrame:ClearAllPoints();
				--pullOutFrame:SetPoint("TOPLEFT",ER_ContainerFrame,"TOPLEFT", 10,-10);

			end)

			FriendsMenuXP_FixRaidGroupButton();
		end
	end
end

local TimeSinceLastUpdate = 0;

function FriendsMenuXP_FixRaidGroupButton()
	if(not InCombatLockdown()) then
		for i=1,40 do 
			local raidbutton = getglobal("RaidGroupButton"..i);
			if(raidbutton and raidbutton.unit) then
				raidbutton:SetAttribute("type", "target");
				raidbutton:SetAttribute("unit", raidbutton.unit);
			end
		end
	end
end

function FriendsMenuXP_OnUpdate(self, elapsed)
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed; 
	if(TimeSinceLastUpdate < 0.1) then return end; 
	TimeSinceLastUpdate = 0;
	if(InCombatLockdown()) then return end;

	if( IsControlKeyDown() and FRIENDSMENU_NOW_LINK_PLAYER) then
		if(ChatLinkMaskButton and ChatLinkMaskButton.NAME ~= FRIENDSMENU_NOW_LINK_PLAYER) then
			ChatLinkMaskButton.NAME = FRIENDSMENU_NOW_LINK_PLAYER;
			ChatLinkMaskButton:SetAttribute("macrotext", "/target "..ChatLinkMaskButton.NAME);
		end

		local x,y = GetCursorPosition()
		scale = UIParent:GetScale()
		if(scale and scale ~= 0) then
			x = x / scale
			y = y / scale
		end
		ChatLinkMaskButton:ClearAllPoints()
		ChatLinkMaskButton:SetPoint("TOPLEFT",UIParent,"TOPLEFT", x-15, y - UIParent:GetTop() + 5)

		ChatLinkMaskButton:Show();
	else
		if(not IsControlKeyDown() and ChatLinkMaskButton and ChatLinkMaskButton:IsVisible()) then 
			ChatLinkMaskButton:Hide(); 
		end
	end
end

--===============================================================================================
--The following codes are based on Blizzard's FrameXMLs, includes UnitPopup and UIDropDownMenu.
--===============================================================================================
function FriendsMenuXP_Show(listFrame, name, connected, lineID, relativeFrame, buttonSet)
	listFrame.NAME = name;
	listFrame.connected = connected;
	listFrame.lineID = lineID;
	if(relativeFrame) then buttonSet = relativeFrame.buttonSet; end
	if(not buttonSet) then buttonSet = "NORMAL"; end;
	listFrame.buttonSet = buttonSet;
	FriendsMenu_Initialize(listFrame, buttonSet);
	if(not relativeFrame) then PlaySound("igMainMenuOpen"); end --open at last place should not play sound.

	-- Set the dropdownframe scale
	local uiScale = 1.0;
	if ( GetCVar("useUiScale") == "1" ) then
		uiScale = tonumber(GetCVar("uiscale"));
	end
	listFrame:SetScale(uiScale);

	-- Hide the listframe anyways since it is redrawn OnShow() 
	listFrame:Hide();
	listFrame:ClearAllPoints();

	if(relativeFrame) then
		listFrame:SetPoint(relativeFrame:GetPoint(1));
		listFrame:Show();
		return;
	end

	local cursorX, cursorY = GetCursorPosition();
	cursorX = cursorX/uiScale;
	cursorY = cursorY/uiScale
	listFrame:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", cursorX, cursorY);

	-- If no items in the drop down don't show it
	if ( listFrame.numButtons == 0 ) then
		return;
	end

	-- Check to see if the dropdownlist is off the screen, if it is anchor it to the top of the dropdown button
	listFrame:Show();
	-- Hack since GetCenter() is returning coords relative to 1024x768
	local x, y = listFrame:GetCenter();
	-- Hack will fix this in next revision of dropdowns
	if ( not x or not y ) then
		listFrame:Hide();
		return;
	end
	-- Determine whether the menu is off the screen or not
	local offscreenY, offscreenX;
	if ( (y - listFrame:GetHeight()/2) < 0 ) then
		offscreenY = 1;
	end
	if ( listFrame:GetRight() > GetScreenWidth() ) then
		offscreenX = 1;
	end

	if ( offscreenY and offscreenX ) then
		anchorPoint = "BOTTOMRIGHT";
	elseif ( offscreenY ) then
		anchorPoint = "BOTTOMLEFT";
	elseif ( offscreenX ) then
		anchorPoint = "TOPRIGHT";
	else
		anchorPoint = "TOPLEFT";
	end

	listFrame:ClearAllPoints();
	listFrame:SetPoint(anchorPoint, nil, "BOTTOMLEFT", cursorX, cursorY);
end

function FriendsMenu_Initialize(dropDownList, buttonSet)

	--===============================================================================================
	--Copied from UnitPopup_HideButtons(), compute the information used for the button operation.
	--===============================================================================================
	local inInstance, instanceType = IsInInstance();
	local inParty = 0;
	local inRaid = 0;
	if ( (GetNumSubgroupMembers() > 0) or (GetNumGroupMembers() > 0) ) then
		inParty = 1;
	end

	local inRaid = 0;
	if ( (GetNumSubgroupMembers() > 0) and (GetNumGroupMembers() > 0) ) then
		inRaid = 1;
	end

	local isLeader = 0;
	if ( UnitIsGroupLeader("player") ) then
		isLeader = 1;
	end

	local isAssistant = 0;
	if ( UnitIsGroupAssistant("player") ) then
		isAssistant = 1;
	end

	local inBattleground = 0;
	if ( UnitInBattleground("player") ) then
		inBattleground = 1;
	end

	dropDownList.flags = {
		["inInstance"] = inInstance,
		["instanceType"] = instanceType,
		["inParty"] = inParty,
		["inRaid"] = inRaid,
		["isLeader"] = isLeader,
		["isAssistant"] = isAssistant,
		["inBattleground"] = inBattleground,
		["connected"] = dropDownList.connected,
		["lineID"] = dropDownList.lineID,
	}

	-- Hide all the buttons
	local button;
	dropDownList.numButtons = 0;
	dropDownList.maxWidth = 0;
	for j=1, FRIENDSMENU_MAXBUTTONS, 1 do
		button = getglobal(dropDownList:GetName().."Button"..j);
		button:Hide();
	end
	dropDownList:Hide();

	-- Add dropdown title
	local info = FriendsMenuXP_CreateInfo();
	info.text = dropDownList.NAME;
	info.isTitle = 1;
	FriendsMenuXP_AddButton(dropDownList, info);

	for _, v in pairs(FriendsMenuXP_ButtonSet[buttonSet]) do
		info = FriendsMenuXP_Buttons[v];
		if info and (not info.show or info.show(dropDownList.NAME, dropDownList.flags)) then
			if(not info.isSecure or strfind(dropDownList:GetName(), "Secure")) then
				FriendsMenuXP_AddButton(dropDownList, info);
			end
		end
	end
end

function FriendsMenuXP_AddButton(listFrame, info)

	local listFrameName = listFrame:GetName();
	local index = listFrame.numButtons + 1;
	local width;

	-- Set the number of buttons in the listframe
	listFrame.numButtons = index;

	local button = getglobal(listFrameName.."Button"..index);
	if(not button) then return end;
	local normalText = getglobal(button:GetName().."NormalText");
	local icon = getglobal(button:GetName().."Icon");
	-- This button is used to capture the mouse OnEnter/OnLeave events if the dropdown button is disabled, since a disabled button doesn't receive any events
	-- This is used specifically for drop down menu time outs
	local invisibleButton = getglobal(button:GetName().."InvisibleButton");

	-- Default settings
	button:SetDisabledFontObject(GameFontDisableSmallLeft);
	invisibleButton:Hide();
	button:Enable();

	-- If not clickable then disable the button and set it white
	if ( info.notClickable ) then
		info.disabled = 1;
		button:SetDisabledFontObject(GameFontHighlightSmallLeft);
	end

	-- Set the text color and disable it if its a title
	if ( info.isTitle ) then
		info.disabled = 1;
		button:SetDisabledFontObject(GameFontNormalSmallLeft);
	end

	-- Disable the button if disabled and turn off the color code
	if ( info.disabled ) then
		button:Disable();
		invisibleButton:Show();
		info.colorCode = nil;
	end
	-- Configure button
	if ( info.text ) then
		-- look for inline color code this is only if the button is enabled
		if ( info.colorCode ) then
			button:SetText(info.colorCode..info.text.."|r");
		else
			button:SetText(info.text);
		end
		-- Determine the width of the button
		width = normalText:GetWidth() + 30;
		-- Add padding if has and expand arrow or color swatch
		if ( info.hasArrow or info.hasColorSwatch ) then
			width = width + 10;
		end
		if ( info.notCheckable ) then
			width = width - 30;
		end
		-- Set icon
		if ( info.icon ) then
			icon:SetTexture(info.icon);
			if ( info.tCoordLeft ) then
				icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom);
			else
				icon:SetTexCoord(0, 1, 0, 1);
			end
			icon:Show();
			-- Add padding for the icon
			width = width + 10;
		else
			icon:Hide();
		end
		-- Set maximum button width
		if ( width > listFrame.maxWidth ) then
			listFrame.maxWidth = width;
		end
		-- Check to see if there is a replacement font
		if ( info.fontObject ) then
			button:SetNormalFontObject(info.fontObject);
			button:SetHighlightFontObject(info.fontObject);
		else
			button:SetNormalFontObject(GameFontHighlightSmallLeft);
			button:SetHighlightFontObject(GameFontHighlightSmallLeft);
		end
	else
		button:SetText("");
		icon:Hide();
	end

	-- Pass through attributes
	button.func = info.func;
	button.tooltipText = info.tooltipText;

	-- If not checkable move everything over to the left to fill in the gap where the check would be
	local xPos = 5;
	local yPos = -((button:GetID() - 1) * UIDROPDOWNMENU_BUTTON_HEIGHT) - UIDROPDOWNMENU_BORDER_HEIGHT;
	normalText:ClearAllPoints();
	if ( info.justifyH and info.justifyH == "CENTER" ) then
		normalText:SetPoint("CENTER", button, "CENTER", -7, 0);
	else
		normalText:SetPoint("LEFT", button, "LEFT", 0, 0);
	end
	xPos = xPos + 10;

	button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", xPos, yPos);

	button:UnlockHighlight();


	-- Set the height of the listframe
	listFrame:SetHeight((index * UIDROPDOWNMENU_BUTTON_HEIGHT) + (UIDROPDOWNMENU_BORDER_HEIGHT * 2));

	if(button.attributes and button.attributes~="") then
		local attribs = {strsplit(";",button.attributes)};
		for _,v in pairs(attribs) do
			if(v and v~="") then
				button:SetAttribute(v, nil);
			end
		end
	end
	button.attributes = "";
	if(info.isSecure and info.attributes) then
		local attribs = gsub(info.attributes,"%$name%$", listFrame.NAME);
		local aaa = {strsplit(";", attribs)};
		for k,v in pairs(aaa) do
			if(v and v~="") then
				local att,val = strsplit(":",v); 
				if(att and att~="" and val and val~="") then
					button:SetAttribute(strtrim(att), gsub(strtrim(val), "%^", "%:"));
					button.attributes = button.attributes..strtrim(att)..";";
				end
			end
		end
	end

	button:Show();
end

local FriendsMenuXP_ButtonInfo = {};

function FriendsMenuXP_CreateInfo()
	-- Reuse the same table to prevent memory churn
	local info = FriendsMenuXP_ButtonInfo;
	for k,v in pairs(info) do
		info[k] = nil;
	end
	return FriendsMenuXP_ButtonInfo;
end