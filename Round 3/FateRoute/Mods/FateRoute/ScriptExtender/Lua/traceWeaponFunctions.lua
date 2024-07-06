-- faker character
function locateFaker()
    for position, partymember in pairs(Osi.DB_Players:Get(nil)) do
        for _, guid in pairs(partymember) do
            local entityFake = Ext.Entity.Get(guid)
            for fakerCheckKey, fakerCheckEntry in pairs(entityFake.Classes.Classes) do
                if fakerCheckEntry.SubClassUUID == "fcbaa6ae-07d7-4134-a81d-360d23e6050f" then
                    fakerCharacter = guid
                    print("Faker (general listener) found to be " .. fakerCharacter)
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
    resetWeaponCooldowns(fakerCharacter, boosts,mainhandBoosts,offhandBoosts)

    local mainWeaponTemplate = Osi.GetTemplate(Osi.GetEquippedItem(fakerCharacter, equipmentSlot))
    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
    Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)
    print("Reset cooldown of reproduced mainhand melee weapon")
end

function resetWeaponCooldowns(character, boost, mainhandBoost, offhandBoost, offhandBoolean)
    local entity = Ext.Entity.Get(character)
    for key, entry in pairs(boost) do
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
function emulateWielder(character, originalStats)
    
    local strength = tonumber(wielderStrength) or 0
    local dexterity = tonumber(wielderDexterity) or 0
    local movementSpeed = tonumber(wielderMovementSpeed) or 0

    local strengthRanged = tonumber(wielderStrengthRanged) or 0
    local dexterityRanged = tonumber(wielderDexterityRanged) or 0
    local movementSpeedRanged = tonumber(wielderMovementSpeedRanged) or 0

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

    emulateBoost = emulateBoost or ""
    Osi.RemoveBoosts(character, emulateBoost, 1, "Emulate Wielder", "")
    emulateBoost = "Ability(Strength," .. strengthIncrease .. "); Ability(Dexterity," .. dexterityIncrease .. "); ActionResource(Movement," .. movementSpeedIncrease .. ",0)"
    emulateWielderOwner = character
    Osi.TimerLaunch("Emulate Wielder Timer", 125)
end

print("Functions loaded")