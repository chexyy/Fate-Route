-- classes / objects
traceObjectRanged = {}
traceObjectRanged.__index = traceObjectRanged

function traceObjectRanged:new(DisplayName, Icon, weaponUUID, UseCosts)
    local instance = setmetatable({}, traceObjectRanged)
    instance.DisplayName = DisplayName
    instance.Icon = Icon
    instance.weaponUUID = weaponUUID
    instance.UseCosts = UseCosts
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

-- listeners
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted baseSpell sync")
    Ext.Vars.RegisterUserVariable("traceTableRanged", {})
    Ext.Vars.RegisterUserVariable("traceVariablesRanged", {})
    local entity = Ext.Entity.Get(GetHostCharacter())
    local localtraceTableRanged = entity.Vars.traceTableRanged or {}
    local localtraceVariablesRanged = entity.Vars.traceVariablesRanged or {}
    
    if localtraceTableRanged ~= {} then
        _D(localtraceTableRanged)
        for key, entry in ipairs(localtraceTableRanged) do
            for i=1,999,1 do
                local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                if observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" and observedTraceTemplate.DisplayName ~= entry.DisplayName then
                    
                    -- copying over stats
                    observedTraceTemplate:SetRawAttribute("DisplayName", entry.DisplayName)
                    observedTraceTemplate.Icon = entry.Icon
                    observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER_RANGED,100,2);AI_IGNORE:SummonInInventory(" .. entry.weaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
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

            Osi.RemoveSpell(GetHostCharacter(),"Shout_TraceWeapon",0)
        end
    end

    if localtraceVariablesRanged ~= {} and localtraceVariablesRanged ~= nil and localTraceVariable ~= { } then
        _D(localtraceVariablesRanged)
        for key, entry in ipairs(localtraceTableRanged) do
            if entry ~= nil and entry ~= {} then
                if key == 1 then
                    mainWeaponTemplateRanged = localtraceVariablesRanged.mainWeaponTemplateRanged
                    print("mainWeaponTemplateRanged loaded")
                elseif key == 2 then
                    offhandWeaponTemplateRanged = localtraceVariablesRanged.offhandWeaponTemplateRanged
                    print("offhandWeaponTemplateRanged loaded")
                elseif key == 3 then
                    proficiencyBoostRanged = localtraceVariablesRanged.proficiencyBoostRanged
                    print("proficiencyBoostRanged loaded")
                end
            end
        end
    end

    Ext.Osiris.RegisterListener("CharacterMadePlayer", 1, "after", function(character)
        print("Character made player")
        Ext.Vars.RegisterUserVariable("traceTableRanged", {})
        Ext.Vars.RegisterUserVariable("traceVariablesRanged", {})
        local entity = Ext.Entity.Get(character)
        local localtraceTableRanged = entity.Vars.traceTableRanged or {}
        local localtraceVariablesRanged = entity.Vars.traceVariablesRanged or {}
        
        if localtraceTableRanged ~= {} then
            _D(localtraceTableRanged)
            for key, entry in ipairs(localtraceTableRanged) do
                for i=1,999,1 do
                    local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                    if observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" and observedTraceTemplate.DisplayName ~= entry.DisplayName then
                        
                        -- copying over stats
                        observedTraceTemplate:SetRawAttribute("DisplayName", entry.DisplayName)
                        observedTraceTemplate.Icon = entry.Icon
                        observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER_RANGED,100,2);AI_IGNORE:SummonInInventory(" .. entry.weaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
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

                Osi.RemoveSpell(character,"Shout_TraceWeapon",0)
            end
        end
    
        if localtraceVariablesRanged ~= {} and localtraceVariablesRanged ~= nil and localTraceVariable ~= { } then
            _D(localtraceVariablesRanged)
            for key, entry in ipairs(localtraceTableRanged) do
                if entry ~= nil and entry ~= {} then
                    if key == 1 then
                        mainWeaponTemplateRanged = localtraceVariablesRanged.mainWeaponTemplateRanged
                        print("mainWeaponTemplateRanged loaded")
                    elseif key == 2 then
                        offhandWeaponTemplateRanged = localtraceVariablesRanged.offhandWeaponTemplateRanged
                        print("offhandWeaponTemplateRanged loaded")
                    elseif key == 3 then
                        proficiencyBoostRanged = localtraceVariablesRanged.proficiencyBoostRanged
                        print("proficiencyBoostRanged loaded")
                    end
                end
            end
        end
    
    end)

end)


Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == "Target_TraceWeapon_Ranged" then

        if HasAppliedStatus(caster,"FAKER_RANGED") then
            Osi.RemoveStatus(caster,"FAKER_RANGED")
        end
        local beginningIndex, endingIndex = string.find(target, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
        local targetUUID = string.sub(target,beginningIndex,endingIndex)
        
        if GetEquippedItem(targetUUID, "Ranged Offhand Weapon") ~= nil then
            local offhandWeapon = GetEquippedItem(targetUUID, "Ranged Offhand Weapon")
            offhandWeaponTemplateRanged = Osi.GetTemplate(offhandWeapon)
            Osi.TemplateAddTo(offhandWeaponTemplateRanged,caster,1,0) -- Gives offhand item
        end
        
        local mainWeapon = GetEquippedItem(targetUUID, "Ranged Main Weapon")
        if mainWeapon ~= nil then
            mainWeaponTemplateRanged = Osi.GetTemplate(mainWeapon)
            Osi.TemplateAddTo(mainWeaponTemplateRanged,caster,1,0) -- Gives item
            ApplyStatus(caster,"FAKER_RANGED",10,100)
        else
            local caster = Ext.Entity.Get(caster)
            caster.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = caster.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount + 1
        end
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_RANGED" then
        proficiencyBoostRanged = {}
        if mainWeaponTemplateRanged ~= nil then
            Osi.Equip(object,GetItemByTemplateInInventory(mainWeaponTemplateRanged,object),1,0)
            Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplateRanged,object), "REPRODUCTION", 10, 100)
        end
        if offhandWeaponTemplateRanged ~= nil then
            Osi.Equip(object,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,object),1,0)
            Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplateRanged,object), "REPRODUCTION", 10, 100)
        end 
    end

end)

Ext.Osiris.RegisterListener("MissedBy", 4, "after", function(defender, attackOwner, attacker, storyActionID) 
    if Osi.HasActiveStatus(attacker, "FAKER_RANGED") then
        Osi.RequestPassiveRoll(GetHostCharacter(), GetHostCharacter(),"SavingThrow", "Constitution", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 0, "Image Failure Roll (Melee)")
    end
end)

Ext.Osiris.RegisterListener("RollResult", 6, "after", function(eventName, roller, rollSubject, resultType, isActiveRoll, criticality)
    if eventName == "Image Failure Roll (Melee)" then 
        if resultType == 0 then
            Osi.RemoveStatus(caster,"FAKER_RANGED")
        end
    end
end)

Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(itemTemplate, character)
    -- mainhand
    if itemTemplate == mainWeaponTemplateRanged then
        print("Mainhand item equipped")
        -- proficiency
        if Osi.IsProficientWith(character, Osi.GetEquippedItem(GetHostCharacter(), "Ranged Main Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Main Weapon")).ServerTemplateTag.Tags[3]
            print("The weapon type is " .. weaponType)
            addProficiencyPassive(character,Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
        end
        -- checking if it's been traced before
        addTraceSpell(character, "Ranged Main Weapon")
        -- keeping track of variables
        local entity = Ext.Entity.Get(character)
        entity.Vars.traceVariablesRanged = traceVariablesRanged:new(mainWeaponTemplateRanged,offhandWeaponTemplateRanged,proficiencyBoostRanged)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
        local originalWeaponCooldowns = resetCooldownOne(character,boosts,mainhandBoosts,offhandBoosts)
        print(originalWeaponCooldowns)
        resetCooldownTwo(character,boosts,mainhandBoosts,offhandBoosts,originalWeaponCooldowns)
        
    end

    -- in the case of a secondary weapon
    if itemTemplate == offhandWeaponTemplateRanged then
        print("Offhand item equipped")
        -- proficiency
        if Osi.IsProficientWith(character, Osi.GetEquippedItem(GetHostCharacter(), "Ranged Offhand Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3]
            addProficiencyPassive(character,Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
        end
        -- checking if it's been traced before
        addTraceSpell(character, "Ranged Offhand Weapon")
        local entity = Ext.Entity.Get(character)
        entity.Vars.traceVariablesRanged = traceVariablesRanged:new(mainWeaponTemplateRanged,offhandWeaponTemplateRanged,proficiencyBoostRanged)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
        local originalWeaponCooldowns = resetCooldownOne(character,boosts,mainhandBoosts,offhandBoosts)
        print(originalWeaponCooldowns)
        resetCooldownTwo(character,boosts,mainhandBoosts,offhandBoosts,originalWeaponCooldowns)
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_RANGED" then 
        if mainWeaponTemplateRanged ~= nil then    
            -- removing proficiency
            removeProficiencyPassive(proficiencyBoostRanged)
            proficiencyBoostRanged = {}

            Osi.Unequip(GetHostCharacter(),GetItemByTemplateInInventory(mainWeaponTemplateRanged,object))
            Osi.TemplateRemoveFrom(mainWeaponTemplateRanged, object, 1)
            mainWeaponTemplateRanged = nil
        else
            local mainWeaponRanged = GetEquippedItem(object, "Ranged Main Weapon")
            local mainWeaponTemplateRanged = Osi.GetTemplate(mainWeaponRanged)
            if mainWeaponTemplateRanged ~= nil then
                Osi.Unequip(GetHostCharacter(),GetItemByTemplateInInventory(mainWeaponTemplateRanged,object))
                Osi.TemplateRemoveFrom(mainWeaponTemplateRanged, object, 1)
            end
        end

        if offhandWeaponTemplateRanged ~= nil then  
            Osi.Unequip(object,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,object))
            Osi.TemplateRemoveFrom(offhandWeaponTemplateRanged, object, 1)
            offhandWeaponTemplateRanged = nil
        else
            local offhandWeaponRanged = GetEquippedItem(object, "Ranged Offhand Weapon")
            local offhandWeaponTemplateRanged = Osi.GetTemplate(offhandWeaponRanged)
            if offhandWeaponTemplateRanged ~= nil then
                Osi.Unequip(GetHostCharacter(),GetItemByTemplateInInventory(offhandWeaponTemplateRanged,object))
                Osi.TemplateRemoveFrom(offhandWeaponTemplateRanged, object, 1)
            end
        end
        
        local entity = Ext.Entity.Get(object)
        entity.Vars.traceVariablesRanged = {}
    end

end)

print("Listeners loaded")