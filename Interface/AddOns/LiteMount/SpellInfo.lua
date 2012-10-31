--[[----------------------------------------------------------------------------

  LiteMount/SpellInfo.lua

  Constants for mount spell information.

  Copyright 2011,2012 Mike Battersby

----------------------------------------------------------------------------]]--

-- Bits 1 through 16 match Blizzard's flags in GetCompanionInfo()
-- See http://us.battle.net/wow/en/forum/topic/2112232816#6
LM_FLAG_BIT_RUN = 1
LM_FLAG_BIT_FLY = 2
LM_FLAG_BIT_FLOAT = 4
LM_FLAG_BIT_SWIM = 8
LM_FLAG_BIT_JUMP = 16
LM_FLAG_BIT_WALK = 32
LM_FLAG_BIT_AQ = 128
LM_FLAG_BIT_VASHJIR = 256

LM_SPELL_TRAVEL_FORM = 783
LM_SPELL_AQUATIC_FORM = 1066
LM_SPELL_GHOST_WOLF = 2645
LM_SPELL_BLUE_QIRAJI_TANK = 25953
LM_SPELL_GREEN_QIRAJI_TANK = 26054
LM_SPELL_RED_QIRAJI_TANK = 26055
LM_SPELL_YELLOW_QIRAJI_TANK = 26056
LM_SPELL_RIDING_TURTLE = 30174
LM_SPELL_FLIGHT_FORM = 33943
LM_SPELL_SWIFT_FLIGHT_FORM = 40120
LM_SPELL_FLYING_BROOM = 42667
LM_SPELL_TURBO_CHARGED_FLYING_MACHINE = 44151
LM_SPELL_FLYING_MACHINE = 44153
LM_SPELL_MAGIC_BROOM = 47977
LM_SPELL_BRONZE_DRAKE = 59569
LM_SPELL_MAGNIFICENT_FLYING_CARPET = 61309
LM_SPELL_FLYING_CARPET = 61451
LM_SPELL_SEA_TURTLE = 64731
LM_SPELL_LOANED_GRYPHON = 64749
LM_SPELL_LOANED_WIND_RIDER = 64762
LM_SPELL_ABYSSAL_SEAHORSE = 75207
LM_SPELL_FROSTY_FLYING_CARPET = 75596
LM_SPELL_RUNNING_WILD = 87840
LM_SPELL_SUBDUED_SEAHORSE = 98718
LM_SPELL_TARECGOSAS_VISAGE = 101641

LM_ITEM_FLYING_BROOM = 33176
LM_ITEM_MAGIC_BROOM = 37011
LM_ITEM_LOANED_GRYPHON_REINS = 44221
LM_ITEM_LOANED_WIND_RIDER_REINS = 44229
LM_ITEM_DRAGONWRATH_TARECGOSAS_REST = 71086

-- Racial and Class spells don't appear in the companion index
LM_RACIAL_MOUNT_SPELLS = {
    LM_SPELL_RUNNING_WILD,
}

LM_CLASS_MOUNT_SPELLS = {
    LM_SPELL_AQUATIC_FORM,
    LM_SPELL_FLIGHT_FORM,
    LM_SPELL_GHOST_WOLF,
    LM_SPELL_SWIFT_FLIGHT_FORM,
    LM_SPELL_TRAVEL_FORM,
}

-- Skill Lines from select(7, GetProfessionInfo(i))
--      164 Blacksmithing
--      165 Leatherworking
--      171 Alchemy
--      182 Herbalism
--      185 Cooking
--      186 Mining
--      197 Tailoring
--      202 Engineering
--      333 Enchanting
--      393 Skinning
--      755 Jewelcrafting
--      773 Inscription

LM_PROFESSION_MOUNT_SPELLS = {  -- = { skillLine, minSkillLevel }
    [LM_SPELL_FLYING_MACHINE] = { 202, 300 },
    [LM_SPELL_TURBO_CHARGED_FLYING_MACHINE] = { 202, 375 },
    [LM_SPELL_MAGNIFICENT_FLYING_CARPET] = { 197, 425 },
    [LM_SPELL_FROSTY_FLYING_CARPET] = { 197, 425 },
    [LM_SPELL_FLYING_CARPET] = { 197, 300 },
}

LM_ITEM_MOUNT_ITEMS = {
    [LM_ITEM_LOANED_GRYPHON_REINS] = LM_SPELL_LOANED_GRYPHON,
    [LM_ITEM_LOANED_WIND_RIDER_REINS] = LM_SPELL_LOANED_WIND_RIDER,
    [LM_ITEM_FLYING_BROOM] = LM_SPELL_FLYING_BROOM,
    [LM_ITEM_MAGIC_BROOM] = LM_SPELL_MAGIC_BROOM,
    [LM_ITEM_DRAGONWRATH_TARECGOSAS_REST] = LM_SPELL_TARECGOSAS_VISAGE,
}

LM_FlagOverrideTable = {
    [LM_SPELL_AQUATIC_FORM]       = bit.bor(LM_FLAG_BIT_FLOAT,
                                            LM_FLAG_BIT_SWIM),
    [LM_SPELL_RIDING_TURTLE]      = bit.bor(LM_FLAG_BIT_FLOAT,
                                            LM_FLAG_BIT_SWIM,
                                            LM_FLAG_BIT_WALK),
    [LM_SPELL_SEA_TURTLE]         = bit.bor(LM_FLAG_BIT_FLOAT,
                                            LM_FLAG_BIT_SWIM,
                                            LM_FLAG_BIT_WALK),
    [LM_SPELL_FLIGHT_FORM]        = bit.bor(LM_FLAG_BIT_FLY),
    [LM_SPELL_SWIFT_FLIGHT_FORM]  = bit.bor(LM_FLAG_BIT_FLY),
    [LM_SPELL_RUNNING_WILD]       = bit.bor(LM_FLAG_BIT_RUN),
    [LM_SPELL_GHOST_WOLF]         = bit.bor(LM_FLAG_BIT_WALK),
    [LM_SPELL_TRAVEL_FORM]        = bit.bor(LM_FLAG_BIT_WALK),
    [LM_SPELL_BLUE_QIRAJI_TANK]   = bit.bor(LM_FLAG_BIT_AQ),
    [LM_SPELL_GREEN_QIRAJI_TANK]  = bit.bor(LM_FLAG_BIT_AQ),
    [LM_SPELL_RED_QIRAJI_TANK]    = bit.bor(LM_FLAG_BIT_AQ),
    [LM_SPELL_YELLOW_QIRAJI_TANK] = bit.bor(LM_FLAG_BIT_AQ),
    [LM_SPELL_ABYSSAL_SEAHORSE]   = bit.bor(LM_FLAG_BIT_VASHJIR),
    [LM_SPELL_SUBDUED_SEAHORSE]   = bit.bor(LM_FLAG_BIT_FLOAT,
                                            LM_FLAG_BIT_SWIM,
                                            LM_FLAG_BIT_VASHJIR),
    [LM_SPELL_TARECGOSAS_VISAGE]  = bit.bor(LM_FLAG_BIT_FLY),
    [LM_SPELL_FLYING_BROOM]       = bit.bor(LM_FLAG_BIT_FLY),
    [LM_SPELL_MAGIC_BROOM]        = bit.bor(LM_FLAG_BIT_RUN,
                                            LM_FLAG_BIT_FLY),
    [LM_SPELL_LOANED_GRYPHON]     = bit.bor(LM_FLAG_BIT_FLY),
    [LM_SPELL_LOANED_WIND_RIDER]  = bit.bor(LM_FLAG_BIT_FLY),
}
