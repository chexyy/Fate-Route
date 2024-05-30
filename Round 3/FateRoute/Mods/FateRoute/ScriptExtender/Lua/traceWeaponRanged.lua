-- classes / objects
traceVariablesRanged = {}
traceVariablesRanged.__index = traceVariablesRanged

function traceVariablesRanged:new(mainWeaponTemplateRanged, offhandWeaponTemplateRanged, proficiencyBoostRanged, fakerCharacter)
    local instance = setmetatable({}, traceVariablesRanged)
    instance.mainWeaponTemplateRanged = mainWeaponTemplateRanged
    instance.offhandWeaponTemplateRanged = offhandWeaponTemplateRanged
    instance.proficiencyBoostRanged = proficiencyBoostRanged
    instance.fakerCharacter = fakerCharacter
    return instance
end

-- listeners
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted ranged baseSpell sync")
    Ext.Vars.RegisterUserVariable("traceTableRanged", {})
    Ext.Vars.RegisterUserVariable("traceVariablesRanged", {})
    local entity = Ext.Entity.Get(GetHostCharacter())
    local localTraceTable = entity.Vars.traceTableRanged or {}
    local localTraceVariables = entity.Vars.traceVariablesRanged or {}
    
    if localTraceTable ~= {} then
        _D(localTraceTable)
        for key, entry in ipairs(localTraceTable) do
            for i=1,999,1 do
                local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                if observedTraceTemplate.Icon == entry.Icon or observedTraceTemplate.DisplayName == entry.DisplayName then
                    print("Broke at index #" .. i)
                    break
                elseif observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
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

    if localTraceVariables ~= {} and localTraceVariables ~= nil and localTraceVariable ~= { } then
        _D(localTraceVariables)
        for key, entry in ipairs(localTraceTable) do
            if entry ~= nil and entry ~= {} then
                if key == 1 then
                    mainWeaponTemplateRanged = localTraceVariables.mainWeaponTemplateRanged
                    print("mainWeaponTemplateRanged loaded")
                elseif key == 2 then
                    offhandWeaponTemplateRanged = localTraceVariables.offhandWeaponTemplateRanged
                    print("offhandWeaponTemplateRanged loaded")
                elseif key == 3 then
                    proficiencyBoostRanged = localTraceVariables.proficiencyBoostRanged
                    print("proficiencyBoostRanged loaded")
                elseif key == 4 then
                    fakerCharacter = localTraceVariables.fakerCharacter
                    print("fakerCharacter loaded")
                end
            end
        end
    end

    Ext.Osiris.RegisterListener("CharacterMadePlayer", 1, "after", function(character)
        print("Character made player")
        Ext.Vars.RegisterUserVariable("traceTableRanged", {})
        Ext.Vars.RegisterUserVariable("traceVariablesRanged", {})
        local entity = Ext.Entity.Get(character)
        local localTraceTable = entity.Vars.traceTableRanged or {}
        local localTraceVariables = entity.Vars.traceVariablesRanged or {}
        
        if localTraceTable ~= {} then
            _D(localTraceTable)
            for key, entry in ipairs(localTraceTable) do
                for i=1,999,1 do
                    local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                    if observedTraceTemplate.Icon == entry.Icon or observedTraceTemplate.DisplayName == entry.DisplayName then
                        print("Broke at index #" .. i)
                        break
                    elseif observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
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
    
        if localTraceVariables ~= {} and localTraceVariables ~= nil and localTraceVariable ~= { } then
            _D(localTraceVariables)
            for key, entry in ipairs(localTraceTable) do
                if entry ~= nil and entry ~= {} then
                    if key == 1 then
                        mainWeaponTemplateRanged = localTraceVariables.mainWeaponTemplateRanged
                        print("mainWeaponTemplateRanged loaded")
                    elseif key == 2 then
                        offhandWeaponTemplateRanged = localTraceVariables.offhandWeaponTemplateRanged
                        print("offhandWeaponTemplateRanged loaded")
                    elseif key == 3 then
                        proficiencyBoostRanged = localTraceVariables.proficiencyBoostRanged
                        print("proficiencyBoostRanged loaded")
                    elseif key == 4 then
                        fakerCharacter = localTraceVariables.fakerCharacter
                        print("fakerCharacter loaded")
                    end
                end
            end
        end
    
    end)
    
end)


Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == "Target_TraceWeapon_Ranged" then

        fakerCharacter = caster
        if HasAppliedStatus(fakerCharacter,"FAKER_RANGED") then
            Osi.RemoveStatus(fakerCharacter,"FAKER_RANGED")
        end
        local beginningIndex, endingIndex = string.find(target, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
        local targetUUID = string.sub(target,beginningIndex,endingIndex)
        local targetEntity = Ext.Entity.Get(target)
        wielderStrengthRanged = targetEntity.Stats.Abilities[2]
        wielderDexterityRanged = targetEntity.Stats.Abilities[3]
        wielderMovementSpeedRanged = targetEntity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount
        
        if GetEquippedItem(targetUUID, "Ranged Offhand Weapon") ~= nil then
            print("Attempting to equip main weapon")
            local offhandWeapon = GetEquippedItem(targetUUID, "Ranged Offhand Weapon")
            offhandWeaponTemplateRanged = Osi.GetTemplate(offhandWeapon)
            Osi.TemplateAddTo(offhandWeaponTemplateRanged,fakerCharacter,1,0) -- Gives offhand item
        end
        
        local mainWeapon = GetEquippedItem(targetUUID, "Ranged Main Weapon")

        if mainWeapon ~= nil then 
            mainWeaponTemplateRanged = Osi.GetTemplate(mainWeapon)
            Osi.TemplateAddTo(mainWeaponTemplateRanged,fakerCharacter,1,0) -- Gives item
            ApplyStatus(fakerCharacter,"FAKER_RANGED",15,100)
        else
            local casterEntity = Ext.Entity.Get(fakerCharacter)
            casterEntity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = caster.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount + 1
        end
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_RANGED" then
        proficiencyBoostRanged = {}
        if mainWeaponTemplateRanged ~= nil then
            spellActivatedMainRanged = true
            Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter),1,0)
            Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter), "REPRODUCTION", 15, 100)
        end
        if offhandWeaponTemplateRanged ~= nil then
            spellActivatedOffRanged = true
            Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter),1,0)
            Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter), "REPRODUCTION", 15, 100)
        end 
        if mainWeaponTemplateRanged == nil and offhandWeaponTemplateRanged == nil then
            if Osi.GetEquippedItem(fakerCharacter, "Rangged Main Weapon") then
                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)

                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
                print("Reset cooldown of reproduced mainhand ranged weapon")

                if GetEquippedItem(targetUUID, "Ranged Offhand Weapon") ~= nil then
                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
                    
                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
                    print("Reset cooldown of reproduced offhand ranged weapon")
                end 
            end
        end
    end

end)

Ext.Osiris.RegisterListener("MissedBy", 4, "after", function(defender, attackOwner, attacker, storyActionID) 
    if Osi.HasActiveStatus(attacker, "FAKER_RANGED") and attacker == fakerCharacter and defender ~= fakerCharacter then
        print("Attacker is " .. attacker .. " and defender is " .. defender)
        Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Constitution", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 0, "Image Failure Roll (Ranged)")
    end
end)

Ext.Osiris.RegisterListener("RollResult", 6, "after", function(eventName, roller, rollSubject, resultType, isActiveRoll, criticality)
    if eventName == "Image Failure Roll (Ranged)" then 
        if resultType == 0 then
            Osi.RemoveStatus(fakerCharacter,"FAKER_RANGED")
        end
    end
end)

Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(itemTemplate, character)
    -- mainhand
    if itemTemplate == mainWeaponTemplateRanged and spellActivatedMainRanged == true then
        spellActivatedMainRanged = false
        print("Mainhand item equipped")
        -- checking if it's been traced before
        addTraceSpell(fakerCharacter, "Ranged Main Weapon", wielderStrengthRanged, wielderDexterityRanged, wielderMovementSpeedRanged)
        -- keeping track of variables
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariablesRanged = traceVariablesRanged:new(mainWeaponTemplateRanged,offhandWeaponTemplateRanged,proficiencyBoostRanged, fakerCharacter)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
        
        Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter))
        Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter),1,0)

        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
        -- proficiency
        if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).ServerTemplateTag.Tags[3]
            print("The weapon type is " .. weaponType)
            addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
        end
    end

    -- in the case of a secondary weapon
    if itemTemplate == offhandWeaponTemplateRanged and spellActivatedOffRanged == true then
        spellActivatedOffRanged = false
        print("Offhand item equipped")
        -- checking if it's been traced before
        addTraceSpell(character, "Ranged Offhand Weapon", wielderStrengthRanged, wielderDexterityRanged, wielderMovementSpeedRanged)
        local entity = Ext.Entity.Get(character)
        entity.Vars.traceVariablesRanged = traceVariablesRanged:new(mainWeaponTemplateRanged,offhandWeaponTemplateRanged,proficiencyBoostRanged, fakerCharacter)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
        
        Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter))
        Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter),1,0)

        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
         -- proficiency
         if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3]
            addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
        end
    end

    wielderStrengthRanged = nil
    wielderDexterityRanged = nil 
    wielderMovementSpeedRanged = nil

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_RANGED" then 
        fakerCharacter = object
        if mainWeaponTemplateRanged ~= nil then    
            -- removing proficiency
            removeProficiencyPassive(proficiencyBoostRanged)
            proficiencyBoostRanged = {}

            Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter))
            Osi.TemplateRemoveFrom(mainWeaponTemplateRanged, fakerCharacter, 1)
            mainWeaponTemplateRanged = nil
            Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
            Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
        else
            local mainWeapon = GetEquippedItem(fakerCharacter, "Ranged Main Weapon")
            if mainWeapon ~= nil then
                local mainWeaponTemplateRanged = Osi.GetTemplate(mainWeapon)
                if mainWeaponTemplateRanged ~= nil then
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter))
                    Osi.TemplateRemoveFrom(mainWeaponTemplateRanged, fakerCharacter, 1)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                end
            end
        end

        if offhandWeaponTemplateRanged ~= nil then  
            Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter))
            Osi.TemplateRemoveFrom(offhandWeaponTemplateRanged, fakerCharacter, 1)
            offhandWeaponTemplateRanged = nil
            Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
            Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
        else
            local offhandWeapon = GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")
            if offhandWeapon ~= nil then
                local offhandWeaponTemplateRanged = Osi.GetTemplate(offhandWeapon)
                if offhandWeaponTemplateRanged ~= nil then
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter))
                    print(fakerCharacter)
                    Osi.TemplateRemoveFrom(mainWeaponTemplateRanged, fakerCharacter, 1)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                end
            end
        end
        
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariablesRanged = {}

        fakerCharacter = {}
    end

end)

print("Ranged listeners loaded")