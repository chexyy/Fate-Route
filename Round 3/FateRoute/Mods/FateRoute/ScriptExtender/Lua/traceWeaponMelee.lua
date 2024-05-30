-- classes / objects
traceObject = {}
traceObject.__index = traceObject

function traceObject:new(DisplayName, Icon, weaponUUID, UseCosts, wielderStrength, wielderDexterity, wielderMovementSpeed)
    local instance = setmetatable({}, traceObject)
    instance.DisplayName = DisplayName
    instance.Icon = Icon
    instance.weaponUUID = weaponUUID
    instance.UseCosts = UseCosts
    instance.wielderStrength = wielderStrength
    instance.wielderDexterity = wielderDexterity
    instance.wielderMovementSpeed = wielderMovementSpeed
    return instance
end

traceVariables = {}
traceVariables.__index = traceVariables

function traceVariables:new(mainWeaponTemplate, offhandWeaponTemplate, proficiencyBoost, fakerCharacter)
    local instance = setmetatable({}, traceVariables)
    instance.mainWeaponTemplate = mainWeaponTemplate
    instance.offhandWeaponTemplate = offhandWeaponTemplate
    instance.proficiencyBoost = proficiencyBoost
    instance.fakerCharacter = fakerCharacter
    return instance
end

-- listeners
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted melee baseSpell sync")
    Ext.Vars.RegisterUserVariable("traceTable", {})
    Ext.Vars.RegisterUserVariable("traceVariables", {})
    local entity = Ext.Entity.Get(GetHostCharacter())
    local localTraceTable = entity.Vars.traceTable or {}
    local localTraceVariables = entity.Vars.traceVariables or {}
    
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
                    observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER_MELEE,100,2);AI_IGNORE:SummonInInventory(" .. entry.weaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
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
                    if observedTraceTemplate.Icon == entry.Icon or observedTraceTemplate.DisplayName == entry.DisplayName then
                        print("Broke at index #" .. i)
                        break
                    elseif observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                        -- copying over stats
                        observedTraceTemplate:SetRawAttribute("DisplayName", entry.DisplayName)
                        observedTraceTemplate.Icon = entry.Icon
                        observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER_MELEE,100,2);AI_IGNORE:SummonInInventory(" .. entry.weaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
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
        local targetEntity = Ext.Entity.Get(target)
        wielderStrength = targetEntity.Stats.Abilities[2]
        wielderDexterity = targetEntity.Stats.Abilities[3]
        wielderMovementSpeed = targetEntity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount
        
        if GetEquippedItem(targetUUID, "Melee Offhand Weapon") ~= nil then
            print("Attempting to equip main weapon")
            local offhandWeapon = GetEquippedItem(targetUUID, "Melee Offhand Weapon")
            offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
            Osi.TemplateAddTo(offhandWeaponTemplate,fakerCharacter,1,0) -- Gives offhand item
        end
        
        local mainWeapon = GetEquippedItem(targetUUID, "Melee Main Weapon")

        if mainWeapon ~= nil then 
            mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
            Osi.TemplateAddTo(mainWeaponTemplate,fakerCharacter,1,0) -- Gives item
            ApplyStatus(fakerCharacter,"FAKER_MELEE",15,100)
        else
            local casterEntity = Ext.Entity.Get(fakerCharacter)
            casterEntity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = caster.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount + 1
        end
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_MELEE" then
        fakerCharacter = object
        proficiencyBoost = {}
        if mainWeaponTemplate ~= nil or offhandWeaponTemplate ~= nil then
            if mainWeaponTemplate ~= nil then
                spellActivatedMain = true
                traceCheckMain = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter), "REPRODUCTION", 15, 100)
            end
            if offhandWeaponTemplate ~= nil then
                spellActivatedOff = true
                traceCheckOff = true
                Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter),1,0)
                Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter), "REPRODUCTION", 15, 100)
            end
            if mainWeaponTemplate ~= nil and offhandWeaponTemplate ~= nil then
                -- checking if it's been traced before
                    addTraceSpell(fakerCharacter, "Melee Mainhand Weapon", wielderStrength, wielderDexterity, wielderMovementSpeed)
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

                if GetEquippedItem(targetUUID, "Melee Offhand Weapon") ~= nil then
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
        -- checking if it's been traced before
        addTraceSpell(fakerCharacter, "Melee Main Weapon", wielderStrength, wielderDexterity, wielderMovementSpeed, false)
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
        -- checking if it's been traced before
        addTraceSpell(fakerCharacter, "Melee Offhand Weapon", wielderStrength, wielderDexterity, wielderMovementSpeed)
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

    wielderStrength = nil
    wielderDexterity = nil 
    wielderMovementSpeed = nil

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
                    print(fakerCharacter)
                    Osi.TemplateRemoveFrom(mainWeaponTemplate, fakerCharacter, 1)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                end
            end
        end
        
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariables = {}

        fakerCharacter = ""
    end

end)

print("Melee listeners loaded")