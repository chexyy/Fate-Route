-- listeners
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted melee variables sync")
    Ext.Vars.RegisterUserVariable("traceVariables", {})

    local foundFaker = false
    for position, partymember in pairs(Osi.DB_Players:Get(nil)) do
        for _, guid in pairs(partymember) do
            local entityFake = Ext.Entity.Get(guid)
            for fakerCheckKey, fakerCheckEntry in pairs(entityFake.Classes.Classes) do
                if fakerCheckEntry.SubClassUUID == "fcbaa6ae-07d7-4134-a81d-360d23e6050f" then
                    fakerCharacter = guid
                    print("Faker (melee): " .. fakerCharacter .. " detected from player database loop")
                    foundFaker = true
                    break
                end
            end

            if foundFaker == true then
                break
            end
        end

        if foundFaker == true then
            break
        end    
    end

    local entity = Ext.Entity.Get(fakerCharacter)
    local localTraceVariables = entity.Vars.traceVariables or {}

    if localTraceVariables ~= {} and localTraceVariables ~= nil and localTraceVariable ~= { } and localTraceVariable ~= "" then
        if next(localTraceVariables) ~= nil then
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
                    end
                end
            end
        end
    end 
    
end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == "Target_TraceWeapon_Melee" and HasAppliedStatus(caster,"FAKER_MELEE") == 1 then
        Osi.RemoveStatus(caster,"FAKER_MELEE")
        fakerCharacter = caster
        fakerTarget = target
        Osi.TimerLaunch("Faker Cooldown (Melee)", 250)
    elseif spellName == "Target_TraceWeapon_Melee" then
        fakerCharacter = caster
        traceWeaponMelee(caster,target)
    end
end)

function traceWeaponMelee(caster,target)
    fakerCharacter = caster
    local beginningIndex, endingIndex = string.find(target, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
    targetUUID_Melee = string.sub(target,beginningIndex,endingIndex)

    if HasMeleeWeaponEquipped(targetUUID_Melee, "Mainhand") == 0 and HasMeleeWeaponEquipped(targetUUID_Melee, "Offhand") == 0 then
        local casterEntity = Ext.Entity.Get(fakerCharacter)
        casterEntity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = casterEntity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount + 1
        return nil
    end

    local targetEntity = Ext.Entity.Get(target)
    wielderStrength = targetEntity.Stats.Abilities[2]
    wielderDexterity = targetEntity.Stats.Abilities[3]
    wielderMovementSpeed = targetEntity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount
    wielderName = Osi.ResolveTranslatedString(targetEntity.DisplayName.NameKey.Handle.Handle)
    
    if HasMeleeWeaponEquipped(targetUUID_Melee, "Offhand") == 1 or (GetEquippedShield(targetUUID_Melee) ~= "NULL_00000000-0000-0000-0000-000000000000" and GetEquippedShield(targetUUID_Melee) ~= nil) then
        print("Attempting to equip melee offhand weapon")
        local offhandWeapon = GetEquippedItem(targetUUID_Melee, "Melee Offhand Weapon")
        offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
        Osi.TemplateAddTo(offhandWeaponTemplate,fakerCharacter,1,0) -- Gives offhand item
        wielderIcon = Ext.Entity.Get(Osi.GetEquippedItem(target, "Melee Offhand Weapon")).Icon.Icon
    end
    
    if HasMeleeWeaponEquipped(targetUUID_Melee, "Mainhand") == 1 then 
        print("Attempting to equip melee main weapon")
        local mainWeapon = GetEquippedItem(targetUUID_Melee, "Melee Main Weapon")
        mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
        Osi.TemplateAddTo(mainWeaponTemplate,fakerCharacter,1,0) -- Gives item
        ApplyStatus(fakerCharacter,"FAKER_MELEE",15,100)
        wielderIcon = Ext.Entity.Get(Osi.GetEquippedItem(target, "Melee Main Weapon")).Icon.Icon
    end
end

Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer) 
    if timer == "Faker Cooldown (Melee)" then
        traceWeaponMelee(fakerCharacter,fakerTarget)
        fakerTarget = nil
    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_MELEE" and dualWeaponsProjected == nil then
        if Osi.GetLevel(fakerCharacter) >= 6 and HasPassive(fakerCharacter,"Passive_EmulateWielder_Toggle") == 0 then -- ➤ need a way to differentiate active weapon
            AddPassive(fakerCharacter,"Passive_EmulateWielder_Toggle")
        end
        if Osi.HasActiveStatus(fakerCharacter, "EMULATE_WIELDER_SELFDAMAGE") == 1 then
            emulateWielder(fakerCharacter, originalStats) 
        end

        proficiencyBoost = {}
        if mainWeaponTemplate ~= nil or offhandWeaponTemplate ~= nil then
            if mainWeaponTemplate ~= nil then
                spellActivatedMain = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter), "REPRODUCTION_MELEE", 15, 100, fakerCharacter)
            end
            if offhandWeaponTemplate ~= nil and Osi.HasActiveStatus(GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter), "REPRODUCTION_MELEE") == 0  then
                spellActivatedOff = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter), "REPRODUCTION_MELEE", 15, 100, fakerCharacter)
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

                local mainWeaponTemplate = Osi.GetTemplate(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon"))
                Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)

                print("Reset cooldown of reproduced mainhand melee weapon")

                if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")) == 0 then
                    local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).ServerTemplateTag.Tags[3]
                    print("The weapon type is " .. weaponType)
                    addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
                end

                if Osi.HasMeleeWeaponEquipped(fakerCharacter, "Offhand") == 1 then
                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacter, boosts,{},offhandBoosts)

                    local offhandWeaponTemplate = Osi.GetTemplate(Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon"))
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
                    Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)

                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacter, boosts,{},offhandBoosts)
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
    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_MELEE" and dualWeaponsProjected == true then
        if Osi.GetLevel(fakerCharacter) >= 6 and HasPassive(fakerCharacter,"Passive_EmulateWielder_Toggle") == 0 then -- ➤ need a way to differentiate active weapon
            AddPassive(fakerCharacter,"Passive_EmulateWielder_Toggle")
        end
        if Osi.HasActiveStatus(fakerCharacter, "EMULATE_WIELDER_SELFDAMAGE") == 1 then
            emulateWielder(fakerCharacter, originalStats) 
        end

        fakerCharacter = object

        proficiencyBoost = {}
        if mainWeaponTemplate ~= nil or offhandWeaponTemplate ~= nil then
            if mainWeaponTemplate ~= nil and Osi.HasActiveStatus(GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter), "REPRODUCTION_MELEE") == 0 then
                spellActivatedMain = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter), "REPRODUCTION_MELEE", 15, 100, fakerCharacter)
            end
            if offhandWeaponTemplate ~= nil and Osi.HasActiveStatus(GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter), "REPRODUCTION_MELEE") == 0 then
                spellActivatedOff = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter), "REPRODUCTION_MELEE", 15, 100, fakerCharacter)
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

                if Osi.HasMeleeWeaponEquipped(targetUUID_Melee, "Offhand") == 1 then
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
    if (Osi.HasActiveStatus(attacker, "FAKER_MELEE") == 1 or Osi.HasActiveStatus(attackOwner, "FAKER_MELEE") == 1) and savingThrowTimer == nil then
        local fakerCharacter = attacker or attackOwner
        print("Attacker is " .. attacker .. " and defender is " .. defender)
        if (Osi.HasActiveStatus(attacker, "REINFORCEMENT_OVEREDGE") == 1) then
            Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Constitution", "13467824-03fd-4316-a0d1-5412cb6f9b2b", 0, "Image Failure Roll (Melee)")
        else
            Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Constitution", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 0, "Image Failure Roll (Melee)")
        end
        Osi.TimerLaunch("Fate Saving Throw Timer",250)
        savingThrowTimer = true
    end
end)

Ext.Osiris.RegisterListener("RollResult", 6, "after", function(eventName, roller, rollSubject, resultType, isActiveRoll, criticality)
    if eventName == "Image Failure Roll (Melee)" then 
        local fakerCharacter = roller
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
        entity.Vars.traceVariables = traceVariables:new(mainWeaponTemplate,offhandWeaponTemplate,proficiencyBoost)
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
    if itemTemplate == offhandWeaponTemplate and spellActivatedOff == true and offhandWeaponTemplate ~= mainWeaponTemplate then
        spellActivatedOff = false
        print("Offhand item equipped")
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariables = traceVariables:new(mainWeaponTemplate,offhandWeaponTemplate,proficiencyBoost)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts, {}, offhandBoosts)

        Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter))
        Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter),1,0)

        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts, {}, offhandBoosts)
        -- proficiency
        if Osi.IsProficientWith(fakerCharacter, Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).ServerTemplateTag.Tags[3]
            addProficiencyPassive(fakerCharacter,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoost)
        end
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    local fakerCharacter = object
    
    if status == "FAKER_MELEE" then
        if Osi.HasActiveStatus(fakerCharacter, "FAKER_RANGED") == 0 and Osi.HasPassive(fakerCharacter, "Passive_EmulateWielder_Toggle") == 1 then
            if HasAppliedStatus(fakerCharacter,"EMULATE_WIELDER_SELFDAMAGE") == 1 then
                Osi.TogglePassive(fakerCharacter, "Passive_EmulateWielder_Toggle")
            end
            Osi.RemovePassive(fakerCharacter, "Passive_EmulateWielder_Toggle")
            Osi.RemoveStatus(fakerCharacter, "EMULATE_WIELDER_CHECK")
            emulateWielderCheck = nil
        end

        if proficiencyBoost ~= nil then
            removeProficiencyPassive(proficiencyBoost)
            proficiencyBoost = {}
        end

        local mainWeapon = GetEquippedItem(fakerCharacter, "Melee Main Weapon")
        if mainWeapon ~= nil then
            local mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
            if mainWeaponTemplate ~= nil then
                Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
                Osi.TemplateRemoveFrom(mainWeaponTemplate, fakerCharacter, 1)
                print("Attempted to remove " .. mainWeaponTemplate)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
            end
        end

        local offhandWeapon = GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")
        if offhandWeapon ~= nil then
            local offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
            if offhandWeaponTemplate ~= nil then
                Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter))
                Osi.TemplateRemoveFrom(offhandWeaponTemplate, fakerCharacter, 1)
                print("Attempted to remove " .. offhandWeaponTemplate)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
            end
        end
        
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariables = {}

        wielderStrength = 0
        wielderDexterity = 0
        wielderMovementSpeed = 0
        wielderName = ""
        offhandWeaponTemplate = nil
        mainWeaponTemplate = nil
    end

end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "before", function(caster, target, spellName, spellType, spellElement, storyActionID) 
    if spellName == "Throw_Alteration_Arrow" then
        if HasMeleeWeaponEquipped(caster, "Mainhand") == 1 then
            mainWeaponTemplateArrow = GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")
        end
        if HasMeleeWeaponEquipped(caster, "Offhand") == 1 then
            offhandWeaponTemplateArrow = GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")
        end
        print("Detected alteration arrow used")
        Osi.TimerLaunch("Alteration Arrow", 4000)
    end
end)

Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer)
    if timer == "Alteration Arrow" then
        if mainWeaponTemplateArrow ~= nil then
            Osi.UnloadItem(mainWeaponTemplateArrow)
            mainWeaponTemplateArrow = nil
            print("Main weapon attempted to be deleted from alteration arrow")
        end
        if offhandWeaponTemplateArrow ~= nil then
            Osi.UnloadItem(offhandWeaponTemplateArrow)
            offhandWeaponTemplateArrow = nil
            print("Offhand weapon attempted to be deleted from alteration arrow")
        end
        if HasMeleeWeaponEquipped(fakerCharacter, "Mainhand") == 0 then
            Osi.RemoveStatus(fakerCharacter,"FAKER_MELEE")
        end

        print("Shot weapon attempted to be deleted end")
    end

end)

print("Melee listeners loaded")