function addTraceSpell(character, weaponSlot)
    local entity = Ext.Entity.Get(character)
    local localTraceTable = entity.Vars.traceTable or {}
    local foundWeapon = 0
    for key, entry in ipairs(localTraceTable) do
        if localTraceTable ~= {} then
            local offhandWeapon = Osi.GetEquippedItem(GetHostCharacter(), weaponSlot)
            if entry.DisplayName == Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot)).DisplayName.NameKey.Handle.Handle then
                foundWeapon = 1
                break
            end
        end 
    end
        
    for i = 1,999, 1 do
        if foundWeapon == 0 then
            local offhandWeapon = Osi.GetEquippedItem(GetHostCharacter(), weaponSlot)
            local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
            if observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                
                local offhandWeaponUUID = Ext.Entity.Get(offhandWeapon).ServerItem.Template.Id
                observedTraceTemplate:SetRawAttribute("DisplayName", Ext.Entity.Get(offhandWeapon).DisplayName.NameKey.Handle.Handle)
                observedTraceTemplate.Icon = Ext.Entity.Get(offhandWeapon).ServerIconList.Icons[1].Icon
                observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER,100,2);AI_IGNORE:SummonInInventory(" .. offhandWeaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")

                -- sets use cost based on rarity
                if Ext.Entity.Get(offhandWeapon).Value.Rarity == 0 then
                    observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:1"
                elseif Ext.Entity.Get(offhandWeapon).Value.Rarity == 1 then
                    observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:2"
                elseif Ext.Entity.Get(offhandWeapon).Value.Rarity == 2 then
                    observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:3"
                elseif Ext.Entity.Get(offhandWeapon).Value.Rarity == 3 then
                    observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:4"
                elseif Ext.Entity.Get(offhandWeapon).Value.Rarity == 4 then
                    observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:5"
                else
                    observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:2"
                end
            
                -- adding to spell
                local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")
                local containerList = baseSpell.ContainerSpells
                containerList = containerList .. ";Shout_TraceWeapon_Template" .. i

                observedTraceTemplate:Sync()       
                baseSpell.ContainerSpells = containerList
                baseSpell:Sync()

                table.insert(localTraceTable,traceObject:new(observedTraceTemplate.DisplayName, observedTraceTemplate.Icon, offhandWeaponUUID, observedTraceTemplate.UseCosts))
                entity.Vars.traceTable = localTraceTable
                print("This sync produced a spell for " .. Osi.ResolveTranslatedString(observedTraceTemplate.DisplayName) .. " for template spell #" .. i) 

                break
            end
        end
    end
end

-- spell cooldowns
function resetCooldownOne(character, weaponSlot)
    if weaponSlot == "Melee Main Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.Boosts
    elseif weaponSlot == "Melee Offhand Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.Boosts
    end
    print("Boosts is")
    _D(weaponSpells)
    local boostsCooldown = {}
    if weaponSpells ~= nil then
        for key, entry in pairs(weaponSpells) do
            if entry ~= nil then
                local weaponSpellData = Ext.Stats.Get(entry.Params)
                table.insert(boostsCooldown,weaponSpellData.Cooldown)
                weaponSpellData.Cooldown = "None"
                weaponSpellData:Sync()
                Osi.RemoveSpell(character, entry.Params)
                Osi.AddSpell(character, entry.Params,0,0)
            end
        end
    end

    if weaponSlot == "Melee Main Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.BoostsOnEquipMainHand
    elseif weaponSlot == "Melee Offhand Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.BoostsOnEquipMainHand
    end
    print("BoostsOnEquipMainHand is")
    _D(weaponSpells)
    local boostsOnEquipMainHandCooldown = {}
    if weaponSpells ~= nil then
        for key, entry in pairs(weaponSpells) do
            if entry ~= nil then
                local weaponSpellData = Ext.Stats.Get(entry.Params)
                table.insert(boostsOnEquipMainHandCooldown,weaponSpellData.Cooldown)
                weaponSpellData.Cooldown = "None"
                weaponSpellData:Sync()
                Osi.RemoveSpell(character, entry.Params)
                Osi.AddSpell(character, entry.Params,0,0)
            end
        end
    end

    if weaponSlot == "Melee Main Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.BoostsOnEquipOffHand
    elseif weaponSlot == "Melee Offhand Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.BoostsOnEquipOffHand
    end
    print("BoostsOnEquipOffHand is")
    _D(weaponSpells)
    local boostsOnEquipOffHandCooldown = {}
    if weaponSpells ~= nil then
        for key, entry in pairs(weaponSpells) do
            if entry ~= nil then
                local weaponSpellData = Ext.Stats.Get(entry.Params)
                table.insert(boostsOnEquipOffHandCooldown,weaponSpellData.Cooldown)
                weaponSpellData.Cooldown = "None"
                weaponSpellData:Sync()
                Osi.RemoveSpell(character, entry.Params)
                Osi.AddSpell(character, entry.Params,0,0)
            end
        end
    end

    local originalWeaponCooldowns = {}
    table.insert(originalWeaponCooldowns,boostsCooldown)
    table.insert(originalWeaponCooldowns,boostsOnEquipMainHandCooldown)
    table.insert(originalWeaponCooldowns,boostsOnEquipOffHandCooldown)

    print("Reset cooldowns one done")
    _D(originalWeaponCooldowns)
    return originalWeaponCooldowns
end

function resetCooldownTwo(character, weaponSlot, originalWeaponCooldowns)
    if weaponSlot == "Melee Main Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.Boosts
    elseif weaponSlot == "Melee Offhand Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.Boosts
    end
    print("Boosts is")
    _D(weaponSpells)
    if weaponSpells ~= nil then
        for key, entry in pairs(weaponSpells) do
            if originalWeaponCooldowns[1][key] ~= nil then
                local weaponSpellData = Ext.Stats.Get(entry.Params)
                weaponSpellData.Cooldown = originalWeaponCooldowns[1][key]
                weaponSpellData:Sync()
                Osi.RemoveSpell(character, entry.Params)
                Osi.AddSpell(character, entry.Params,0,0)
            end
        end
    end

    if weaponSlot == "Melee Main Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.BoostsOnEquipMainHand
    elseif weaponSlot == "Melee Offhand Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.BoostsOnEquipMainHand
    end
    print("BoostsOnEquipMainHand is")
    _D(weaponSpells)
    if weaponSpells ~= nil then
        for key, entry in pairs(weaponSpells) do
            if originalWeaponCooldowns[2][key] ~= nil then
                local weaponSpellData = Ext.Stats.Get(entry.Params)
                weaponSpellData.Cooldown = originalWeaponCooldowns[2][key]
                weaponSpellData:Sync()
                Osi.RemoveSpell(character, entry.Params)
                Osi.AddSpell(character, entry.Params,0,0)
            end
        end
    end

    if weaponSlot == "Melee Main Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.BoostsOnEquipOffHand
    elseif weaponSlot == "Melee Offhand Weapon" then
        local weaponType = Osi.GetEquippedItem(character, "Melee Main Weapon")
        print(weaponType)
        local weaponSpells = Ext.Entity.Get(weaponType).Use.BoostsOnEquipOffHand
    end
    _D(weaponSpells)
    if weaponSpells ~= nil then
        for key, entry in pairs(weaponSpells) do
            if originalWeaponCooldowns[3][key] ~= nil then
                local weaponSpellData = Ext.Stats.Get(entry.Params)
                weaponSpellData.Cooldown = originalWeaponCooldowns[3][key]
                weaponSpellData:Sync()
                Osi.RemoveSpell(character, entry.Params)
                Osi.AddSpell(character, entry.Params,0,0)
            end
        end
    end

    print("Reset cooldowns two done")
end


function addProficiencyPassive(character, weaponType, proficiencyBoost)
    if weaponType == "5d7b1304-6d20-4d60-ba1b-0fbb491bfc18" then -- flail
        table.insert(proficiencyBoost, "flail")
        Osi.AddPassive(character, "Proficiency_Flails")
    elseif weaponType == "aa4cfcea-aee8-44b9-a460-e7231df796b1" then -- morningstar
        table.insert(proficiencyBoost, "morningstar")
        Osi.AddPassive(character, "Proficiency_Morningstars")
    elseif weaponType == "aeaf4e95-38d7-45ec-8900-40bc9e6106b0" then -- rapier
        table.insert(proficiencyBoost, "rapier")
        Osi.AddPassive(character, "Proficiency_Rapiers")
    elseif weaponType == "206f9701-7b24-4eaf-9ac4-a47746c251e2" then -- scimitar
        table.insert(proficiencyBoost, "scimitar")
        Osi.AddPassive(character, "Proficiency_Scimitars")
    elseif weaponType == "c826fd1e-4780-43d4-b49b-87f30c060fe6" then -- shortsword
        table.insert(proficiencyBoost, "shortsword")
        Osi.AddPassive(character, "Proficiency_Shortswords")
    elseif weaponType == "eed87cdb-c5ee-45c2-9a5a-6949dce87a1e" then -- warpick
        table.insert(proficiencyBoost, "warpick")
        Osi.AddPassive(character, "Proficiency_Warpicks")
    elseif weaponType == "7609654e-b213-410d-b08f-6d2930da6411" then -- battleaxe
        table.insert(proficiencyBoost, "battleaxe")
        Osi.AddPassive(character, "Proficiency_Battleaxes")
    elseif weaponType == "96a99a42-ec5d-4081-9d62-c9e3f0057136" then -- longsword
        table.insert(proficiencyBoost, "longsword")
        Osi.AddPassive(character, "Proficiency_Longswords")
    elseif weaponType == "c808f076-4a0f-422a-97db-e985ce35f3f9" then -- trident
        table.insert(proficiencyBoost, "trident")
        Osi.AddPassive(character, "Proficiency_Tridents")
    elseif weaponType == "1dff197e-b74c-4173-94d3-e1323239556c" then -- warhammer
        table.insert(proficiencyBoost, "warhammer")
        Osi.AddPassive(character, "Proficiency_Warhammers")
    elseif weaponType == "7a15ea4f-cb00-4201-8e7f-024627e3d014" then -- glaive
        table.insert(proficiencyBoost, "glaive")
        Osi.AddPassive(character, "Proficiency_Glaives")
    elseif weaponType == "02da79f5-6f13-4f90-9819-102e37693f48" then -- greataxe
        table.insert(proficiencyBoost, "greataxe")
        Osi.AddPassive(character, "Proficiency_Greataxes")
    elseif weaponType == "aec4ed1a-993b-491f-a2db-640bf11869c1" then -- greatsword
        table.insert(proficiencyBoost, "greatsword")
        Osi.AddPassive(character, "Proficiency_Greatswords")
    elseif weaponType == "2c74855f-769a-43f5-b6db-48c4c47721ff" then -- halberd
        table.insert(proficiencyBoost, "halberd")
        Osi.AddPassive(character, "Proficiency_Halberds")
    elseif weaponType == "2503012b-9cc4-491c-a068-282f8cea8707" then -- maul
        table.insert(proficiencyBoost, "maul")
        Osi.AddPassive(character, "Proficiency_Mauls")
    elseif weaponType == "ca1a548b-f409-4cad-af5a-dfdd5834c709" then -- pike
        table.insert(proficiencyBoost, "pike")
        Osi.AddPassive(character, "Proficiency_Pikes")
    end
end

function removeProficiencyPassive(proficiencyBoost)
    for key, entry in pairs(proficiencyBoost) do
        if entry == "flail" then -- flail
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Flails")
        elseif entry == "morningstar" then -- morningstar
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Morningstars")
        elseif entry == "rapier" then -- rapier
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Rapiers")
        elseif entry == "scimitar" then -- scimitar
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Scimitars")
        elseif entry == "shortsword" then -- shortsword
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Shortswords")
        elseif entry == "warpick" then -- warpick
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Warpicks")
        elseif entry == "battleaxe" then -- battleaxe
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Battleaxes")
        elseif entry == "longsword" then -- longsword
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Longswords")
        elseif entry == "trident" then -- trident
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Tridents")
        elseif entry == "warhammer" then -- warhammer
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Warhammers")
        elseif entry == "glaive" then -- glaive
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Glaives")
        elseif entry == "greataxe" then -- greataxe
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Greataxes")
        elseif entry == "greatsword" then -- greatsword
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Greatswords")
        elseif entry == "halberd" then -- halberd
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Halberds")
        elseif entry == "maul" then -- maul
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Mauls")
        elseif entry == "pike" then -- pike
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Pikes")
        end
    end
end

print("Functions loaded")