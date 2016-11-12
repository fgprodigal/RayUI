local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

--Cache global variables
--WoW API / Variables
local GetChatWindowInfo = GetChatWindowInfo

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: CHAT_FONT_HEIGHTS, UNIT_NAME_FONT, DAMAGE_TEXT_FONT, STANDARD_TEXT_FONT
-- GLOBALS: GameTooltipHeader, SystemFont_Shadow_Large_Outline, NumberFont_OutlineThick_Mono_Small
-- GLOBALS: NumberFont_Outline_Huge, NumberFont_Outline_Large, NumberFont_Outline_Med
-- GLOBALS: NumberFont_Shadow_Med, NumberFont_Shadow_Small, QuestFont, QuestFont_Large
-- GLOBALS: SystemFont_Large, GameFontNormalMed3, SystemFont_Shadow_Huge1, SystemFont_Med1
-- GLOBALS: SystemFont_Med3, SystemFont_OutlineThick_Huge2, SystemFont_Outline_Small
-- GLOBALS: SystemFont_Shadow_Large, SystemFont_Shadow_Med1, SystemFont_Shadow_Med3
-- GLOBALS: SystemFont_Shadow_Outline_Huge2, SystemFont_Shadow_Small, SystemFont_Small
-- GLOBALS: SystemFont_Tiny, Tooltip_Med,  Tooltip_Small, ZoneTextString, SubZoneTextString
-- GLOBALS: PVPInfoTextString, PVPArenaTextString, CombatTextFont, FriendsFont_Normal
-- GLOBALS: FriendsFont_Small, FriendsFont_Large, FriendsFont_UserText
-- GLOBALS: GameFontNormal, ErrorFont, SubZoneTextFont, ZoneTextFont, PVPInfoTextFont

local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

function R:UpdateBlizzardFonts()
	local NORMAL     = self["media"].font
	local COMBAT     = self["media"].dmgfont
	local NUMBER     = self["media"].font

	local _, editBoxFontSize, _, _, _, _, _, _, _, _ = GetChatWindowInfo(1)

	CHAT_FONT_HEIGHTS = {12, 13, 14, 15, 16, 17, 18, 19, 20}

	UNIT_NAME_FONT     = NORMAL
	-- NAMEPLATE_FONT     = NORMAL
	DAMAGE_TEXT_FONT   = COMBAT
	STANDARD_TEXT_FONT = NORMAL

	-- Base fonts
	SetFont(GameFontNormal,                  NORMAL, self.global.media.fontsize)
	-- SetFont(GameFontNormalSmall,                NORMAL, self.global.media.fontsize)
	SetFont(GameTooltipHeader,                  NORMAL, self.global.media.fontsize)
	SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER, self.global.media.fontsize, "OUTLINE")
	SetFont(SystemFont_Shadow_Large_Outline,	NUMBER, 20, "OUTLINE")
	SetFont(NumberFont_Outline_Huge,            NUMBER, 28, "THICKOUTLINE")
	SetFont(NumberFont_Outline_Large,           NUMBER, 15, "OUTLINE")
	SetFont(NumberFont_Outline_Med,             NUMBER, self.global.media.fontsize*1.1, "OUTLINE")
	SetFont(NumberFont_Shadow_Med,              NORMAL, self.global.media.fontsize) --chat editbox uses this
	SetFont(NumberFont_Shadow_Small,            NORMAL, self.global.media.fontsize)
	SetFont(QuestFont,                          NORMAL, self.global.media.fontsize)
	SetFont(ErrorFont,                          NORMAL, 15, "THINOUTLINE") -- Quest Progress & Errors
	SetFont(SubZoneTextFont,                          NORMAL, 26, "THINOUTLINE", nil, nil, nil, 0, 0, 0, R.mult, -R.mult)
	SetFont(ZoneTextFont,                          NORMAL, 112, "THINOUTLINE", nil, nil, nil, 0, 0, 0, R.mult, -R.mult)
	SetFont(PVPInfoTextFont,                          NORMAL, 20, "THINOUTLINE", nil, nil, nil, 0, 0, 0, R.mult, -R.mult)
	SetFont(QuestFont_Large,                    NORMAL, 14)
	SetFont(SystemFont_Large,                   NORMAL, 15)
	SetFont(SystemFont_Shadow_Huge1,			NORMAL, 20, "THINOUTLINE") -- Raid Warning, Boss emote frame too
	SetFont(SystemFont_Med1,                    NORMAL, self.global.media.fontsize)
	SetFont(SystemFont_Med3,                    NORMAL, self.global.media.fontsize*1.1)
	SetFont(SystemFont_OutlineThick_Huge2,      NORMAL, 20, "THICKOUTLINE")
	SetFont(SystemFont_Outline_Small,           NUMBER, self.global.media.fontsize, "OUTLINE")
	SetFont(SystemFont_Shadow_Large,            NORMAL, 15)
	SetFont(SystemFont_Shadow_Med1,             NORMAL, self.global.media.fontsize)
	SetFont(SystemFont_Shadow_Med3,             NORMAL, self.global.media.fontsize*1.1)
	SetFont(SystemFont_Shadow_Outline_Huge2,    NORMAL, 20, "OUTLINE")
	SetFont(SystemFont_Shadow_Small,            NORMAL, self.global.media.fontsize*0.9)
	SetFont(SystemFont_Small,                   NORMAL, self.global.media.fontsize)
	SetFont(SystemFont_Tiny,                    NORMAL, self.global.media.fontsize)
	SetFont(Tooltip_Med,                        NORMAL, self.global.media.fontsize)
	SetFont(Tooltip_Small,                      NORMAL, self.global.media.fontsize)
	SetFont(ZoneTextString,						NORMAL, 32, "OUTLINE")
	SetFont(SubZoneTextString,					NORMAL, 25, "OUTLINE")
	SetFont(PVPInfoTextString,					NORMAL, 22, "THINOUTLINE")
	SetFont(PVPArenaTextString,					NORMAL, 22, "THINOUTLINE")
	SetFont(CombatTextFont,                     COMBAT, 100, "THINOUTLINE") -- number here just increase the font quality.
	SetFont(FriendsFont_Normal, 				NORMAL, self.global.media.fontsize)
	SetFont(FriendsFont_Small,					NORMAL, self.global.media.fontsize)
	SetFont(FriendsFont_Large, 					NORMAL, self.global.media.fontsize)
	SetFont(FriendsFont_UserText, 				NORMAL, self.global.media.fontsize)
end