-- trace new weapon
function addTraceSpell(character, weaponSlot, wielderStrength, wielderDexterity, wielderMovementSpeed, wielderIcon, originalWielderName, meleeOrRanged, weaponTemplates)
    local entity = Ext.Entity.Get(character)
    local localTraceTable = entity.Vars.traceTable or {}
    local foundWeapon = 0
    
    -- looking to see if weapon was found
    for key, entry in ipairs(localTraceTable) do
        if localTraceTable ~= {} then
            entry.weaponUUID = entry.weaponUUID or {}
            -- if both weapons are there
            if weaponSlot[1] ~= nil and weaponSlot[2] ~= nil then
                if entry.weaponUUID[1] == Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).GameObjectVisual.RootTemplateId and entry.weaponUUID[2] == Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).GameObjectVisual.RootTemplateId then
                    foundWeapon = checkForWeapon(entry,character,weaponSlot,wielderIcon)
                    foundWeapon = 1
                    break
                end

            -- if only main hand is there
            elseif weaponSlot[1] ~= nil and weaponSlot[2] == nil then
                if entry.weaponUUID[1] == Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).GameObjectVisual.RootTemplateId then
                    foundWeapon = checkForWeapon(entry,character,weaponSlot,wielderIcon)
                    foundWeapon = 1
                    break
                end

            -- if only off hand is there
            elseif weaponSlot[1] == nil and weaponSlot[2] ~= nil then
                if entry.weaponUUID[2] == Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).GameObjectVisual.RootTemplateId then
                    foundWeapon = checkForWeapon(entry,character,weaponSlot,wielderIcon)
                    foundWeapon = 1
                    break
                end
            end
        end 
    end
        
    for i = 1,999, 1 do
        if foundWeapon == 0 then
            -- adding the weapon
            local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
            if observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then

                -- checks if melee or ranged
                if meleeOrRanged == "Melee" then
                    spellProperties = "ApplyStatus(FAKER_MELEE,100,3);"
                    REPRODUCTION = "REPRODUCTION_MELEE"
                else 
                    spellProperties = "ApplyStatus(FAKER_RANGED,100,3);"
                    REPRODUCTION = "REPRODUCTION_RANGED"
                end

                --if mainhand but no offhand
                if weaponSlot[1] ~= nil and weaponSlot[2] == nil then
                    weaponName = Ext.Loca.GetTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).DisplayName.NameKey.Handle.Handle)
                    displayName = originalWielderName .. "'s " .. weaponName
                    local weapon = Osi.GetEquippedItem(character, weaponSlot[1])
                    
                    Ext.Loca.UpdateTranslatedString(displayName, displayName) -- display name
                    observedTraceTemplate:SetRawAttribute("DisplayName", displayName) -- display name
                    observedTraceTemplate:SetRawAttribute("Description", "h9786436ag6854g4471gb89cgb7966937b899") -- description
                    observedTraceTemplate.Icon = wielderIcon -- icon
                    observedTraceTemplate:SetRawAttribute("DescriptionParams", "This weapon was;" .. wielderStrength .. ";" .. wielderDexterity .. ";" .. wielderMovementSpeed) -- description param
                    
                    -- checks if melee or ranged and makes spell summonable
                    weaponUUID = {Ext.Entity.Get(weapon).ServerItem.Template.Id, nil}
                    spellProperties = spellProperties .. "AI_IGNORE:SummonInInventory(" .. weaponUUID[1] .. ",3,1,true,true,true,,," .. REPRODUCTION .. "," .. REPRODUCTION .. ")"
                    observedTraceTemplate:SetRawAttribute("SpellProperties", spellProperties)

                    -- sets use cost based on rarity
                    local magicalEnergyCost = Ext.Entity.Get(weapon).Value.Rarity + 1
                    observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:" .. magicalEnergyCost
                
                --if offhand but no mainhand
                elseif weaponSlot[1] == nil and weaponSlot[2] ~= nil then
                    weaponName = Ext.Loca.GetTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).DisplayName.NameKey.Handle.Handle)
                    displayName = originalWielderName .. "'s " .. weaponName
                    local weapon = Osi.GetEquippedItem(character, weaponSlot[2])
                    
                    Ext.Loca.UpdateTranslatedString(displayName, displayName) -- display name
                    observedTraceTemplate:SetRawAttribute("DisplayName", displayName) -- display name
                    observedTraceTemplate:SetRawAttribute("Description", "h9786436ag6854g4471gb89cgb7966937b899")
                    observedTraceTemplate.Icon = wielderIcon -- icon
                    observedTraceTemplate:SetRawAttribute("DescriptionParams", "This weapon was;" .. wielderStrength .. ";" .. wielderDexterity .. ";" .. wielderMovementSpeed) -- description param

                    -- makes spell summonable
                    weaponUUID = {nil, Ext.Entity.Get(weapon).ServerItem.Template.Id}
                    spellProperties = spellProperties .. "AI_IGNORE:SummonInInventory(" .. weaponUUID[2] .. ",3,1,true,true,true,,," .. REPRODUCTION .. "," .. REPRODUCTION .. ")"
                    observedTraceTemplate:SetRawAttribute("SpellProperties", spellProperties)

                    -- sets use cost based on rarity
                    local magicalEnergyCost = Ext.Entity.Get(weapon).Value.Rarity + 1
                    observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:" .. magicalEnergyCost

                
                --if both mainhand and offhand
                elseif weaponSlot[1] ~= nil and weaponSlot[2] ~= nil then
                    local weaponNames = {Ext.Loca.GetTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).DisplayName.NameKey.Handle.Handle),Ext.Loca.GetTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).DisplayName.NameKey.Handle.Handle)}
                    local weapon = {Osi.GetEquippedItem(character, weaponSlot[1]),Osi.GetEquippedItem(character, weaponSlot[2])}

                    -- display name
                    if weaponNames[1] ~= weaponNames[2] then
                        displayName = originalWielderName .. "'s " .. weaponNames[1] .. " and " .. weaponNames[2]
                        weaponName = weaponNames[1] .. " and " .. weaponNames[2]
                    else
                        displayName = originalWielderName .. "'s " .. weaponNames[1] .. "s"
                        weaponName = weaponNames[1] .. "s"
                    end
                    Ext.Loca.UpdateTranslatedString(displayName, displayName)
                    observedTraceTemplate:SetRawAttribute("DisplayName", displayName)
                    observedTraceTemplate:SetRawAttribute("Description", "h9786436ag6854g4471gb89cgb7966937b899")

                    observedTraceTemplate.Icon = wielderIcon -- icon
                    observedTraceTemplate:SetRawAttribute("DescriptionParams", "These weapons were;" .. wielderStrength .. ";" .. wielderDexterity .. ";" .. wielderMovementSpeed) -- description param

                    -- checks if melee or ranged and makes spell summonable
                    weaponUUID = {Ext.Entity.Get(weapon[1]).ServerItem.Template.Id, Ext.Entity.Get(weapon[2]).ServerItem.Template.Id}
                    -- spellProperties = spellProperties .. "AI_IGNORE:SummonInInventory(" .. weaponUUID[1] .. ",3,1,true,true,true,,,REPRODUCTION,REPRODUCTION);AI_IGNORE:SummonInInventory(" .. weaponUUID[2] .. ",3,1,true,true,true,,,REPRODUCTION,REPRODUCTION)"

                    -- sets use cost based on rarity
                    local magicalEnergyCost = math.ceil((Ext.Entity.Get(weapon[1]).Value.Rarity + Ext.Entity.Get(weapon[1]).Value.Rarity)*3/4)
                    observedTraceTemplate.UseCosts = "BonusActionPoint:1;MagicalEnergy:" .. magicalEnergyCost

                    -- add tooltip apply status
                    local extraSpellNum = addExtraDescription(character,weaponSlot, weaponUUID, meleeOrRanged,"Shout_TraceWeapon_Template" .. i, weaponTemplates)
                    -- local statusNum = addApplyStatus(character,weaponSlot,weaponUUID, extraSpellNum, "Shout_TraceWeapon_Template" .. i)
                    tooltipApply = "ApplyStatus(WEAPON_DESCRIPTION_TEMPLATE" .. extraSpellNum[1] .. ",100,3);ApplyStatus(WEAPON_DESCRIPTION_TEMPLATE" .. extraSpellNum[2] .. ",100,3)"
                    -- print("Tooltip is " .. tooltipApply)

                        -- checks if melee or ranged
                        -- if meleeOrRanged == "Melee" then
                        --     spellProperties = "ApplyStatus(FAKER_MELEE_DUAL,100,3);"
                        -- else 
                        --     spellProperties = "ApplyStatus(FAKER_RANGED_DUAL,100,3);"
                        -- end
                    -- spellProperties = spellProperties .. tooltipApply
                    spellProperties = spellProperties .. "AI_IGNORE:SummonInInventory(" .. weaponUUID[1] .. ",3,1,true,true,true,,," .. REPRODUCTION .. "," .. REPRODUCTION .. ")" --;AI_IGNORE:SummonInInventory(" .. weaponUUID[2] .. ",3,1,true,true,true,,,REPRODUCTION,REPRODUCTION)"
                    observedTraceTemplate:SetRawAttribute("SpellProperties", "")
                    -- table.insert(observedTraceTemplate.SpellFlags,"IsLinkedSpellContainer")
                    -- observedTraceTemplate.ContainerSpells = "Shout_TraceWeapon_TemplateDescription" .. extraSpellNum[1] .. ";Shout_TraceWeapon_TemplateDescription" .. extraSpellNum[2]

                    -- observedTraceTemplate:SetRawAttribute("SpellAnimation", "f489d217-b699-4e8e-bf22-6ef539c5d65b,,;,,;7a343ea7-1330-428a-b0b1-9f6dc7f2a91c,,;0f872585-3c6e-4493-a0b5-5acc882b7aaf,,;f9414915-2da7-4f40-bcbd-90e956461246,,;,,;f2a62277-c87a-4ec7-b4f2-c3c37e6e30ae,,;,,;,,")
                    observedTraceTemplate:SetRawAttribute("TooltipStatusApply", tooltipApply)

                end
            
                -- adding to spell
                local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")
                local containerList = baseSpell.ContainerSpells
                containerList = containerList .. ";Shout_TraceWeapon_Template" .. i

                observedTraceTemplate:Sync()       
                baseSpell.ContainerSpells = containerList
                baseSpell:Sync()

                table.insert(localTraceTable,traceObject:new(displayName, wielderIcon, weaponUUID,spellProperties, observedTraceTemplate.UseCosts, tooltipApply, wielderStrength, wielderDexterity, wielderMovementSpeed,meleeOrRanged, weaponName))
                entity.Vars.traceTable = localTraceTable
                print("This sync produced a spell for " .. Osi.ResolveTranslatedString(observedTraceTemplate.DisplayName) .. " for template spell #" .. i)  
                break
            end
        end
    end
end

function checkForWeapon(entry, character, weaponSlot, wielderIcon, wielderStrength, wielderDexterity, wielderMovementSpeed)
    local foundWeapon = 0;
    local wielderStrength = wielderStrength or 0
    local wielderDexterity = wielderDexterity or 0
    local wielderMovementSpeed = wielderMovementSpeed or 0
    if wielderStrength > entry.wielderStrength or wielderDexterity > entry.wielderDexterity or wielderMovementSpeed > entry.wielderMovementSpeed then
        print("Stat found to be higher")
        if wielderStrength > entry.wielderStrength then
            print("Strength replaced as " .. wielderStrength .. " is greater than " .. entry.wielderStrength)
            entry.wielderStrength = wielderStrength
        end
        if wielderDexterity > entry.wielderDexterity then
            print("Dexterity replaced as " .. wielderDexterity .. " is greater than " .. entry.wielderDexterity)
            entry.wielderDexterity = wielderDexterity
        end
        if wielderMovementSpeed > entry.wielderMovementSpeed then
            print("Movement speed replaced as " .. wielderMovementSpeed .. " is greater than " .. entry.wielderMovementSpeed)
            entry.wielderMovementSpeed = wielderMovementSpeed
        end
        entry.Icon = wielderIcon
        if weaponSlot[1] ~= nil and weaponSlot[2] == nil then
            entry.DisplayName = originalWielderName .. "'s " .. Ext.Loca.GetTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).DisplayName.NameKey.Handle.Handle)
        elseif weaponSlot[1] == nil and weaponSlot[2] ~= nil then
            entry.DisplayName = originalWielderName .. "'s " .. Ext.Loca.GetTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).DisplayName.NameKey.Handle.Handle)
        else
            entry.DisplayName = originalWielderName .. "'s " .. Ext.Loca.GetTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).DisplayName.NameKey.Handle.Handle) .. " and " .. Ext.Loca.GetTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).DisplayName.NameKey.Handle.Handle)
        end
        entity.Vars.traceTable = localTraceTable

    end
    foundWeapon = 1
    return foundWeapon
    
end

function addExtraDescription(character, weaponSlot, weaponUUID, meleeOrRanged, originalSpell, weaponTemplates)
    
    local weaponDisplayName = {Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).DisplayName.NameKey.Handle.Handle,Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).DisplayName.NameKey.Handle.Handle}
    local extraDescriptionAddon = ""
    local entity = Ext.Entity.Get(character)
    
    local extraSpellNum = {}
    for weaponNum = 1,2,1 do
        local foundWeaponDescription = false
        local localextraDescriptionTable = entity.Vars.extraDescriptionTable or {}
        if localextraDescriptionTable ~= {} then
            _D(localextraDescriptionTable)
            for i = 1,999,1 do
                local observedDescriptionTemplate = Ext.Stats.Get("Shout_TraceWeapon_TemplateDescription" .. i)
                if observedDescriptionTemplate.DisplayName == weaponDisplayName[weaponNum] then
                    foundWeaponDescription = true 

                    -- observedDescriptionTemplate.SpellContainerID = observedDescriptionTemplate.SpellContainerID .. ";" ..  originalSpell

                    entity.Vars.extraDescriptionTable = localextraDescriptionTable
                    extraSpellNum[weaponNum] = i
                    break
                end
            end
            
        end

        if foundWeaponDescription == false then
            local weaponDescription = {Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).ServerItem.Template.Description.Handle.Handle,Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).ServerItem.Template.Description.Handle.Handle}
            local weaponIcon = {Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).Icon.Icon,Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).Icon.Icon}
            
            for i = 1,999,1 do
                local observedDescriptionTemplate = Ext.Stats.Get("Shout_TraceWeapon_TemplateDescription" .. i) 
                if observedDescriptionTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                    observedDescriptionTemplate:SetRawAttribute("DisplayName", weaponDisplayName[weaponNum])
                    observedDescriptionTemplate:SetRawAttribute("Description", weaponDescription[weaponNum])
                    observedDescriptionTemplate:SetRawAttribute("Sheathing", meleeOrRanged)

                    if meleeOrRanged == "Melee" then
                        REPRODUCTION = "REPRODUCTION_MELEE"
                    else
                        REPRODUCTION = "REPRODUCTION_RANGED"
                    end

                    spellProperties = "AI_IGNORE:SummonInInventory(" .. weaponUUID[weaponNum] .. ",3,1,true,true,true,,," .. REPRODUCTION .. "," .. REPRODUCTION .. ")"
                    observedDescriptionTemplate:SetRawAttribute("SpellProperties", spellProperties)

                    local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")

                    observedDescriptionTemplate.Icon = weaponIcon[weaponNum]
                    -- observedDescriptionTemplate.SpellContainerID = observedDescriptionTemplate.SpellContainerID .. ";" ..  originalSpell
                    observedDescriptionTemplate:Sync()

                    local observedStatusTemplate = Ext.Stats.Get("WEAPON_DESCRIPTION_TEMPLATE" .. i) 
                    observedStatusTemplate:SetRawAttribute("DisplayName", weaponDisplayName[weaponNum])
                    observedStatusTemplate.DescriptionParams = Osi.ResolveTranslatedString(weaponDisplayName[weaponNum])
                    observedStatusTemplate.Icon = weaponIcon[weaponNum]
                    observedStatusTemplate:Sync()

                    extraSpellNum[weaponNum] = i

                    baseSpell:Sync()
                    break
                end
            end

            print(Osi.ResolveTranslatedString(weaponDisplayName[weaponNum]) .. " added to extraDescriptionTable, whose weapon template is " .. weaponTemplates[weaponNum])
            table.insert(localextraDescriptionTable, extraDescription:new(weaponDisplayName[weaponNum],weaponDescription[weaponNum],weaponIcon[weaponNum], spellProperties, meleeOrRanged, weaponTemplates[weaponNum]))
            entity.Vars.extraDescriptionTable = localextraDescriptionTable
            
        end
    end

    return extraSpellNum

end

-- spell cooldowns
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

-- proficiency
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