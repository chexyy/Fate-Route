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

                if weaponSlot == "Melee Main Weapon" or "Melee Offhand Weapon" then
                    observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER_MELEE,100,2);AI_IGNORE:SummonInInventory(" .. offhandWeaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
                else
                    observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER_RANGED,100,2);AI_IGNORE:SummonInInventory(" .. offhandWeaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
                end

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
    elseif weaponType == "9b333d67-365f-41fa-80b2-08e86588e9ac" then -- club
        table.insert(proficiencyBoost, "club")
        Osi.AddPassive(character, "Proficiency_Clubs")
    elseif weaponType == "7490e5d0-d346-4b0e-80c6-04e977160863" then -- dagger
        table.insert(proficiencyBoost, "dagger")
        Osi.AddPassive(character, "Proficiency_Daggers")
    elseif weaponType == "09dd1e1e-6d9f-4cc6-b514-68e981c80543" then -- handaxe
        table.insert(proficiencyBoost, "handaxe")
        Osi.AddPassive(character, "Proficiency_Handaxes")
    elseif weaponType == "b6e3bfa1-2c63-404f-becb-21d047aacce1" then -- javelin
        table.insert(proficiencyBoost, "javelin")
        Osi.AddPassive(character, "Proficiency_Javelins")
    elseif weaponType == "edc46cc0-25d0-4da9-bfcb-edba239edcce" then -- light hammer
        table.insert(proficiencyBoost, "light hammer")
        Osi.AddPassive(character, "Proficiency_LightHammers")
    elseif weaponType == "c29fc6ce-0482-420d-a839-41a0bab95c2d" then -- mace
        table.insert(proficiencyBoost, "mace")
        Osi.AddPassive(character, "Proficiency_Maces")
    elseif weaponType == "bfdc63bd-b8f6-4eac-9363-0c71882ff46f" then -- sickle
        table.insert(proficiencyBoost, "sickle")
        Osi.AddPassive(character, "Proficiency_Sickles")
    elseif weaponType == "b428632e-3137-47aa-ae8f-ddff6fc27cc8" then -- quarterstaff
        table.insert(proficiencyBoost, "quarterstaff")
        Osi.AddPassive(character, "Proficiency_Quarterstaffs")
    elseif weaponType == "fef6b399-19da-4d4b-b1ec-c79dff7f46c3" then -- spear
        table.insert(proficiencyBoost, "spear")
        Osi.AddPassive(character, "Proficiency_Spears")
    elseif weaponType == "ab44887d-0eb0-4fef-bd9d-943ea8971aa2" then -- greatclub
        table.insert(proficiencyBoost, "greatclub")
        Osi.AddPassive(character, "Proficiency_Greatclubs")
    elseif weaponType == "1c12ee6d-50e2-459f-90c8-ae56701190ce" then -- hand crossbow
        table.insert(proficiencyBoost, "hand crossbow")
        Osi.AddPassive(character, "Proficiency_HandCrossbows")
    elseif weaponType == "2cc23bb9-d777-4265-a34c-333528628b90" then -- heavy crossbow
        table.insert(proficiencyBoost, "heavy crossbow")
        Osi.AddPassive(character, "Proficiency_HeavyCrossbows")
    elseif weaponType == "a302a8e2-a3f9-41e1-a68c-70a453e65399" then -- light crossbow
        table.insert(proficiencyBoost, "light crossbow")
        Osi.AddPassive(character, "Proficiency_LightCrossbows")
    elseif weaponType == "81197304-7116-4d7b-8ef4-207bbf636682" then -- shortbow
        table.insert(proficiencyBoost, "shortbow")
        Osi.AddPassive(character, "Proficiency_Shortbows")
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
        elseif entry == "club" then -- club
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Clubs")
        elseif entry == "dagger" then -- dagger
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Daggers")
        elseif entry == "handaxe" then -- handaxe
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Handaxes")
        elseif entry == "javelin" then -- javelin
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Javelins")
        elseif entry == "light hammer" then -- light hammer
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_LightHammers")
        elseif entry == "mace" then -- mace
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Maces")
        elseif entry == "sickle" then -- sickle
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Sickles")
        elseif entry == "quarterstaff" then -- quarterstaff
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Quarterstaffs")
        elseif entry == "spear" then -- spear
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Spears")
        elseif entry == "greatclub" then -- greatclub 
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Greatclubs")
        elseif entry == "hand crossbow" then -- hand crossbow
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_HandCrossbows")
        elseif entry == "heavy crossbow" then -- heavy crossbow
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_HeavyCrossbows") 
        elseif entry == "light crossbow" then -- light crossbow
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_LightCrossbows")
        elseif entry == "shortbow" then -- shortbow
            Osi.RemovePassive(GetHostCharacter(), "Proficiency_Shortbows")
        end
    end
end

print("Functions loaded")