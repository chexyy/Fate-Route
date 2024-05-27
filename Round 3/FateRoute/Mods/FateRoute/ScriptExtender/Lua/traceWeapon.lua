traceObject = {}
traceObject.__index = traceObject

function traceObject:new(DisplayName, Icon, weaponUUID, UseCosts)
    local instance = setmetatable({}, traceObject)
    instance.DisplayName = DisplayName
    instance.Icon = Icon
    instance.weaponUUID = weaponUUID
    instance.UseCosts = UseCosts
    return instance
end

Ext.Osiris.RegisterListener("CharacterMadePlayer", 1, "after", function(character)
    print("Character made player")
    Ext.Vars.RegisterUserVariable("traceTable", {})
    local entity = Ext.Entity.Get(character)
    local localTraceTable = entity.Vars.traceTable or {}
    
    if localTraceTable ~= {} then
        _D(localTraceTable)
        for key, entry in ipairs(localTraceTable) do
            for i=1,999,1 do
                local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                if observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" and observedTraceTemplate.DisplayName ~= entry.DisplayName then
                    
                    -- copying over stats
                    observedTraceTemplate:SetRawAttribute("DisplayName", entry.DisplayName)
                    observedTraceTemplate.Icon = entry.Icon
                    observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER,100,2);AI_IGNORE:SummonInInventory(" .. entry.weaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
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
        end
    end

end)



-- listeners
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == "Target_TraceWeapon" then

        if HasAppliedStatus(caster,"FAKER") then
            Osi.RemoveStatus(caster,"FAKER")
        end
        local beginningIndex, endingIndex = string.find(target, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
        local targetUUID = string.sub(target,beginningIndex,endingIndex)
        
        if GetEquippedItem(targetUUID, "Melee Offhand Weapon") ~= nil then
            local offhandWeapon = GetEquippedItem(targetUUID, "Melee Offhand Weapon")
            offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
            Osi.TemplateAddTo(offhandWeaponTemplate,caster,1,0) -- Gives offhand item
        end
        
        local mainWeapon = GetEquippedItem(targetUUID, "Melee Main Weapon")
        mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
        Osi.TemplateAddTo(mainWeaponTemplate,caster,1,0) -- Gives item

        ApplyStatus(caster,"FAKER",10,100)
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER" then
        if mainWeaponTemplate ~= nil then
            Osi.Equip(object,GetItemByTemplateInInventory(mainWeaponTemplate,object),1,0)
            Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplate,object), "REPRODUCTION", 10, 100)
        end
        if offhandWeaponTemplate ~= nil then
            Osi.Equip(object,GetItemByTemplateInInventory(offhandWeaponTemplate,object),1,0)
            Osi.ApplyStatus(GetItemByTemplateInInventory(offhandWeaponTemplate,object), "REPRODUCTION", 10, 100)
        end 
    end

end)

Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(itemTemplate, character)
    -- mainhand
    if itemTemplate == mainWeaponTemplate then
        print("Mainhand item equipped")
        local entity = Ext.Entity.Get(character)
        local localTraceTable = entity.Vars.traceTable or {}
        local foundWeapon = 0

        -- proficiency
        if Osi.IsProficientWith(character, Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).ServerTemplateTag.Tags[3]
            print("The weapon type is " .. weaponType)
            if weaponType == "5d7b1304-6d20-4d60-ba1b-0fbb491bfc18" then -- flail
                proficiencyBoostMain = "flail"
                Osi.AddPassive(character, "Proficiency_Flails")
            elseif weaponType == "aa4cfcea-aee8-44b9-a460-e7231df796b1" then -- morningstar
                proficiencyBoostMain = "morningstar"
                Osi.AddPassive(character, "Proficiency_Morningstars")
            elseif weaponType == "aeaf4e95-38d7-45ec-8900-40bc9e6106b0" then -- rapier
                proficiencyBoostMain = "rapier"
                Osi.AddPassive(character, "Proficiency_Rapiers")
            elseif weaponType == "206f9701-7b24-4eaf-9ac4-a47746c251e2" then -- scimitar
                proficiencyBoostMain = "scimitar"
                Osi.AddPassive(character, "Proficiency_Scimitars")
            elseif weaponType == "c826fd1e-4780-43d4-b49b-87f30c060fe6" then -- shortsword
                proficiencyBoostMain = "shortsword"
                Osi.AddPassive(character, "Proficiency_Shortswords")
            elseif weaponType == "eed87cdb-c5ee-45c2-9a5a-6949dce87a1e" then -- warpick
                proficiencyBoostMain = "warpick"
                Osi.AddPassive(character, "Proficiency_Warpicks")
            elseif weaponType == "7609654e-b213-410d-b08f-6d2930da6411" then -- battleaxe
                proficiencyBoostMain = "battleaxe"
                Osi.AddPassive(character, "Proficiency_Battleaxes")
            elseif weaponType == "96a99a42-ec5d-4081-9d62-c9e3f0057136" then -- longsword
                proficiencyBoostMain = "longsword"
                Osi.AddPassive(character, "Proficiency_Longswords")
            elseif weaponType == "c808f076-4a0f-422a-97db-e985ce35f3f9" then -- trident
                proficiencyBoostMain = "trident"
                Osi.AddPassive(character, "Proficiency_Tridents")
            elseif weaponType == "1dff197e-b74c-4173-94d3-e1323239556c" then -- warhammer
                proficiencyBoostMain = "warhammer"
                Osi.AddPassive(character, "Proficiency_Warhammers")
            elseif weaponType == "7a15ea4f-cb00-4201-8e7f-024627e3d014" then -- glaive
                proficiencyBoostMain = "glaive"
                Osi.AddPassive(character, "Proficiency_Glaives")
            elseif weaponType == "02da79f5-6f13-4f90-9819-102e37693f48" then -- greataxe
                proficiencyBoostMain = "greataxe"
                Osi.AddPassive(character, "Proficiency_Greataxes")
            elseif weaponType == "aec4ed1a-993b-491f-a2db-640bf11869c1" then -- greatsword
                proficiencyBoostMain = "greatsword"
                Osi.AddPassive(character, "Proficiency_Greatswords")
            elseif weaponType == "2c74855f-769a-43f5-b6db-48c4c47721ff" then -- halberd
                proficiencyBoostMain = "halberd"
                Osi.AddPassive(character, "Proficiency_Halberds")
            elseif weaponType == "2503012b-9cc4-491c-a068-282f8cea8707" then -- maul
                proficiencyBoostMain = "maul"
                Osi.AddPassive(character, "Proficiency_Mauls")
            elseif weaponType == "ca1a548b-f409-4cad-af5a-dfdd5834c709" then -- pike
                proficiencyBoostMain = "pike"
                Osi.AddPassive(character, "Proficiency_Pikes")
            end
        end


        -- checking if it's been traced before
        for key, entry in ipairs(localTraceTable) do
            if localTraceTable ~= {} then
                local mainWeapon = Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")
                if entry.DisplayName == Ext.Entity.Get(mainWeapon).DisplayName.NameKey.Handle.Handle then
                    foundWeapon = 1
                    break
                end
            end 
        end
            
        for i = 1,999, 1 do
            if foundWeapon == 0 then
                local mainWeapon = Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")
                local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                if observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                    
                    local mainWeaponUUID = Ext.Entity.Get(mainWeapon).ServerItem.Template.Id
                    observedTraceTemplate:SetRawAttribute("DisplayName", Ext.Entity.Get(mainWeapon).DisplayName.NameKey.Handle.Handle)
                    observedTraceTemplate.Icon = Ext.Entity.Get(mainWeapon).ServerIconList.Icons[1].Icon
                    observedTraceTemplate:SetRawAttribute("SpellProperties", "ApplyStatus(FAKER,100,2);AI_IGNORE:SummonInInventory(" .. mainWeaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")

                    -- sets use cost based on rarity
                    if Ext.Entity.Get(mainWeapon).Value.Rarity == 0 then
                        observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:1"
                    elseif Ext.Entity.Get(mainWeapon).Value.Rarity == 1 then
                        observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:2"
                    elseif Ext.Entity.Get(mainWeapon).Value.Rarity == 2 then
                        observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:3"
                    elseif Ext.Entity.Get(mainWeapon).Value.Rarity == 3 then
                        observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:4"
                    elseif Ext.Entity.Get(mainWeapon).Value.Rarity == 4 then
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

                    table.insert(localTraceTable,traceObject:new(observedTraceTemplate.DisplayName, observedTraceTemplate.Icon, mainWeaponUUID, observedTraceTemplate.UseCosts))
                    entity.Vars.traceTable = localTraceTable
                    print("This sync produced a spell for " .. Osi.ResolveTranslatedString(observedTraceTemplate.DisplayName) .. " for template spell #" .. i) 

                    break
                end
            end
        end
    end

    -- in the case of a secondary weapon
    if itemTemplate == offhandWeaponTemplate then
        print("Offhand item equipped")
        
        -- proficiency
        if Osi.IsProficientWith(character, Osi.GetEquippedItem(GetHostCharacter(), "Melee Offhand Weapon")) == 0 then
            local weaponType = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Offhand Weapon")).ServerTemplateTag.Tags[3]
            if weaponType == "5d7b1304-6d20-4d60-ba1b-0fbb491bfc18" then -- flail
                proficiencyBoostOffhand = "flail"
                Osi.AddPassive(character, "Proficiency_Flails")
            elseif weaponType == "aa4cfcea-aee8-44b9-a460-e7231df796b1" then -- morningstar
                proficiencyBoostOffhand = "morningstar"
                Osi.AddPassive(character, "Proficiency_Morningstars")
            elseif weaponType == "aeaf4e95-38d7-45ec-8900-40bc9e6106b0" then -- rapier
                proficiencyBoostOffhand = "rapier"
                Osi.AddPassive(character, "Proficiency_Rapiers")
            elseif weaponType == "206f9701-7b24-4eaf-9ac4-a47746c251e2" then -- scimitar
                proficiencyBoostOffhand = "scimitar"
                Osi.AddPassive(character, "Proficiency_Scimitars")
            elseif weaponType == "c826fd1e-4780-43d4-b49b-87f30c060fe6" then -- shortsword
                proficiencyBoostOffhand = "shortsword"
                Osi.AddPassive(character, "Proficiency_Shortswords")
            elseif weaponType == "eed87cdb-c5ee-45c2-9a5a-6949dce87a1e" then -- warpick
                proficiencyBoostOffhand = "warpick"
                Osi.AddPassive(character, "Proficiency_Warpicks")
            elseif weaponType == "7609654e-b213-410d-b08f-6d2930da6411" then -- battleaxe
                proficiencyBoostOffhand = "battleaxe"
                Osi.AddPassive(character, "Proficiency_Battleaxes")
            elseif weaponType == "96a99a42-ec5d-4081-9d62-c9e3f0057136" then -- longsword
                proficiencyBoostOffhand = "longsword"
                Osi.AddPassive(character, "Proficiency_Longswords")
            elseif weaponType == "c808f076-4a0f-422a-97db-e985ce35f3f9" then -- trident
                proficiencyBoostOffhand = "trident"
                Osi.AddPassive(character, "Proficiency_Tridents")
            elseif weaponType == "1dff197e-b74c-4173-94d3-e1323239556c" then -- warhammer
                proficiencyBoostOffhand = "warhammer"
                Osi.AddPassive(character, "Proficiency_Warhammers")
            elseif weaponType == "7a15ea4f-cb00-4201-8e7f-024627e3d014" then -- glaive
                proficiencyBoostOffhand = "glaive"
                Osi.AddPassive(character, "Proficiency_Glaives")
            elseif weaponType == "02da79f5-6f13-4f90-9819-102e37693f48" then -- greataxe
                proficiencyBoostOffhand = "greataxe"
                Osi.AddPassive(character, "Proficiency_Greataxes")
            elseif weaponType == "aec4ed1a-993b-491f-a2db-640bf11869c1" then -- greatsword
                proficiencyBoostOffhand = "greatsword"
                Osi.AddPassive(character, "Proficiency_Greatswords")
            elseif weaponType == "2c74855f-769a-43f5-b6db-48c4c47721ff" then -- halberd
                proficiencyBoostOffhand = "halberd"
                Osi.AddPassive(character, "Proficiency_Halberds")
            elseif weaponType == "2503012b-9cc4-491c-a068-282f8cea8707" then -- maul
                proficiencyBoostOffhand = "maul"
                Osi.AddPassive(character, "Proficiency_Mauls")
            elseif weaponType == "ca1a548b-f409-4cad-af5a-dfdd5834c709" then -- pike
                proficiencyBoostOffhand = "pike"
                Osi.AddPassive(character, "Proficiency_Pikes")
            end
        end
        
        -- checking if it's been traced before
        local entity = Ext.Entity.Get(character)
        local localTraceTable = entity.Vars.traceTable or {}
        local foundWeapon = 0
        for key, entry in ipairs(localTraceTable) do
            if localTraceTable ~= {} then
                local offhandWeapon = Osi.GetEquippedItem(GetHostCharacter(), "Melee Offhand Weapon")
                if entry.DisplayName == Ext.Entity.Get(Osi.GetEquippedItem(character, "Melee Offhand Weapon")).DisplayName.NameKey.Handle.Handle then
                    foundWeapon = 1
                    break
                end
            end 
        end
            
        for i = 1,999, 1 do
            if foundWeapon == 0 then
                local offhandWeapon = Osi.GetEquippedItem(GetHostCharacter(), "Melee Offhand Weapon")
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

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER" then 
        if mainWeaponTemplate ~= nil then    
            
            -- removing proficiency
            if proficiencyBoostMain == "flail" then -- flail
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Flails")
            elseif proficiencyBoostMain == "morningstar" then -- morningstar
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Morningstars")
            elseif proficiencyBoostMain == "rapier" then -- rapier
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Rapiers")
            elseif proficiencyBoostMain == "scimitar" then -- scimitar
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Scimitars")
            elseif proficiencyBoostMain == "shortsword" then -- shortsword
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Shortswords")
            elseif proficiencyBoostMain == "warpick" then -- warpick
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Warpicks")
            elseif proficiencyBoostMain == "battleaxe" then -- battleaxe
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Battleaxes")
            elseif proficiencyBoostMain == "longsword" then -- longsword
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Longswords")
            elseif proficiencyBoostMain == "trident" then -- trident
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Tridents")
            elseif proficiencyBoostMain == "warhammer" then -- warhammer
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Warhammers")
            elseif proficiencyBoostMain == "glaive" then -- glaive
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Glaives")
            elseif proficiencyBoostMain == "greataxe" then -- greataxe
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Greataxes")
            elseif proficiencyBoostMain == "greatsword" then -- greatsword
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Greatswords")
            elseif proficiencyBoostMain == "halberd" then -- halberd
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Halberds")
            elseif proficiencyBoostMain == "maul" then -- maul
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Mauls")
            elseif proficiencyBoostMain == "pike" then -- pike
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Pikes")
            end

            Osi.Unequip(GetHostCharacter(),GetItemByTemplateInInventory(mainWeaponTemplate,object))
            Osi.TemplateRemoveFrom(mainWeaponTemplate, object, 1)
            mainWeaponTemplate = nil
        end

        if offhandWeaponTemplate ~= nil then

            -- removing proficiency
            if proficiencyBoostOffhand == "flail" then -- flail
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Flails")
            elseif proficiencyBoostOffhand == "morningstar" then -- morningstar
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Morningstars")
            elseif proficiencyBoostOffhand == "rapier" then -- rapier
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Rapiers")
            elseif proficiencyBoostOffhand == "scimitar" then -- scimitar
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Scimitars")
            elseif proficiencyBoostOffhand == "shortsword" then -- shortsword
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Shortswords")
            elseif proficiencyBoostOffhand == "warpick" then -- warpick
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Warpicks")
            elseif proficiencyBoostOffhand == "battleaxe" then -- battleaxe
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Battleaxes")
            elseif proficiencyBoostOffhand == "longsword" then -- longsword
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Longswords")
            elseif proficiencyBoostOffhand == "trident" then -- trident
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Tridents")
            elseif proficiencyBoostOffhand == "warhammer" then -- warhammer
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Warhammers")
            elseif proficiencyBoostOffhand == "glaive" then -- glaive
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Glaives")
            elseif proficiencyBoostOffhand == "greataxe" then -- greataxe
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Greataxes")
            elseif proficiencyBoostOffhand == "greatsword" then -- greatsword
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Greatswords")
            elseif proficiencyBoostOffhand == "halberd" then -- halberd
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Halberds")
            elseif proficiencyBoostOffhand == "maul" then -- maul
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Mauls")
            elseif proficiencyBoostOffhand == "pike" then -- pike
                Osi.RemovePassive(GetHostCharacter(), "Proficiency_Pikes")
            end

            Osi.Unequip(object,GetItemByTemplateInInventory(offhandWeaponTemplate,object))
            Osi.TemplateRemoveFrom(offhandWeaponTemplate, object, 1)
            offhandWeaponTemplate = nil
        end
    end

end)