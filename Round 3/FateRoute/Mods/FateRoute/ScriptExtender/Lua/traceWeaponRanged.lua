-- listeners
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted ranged variables sync")
    Ext.Vars.RegisterUserVariable("traceVariablesRanged", {})

    local foundFaker = false
    for position, partymember in pairs(Osi.DB_Players:Get(nil)) do
        for _, guid in pairs(partymember) do
            local entityFake = Ext.Entity.Get(guid)
            for fakerCheckKey, fakerCheckEntry in pairs(entityFake.Classes.Classes) do
                if fakerCheckEntry.SubClassUUID == "fcbaa6ae-07d7-4134-a81d-360d23e6050f" then
                    fakerCharacterRanged = guid
                    print("Faker (ranged): " .. fakerCharacterRanged .. " detected from player database loop")
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

    local entity = Ext.Entity.Get(fakerCharacterRanged)
    local localTraceVariablesRanged = entity.Vars.traceVariablesRanged or {}

    if localTraceVariablesRanged ~= {} and localTraceVariablesRanged ~= nil and localTraceVariablesRanged ~= { } and localTraceVariablesRanged ~= "" then
        if next(localTraceVariablesRanged) ~= nil then
            for key, entry in ipairs(localTraceVariablesRanged) do
                if entry ~= nil and entry ~= {} then
                    if key == 1 then
                        mainWeaponTemplateRanged = localTraceVariablesRanged.mainWeaponTemplateRanged
                        print("mainWeaponTemplateRanged loaded")
                    elseif key == 2 then
                        offhandWeaponTemplateRanged = localTraceVariablesRanged.offhandWeaponTemplateRanged
                        print("offhandWeaponTemplateRanged loaded")
                    elseif key == 3 then
                        proficiencyBoostRanged = localTraceVariablesRanged.proficiencyBoostRanged
                        print("proficiencyBoostRanged loaded")
                    end
                end
            end
        end
    end

end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == "Target_TraceWeapon_Ranged" and HasAppliedStatus(caster,"FAKER_RANGED") == 1 then
        Osi.RemoveStatus(caster,"FAKER_RANGED")
        fakerCharacterRanged = caster
        fakerTargetRanged = target
        Osi.TimerLaunch("Faker Cooldown (Ranged)", 250)
    elseif spellName == "Target_TraceWeapon_Ranged" then
        fakerCharacterRanged = caster
        traceWeaponRanged(caster,target)
    end
end)

function traceWeaponRanged(caster,target)
    local fakerCharacterRanged = caster
    local beginningIndex, endingIndex = string.find(target, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
    targetUUID_Ranged = string.sub(target,beginningIndex,endingIndex)

    if HasRangedWeaponEquipped(targetUUID_Ranged, "Mainhand") == 0 and HasRangedWeaponEquipped(targetUUID_Ranged, "Offhand") == 0 then
        local casterEntity = Ext.Entity.Get(fakerCharacterRanged)
        casterEntity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = casterEntity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount + 1
        return nil
    end

    local targetEntity = Ext.Entity.Get(target)
    wielderStrengthRanged = targetEntity.Stats.Abilities[2]
    wielderDexterityRanged = targetEntity.Stats.Abilities[3]
    wielderMovementSpeedRanged = targetEntity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount
    wielderNameRanged = Osi.ResolveTranslatedString(targetEntity.DisplayName.NameKey.Handle.Handle)
    
    if HasRangedWeaponEquipped(targetUUID_Ranged, "Offhand") == 1 then
        print("Attempting to equip ranged offhand weapon")
        local offhandWeapon = GetEquippedItem(targetUUID_Ranged, "Ranged Offhand Weapon")
        offhandWeaponTemplateRanged = Osi.GetTemplate(offhandWeapon)
        Osi.TemplateAddTo(offhandWeaponTemplateRanged,fakerCharacterRanged,1,0) -- Gives offhand item
        wielderIconRanged = Ext.Entity.Get(Osi.GetEquippedItem(target, "Ranged Offhand Weapon")).Icon.Icon
    end
    
    if HasRangedWeaponEquipped(targetUUID_Ranged, "Mainhand") == 1 then 
        print("Attempting to equip ranged main weapon")
        local mainWeapon = GetEquippedItem(targetUUID_Ranged, "Ranged Main Weapon")
        mainWeaponTemplateRanged = Osi.GetTemplate(mainWeapon)
        Osi.TemplateAddTo(mainWeaponTemplateRanged,fakerCharacterRanged,1,0) -- Gives item
        ApplyStatus(fakerCharacterRanged,"FAKER_RANGED",15,100)
        wielderIconRanged = Ext.Entity.Get(Osi.GetEquippedItem(target, "Ranged Main Weapon")).Icon.Icon
    end
end

Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer) 
    if timer == "Faker Cooldown (Ranged)" then
        traceWeaponRanged(fakerCharacterRanged,fakerTargetRanged)
        fakerTargetRanged = nil
    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_RANGED" and dualWeaponsProjected == nil then
        proficiencyBoostRanged = {}
        if mainWeaponTemplateRanged ~= nil or offhandWeaponTemplateRanged ~= nil then
            if offhandWeaponTemplateRanged ~= nil then
                spellActivatedOffRanged = true
                Osi.Equip(fakerCharacterRanged,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacterRanged),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacterRanged), "REPRODUCTION_RANGED", 15, 100, fakerCharacterRanged)
            end
            if mainWeaponTemplateRanged ~= nil then
                spellActivatedMainRanged = true
                Osi.Equip(fakerCharacterRanged,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacterRanged),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacterRanged), "REPRODUCTION_RANGED", 15, 100, fakerCharacterRanged)
            end
            if mainWeaponTemplateRanged ~= nil or offhandWeaponTemplateRanged ~= nil then
                Osi.ApplyStatus(fakerCharacterRanged, "FAKER_RANGED_CONFIRMATION", 15, 100)
            end
        end
        if mainWeaponTemplateRanged == nil and offhandWeaponTemplateRanged == nil then
            if Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon") ~= nil then
                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacterRanged, boosts,mainhandBoosts,offhandBoosts)

                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacterRanged, boosts,mainhandBoosts,offhandBoosts)
                print("Reset cooldown of reproduced mainhand ranged weapon")

                if Osi.IsProficientWith(fakerCharacterRanged, Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")) == 0 then
                    local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).ServerTemplateTag.Tags[3]
                    print("The weapon type is " .. weaponType)
                    addProficiencyPassive(fakerCharacterRanged,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
                end

                if Osi.HasRangedWeaponEquipped(fakerCharacterRanged, "Offhand") == 1 then
                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacterRanged, boosts,mainhandBoosts,offhandBoosts)

                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacterRanged, boosts,mainhandBoosts,offhandBoosts)
                    print("Reset cooldown of reproduced offhand ranged weapon")

                    if Osi.IsProficientWith(fakerCharacterRanged, Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")) == 0 then
                        local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3]
                        addProficiencyPassive(fakerCharacterRanged,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
                    end
                end 
            end
        end
    end

    if status == "FAKER_RANGED_CONFIRMATION" then
        print("Faker confirmation done")
        -- checking if it's been traced before
        if mainWeaponTemplateRanged ~= nil and offhandWeaponTemplateRanged == nil then
            addTraceSpell(fakerCharacterRanged, {"Ranged Main Weapon", nil}, wielderStrengthRanged, wielderDexterityRanged, wielderMovementSpeedRanged, wielderIconRanged, wielderNameRanged, "Ranged", {mainWeaponTemplateRanged, nil})
        elseif mainWeaponTemplateRanged == nil and offhandWeaponTemplateRanged ~= nil then
            addTraceSpell(fakerCharacterRanged, {nil, "Ranged Offhand Weapon"}, wielderStrengthRanged, wielderDexterityRanged, wielderMovementSpeedRanged, wielderIconRanged, wielderNameRanged, "Ranged", {nil, offhandWeaponTemplateRanged})
        elseif mainWeaponTemplateRanged ~= nil and offhandWeaponTemplateRanged ~= nil then
            addTraceSpell(fakerCharacterRanged, {"Ranged Main Weapon", "Ranged Offhand Weapon"}, wielderStrengthRanged, wielderDexterityRanged, wielderMovementSpeedRanged, wielderIconRanged, wielderNameRanged, "Ranged", {mainWeaponTemplateRanged, offhandWeaponTemplateRanged})
        end
    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_RANGED" and dualWeaponsProjectedRanged == true then
        fakerCharacterRanged = object

        proficiencyBoostRanged = {}
        if mainWeaponTemplateRanged ~= nil or offhandWeaponTemplateRanged ~= nil then
            if offhandWeaponTemplateRanged ~= nil then
                if Osi.HasActiveStatus(GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacterRanged), "REPRODUCTION_RANGED") == 0 then
                    spellActivatedOffRanged = true
                    Osi.Equip(fakerCharacterRanged,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacterRanged),1,0)
                    Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacterRanged), "REPRODUCTION_RANGED", 15, 100, fakerCharacterRanged)
                end
            end
            if mainWeaponTemplateRanged ~= nil then
                if Osi.HasActiveStatus(GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacterRanged), "REPRODUCTION_RANGED") == 0 then
                    spellActivatedMainRanged = true
                    Osi.Equip(fakerCharacterRanged,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacterRanged),1,0)
                    Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacterRanged), "REPRODUCTION_RANGED", 15, 100, fakerCharacterRanged)
                end
            end
        end
        if mainWeaponTemplateRanged == nil and offhandWeaponTemplateRanged == nil then
            if Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon") ~= nil then
                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacterRanged, boosts,mainhandBoosts,offhandBoosts)

                local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.Boosts
                local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
                local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
                resetWeaponCooldowns(fakerCharacterRanged, boosts,mainhandBoosts,offhandBoosts)
                print("Reset cooldown of reproduced mainhand ranged weapon")

                if Osi.IsProficientWith(fakerCharacterRanged, Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")) == 0 then
                    local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).ServerTemplateTag.Tags[3]
                    print("The weapon type is " .. weaponType)
                    addProficiencyPassive(fakerCharacterRanged,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
                end

                if Osi.HasRangedWeaponEquipped(fakerCharacterRanged, "Offhand") == 1 then
                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacterRanged, boosts,mainhandBoosts,offhandBoosts)

                    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.Boosts
                    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
                    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
                    resetWeaponCooldowns(fakerCharacterRanged, boosts,mainhandBoosts,offhandBoosts)
                    print("Reset cooldown of reproduced offhand ranged weapon")

                    if Osi.IsProficientWith(fakerCharacterRanged, Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")) == 0 then
                        local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3]
                        addProficiencyPassive(fakerCharacterRanged,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
                    end
                end 
            end
        end

        dualWeaponsProjected = nil
    end

end)

Ext.Osiris.RegisterListener("MissedBy", 4, "after", function(defender, attackOwner, attacker, storyActionID)
    if (Osi.HasActiveStatus(attacker, "FAKER_RANGED") == 1 or Osi.HasActiveStatus(attackOwner, "FAKER_RANGED") == 1) and savingThrowTimer == nil then
        local fakerCharacterRanged = attacker or attackOwner
        print("Attacker is " .. attacker .. " and defender is " .. defender)
        if (Osi.HasActiveStatus(attacker, "REINFORCEMENT_OVERDRAW") == 1) then
            if (Osi.HasPassive(attacker, "Passive_MentalBattle") == 1) then
                Osi.RequestPassiveRoll(fakerCharacterRanged, fakerCharacterRanged,"SavingThrow", "Intelligence", "13467824-03fd-4316-a0d1-5412cb6f9b2b", 1, "Image Failure Roll (Ranged)")
            else
                Osi.RequestPassiveRoll(fakerCharacterRanged, fakerCharacterRanged,"SavingThrow", "Intelligence", "13467824-03fd-4316-a0d1-5412cb6f9b2b", 0, "Image Failure Roll (Ranged)")
            end
        else
            if (Osi.HasPassive(attacker, "Passive_MentalBattle") == 1) then
                Osi.RequestPassiveRoll(fakerCharacterRanged, fakerCharacterRanged,"SavingThrow", "Intelligence", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 1, "Image Failure Roll (Ranged)")
            else
                Osi.RequestPassiveRoll(fakerCharacterRanged, fakerCharacterRanged,"SavingThrow", "Intelligence", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 0, "Image Failure Roll (Ranged)")
            end
        end
        Osi.TimerLaunch("Fate Saving Throw Timer",250)
        savingThrowTimer = true
    end
end)

Ext.Osiris.RegisterListener("RollResult", 6, "after", function(eventName, roller, rollSubject, resultType, isActiveRoll, criticality)
    if eventName == "Image Failure Roll (Ranged)" then 
        local fakerCharacterRanged = roller
        if resultType == 0 then
            Osi.RemoveStatus(fakerCharacterRanged,"FAKER_RANGED")
        end
    end
end)

Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(itemTemplate, character)
    -- mainhand
    if itemTemplate == mainWeaponTemplateRanged and spellActivatedMainRanged == true then
        spellActivatedMainRanged = false
        print("Mainhand item equipped")
        -- keeping track of variables
        local entity = Ext.Entity.Get(fakerCharacterRanged)
        entity.Vars.traceVariablesRanged = traceVariablesRanged:new(mainWeaponTemplateRanged,offhandWeaponTemplateRanged,proficiencyBoostRanged)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacterRanged, boosts, mainhandBoosts, offhandBoosts)

        Osi.Unequip(fakerCharacterRanged,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacterRanged))
        Osi.Equip(fakerCharacterRanged,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacterRanged),1,0)

        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacterRanged, boosts, mainhandBoosts, offhandBoosts)
        -- proficiency
        if Osi.IsProficientWith(fakerCharacterRanged, Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).ServerTemplateTag.Tags[3]
            print("The weapon type is " .. weaponType)
            addProficiencyPassive(fakerCharacterRanged,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
        end
    end

    -- in the case of a secondary weapon
    if itemTemplate == offhandWeaponTemplateRanged and spellActivatedOffRanged == true and offhandWeaponTemplateRanged ~= mainWeaponTemplateRanged then
        spellActivatedOffRanged = false
        print("Offhand item equipped")
        local entity = Ext.Entity.Get(fakerCharacterRanged)
        entity.Vars.traceVariablesRanged = traceVariablesRanged:new(mainWeaponTemplateRanged,offhandWeaponTemplateRanged,proficiencyBoostRanged)
        -- resetting cooldown
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacterRanged, boosts, {}, offhandBoosts)

        Osi.Unequip(fakerCharacterRanged,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacterRanged))
        Osi.Equip(fakerCharacterRanged,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacterRanged),1,0)

        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacterRanged, boosts, {}, offhandBoosts)
        -- proficiency
        if Osi.IsProficientWith(fakerCharacterRanged, Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3]
            addProficiencyPassive(fakerCharacterRanged,Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")).ServerTemplateTag.Tags[3],proficiencyBoostRanged)
        end
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    local fakerCharacterRanged = object
    
    if status == "FAKER_RANGED" then 
        if proficiencyBoostRanged ~= nil then
            removeProficiencyPassive(proficiencyBoostRanged)
            proficiencyBoostRanged = {}
        end

        local mainWeaponRanged = GetEquippedItem(fakerCharacterRanged, "Ranged Main Weapon")
        if mainWeaponRanged ~= nil then
            local mainWeaponTemplateRanged = Osi.GetTemplate(mainWeaponRanged)
            if mainWeaponTemplateRanged ~= nil then    
                Osi.Unequip(fakerCharacterRanged,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacterRanged))
                Osi.TemplateRemoveFrom(mainWeaponTemplateRanged, fakerCharacterRanged, 1)
                print("Attempted to remove " .. mainWeaponTemplateRanged)
                Osi.SetWeaponUnsheathed(fakerCharacterRanged, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacterRanged, 1, 0)
                Osi.UnloadItem(mainWeaponTemplateRanged)
            end
        else
            if mainWeaponTemplateRanged ~= nil then
                Osi.UnloadItem(mainWeaponTemplateRanged)
            end
        end

        local offhandWeaponRanged = GetEquippedItem(fakerCharacterRanged, "Ranged Offhand Weapon")
        if offhandWeaponRanged ~= nil then
            local offhandWeaponTemplateRanged = Osi.GetTemplate(offhandWeaponRanged)
            if offhandWeaponTemplateRanged ~= nil then
                Osi.Unequip(fakerCharacterRanged,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacterRanged))
                Osi.TemplateRemoveFrom(offhandWeaponTemplateRanged, fakerCharacterRanged, 1)
                print("Attempted to remove " .. offhandWeaponTemplateRanged)
                Osi.SetWeaponUnsheathed(fakerCharacterRanged, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacterRanged, 1, 0)
                Osi.UnloadItem(offhandWeaponTemplateRanged)
            end
        else
            if offhandWeaponTemplateRanged ~= nil then
                Osi.UnloadItem(offhandWeaponTemplateRanged)
            end
        end
        
        local entity = Ext.Entity.Get(fakerCharacterRanged)
        entity.Vars.traceVariablesRanged = {}

        wielderStrengthRanged = 0
        wielderDexterityRanged = 0
        wielderMovementSpeedRanged = 0
        wielderNameRanged = ""
        offhandWeaponTemplateRanged = nil
        mainWeaponTemplateRanged = nil
    end

end)

print("Ranged listeners loaded")