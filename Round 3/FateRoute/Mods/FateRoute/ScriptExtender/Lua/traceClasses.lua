-- classes / objects

-- tables
traceObject = {}
traceObject.__index = traceObject

function traceObject:new(DisplayName, Icon, weaponUUID, spellProperties, UseCosts, tooltipApply, wielderStrength, wielderDexterity, wielderMovementSpeed, meleeOrRanged)
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
    return instance
end

extraDescription = {}
extraDescription.__index = extraDescription

function extraDescription:new(weaponDisplayName, weaponDescription, weaponIcon, spellProperties, meleeOrRanged, weaponTemplate)
    local instance = setmetatable({}, traceVariables)
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