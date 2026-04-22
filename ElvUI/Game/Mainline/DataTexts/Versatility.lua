local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local format, strjoin = format, strjoin
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local GetVersatilityBonus = GetVersatilityBonus
local BreakUpLargeNumbers = BreakUpLargeNumbers

local CR_VERSATILITY_DAMAGE_DONE = CR_VERSATILITY_DAMAGE_DONE
local CR_VERSATILITY_DAMAGE_TAKEN = CR_VERSATILITY_DAMAGE_TAKEN
local STAT_CATEGORY_ENHANCEMENTS = STAT_CATEGORY_ENHANCEMENTS
local STAT_VERSATILITY = STAT_VERSATILITY

local displayString, db = ''

local function OnEnter()
	DT.tooltip:ClearLines()

	local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE)
	local damageDone = GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
	local damageTaken = GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN)
	local bonusDamage = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
	local bonusTaken = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN)

	local tooltip = format('%s: %s [%.2f%% (+ %.2f%%) / %.2f%% (+ %.2f%%)]', STAT_VERSATILITY, BreakUpLargeNumbers(versatility), damageDone, bonusDamage, damageTaken, bonusTaken)
	DT.tooltip:AddLine(tooltip, nil, nil, nil, true)
	DT.tooltip:Show()
end

local function OnEvent(self)
	local bonusDamage = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
	local damageDone = GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)

	if db.NoLabel then
		self.text:SetFormattedText(displayString, damageDone, bonusDamage)
	else
		self.text:SetFormattedText(displayString, db.Label ~= '' and db.Label or STAT_VERSATILITY, damageDone, bonusDamage)
	end
end

local function ApplySettings(self, hex)
	if not db then
		db = E.global.datatexts.settings[self.name]
	end

	displayString = strjoin('', db.NoLabel and '' or '%s: ', hex, '%.'..db.decimalLength..'f%% (+%.'..db.decimalLength..'f%%|r')
end

DT:RegisterDatatext('Versatility', STAT_CATEGORY_ENHANCEMENTS, { 'UNIT_STATS', 'UNIT_AURA', 'ACTIVE_TALENT_GROUP_CHANGED', 'PLAYER_TALENT_UPDATE', 'PLAYER_DAMAGE_DONE_MODS' }, OnEvent, nil, nil, OnEnter, nil, STAT_VERSATILITY, nil, ApplySettings)
