-- classes / objects
traceObject = {}
traceObject.__index = traceObject

function traceObject:new(DisplayName, Icon, weaponUUID, UseCosts)
    local instance = setmetatable({}, traceObject)
    instance.DisplayName = DisplayName
    instance.Icon = Icon
    instance.weaponUUID = weaponUUID
    instance.UseCosts = UseCosts
    return instance
end

traceVariables = {}
traceVariables.__index = traceVariables

function traceVariables:new(mainWeaponTemplate, offhandWeaponTemplate, proficiencyBoost)
    local instance = setmetatable({}, traceVariables)
    instance.mainWeaponTemplate = mainWeaponTemplate
    instance.offhandWeaponTemplate = offhandWeaponTemplate
    instance.proficiencyBoost = proficiencyBoost
    return instance
end

-- listeners
Ext.Osiris.RegisterListener("CharacterMadePlayer", 1, "after", function(character)
    print("Character made player")
    Ext.Vars.RegisterUserVariable("traceTable", {})
    Ext.Vars.RegisterUserVariable("traceVariables", {})
    local entity = Ext.Entity.Get(character)
    local localTraceTable = entity.Vars.traceTable or {}
    local localTraceVariables = entity.Vars.traceVariables or {}
    
    if localTraceTable ~= {} then
        _D(localTraceTable)
        for key, entry in ipairs(localTraceTable) do
            for i=1,999,1 do
                local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                if observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" and observedTraceTemplate.DisplayName ~= entry.DisplayName then
                    
                    -- copying over stats
                    observedTraceTemplate:SetRawAttribute("DisplayName", entry.DisplayName)
                    observedTraceTemplate.Icon = entry.Icon
                    observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER,100,2);AI_IGNORE:SummonInInventory(" .. entry.weaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
                    observedTraceTemplate.UseCosts = entry.UseCosts

                    -- adding to spell
                    local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")
                    local containerList = baseSpell.ContainerSpells
                    if containerList == "" then
                        containerList = "Shout_TraceWeapon_Template" .. i
                    else
                        containerList = containerList .. ";Shout_TraceWeapon_Template" .. i
                    end
                    
    
                    observedTraceTemplate:Sync()       
                    baseSpell.ContainerSpells = containerList
                    baseSpell:Sync()
    
                    print("This sync produced a spell for " .. Osi.ResolveTranslatedString(observedTraceTemplate.DisplayName) .. " for template spell #" .. i) 
                    break
                end
            end

            local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")
            baseSpell:Sync() 
        end
    end

    if localTraceVariables ~= {} and localTraceVariables ~= nil and localTraceVariable ~= { } then
        _D(localTraceVariables)
        for key, entry in ipairs(localTraceTable) do
            if entry ~= nil and entry ~= {} then
                if key == 1 then
                    mainWeaponTemplate = localTraceVariables.mainWeaponTemplate
                    print("mainWeaponTemplate loaded")
                elseif key == 2 then
                    offhandWeaponTemplate = localTraceVariables.offhandWeaponTemplate
                    print("offhandWeaponTemplate loaded")
                elseif key == 3 then
                    proficiencyBoost = localTraceVariables.proficiencyBoost
                    print("proficiencyBoost loaded")
                end
            end
        end
    end

end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == "Target_TraceWeapon" then

        if HasAppliedStatus(caster,"FAKER") then
            Osi.RemoveStatus(caster,"FAKER")
        end
        local beginningIndex, endingIndex = string.find(target, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
        local targetUUID = string.sub(target,beginningIndex,endingIndex)
        
        if GetEquippedItem(targetUUID, "Melee Offhand Weapon") ~= nil then
            local offhandWeapon = GetEquippedItem(targetUUID, "Melee Offhand Weapon")
            offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
            Osi.TemplateAddTo(offhandWeaponTemplate,caster,1,0) -- Gives offhand item
        end
        
        local mainWeapon = GetEquippedItem(targetUUID, "Melee Main Weapon")
        mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
        Osi.TemplateAddTo(mainWeaponTemplate,caster,1,0) -- Gives item

        ApplyStatus(caster,"FAKER",10,100)
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER" then
        proficiencyBoost = {}
        if mainWeaponTemplate ~= nil then
            Osi.Equip(object,GetItemByTemplateInInventory(mainWeaponTemplate,object),1,0)
            Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplate,object), "REPRODUCTION", 10, 100)
        end
        if offhandWeaponTemplate ~= nil then
            Osi.Equip(object,GetItemByTemplateInInventory(offhandWeaponTemplate,object),1,0)
            Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplate,object), "REPRODUCTION", 10, 100)
        end 
    end

end)

Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(itemTemplate, character)
    -- mainhand
    if itemTemplate == mainWeaponTemplate then
        print("Mainhand item equipped")
        -- proficiency
        if Osi.IsProficientWith(character, Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).ServerTemplateTag.Tags[3]
            print("The weapon type is " .. weaponType)
            addProficiencyPassive(character,Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
        end
        -- checking if it's been traced before
        addTraceSpell(character, "Melee Main Weapon")
        -- keeping track of variables
        local entity = Ext.Entity.Get(character)
        entity.Vars.traceVariables = traceVariables:new(mainWeaponTemplate,offhandWeaponTemplate,proficiencyBoost)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Use.BoostsOnEquipOffHand
        local originalWeaponCooldowns = resetCooldownOne(character,boosts,mainhandBoosts,offhandBoosts)
        print(originalWeaponCooldowns)
        resetCooldownTwo(character,boosts,mainhandBoosts,offhandBoosts,originalWeaponCooldowns)
        
    end

    -- in the case of a secondary weapon
    if itemTemplate == offhandWeaponTemplate then
        print("Offhand item equipped")
        -- proficiency
        if Osi.IsProficientWith(character, Osi.GetEquippedItem(GetHostCharacter(), "Melee Offhand Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Offhand Weapon")).ServerTemplateTag.Tags[3]
            addProficiencyPassive(character,Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
        end
        -- checking if it's been traced before
        addTraceSpell(character, "Melee Offhand Weapon")
        local entity = Ext.Entity.Get(character)
        entity.Vars.traceVariables = traceVariables:new(mainWeaponTemplate,offhandWeaponTemplate,proficiencyBoost)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Use.BoostsOnEquipOffHand
        local originalWeaponCooldowns = resetCooldownOne(character,boosts,mainhandBoosts,offhandBoosts)
        print(originalWeaponCooldowns)
        resetCooldownTwo(character,boosts,mainhandBoosts,offhandBoosts,originalWeaponCooldowns)
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER" then 
        if mainWeaponTemplate ~= nil then    
            -- removing proficiency
            removeProficiencyPassive(proficiencyBoost)
            proficiencyBoost = {}

            Osi.Unequip(GetHostCharacter(),GetItemByTemplateInInventory(mainWeaponTemplate,object))
            Osi.TemplateRemoveFrom(mainWeaponTemplate, object, 1)
            mainWeaponTemplate = nil
        end

        if offhandWeaponTemplate ~= nil then  
            Osi.Unequip(object,GetItemByTemplateInInventory(offhandWeaponTemplate,object))
            Osi.TemplateRemoveFrom(offhandWeaponTemplate, object, 1)
            offhandWeaponTemplate = nil
        end
        
        local entity = Ext.Entity.Get(object)
        entity.Vars.traceVariables = {}
    end

end)

print("Listeners loaded")