-- classes / objects
-- Battleaxes - 1
-- Clubs - 2
-- Daggers - 3
-- Flails - 4
-- Glaives - 5
-- Greataxes - 6
-- Greatclubs - 7
-- Greatswords - 8
-- Halberds - 9
-- Handaxes - 10
-- Javelins - 11
-- Light hammers - 12
-- Longswords - 13
-- Maces - 14
-- Mauls - 15
-- Morningstars - 16
-- Pikes - 17
-- Quarterstaves - 18
-- Rapiers - 19
-- Scimitars - 20
-- Shortswords - 21
-- Sickles - 22
-- Spears - 23
-- Tridents - 24
-- War Picks - 25
-- Warhammers - 26
-- Dart - 27
-- Hand Crossbows - 28
-- Heavy Crossbows - 29
-- Light Crossbows - 30
-- Longbows - 31
-- Shortbows - 32
-- Sling - 33



-- tables
traceType = {}
traceType.__index = traceType

function traceObject:new(DisplayName, Icon, weaponUUID, spellProperties, UseCosts, tooltipApply, wielderStrength, wielderDexterity, wielderMovementSpeed, meleeOrRanged, weaponName)
    local instance = setmetatable({}, traceObject)
    instance.DisplayName = DisplayName
    instance.Icon = Icon
    instance.weaponUUID = weaponUUID
    instance.spellProperties = spellProperties
    instance.UseCosts = UseCosts
    instance.tooltipApply = tooltipApply
    instance.wielderStrength = wielderStrength
    instance.wielderDexterity = wielderDexterity
    instance.wielderMovementSpeed = wielderMovementSpeed
    instance.meleeOrRanged = meleeOrRanged
    instance.weaponName = weaponName
    return instance
end


traceObject = {}
traceObject.__index = traceObject

function traceObject:new(DisplayName, Icon, weaponUUID, spellProperties, UseCosts, tooltipApply, wielderStrength, wielderDexterity, wielderMovementSpeed, meleeOrRanged, weaponName)
    local instance = setmetatable({}, traceObject)
    instance.DisplayName = DisplayName
    instance.Icon = Icon
    instance.weaponUUID = weaponUUID
    instance.spellProperties = spellProperties
    instance.UseCosts = UseCosts
    instance.tooltipApply = tooltipApply
    instance.wielderStrength = wielderStrength
    instance.wielderDexterity = wielderDexterity
    instance.wielderMovementSpeed = wielderMovementSpeed
    instance.meleeOrRanged = meleeOrRanged
    instance.weaponName = weaponName
    return instance
end

extraDescription = {}
extraDescription.__index = extraDescription

function extraDescription:new(weaponDisplayName, weaponDescription, weaponIcon, spellProperties, meleeOrRanged, weaponTemplate)
    local instance = setmetatable({}, extraDescription)
    instance.weaponDisplayName = weaponDisplayName
    instance.weaponDescription = weaponDescription
    instance.weaponIcon = weaponIcon
    instance.spellProperties = spellProperties
    instance.meleeOrRanged = meleeOrRanged
    instance.weaponTemplate = weaponTemplate
    return instance
end

-- trace variables
traceVariables = {}
traceVariables.__index = traceVariables

function traceVariables:new(mainWeaponTemplate, offhandWeaponTemplate, proficiencyBoost)
    local instance = setmetatable({}, traceVariables)
    instance.mainWeaponTemplate = mainWeaponTemplate
    instance.offhandWeaponTemplate = offhandWeaponTemplate
    instance.proficiencyBoost = proficiencyBoost
    return instance
end

traceVariablesRanged = {}
traceVariablesRanged.__index = traceVariablesRanged

function traceVariablesRanged:new(mainWeaponTemplateRanged, offhandWeaponTemplateRanged, proficiencyBoostRanged)
    local instance = setmetatable({}, traceVariablesRanged)
    instance.mainWeaponTemplateRanged = mainWeaponTemplateRanged
    instance.offhandWeaponTemplateRanged = offhandWeaponTemplateRanged
    instance.proficiencyBoostRanged = proficiencyBoostRanged
    return instance
end