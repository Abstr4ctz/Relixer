----- BINDINGS -----

BINDING_HEADER_RELIXER = "Relixer";

----- OTHER VARIABLES -----

local lsTexture = "Spell_Nature_Thunderclap"
local esTexture = "Spell_Nature_Earthshock"


------ HELPER FUNCTIONS ------

local function getSpellId(targetSpellName, targetSpellRank)
    for i = 1, 200 do
        local spellName, spellRank = GetSpellName(i, "spell")
        if spellName == targetSpellName and (not targetSpellRank or spellRank == targetSpellRank) then
            return i
        end
    end
    return nil
end


local function GetCooldown(spellId)
	if not spellId then
		return 10
	end

	local start, duration, enabled = GetSpellCooldown(spellId, "spell")
	if duration == 0 then
		return 0
	end

	return start + duration - GetTime()
end

local function SpellReady(spellId)
    local start, duration, enabled = GetSpellCooldown(spellId, "spell")
    return duration == 0
end

local function FindActionSlotByTexture(texture)
    for i = 1, 120 do
        local actionTexture = GetActionTexture(i)
        if actionTexture and string.find(actionTexture, texture) then
            return i
        end
    end
    return nil
end

local function ItemLinkToName(link)
	if ( link ) then
   	return gsub(link,"^.*%[(.*)%].*$","%1");
	end
end

local function FindItem(item)
	if ( not item ) then return; end
	item = string.lower(ItemLinkToName(item));
	local link;
	for i = 1,23 do
		link = GetInventoryItemLink("player",i);
		if ( link ) then
			if ( item == string.lower(ItemLinkToName(link)) )then
				return i, nil, GetInventoryItemTexture('player', i), GetInventoryItemCount('player', i);
			end
		end
	end
	local count, bag, slot, texture;
	local totalcount = 0;
	for i = 0,NUM_BAG_FRAMES do
		for j = 1,MAX_CONTAINER_ITEMS do
			link = GetContainerItemLink(i,j);
			if ( link ) then
				if ( item == string.lower(ItemLinkToName(link))) then
					bag, slot = i, j;
					texture, count = GetContainerItemInfo(i,j);
					totalcount = totalcount + count;
				end
			end
		end
	end
	return bag, slot, texture, totalcount;
end

local function UseItemByName(item)
	local bag,slot = FindItem(item);
	if ( not bag ) then return; end;
	if ( slot ) then
		UseContainerItem(bag,slot); -- use, equip item in bag
		return bag, slot;
	else
		UseInventoryItem(bag); -- unequip from body
		return bag;
	end
end

local function CastSwapByName(targetSpellName, targetSpellRank, itemName)
    local spellId = getSpellId(targetSpellName, targetSpellRank)
    if spellId then
        local spellReady = SpellReady(spellId)
        if spellReady then
            UseItemByName(itemName)
            CastSpell(spellId, "spell")
        end
    end
end

------ LS ------

function Relixer_LS()
    local lsCooldown = GetCooldown(getSpellId("Lightning Strike"))
	
	if lsCooldown == 0 then
        CastSwapByName("Lightning Strike", "Rank 3", "Totem of Crackling Thunder")
    end
end

------ SHOCKS ------

function Relixer_FrostShockMax()
    local shockCooldown = GetCooldown(getSpellId("Earth Shock"))
	if shockCooldown == 0 then
		CastSwapByName("Frost Shock", "Rank 4", "Totem of the Stonebreaker")
	end
end

function Relixer_FrostShockMin()
    local shockCooldown = GetCooldown(getSpellId("Earth Shock"))
	if shockCooldown == 0 then
		CastSwapByName("Frost Shock", "Rank 1", "Totem of the Stonebreaker")
	end
end

function Relixer_EarthShockMax()
    local shockCooldown = GetCooldown(getSpellId("Earth Shock"))
	if shockCooldown == 0 then
		CastSwapByName("Earth Shock", "Rank 7", "Totem of the Stonebreaker")
	end
end

function Relixer_EarthShockMin()
    local shockCooldown = GetCooldown(getSpellId("Earth Shock"))
	if shockCooldown == 0 then
		CastSwapByName("Earth Shock", "Rank 1", "Totem of the Stonebreaker")
	end
end

function Relixer_FlameShockMax()
    local shockCooldown = GetCooldown(getSpellId("Earth Shock"))
	if shockCooldown == 0 then
		CastSwapByName("Flame Shock", "Rank 6", "Totem of the Stonebreaker")
	end
end

function Relixer_FlameShockMin()
    local shockCooldown = GetCooldown(getSpellId("Earth Shock"))
	if shockCooldown == 0 then
		CastSwapByName("Flame Shock", "Rank 1", "Totem of the Stonebreaker")
	end
end

------ SLASH COMMANDS ------

SLASH_RELIXER_LS1 = "/relixerls"
SlashCmdList["RELIXER_LS"] = Relixer_LS

SLASH_RELIXER_FROSTSHOCKMAX1 = "/relixerfrostshockmax"
SlashCmdList["RELIXER_FROSTSHOCKMAX"] = Relixer_FrostShockMax

SLASH_RELIXER_FROSTSHOCKMIN1 = "/relixerfrostshockmin"
SlashCmdList["RELIXER_FROSTSHOCKMIN"] = Relixer_FrostShockMin

SLASH_RELIXER_EARTHSHOCKMAX1 = "/relixerearthshockmax"
SlashCmdList["RELIXER_EARTHSHOCKMAX"] = Relixer_EarthShockMax

SLASH_RELIXER_EARTHSHOCKMIN1 = "/relixerearthshockmin"
SlashCmdList["RELIXER_EARTHSHOCKMIN"] = Relixer_EarthShockMin

SLASH_RELIXER_FLAMESHOCKMAX1 = "/relixerflameshockmax"
SlashCmdList["RELIXER_FLAMESHOCKMAX"] = Relixer_FlameShockMax

SLASH_RELIXER_FLAMESHOCKMIN1 = "/relixerflameshockmin"
SlashCmdList["RELIXER_FLAMESHOCKMIN"] = Relixer_FlameShockMin