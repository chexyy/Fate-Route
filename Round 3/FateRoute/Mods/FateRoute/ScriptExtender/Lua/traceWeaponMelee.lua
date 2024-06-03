-- listeners
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted melee variables sync")
    Ext.Vars.RegisterUserVariable("traceVariables", {})

    local entity = Ext.Entity.Get(GetHostCharacter())
    local localTraceVariables = entity.Vars.traceVariables or {}

    if localTraceVariables ~= {} and localTraceVariables ~= nil and localTraceVariable ~= { } then
        _D(localTraceVariables)
        for key, entry in ipairs(localTraceVariables) do
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
                elseif key == 4 then
                    fakerCharacter = localTraceVariables.fakerCharacter
                    print("fakerCharacter loaded")
                end
            end
        end
    end

    Ext.Osiris.RegisterListener("CharacterMadePlayer", 1, "after", function(character)
        print("Character made player (melee)")
        print("Attempted second melee variables sync")
        Ext.Vars.RegisterUserVariable("traceVariables", {})

        local entity = Ext.Entity.Get(GetHostCharacter())
        local localTraceVariables = entity.Vars.traceVariables or {}

        if localTraceVariables ~= {} and localTraceVariables ~= nil and localTraceVariable ~= { } then
            _D(localTraceVariables)
            for key, entry in ipairs(localTraceVariables) do
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
    if spellName == "Target_TraceWeapon_Melee" then

        fakerCharacter = caster
        if HasAppliedStatus(fakerCharacter,"FAKER_MELEE") then
            Osi.RemoveStatus(fakerCharacter,"FAKER_MELEE")
        end
        local beginningIndex, endingIndex = string.find(target, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
        local targetUUID = string.sub(target,beginningIndex,endingIndex)

        if HasMeleeWeaponEquipped(targetUUID, "Mainhand") == 0 and HasMeleeWeaponEquipped(targetUUID, "Offhand") == 0 then
            local casterEntity = Ext.Entity.Get(fakerCharacter)
            casterEntity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = caster.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount + 1
        end

        local targetEntity = Ext.Entity.Get(target)
        wielderStrength = targetEntity.Stats.Abilities[2]
        wielderDexterity = targetEntity.Stats.Abilities[3]
        wielderMovementSpeed = targetEntity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount
        wielderName = targetEntity.CharacterCreationStats.Name
        
        if HasMeleeWeaponEquipped(targetUUID, "Offhand") == 1 or GetEquippedShield(targetUUID) ~= "NULL_00000000-0000-0000-0000-000000000000" then
            print("Attempting to equip melee offhand weapon")
            local offhandWeapon = GetEquippedItem(targetUUID, "Melee Offhand Weapon")
            offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
            Osi.TemplateAddTo(offhandWeaponTemplate,fakerCharacter,1,0) -- Gives offhand item
            wielderIcon = Ext.Entity.Get(Osi.GetEquippedItem(target, "Melee Offhand Weapon")).Icon.Icon
        end
        
        if HasMeleeWeaponEquipped(targetUUID, "Mainhand") == 1 then 
            print("Attempting to equip melee main weapon")
            local mainWeapon = GetEquippedItem(targetUUID, "Melee Main Weapon")
            mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
            Osi.TemplateAddTo(mainWeaponTemplate,fakerCharacter,1,0) -- Gives item
            ApplyStatus(fakerCharacter,"FAKER_MELEE",15,100)
            wielderIcon = Ext.Entity.Get(Osi.GetEquippedItem(target, "Melee Main Weapon")).Icon.Icon
        end
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_MELEE" and dualWeaponsProjected == nil then
        fakerCharacter = object
        proficiencyBoost = {}
        if mainWeaponTemplate ~= nil or offhandWeaponTemplate ~= nil then
            if offhandWeaponTemplate ~= nil then
                spellActivatedOff = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter), "REPRODUCTION", 15, 100)
            end
            if mainWeaponTemplate ~= nil then
                spellActivatedMain = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter), "REPRODUCTION", 15, 100)
            end
            if mainWeaponTemplate ~= nil or offhandWeaponTemplate ~= nil then
                Osi.ApplyStatus(fakerCharacter, "FAKER_MELEE_CONFIRMATION", 15, 100)
            end
        end
        if mainWeaponTemplate == nil and offhandWeaponTemplate == nil then
            if Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon") ~= nil then
                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)

                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
                print("Reset cooldown of reproduced mainhand melee weapon")

                if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")) == 0 then
                    local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).ServerTemplateTag.Tags[3]
                    print("The weapon type is " .. weaponType)
                    addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
                end

                if Osi.HasMeleeWeaponEquipped(targetUUID, "Offhand") == 1 then
                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)

                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
                    print("Reset cooldown of reproduced offhand melee weapon")

                    if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")) == 0 then
                        local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).ServerTemplateTag.Tags[3]
                        addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
                    end
                end 
            end
        end
    end

    if status == "FAKER_MELEE_CONFIRMATION" then
        print("Faker confirmation done")
        -- checking if it's been traced before
        if mainWeaponTemplate ~= nil and offhandWeaponTemplate == nil then
            addTraceSpell(fakerCharacter, {"Melee Main Weapon", nil}, wielderStrength, wielderDexterity, wielderMovementSpeed, wielderIcon, wielderName, "Melee", {mainWeaponTemplate, nil})
        elseif mainWeaponTemplate == nil and offhandWeaponTemplate ~= nil then
            addTraceSpell(fakerCharacter, {nil, "Melee Offhand Weapon"}, wielderStrength, wielderDexterity, wielderMovementSpeed, wielderIcon, wielderName, "Melee", {nil, offhandWeaponTemplate})
        elseif mainWeaponTemplate ~= nil and offhandWeaponTemplate ~= nil then
            addTraceSpell(fakerCharacter, {"Melee Main Weapon", "Melee Offhand Weapon"}, wielderStrength, wielderDexterity, wielderMovementSpeed, wielderIcon, wielderName, "Melee", {mainWeaponTemplate, offhandWeaponTemplate})
        end
        wielderStrength = nil
        wielderDexterity = nil 
        wielderMovementSpeed = nil
        wielderIcon = nil
        wielderName = nil
    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_MELEE" and dualWeaponsProjected == true then
        fakerCharacter = object
        proficiencyBoost = {}
        if mainWeaponTemplate ~= nil or offhandWeaponTemplate ~= nil then
            if offhandWeaponTemplate ~= nil then
                spellActivatedOff = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter), "REPRODUCTION", 15, 100)
            end
            if mainWeaponTemplate ~= nil then
                spellActivatedMain = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter), "REPRODUCTION", 15, 100)
            end
        end
        if mainWeaponTemplate == nil and offhandWeaponTemplate == nil then
            if Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon") ~= nil then
                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)

                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
                print("Reset cooldown of reproduced mainhand melee weapon")

                if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")) == 0 then
                    local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).ServerTemplateTag.Tags[3]
                    print("The weapon type is " .. weaponType)
                    addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
                end

                if Osi.HasMeleeWeaponEquipped(targetUUID, "Offhand") == 1 then
                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)

                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
                    print("Reset cooldown of reproduced offhand melee weapon")

                    if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")) == 0 then
                        local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).ServerTemplateTag.Tags[3]
                        addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
                    end
                end 
            end
        end

        dualWeaponsProjected = nil
    end

end)

Ext.Osiris.RegisterListener("MissedBy", 4, "after", function(defender, attackOwner, attacker, storyActionID) 
    if Osi.HasActiveStatus(attacker, "FAKER_MELEE") and attacker == fakerCharacter and defender ~= fakerCharacter then
        print("Attacker is " .. attacker .. " and defender is " .. defender)
        Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Constitution", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 0, "Image Failure Roll (Melee)")
    end
end)

Ext.Osiris.RegisterListener("RollResult", 6, "after", function(eventName, roller, rollSubject, resultType, isActiveRoll, criticality)
    if eventName == "Image Failure Roll (Melee)" then 
        if resultType == 0 then
            Osi.RemoveStatus(fakerCharacter,"FAKER_MELEE")
        end
    end
end)

Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(itemTemplate, character)
    -- mainhand
    if itemTemplate == mainWeaponTemplate and spellActivatedMain == true then
        spellActivatedMain = false
        print("Mainhand item equipped")
        -- keeping track of variables
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariables = traceVariables:new(mainWeaponTemplate,offhandWeaponTemplate,proficiencyBoost, fakerCharacter)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts, mainhandBoosts, offhandBoosts)

        Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
        Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)

        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts, mainhandBoosts, offhandBoosts)
        -- proficiency
        if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).ServerTemplateTag.Tags[3]
            print("The weapon type is " .. weaponType)
            addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
        end
    end

    -- in the case of a secondary weapon
    if itemTemplate == offhandWeaponTemplate and spellActivatedOff == true then
        spellActivatedOff = false
        print("Offhand item equipped")
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariables = traceVariables:new(mainWeaponTemplate,offhandWeaponTemplate,proficiencyBoost, fakerCharacter)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts, mainhandBoosts, offhandBoosts)

        Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter))
        Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter),1,0)

        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts, mainhandBoosts, offhandBoosts)
        -- proficiency
        if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).ServerTemplateTag.Tags[3]
            addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
        end
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_MELEE" then 
        if mainWeaponTemplate ~= nil then    
            -- removing proficiency
            removeProficiencyPassive(proficiencyBoost)
            proficiencyBoost = {}

            Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
            Osi.TemplateRemoveFrom(mainWeaponTemplate, fakerCharacter, 1)
            mainWeaponTemplate = nil
            Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
            Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
        else
            local mainWeapon = GetEquippedItem(fakerCharacter, "Melee Main Weapon")
            if mainWeapon ~= nil then
                local mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
                if mainWeaponTemplate ~= nil then
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
                    Osi.TemplateRemoveFrom(mainWeaponTemplate, fakerCharacter, 1)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                end
            end
        end

        if offhandWeaponTemplate ~= nil then  
            Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter))
            Osi.TemplateRemoveFrom(offhandWeaponTemplate, fakerCharacter, 1)
            offhandWeaponTemplate = nil
            Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
            Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
        else
            local offhandWeapon = GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")
            if offhandWeapon ~= nil then
                local offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
                if offhandWeaponTemplate ~= nil then
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter))
                    Osi.TemplateRemoveFrom(mainWeaponTemplate, fakerCharacter, 1)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                end
            end
        end
        
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariables = {}

        mainWeaponTemplate = nil
        offhandWeaponTemplate = nil
        fakerCharacter = ""
    end

end)

print("Melee listeners loaded")