-- faker character
function locateFaker()
    for position, partymember in pairs(Osi.DB_Players:Get(nil)) do
        for _, guid in pairs(partymember) do
            local entityFake = Ext.Entity.Get(guid)
            for fakerCheckKey, fakerCheckEntry in pairs(entityFake.Classes.Classes) do
                if fakerCheckEntry.SubClassUUID == "fcbaa6ae-07d7-4134-a81d-360d23e6050f" then
                    fakerCharacter = guid
                    print("Faker found to be " .. fakerCharacter)
                    return fakerCharacter
                end
            end
        end   
    end
end

-- spell cooldowns
function cooldownHelper(equipmentSlot)
    local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Use.Boosts
    local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Use.BoostsOnEquipMainHand
    local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Use.BoostsOnEquipOffHand

    if Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Value.Rarity == 1 then
        ApplyStatus(Osi.GetEquippedItem(fakerCharacter, equipmentSlot), "REPRODUCTION_UNCOMMON", -1, 100, fakerCharacter)

    elseif Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Value.Rarity == 2 then
        ApplyStatus(Osi.GetEquippedItem(fakerCharacter, equipmentSlot), "REPRODUCTION_RARE", -1, 100, fakerCharacter)

    elseif Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Value.Rarity == 3 then
        ApplyStatus(Osi.GetEquippedItem(fakerCharacter, equipmentSlot), "REPRODUCTION_VERYRARE", -1, 100, fakerCharacter)

    elseif Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Value.Rarity == 4 then
        ApplyStatus(Osi.GetEquippedItem(fakerCharacter, equipmentSlot), "REPRODUCTION_LEGENDARY", -1, 100, fakerCharacter)

    end

    resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)

    local mainWeaponTemplate = Osi.GetTemplate(Osi.GetEquippedItem(fakerCharacter, equipmentSlot))
    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
    Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)
    Ext.Timer.WaitFor(50, function()
        local boosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Use.Boosts
        local mainhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Use.BoostsOnEquipMainHand
        local offhandBoosts = Ext.Entity.Get(Osi.GetEquippedItem(fakerCharacter, equipmentSlot)).Use.BoostsOnEquipOffHand
        resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)
        
        Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
        Ext.Timer.WaitFor(50, function()
            Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)
        end)

        local meleeOrRanged = equipmentSlot:match("Melee") or equipmentSlot:match("Ranged")
        triggerOffAdd(fakerCharacter, boosts, meleeOrRanged)
    end)

    print("Reset cooldown of reproduced mainhand melee weapon")
end

function triggerOffAdd(character, boost, meleeOrRanged)
    local entity = Ext.Entity.Get(character)
    local triggerOff = {}

    for key, entry in pairs(boost) do
        if entry ~= nil then
            if meleeOrRanged == "Melee" and HasActiveStatus(character, "TRIGGEROFF_MELEE") == 1 then
                table.insert(triggerOff, "SpellId('" .. entry.Params .. "')")

            elseif meleeOrRanged == "Ranged" and HasActiveStatus(character, "TRIGGEROFF_RANGED") == 1 then
                table.insert(triggerOff, "SpellId('" .. entry.Params .. "')")

            end
        end
    end 

    
    if #triggerOff > 0 then
        triggerBoost = "UnlockSpellVariant("
        for key, entry in pairs(triggerOff) do
            if key > 1 and key ~=  #triggerOff then
                triggerBoost = triggerBoost .. " or "
            end
            triggerBoost = triggerBoost .. entry            
        end
        triggerBoost = triggerBoost .. ",ModifyUseCosts(Replace,ActionPoint,0,0,ActionPoint),ModifyIconGlow(),ModifyTooltipDescription())"
        if meleeOrRanged == "Melee" then
            print("Added melee boost: " .. triggerBoost)
            entity.Vars.meleeTriggerOff = triggerBoost
            Osi.AddBoosts(character, triggerBoost, "Trigger Off (Melee)", character)

        elseif meleeOrRanged == "Ranged" then
            print("Added ranged boost: " .. boost)
            entity.Vars.rangedTriggerOff = triggerBoost
            Osi.AddBoosts(character, triggerBoost, "Trigger Off (Ranged)", character)

        end
    end

end

function resetWeaponCooldowns(character, boost, mainhandBoost, offhandBoost)
    local entity = Ext.Entity.Get(character)
    for key, entry in pairs(boost) do
        if entry ~= nil then
            local weaponSpellData = Ext.Stats.Get(entry.Params)
            for keySpellbook, entrySpellbook in pairs(entity.SpellBookCooldowns.Cooldowns) do
                if entrySpellbook ~= nil then
                    if entrySpellbook.SpellId.OriginatorPrototype == entry.Params then
                        entity.SpellBookCooldowns.Cooldowns[keySpellbook] = {}
                        print("Reset " .. Osi.ResolveTranslatedString(weaponSpellData.DisplayName))

                        
                        -- add trigger off passive here
                        break
                    end
                end
            end
        end
    end

    for key, entry in pairs(mainhandBoost) do
        if entry ~= nil then
            local weaponSpellData = Ext.Stats.Get(entry.Params)
            for keySpellbook, entrySpellbook in pairs(entity.SpellBookCooldowns.Cooldowns) do
                if entrySpellbook ~= nil then
                    if entrySpellbook.SpellId.OriginatorPrototype == entry.Params then
                        entity.SpellBookCooldowns.Cooldowns[keySpellbook] = {}
                        print("Reset " .. Osi.ResolveTranslatedString(weaponSpellData.DisplayName))
                        break
                    end
                end
            end
        end
    end

    for key, entry in pairs(offhandBoost) do
        if entry ~= nil then
            local weaponSpellData = Ext.Stats.Get(entry.Params)
            for keySpellbook, entrySpellbook in pairs(entity.SpellBookCooldowns.Cooldowns) do
                if entrySpellbook ~= nil then
                    if entrySpellbook.SpellId.OriginatorPrototype == entry.Params then
                        entity.SpellBookCooldowns.Cooldowns[keySpellbook] = {}
                        print("Reset " .. Osi.ResolveTranslatedString(weaponSpellData.DisplayName))
                        break
                    end
                end
            end
        end
    end

    print("Reset all weapon cooldowns")
end

-- emulate wielder
function emulateWielder(character)

    local originalStats = Ext.Entity.Get(fakerCharacter).Vars.originalStats
    local meleeStats = Ext.Entity.Get(fakerCharacter).Vars.meleeStats or nil
    local rangedStats = Ext.Entity.Get(fakerCharacter).Vars.rangedStats or nil
    
    local strength = 0
    local dexterity = 0
    local movementSpeed = 0

    local strengthRanged = 0
    local dexterityRanged = 0
    local movementSpeedRanged = 0


    if meleeStats ~= nil then 
        print("Melee stats not nil")
        strength = tonumber(meleeStats[1])
        dexterity = tonumber(meleeStats[2])
        movementSpeed = tonumber(meleeStats[3])
    else
        print("Melee stats nil")
        strength = 0
        dexterity = 0
        movementSpeed = 0
    end

    if rangedStats ~= nil then 
        print("Ranged stats not nil")
        strengthRanged = tonumber(rangedStats[1])
        dexterityRanged = tonumber(rangedStats[2])
        movementSpeedRanged = tonumber(rangedStats[3])
    else
        print("Ranged stats nil")
        strengthRanged = 0
        dexterityRanged = 0
        movementSpeedRanged = 0
    end

    local strengthIncrease = 0;
    local dexterityIncrease = 0;
    local movementSpeedIncrease = 0;


    if type(strength) ~= "number" then
        print("Replaced strengh: " .. strength .. " with 0.")
        local strength = 0
    end
    if type(dexterity) ~= "number" then
        print("Replaced dexterity: " .. dexterity .. " with 0.")
        local dexterity = 0
    end
    if type(movementSpeed) ~= "number" then
        print("Replaced movementSpeed: " .. movementSpeed .. " with 0.")
        local strength = 0
    end
    if type(strengthRanged) ~= "number" then
        print("Replaced strengthRanged: " .. strengthRanged .. " with 0.")
        local strength = 0
    end
    if type(dexterityRanged) ~= "number" then
        print("Replaced dexterityRanged: " .. dexterityRanged .. " with 0.")
        local strength = 0
    end
    if type(movementSpeedRanged) ~= "number" then
        print("Replaced movementSpeedRanged: " .. movementSpeedRanged .. " with 0.")
        local strength = 0
    end


    if strength < strengthRanged then
        strength = strengthRanged
    end
    if dexterity < dexterityRanged then
        dexterity = dexterityRanged
    end
    if movementSpeed < movementSpeedRanged then
        movementSpeed = movementSpeedRanged
    end

    if strength > originalStats[1] then
        strengthIncrease = strength - originalStats[1];
    end
    if dexterity > originalStats[2] then
        dexterityIncrease = dexterity - originalStats[2]
    end
    if movementSpeed > originalStats[3] then
        movementSpeedIncrease = movementSpeed - originalStats[3]
    end

    emulateBoost = Ext.Entity.Get(fakerCharacter).Vars.emulateBoostVar or ""
    if type(emulateBoost) ~= string then
        emulateBoost = ""
    end
    Osi.RemoveBoosts(character, emulateBoost, 1, "Emulate Wielder", "")
    emulateBoost = "Ability(Strength," .. strengthIncrease .. "); Ability(Dexterity," .. dexterityIncrease .. "); ActionResource(Movement," .. movementSpeedIncrease .. ",0)"
    Ext.Entity.Get(fakerCharacter).Vars.emulateBoostVar = emulateBoost
    print("emulateboost is: " .. emulateBoost)
    Ext.Timer.WaitFor(250,function()
        Osi.AddBoosts(fakerCharacter, emulateBoost, "Emulate Wielder", "")
    end)
end

function emulateWielderChange(character, meleeOrRanged)
    
    if meleeOrRanged == "Melee" then
        if HasActiveStatus(Osi.GetEquippedWeapon(character), "REPRODUCTION_MELEE") == 0 then
            print("Reproduced melee weapon not equipped, detoggling Emulate Wielder")
            Osi.TogglePassive(character, "Passive_EmulateWielder_Toggle")
            return
        end
    else
        if HasActiveStatus(Osi.GetEquippedWeapon(character), "REPRODUCTION_RANGED") == 0 then
            print("Reproduced ranged weapon not equipped, detoggling Emulate Wielder")
            Osi.TogglePassive(character, "Passive_EmulateWielder_Toggle")
            return
        end
    end

    local originalStats = Ext.Entity.Get(fakerCharacter).Vars.originalStats
    local meleeStats = Ext.Entity.Get(fakerCharacter).Vars.meleeStats or nil
    local rangedStats = Ext.Entity.Get(fakerCharacter).Vars.rangedStats or nil
    
    local strength = 0
    local dexterity = 0
    local movementSpeed = 0

    local strengthRanged = 0
    local dexterityRanged = 0
    local movementSpeedRanged = 0


    if meleeStats ~= nil then 
        print("Melee stats not nil")
        strength = tonumber(meleeStats[1])
        dexterity = tonumber(meleeStats[2])
        movementSpeed = tonumber(meleeStats[3])
    else
        print("Melee stats nil")
        strength = 0
        dexterity = 0
        movementSpeed = 0
    end

    if rangedStats ~= nil then 
        print("Ranged stats not nil")
        strengthRanged = tonumber(rangedStats[1])
        dexterityRanged = tonumber(rangedStats[2])
        movementSpeedRanged = tonumber(rangedStats[3])
    else
        print("Ranged stats nil")
        strengthRanged = 0
        dexterityRanged = 0
        movementSpeedRanged = 0
    end


    if type(strength) ~= "number" then
        print("Replaced strengh: " .. strength .. " with 0.")
        local strength = 0
    end
    if type(dexterity) ~= "number" then
        print("Replaced dexterity: " .. dexterity .. " with 0.")
        local dexterity = 0
    end
    if type(movementSpeed) ~= "number" then
        print("Replaced movementSpeed: " .. movementSpeed .. " with 0.")
        local strength = 0
    end
    if type(strengthRanged) ~= "number" then
        print("Replaced strengthRanged: " .. strengthRanged .. " with 0.")
        local strength = 0
    end
    if type(dexterityRanged) ~= "number" then
        print("Replaced dexterityRanged: " .. dexterityRanged .. " with 0.")
        local strength = 0
    end
    if type(movementSpeedRanged) ~= "number" then
        print("Replaced movementSpeedRanged: " .. movementSpeedRanged .. " with 0.")
        local strength = 0
    end


    if meleeOrRanged == "Ranged" then
        strength = strengthRanged
        dexterity = dexterityRanged
        movementSpeed = movementSpeedRanged
    end

    if strength > originalStats[1] then
        strengthIncrease = strength - originalStats[1];
    end
    if dexterity > originalStats[2] then
        dexterityIncrease = dexterity - originalStats[2]
    end
    if movementSpeed > originalStats[3] then
        movementSpeedIncrease = movementSpeed - originalStats[3]
    end

    emulateBoost = Ext.Entity.Get(fakerCharacter).Vars.emulateBoostVar or ""
    if type(emulateBoost) ~= string then
        emulateBoost = ""
    end
    Osi.RemoveBoosts(character, emulateBoost, 1, "Emulate Wielder", "")
    emulateBoost = "Ability(Strength," .. strengthIncrease .. "); Ability(Dexterity," .. dexterityIncrease .. "); ActionResource(Movement," .. movementSpeedIncrease .. ",0)"
    Ext.Entity.Get(fakerCharacter).Vars.emulateBoostVar = emulateBoost
    print("emulateboost is: " .. emulateBoost)
    Ext.Timer.WaitFor(250,function()
        Osi.AddBoosts(fakerCharacter, emulateBoost, "Emulate Wielder", "")
    end)
end


-- Alteration Arrow / UBW
function spawnClone(target, isBrokenPhantasm, alterationArrow, UBW)
    -- local x, y, z = Osi.GetPosition(target)
    if target ~= nil then
        print("Trying to make clone at " .. target)
        local copiedChar = Osi.CreateOutOfSightAtDirectionFromObject(Osi.GetTemplate(fakerCharacter), fakerCharacter, fakerCharacter, 1, 0, "UBW")
        print("Clone successful")
        -- local copiedChar = Osi.CreateAtObject(Osi.GetTemplate(fakerCharacter), target, 1, 1, "UBW", 1)
        -- print(copiedChar)

        Ext.Timer.WaitFor(200, function()
            -- local copyEntity = Ext.Entity.Get(copiedChar)
            -- Ext.Entity.Get(copiedChar).LevelUp.LevelUps = Ext.Entity.Get(fakerCharacter).LevelUp.LevelUps
            -- for key, class in pairs(Ext.Entity.Get(fakerCharacter).Classes.Classes) do -- classes
            --     copyEntity.Classes.Classes[key] = class
            -- end
            Osi.SetLevel(copiedChar, Osi.GetLevel(fakerCharacter))
            Osi.SetImmortal(copiedChar, 1)
            Osi.ApplyStatus(copiedChar, "INVULNERABLE", -1, 100)
            Osi.SetStoryDisplayName(copiedChar, tostring(Ext.Entity.Get(fakerCharacter).ServerDisplayNameList.Names[2].Name))
            Osi.SetCharacterOnPortraitPainting(copiedChar, fakerCharacter)

            -- for key, entry in pairs(Ext.Entity.Get(fakerCharacter).StatusContainer.Statuses) do
            --     if Osi.HasActiveStatus(copiedChar, entry) == 0 and entry ~= "FAKER_MELEE" and entry ~= "FAKER_RANGED" and entry ~= "STRUCTURAL_GRASP" then
            --         Osi.ApplyStatus(copiedChar, entry, 15, -1, copiedChar)
            --     end

            -- end

            Osi.CopyCharacterEquipment(copiedChar, fakerCharacter)
            -- local slots = {"Amulet", "Boots", "Breast", "Cloak", "Gloves", "Helmet", "Ring", "Ring2"}
            -- for key, slot in pairs(slots) do
            --     if Osi.GetEquippedItem(fakerCharacter, slot) ~= nil then
            --         Osi.TemplateAddTo(Osi.GetTemplate(Osi.GetEquippedItem(fakerCharacter, slot)), copiedChar, 1, 0)
            --         Ext.Timer.WaitFor(100, function()
            --             Osi.Equip(copiedChar, Osi.GetTemplate(Osi.GetEquippedItem(fakerCharacter, slot)), 1, 0, 1)
            --             print("Equipped " .. Osi.GetTemplate(Osi.GetEquippedItem(fakerCharacter, slot)) .. " on clone")
            --         end)
            --     end

            -- end

            local slots = {"Melee Offhand Weapon", "Melee Main Weapon", "Ranged Offhand Weapon", "Ranged Main Weapon"}
            for key, slot in pairs(slots) do
                if Osi.GetEquippedItem(copiedChar, slot) ~= nil then
                    Osi.Unequip(copiedChar, Osi.GetEquippedItem(copiedChar, slot))
                end

            end

            local meleeWeaponTracker = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker
            meleeWeaponTracker = meleeWeaponTracker or {}
            Ext.Timer.WaitFor(50, function()
                Osi.AddBoosts(copiedChar, "Invisibility()", "Apply Weapon Functors - Arrow", copiedChar)
                Osi.SetVisible(copiedChar, 0)
                if #meleeWeaponTracker == 2 then
                    local mainWeapon = Osi.GetTemplate(meleeWeaponTracker[1])
                    local offWeapon = Osi.GetTemplate(meleeWeaponTracker[2])

                    Osi.TemplateAddTo(mainWeapon,copiedChar,1,0)
                    Osi.TemplateAddTo(offWeapon,copiedChar,1,0)

                    Ext.Timer.WaitFor(200, function()
                        Osi.Equip(copiedChar, GetItemByTemplateInInventory(mainWeapon,copiedChar),1,0)
                        Osi.Equip(copiedChar, GetItemByTemplateInInventory(offWeapon,copiedChar),1,0)
                        print("Equipped " .. mainWeapon .. " and " .. offWeapon)
                        if alterationArrow == true then
                            performFunctor(copiedChar,target,isBrokenPhantasm)
                        elseif UBW == true then
                            Ext.TImer.WaitFor(1000, function()
                                TeleportTo(copiedChar, fakerCharacter)
                            end)
                        end
                    end)
                elseif #meleeWeaponTracker == 1 then
                    local mainWeapon = Osi.GetTemplate(meleeWeaponTracker[1])

                    Osi.TemplateAddTo(mainWeapon,copiedChar,1,0)

                    Ext.Timer.WaitFor(200, function()
                        Osi.Equip(copiedChar, GetItemByTemplateInInventory(mainWeapon,copiedChar),1,0)
                        print("Equipped " .. mainWeapon)
                        if alterationArrow == true then
                            performFunctor(copiedChar,target,isBrokenPhantasm)
                        elseif UBW == true then
                            Ext.TImer.WaitFor(1000, function()
                                TeleportTo(copiedChar, fakerCharacter)
                            end)
                        end
                    end)
                end
            end)

            print("Returning " .. copiedChar)
            return copiedChar
        end)

    end

end

function performFunctor(copiedChar, target, isBrokenPhantasm)
    -- Ext.Timer.WaitFor(100, function()
        print("Performing functor")
        -- Ext.Timer.WaitFor(50, function()
            -- Osi.TeleportTo(copiedChar, target)
            -- Osi.AppearOutOfSightTo(copiedChar, target, fakerCharacter, 0, 0)
            -- Ext.Timer.WaitFor(100, function()
                print("Using Spell")
                Osi.UseSpell(copiedChar, "Target_Alteration_Arrow_ApplyWeaponFunctor", target,target,1)
                print("Explode deletion true")
                if isBrokenPhantasm == true then
                    Osi.CreateProjectileStrikeAt(target, "Projectile_BrokenPhantasm_Explosion")
                    Osi.CreateProjectileStrikeAt(target, "Projectile_BrokenPhantasm_Explosion_2")
                end
                Ext.Timer.WaitFor(550, function()
                    -- Osi.TeleportToPosition(copiedChar, 1, 1, 1)
                    -- Ext.Timer.WaitFor(3500, function()
                        Osi.RequestDeleteTemporary(copiedChar)
                        print("Attempted to delete copychar")
                        Osi.RequestDeleteTemporary(copiedChar)
                        -- throwTarget = nil

                        if isBrokenPhantasm == true then
                            Osi.RemoveStatus(fakerCharacter, "FAKER_MELEE", fakerCharacter)
                        end
                    -- end)
                end)
            -- end)
        -- end)
    -- end)
end

print("Functions loaded")