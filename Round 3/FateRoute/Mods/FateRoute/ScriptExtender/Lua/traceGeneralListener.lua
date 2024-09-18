-- variable sync
function syncAllVariables(character)
    Ext.Vars.RegisterUserVariable("extraDescriptionTable", {})
    Ext.Vars.RegisterUserVariable("bladeReconstitutionTurnCheck", {})
    Ext.Vars.RegisterUserVariable("originalStats", {})
    Ext.Vars.RegisterUserVariable("meleeStats", {})
    Ext.Vars.RegisterUserVariable("rangedStats", {})
    -- Ext.Vars.RegisterUserVariable("statusApplyTable", {})

    local entity = Ext.Entity.Get(character)
    local localextraDescriptionTable = entity.Vars.extraDescriptionTable or {}
    local bladeReconstitutionTurnCheck = entity.Vars.bladeReconstitutionTurnCheck or 0
    -- local localstatusApplyTable = entity.Vars.statusApplyTable or {}
    
    if localextraDescriptionTable ~= {} then
        if next(localextraDescriptionTable) ~= nil then
            -- _D(localextraDescriptionTable)
            for key, entry in pairs(localextraDescriptionTable) do
                for i = 1,999,1 do
                    local observedDescriptionTemplate = Ext.Stats.Get("Shout_TraceWeapon_TemplateDescription" .. i)
                    if observedDescriptionTemplate.DisplayName == entry.weaponDisplayName then
                        print("Description check found at index #" .. i)
                        break
                    elseif observedDescriptionTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                        -- print("Sync for " .. entry.weaponIcon .. " for template descritpion spell: Shout_TraceWeapon_TemplateDescription" .. i)
                        observedDescriptionTemplate:SetRawAttribute("DisplayName", entry.weaponDisplayName)
                        observedDescriptionTemplate:SetRawAttribute("Description", entry.weaponDescription)
                        observedDescriptionTemplate:SetRawAttribute("SpellProperties", entry.spellProperties)
                        observedDescriptionTemplate:SetRawAttribute("Sheathing", entry.meleeOrRanged)
                        observedDescriptionTemplate.Icon = entry.weaponIcon
                        observedDescriptionTemplate:Sync()

                        local observedStatusTemplate = Ext.Stats.Get("WEAPON_DESCRIPTION_TEMPLATE" .. i) 
                        observedStatusTemplate:SetRawAttribute("DisplayName", entry.weaponDisplayName)
                        observedStatusTemplate.DescriptionParams = Osi.ResolveTranslatedString(entry.weaponDisplayName)
                        observedStatusTemplate.Icon = entry.weaponIcon
                        observedStatusTemplate:Sync()

                        print("This sync produced a spell for the description and status template: " .. Osi.ResolveTranslatedString(observedDescriptionTemplate.DisplayName) .. " for template #" .. i) 
                        break
                    end
                end
            end
        end
    end
end

-- sync tables
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted extraDescriptionTable and statusApplyTable sync")

    Ext.Vars.RegisterUserVariable("meleeTriggerOff", {})
    Ext.Vars.RegisterUserVariable("rangedTriggerOff", {})

    fakerCharacter = locateFaker()
    syncAllVariables(fakerCharacter)
    local entity = Ext.Entity.Get(fakerCharacter)

    if Osi.HasPassive(fakerCharacter, "Passive_MartialMagi") == 1 then
        Osi.ApplyStatus(fakerCharacter, "MARTIALMAGI_TOGGLE", -1, 100, fakerCharacter)
        print("Applied martial magi")
    end

    if Osi.HasActiveStatus(fakerCharacter, "TRIGGEROFF_MELEE") == 1 then
        if entity.Vars.meleeTriggerOff ~= nil then
            Osi.AddBoosts(fakerCharacter, entity.Vars.meleeTriggerOff, "Trigger Off (Melee)", fakerCharacter)
        end

    end

    if Osi.HasActiveStatus(fakerCharacter, "TRIGGEROFF_RANGED") == 1 then
        if entity.Vars.rangedTriggerOff ~= nil then
            Osi.AddBoosts(fakerCharacter, entity.Vars.rangedTriggerOff, "Trigger Off (Ranged)", fakerCharacter)
        end

    end

    Osi.ObjectSetTitle(fakerCharacter, "Hero of Justice")

    
end)

-- apply reproduced trace stats and summon dual weapons if there
Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    local spellName = spell:match("TWT")
    if spellName == "TWT" then
        print(spell .. " found to be a template")
        local observedTraceTemplate = Ext.Stats.Get(spell)
        local entity = Ext.Entity.Get(caster)

        -- entity.ActionResources.Resources["420c8df5-45c2-4253-93c2-7ec44e127930"][1].Amount = entity.ActionResources.Resources["420c8df5-45c2-4253-93c2-7ec44e127930"][1].Amount - 1 
        -- if Osi.HasActiveStatus(caster, "APPLY_ARIA_8") == 1 then
        --     local magicalEnergyCost = :match("MagicalEnergy:%d+"):match("%d")
        --     Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount + magicalEnergyCost
        -- end

        local descriptionParams = observedTraceTemplate.DescriptionParams
        local params = {}
        for capture in descriptionParams:gmatch("(%d*%.?%d+)") do
            table.insert(params, capture)   
        end
        print("Params found to be:")
        _D(params)

        if Osi.HasPassive(fakerCharacter, "Passive_ProjectionPractitioner") == 1 and Osi.HasActiveStatus(fakerCharacter, "PROJECTION_PRACTITIONER") == 0 then
            Osi.ApplyStatus(fakerCharacter, "PROJECTION_PRACTITIONER", 5, 100, fakerCharacter)
        end
        if Osi.HasPassive(fakerCharacter, "Passive_ProjectionExpert") == 1 and Osi.HasActiveStatus(fakerCharacter, "PROJECTION_PRACTITIONER") == 1 and Osi.HasActiveStatus(fakerCharacter, "PROJECTION_EXPERT") == 0 then
            Osi.ApplyStatus(fakerCharacter, "PROJECTION_EXPERT", 5, 100, fakerCharacter)
        end
        if Osi.HasPassive(fakerCharacter, "Passive_ProjectionMaster") == 1 and Osi.HasActiveStatus(fakerCharacter, "PROJECTION_EXPERT") == 1 then
            Osi.ApplyStatus(fakerCharacter, "PROJECTION_MASTER", 5, 100, fakerCharacter)
        end
        
        -- local templateNum = spell:match("%d+")
        -- if templateNum ~= nil then
            if observedTraceTemplate.Sheathing == "Melee" then -- melee
                -- wielderStrength = params[1]
                -- wielderDexterity = params[2]
                -- wielderMovementSpeed = params[3]
                Ext.Timer.WaitFor(150, function()
                    if Osi.HasPassive(fakerCharacter, "Passive_TriggerOff") == 1 then
                        if Osi.HasActiveStatus(fakerCharacter, "TRIGGEROFF_MELEE") == 1 then
                            Osi.RemoveStatus(fakerCharacter, "TRIGGEROFF_MELEE", fakerCharacter)
                        elseif Osi.HasActiveStatus(fakerCharacter, "TRIGGEROFF_MELEE_COOLDOWN") == 0 then
                            Osi.ApplyStatus(fakerCharacter, "TRIGGEROFF_MELEE", 5, 100, fakerCharacter)
                            Osi.ApplyStatus(fakerCharacter, "TRIGGEROFF_MELEE_COOLDOWN", 5, 100, fakerCharacter)
                        end
                    end
                end)
                

                local meleeStats = {params[1], params[2], params[3]}
                Ext.Entity.Get(fakerCharacter).Vars.meleeStats = meleeStats
                print("Stats of melee reproduction traced weapon tracked")
                _D(meleeStats)

                if observedTraceTemplate.TooltipStatusApply ~= "" then
                    Ext.Timer.WaitFor(750, function()
                        trackTemplate({"Melee Main Weapon", "Melee Offhand Weapon"}, caster)
                    end)

                else -- lone weapon
                    Ext.Timer.WaitFor(750, function()
                        trackTemplate({"Melee Main Weapon", nil}, caster)
                    end)

                end

            else -- ranged
                -- wielderStrengthRanged = params[1]
                -- wielderDexterityRanged = params[2]
                -- wielderMovementSpeedRanged = params[3]
                Ext.Timer.WaitFor(150, function()
                    if Osi.HasPassive(fakerCharacter, "Passive_TriggerOff") == 1 then
                        if Osi.HasActiveStatus(fakerCharacter, "TRIGGEROFF_RANGED") == 1 then
                            Osi.RemoveStatus(fakerCharacter, "TRIGGEROFF_RANGED", fakerCharacter)
                        elseif Osi.HasActiveStatus(fakerCharacter, "TRIGGEROFF_RANGED_COOLDOWN") == 0 then
                            Osi.ApplyStatus(fakerCharacter, "TRIGGEROFF_RANGED", 5, 100, fakerCharacter)
                            Osi.ApplyStatus(fakerCharacter, "TRIGGEROFF_RANGED_COOLDOWN", 5, 100, fakerCharacter)
                        end
                    end
                end)

                local rangedStats = {params[1], params[2], params[3]}
                Ext.Entity.Get(fakerCharacter).Vars.rangedStats = rangedStats
                print("Stats of ranged reproduction traced weapon tracked")

                if observedTraceTemplate.TooltipStatusApply ~= "" then
                    Ext.Timer.WaitFor(750, function()
                        trackTemplate({"Ranged Main Weapon", "Ranged Offhand Weapon"}, caster)
                    end)

                else -- lone ranged weapon
                    Ext.Timer.WaitFor(750, function()
                        trackTemplate({"Ranged Main Weapon", nil}, caster)
                    end)

                end
            end
            if Osi.HasActiveStatus(caster, "EMULATE_WIELDER_SELFDAMAGE") == 1 then
                emulateWielder(caster) 
            end
        -- end
        -- if spell == "TWT_Caliburn" then
        --     print("Caliburn cast")
        --     local originalStats = {entity.Stats.Abilities[2], entity.Stats.Abilities[3], entity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount}
        --     if Osi.HasActiveStatus(caster, "DASH") == 1 then
        --         originalStats[3] = originalStats[3]/2
        --     end
        --     if Osi.HasActiveStatus(caster, "LONGSTRIDER") == 1 then
        --         originalStats[3] = originalStats[3] - 3
        --     end

        --     Ext.Entity.Get(fakerCharacter).Vars.originalStats = originalStats

            
        --     local meleeStats = {params[1], params[2], params[3]}
        --     Ext.Entity.Get(fakerCharacter).Vars.meleeStats = meleeStats
            
        --     -- wielderStrength = params[1]
        --     -- wielderDexterity = params[2]
        --     -- wielderMovementSpeed = params[3]
            
        --     -- caliburnCheck = true

        --     emulateWielderCheck = true
        --     Ext.Timer.WaitFor(500, function()
        --         emulateWielder(caster) 
        --     end)
        --     print("Stats of melee reproduction traced weapon tracked")
        -- end


        

    end

end)

-- adding appropriate tags
function stringSplitter(inputstr, delim)
    if delim == nil then
        delim = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..delim.."]+)") do
      table.insert(t, str)
    end
    return t
end

function traceTagAdder()
    local meleeWeaponTracker = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker
    meleeWeaponTracker = meleeWeaponTracker or {}
    if #meleeWeaponTracker > 0 then
        for weapon = 1,#meleeWeaponTracker do
            if Ext.Entity.Get(meleeWeaponTracker[weapon]) ~= nil then
                local stats = Ext.Stats.Get(Ext.Entity.Get(meleeWeaponTracker[weapon]).ServerItem.Stats)
                print("PassivesOnEquip: " .. stats.PassivesOnEquip)
                if stats.PassivesOnEquip:match("Githborn") == "Githborn" then
                    if Osi.IsTagged(fakerCharacter, "GITHYANKI") == 0 then
                        Osi.SetTag(fakerCharacter, "GITHYANKI")
                        print("Added Githyanki tag")
                    end
                else
                    if stats.PassivesOnEquip ~= "" then
                        local passiveList = stringSplitter(stats.PassivesOnEquip, ";")
                        for key, passive in pairs(passiveList) do
                            if Ext.Stats.Get(passive).Using ~= "" and Ext.Stats.Get(passive).Using ~= nil then
                                if Ext.Stats.Get(passive).Using:match("Githborn") == "Githborn" then
                                    print("Using: " .. Ext.Stats.Get(passive).Using)
                                    if Osi.IsTagged(fakerCharacter, "677ffa76-2562-4217-873e-2253d4720ba4") == 0 then
                                        Osi.SetTag(fakerCharacter, "677ffa76-2562-4217-873e-2253d4720ba4") -- adding githyanki tag
                                        print("Added Githyanki tag")

                                        Osi.Unequip(fakerCharacter, meleeWeaponTracker[weapon])
                                        Ext.Timer.WaitFor(500, function()
                                            Osi.Equip(fakerCharacter, meleeWeaponTracker[weapon], 0, 0, 0)
                                        end)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

    end

end

Ext.Osiris.RegisterListener("EnteredCombat", 2, "after", function(object, combatGuid)
    if object == fakerCharacter then
        traceTagAdder()
    end

end)

Ext.Osiris.RegisterListener("LeftCombat", 2, "after", function(object, combatGuid)
    if object == fakerCharacter then
        if Osi.IsTagged(object, "677ffa76-2562-4217-873e-2253d4720ba4") == 1 and Osi.IsTagged(object, "e49c027c-6ec6-4158-9afb-8b59236d10fd") == 0 then
            Osi.ClearTag(object, "677ffa76-2562-4217-873e-2253d4720ba4")
            print("Removed Githyanki")
        end

    end

end)


-- weapon tracker
function trackTemplate(weaponSlot, character)
    if weaponSlot[1]:match("Melee") == "Melee" then
        local mainWeapon = GetEquippedItem(character, "Melee Main Weapon")

        if weaponSlot[2] ~= nil then
            local offhandWeapon = GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")
            Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker = {mainWeapon, offhandWeapon}
            print("Main and offhand melee weapons assigned") 
        else
            Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker = {mainWeapon, nil}
            print("Main melee weapon assigned")
        end

        traceTagAdder()

    else
        local mainWeaponRanged = GetEquippedItem(character, "Ranged Main Weapon")

        if weaponSlot[2] ~= nil then
            local offhandWeaponRanged = GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")
            Ext.Entity.Get(fakerCharacter).Vars.rangedWeaponTracker = {mainWeaponRanged, offhandWeaponRanged}
            print("Main and offhand ranged weapons assigned")
        else
            Ext.Entity.Get(fakerCharacter).Vars.rangedWeaponTracker = {mainWeaponRanged, nil}
            print("Main ranged weapon assigned")
        end

    end
    

end

-- cooldown helper
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_MELEE" then
        Ext.Timer.WaitFor(1250,function()
            cooldownHelper("Melee Main Weapon")
            if Osi.HasMeleeWeaponEquipped(object, "Offhand") == 1 or Osi.GetEquippedShield(object) ~= nil then
                cooldownHelper("Melee Offhand Weapon")
            end
    
            -- Osi.ApplyStatus(fakerCharacter, "EMULATE_WIELDER_ADDPASSIVE", -1, 100, fakerCharacter)
        end)
        
    end

    if status == "FAKER_RANGED" then
        Ext.Timer.WaitFor(1250,function()
            cooldownHelper("Ranged Main Weapon")
            if Osi.HasRangedWeaponEquipped(object, "Offhand") == 1 then
                cooldownHelper("Ranged Offhand Weapon")
            end

            -- Osi.ApplyStatus(fakerCharacter, "EMULATE_WIELDER_ADDPASSIVE", -1, 100, fakerCharacter)
        end)

    end
end)

-- Timer for Saving Throw or Trace Equip
Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer)
    if timer == "Fate Saving Throw Timer" then
        savingThrowTimer = nil
    end

end)

-- Emulate Wielder
-- Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID) 
--     if status == "EMULATE_WIELDER_SELFDAMAGE" then
--         if originalStats ~= nil then
--             emulateWielder(object)
--         end

--     end

-- end)

-- trace on
-- Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID) 
--     if caster == fakerCharacter then
--         -- Osi.TimerLaunch("Trace On Timer", 800)
--         Osi.ShowNotification(fakerCharacter, "Trace On!")
--     end

-- end)

-- Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer)
--     if timer == "Trace On Timer" then
--         UseSpell(fakerCharacter, "TRACEON", fakerCharacter)
--     end

-- end)

print("General listeners loaded")