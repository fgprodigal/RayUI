local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local function LoadFriend()
	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Friend", 80)
	infobar:SetPoint("LEFT", RayUI_InfoPanel_Durability, "RIGHT", 0, 0)
	infobar.Text:SetText(FRIEND)

	infobar.updateElapsed = 0

	local friendsTablets = LibStub("Tablet-2.0")
	local FriendsTabletData = {}
	local FriendsTabletDataNames = {}
	local FriendsOnline = 0
	local displayString = string.join("", "%s: ", "", "%d|r")

	local ClassLookup = {}
	for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
		ClassLookup[v] = k
	end
	for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
		ClassLookup[v] = k
	end

	local function Friends_TabletClickFunc(name, iname, toonid)
		if not name then return end
		if IsAltKeyDown() then
			if not FriendsFrame_HasInvitePermission() then return end
			if toonid then
				BNInviteFriend(toonid)
			elseif iname == "" then
				InviteUnit(name)
			else
				InviteUnit(iname)
			end
		else
			if toonid then
				ChatFrame_SendSmartTell(name, DEFAULT_CHAT_FRAME)
			else
				ChatFrame_SendTell(name, DEFAULT_CHAT_FRAME)
			end
		end
	end

	local FriendsCat
	local function Friends_BuildTablet()
		local curFriendsOnline = 0
		wipe(FriendsTabletData)
		wipe(FriendsTabletDataNames)

		-- Standard Friends
		for i = 1, GetNumFriends() do
			local name, lvl, class, area, online, status, note = GetFriendInfo(i)
			if online then
				if ( not FriendsTabletData or FriendsTabletData == nil ) then FriendsTabletData = {} end
				if ( not FriendsTabletDataNames or FriendsTabletDataNames == nil ) then FriendsTabletDataNames = {} end

				curFriendsOnline = curFriendsOnline + 1

				local r, g, b = R.colors.class[ClassLookup[class]].r, R.colors.class[ClassLookup[class]].g, R.colors.class[ClassLookup[class]].b
				-- Name
				local cname
				if ( status == "" and name ) then
					cname = string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, name)
				elseif ( name ) then
					cname = string.format("%s |cff%02x%02x%02x%s|r", status, r * 255, g * 255, b * 255, name)
				end

				-- Class
				class = string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, class)

				-- Add Friend to list
				local _, faction = UnitFactionGroup("player")
				tinsert(FriendsTabletData, { cname, lvl, area, faction, "WoW", name, note, "" })
				if name then
					FriendsTabletDataNames[name] = true
				end
			end
		end

		-- Battle.net Friends
		for t = 1, BNGetNumFriends() do
			local presenceID, presenceName, BattleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, broadcast, note = BNGetFriendInfo(t)

			-- WoW friends
			if isOnline then
				if ( not FriendsTabletData or FriendsTabletData == nil ) then FriendsTabletData = {} end
				if ( not FriendsTabletDataNames or FriendsTabletDataNames == nil ) then FriendsTabletDataNames = {} end

				local _,name, _, realmName, _, faction, race, class, guild, area, lvl = BNGetToonInfo(toonID)
				curFriendsOnline = curFriendsOnline + 1

				if (realmName == R.myrealm) then
					FriendsTabletDataNames[toonName] = true
				end

				local r, g, b = FRIENDS_BNET_NAME_COLOR.r, FRIENDS_BNET_NAME_COLOR.g, FRIENDS_BNET_NAME_COLOR.b
                if class and ClassLookup[class] then
                    r, g, b = R.colors.class[ClassLookup[class]].r, R.colors.class[ClassLookup[class]].g, R.colors.class[ClassLookup[class]].b
                end
				-- Name
				local cname
				if ( realmName == GetRealmName() ) then
					-- On My Realm
					cname = string.format(
						"|cff%02x%02x%02x%s|r |cffcccccc(|r|cff%02x%02x%02x%s|r|cffcccccc)|r",
						FRIENDS_BNET_NAME_COLOR.r * 255, FRIENDS_BNET_NAME_COLOR.g * 255, FRIENDS_BNET_NAME_COLOR.b * 255,
						presenceName,
						r * 255, g * 255, b * 255,
						name
					)
				else
					-- On Another Realm
                    if realmName and realmName ~= "" then
                        cname = string.format(
                            "|cff%02x%02x%02x%s|r |cffcccccc(|r|cff%02x%02x%02x%s|r|cffcccccc-%s)|r",
                            FRIENDS_BNET_NAME_COLOR.r * 255, FRIENDS_BNET_NAME_COLOR.g * 255, FRIENDS_BNET_NAME_COLOR.b * 255,
                            presenceName,
                            r * 255, g * 255, b * 255,
                            name,
                            realmName
                        )
                    else
                        cname = string.format(
                            "|cff%02x%02x%02x%s|r |cffcccccc(|r|cff%02x%02x%02x%s|r|cffcccccc)|r",
                            FRIENDS_BNET_NAME_COLOR.r * 255, FRIENDS_BNET_NAME_COLOR.g * 255, FRIENDS_BNET_NAME_COLOR.b * 255,
                            presenceName,
                            r * 255, g * 255, b * 255,
                            name
                        )
                    end
				end

				-- Class
				class = string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, class)
				if (isAFK and name ) then
					cname = string.format("%s %s", CHAT_FLAG_AFK, cname)
				elseif(isDND and name) then
					cname = string.format("%s %s", CHAT_FLAG_DND, cname)
				end

				-- Faction
				if faction == "Horde" then
					faction = FACTION_HORDE
				elseif faction == "Alliance" then
					faction = FACTION_ALLIANCE
				else
                    faction = ""
                end

				-- Add Friend to list
				tinsert(FriendsTabletData, { cname, lvl, area, faction, client, presenceName, note, name, ["toonid"] = toonID })
			end
		end

		-- OnEnter
		FriendsOnline = curFriendsOnline
	end

	local function Friends_UpdateTablet()
		if ( FriendsOnline > 0 and FriendsTabletData ) then
			resSizeExtra = 2
			local Cols, lineHeader
			Friends_BuildTablet()

			-- Title
			local Cols = {
				NAME,
				LEVEL_ABBR,
				ZONE,
				FACTION,
				GAME
			}
			FriendsCat = friendsTablets:AddCategory("columns", #Cols)
			lineHeader = R:MakeTabletHeader(Cols, 10 + resSizeExtra, 0, {"LEFT", "RIGHT", "LEFT", "LEFT", "LEFT"})
			FriendsCat:AddLine(lineHeader)
			R:AddBlankTabLine(FriendsCat)

			-- Friends
			for _, val in ipairs(FriendsTabletData) do
				local line = {}
				for i = 1, #Cols do
					if i == 1 then	-- Name
						line["text"] = val[i]
						line["justify"] = "LEFT"
						line["func"] = function() Friends_TabletClickFunc(val[6],val[8], val["toonid"]) end
						line["size"] = 11 + resSizeExtra
					elseif i == 2 then	-- Level
						line["text"..i] = val[2]
						line["justify"..i] = "RIGHT"
						local uLevelColor = GetQuestDifficultyColor(tonumber(val[2]) or 1)
						line["text"..i.."R"] = uLevelColor.r
						line["text"..i.."G"] = uLevelColor.g
						line["text"..i.."B"] = uLevelColor.b
						line["size"..i] = 11 + resSizeExtra
					else	-- The rest
						line["text"..i] = val[i]
						line["justify"..i] = "LEFT"
						line["text"..i.."R"] = 0.8
						line["text"..i.."G"] = 0.8
						line["text"..i.."B"] = 0.8
						line["size"..i] = 11 + resSizeExtra
					end
				end
				FriendsCat:AddLine(line)
			end

			-- Hint
			friendsTablets:SetHint(L["<点击玩家>发送密语, <Alt+点击玩家>邀请玩家."])
		end
	end

	local function Friends_OnEnter(self)
		local totalFriends, onlineFriends = GetNumFriends()
		local totalBN, numBNetOnline = BNGetNumFriends()
		if InCombatLockdown() or onlineFriends + numBNetOnline == 0 then return end

		-- Register friendsTablets
		if not friendsTablets:IsRegistered(self) then
			friendsTablets:Register(self,
				"children", function()
					Friends_BuildTablet()
					Friends_UpdateTablet()
				end,
				"point", "BOTTOMLEFT",
				"relativePoint", "TOPLEFT",
				"maxHeight", 500,
				"clickable", true,
				"hideWhenEmpty", true
			)
		end

		if friendsTablets:IsRegistered(self) then
			-- friendsTablets appearance
			friendsTablets:SetColor(self, 0, 0, 0)
			friendsTablets:SetTransparency(self, .65)
			friendsTablets:SetFontSizePercent(self, 1)

			-- Open
			if ( FriendsOnline > 0 ) then
				ShowFriends()
			end
			friendsTablets:Open(self)
		end
	end

	local function Friends_Update(self)
		local totalFriends, onlineFriends = GetNumFriends()
		local totalBN, numBNetOnline = BNGetNumFriends()
		infobar.Text:SetFormattedText(displayString, FRIENDS, onlineFriends + numBNetOnline)
	end

	local function Friends_OnMouseDown(self)
		if not InCombatLockdown() then
			ToggleFriendsFrame()
		end
	end

	infobar:HookScript("OnMouseDown", Friends_OnMouseDown)
	infobar:HookScript("OnEnter", Friends_OnEnter)

	infobar:RegisterEvent("FRIENDLIST_UPDATE")
	infobar:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
	infobar:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	infobar:RegisterEvent("PLAYER_ENTERING_WORLD")

	infobar:HookScript("OnEvent", function(self, event)
		self.needrefreshed = true
		self.updateElapsed = 0
	end)
	infobar:HookScript("OnUpdate", function(self, elapsed)
		self.updateElapsed = self.updateElapsed + elapsed
		if self.updateElapsed > 1 then
			self.updateElapsed = 0

			if self.needrefreshed then
				Friends_Update(self)
				self.needrefreshed = nil
			end
		end
	end)
	Friends_OnEnter(infobar)
end

IF:RegisterInfoText("Friend", LoadFriend)
