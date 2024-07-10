-- variable sync
function syncAllVariables(character)
    Ext.Vars.RegisterUserVariable("extraDescriptionTable", {})
    Ext.Vars.RegisterUserVariable("bladeReconstitutionTurnCheck", {})
    -- Ext.Vars.RegisterUserVariable("statusApplyTable", {})

    local entity = Ext.Entity.Get(character)
    local localextraDescriptionTable = entity.Vars.extraDescriptionTable or {}
    local bladeReconstitutionTurnCheck = entity.Vars.bladeReconstitutionTurnCheck or 0
    -- local localstatusApplyTable = entity.Vars.statusApplyTable or {}
    
    if localextraDescriptionTable ~= {} then
        if next(localextraDescriptionTable) ~= nil then
            _D(localextraDescriptionTable)
            for key, entry in pairs(localextraDescriptionTable) do
                for i = 1,999,1 do
                    local observedDescriptionTemplate = Ext.Stats.Get("Shout_TraceWeapon_TemplateDescription" .. i)
                    if observedDescriptionTemplate.DisplayName == entry.weaponDisplayName then
                        print("Description check found at index #" .. i)
                        break
                    elseif observedDescriptionTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
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

    fakerCharacter = locateFaker()
    syncAllVariables(fakerCharacter)
    local entity = Ext.Entity.Get(fakerCharacter)

    for keyStatus, entryStatus in pairs(entity.ServerCharacter.StatusManager.Statuses) do
        if entryStatus.StackId:match("ARIA_") == "ARIA_" then
            print("Removing lingering aria " .. entryStatus.StackId)
            Osi.RemoveStatus(fakerCharacter, entryStatus.StackId)
        end
    end 

    if Osi.HasPassive(fakerCharacter, "Passive_Aria_One") == 1 then
        addAria(fakerCharacter)
    end

    
end)

-- apply reproduced trace stats and summon dual weapons if there
Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    local spellName = spell:match("Shout_TraceWeapon_")
    if spellName == "Shout_TraceWeapon_" then
        print(spell .. " found to be a template")
        local observedTraceTemplate = Ext.Stats.Get(spell)
        local entity = Ext.Entity.Get(caster)

        entity.ActionResources.Resources["420c8df5-45c2-4253-93c2-7ec44e127930"][1].Amount = entity.ActionResources.Resources["420c8df5-45c2-4253-93c2-7ec44e127930"][1].Amount - 1 

        local descriptionParams = observedTraceTemplate.DescriptionParams
        local params = {}
        for capture in descriptionParams:gmatch("(%d*%.?%d+)") do
            table.insert(params, capture)   
        end
        print("Params found to be:")
        _D(params)
        
        local templateNum = spell:match("%d+")
        if templateNum ~= nil then
            if observedTraceTemplate.Sheathing == "Melee" then
                wielderStrength = params[1]
                wielderDexterity = params[2]
                wielderMovementSpeed = params[3]
                print("Stats of melee reproduction traced weapon tracked")
            else
                wielderStrengthRanged = params[1]
                wielderDexterityRanged = params[2]
                wielderMovementSpeedRanged = params[3]
                print("Stats of ranged reproduction traced weapon tracked")
            end
            if Osi.HasActiveStatus(caster, "EMULATE_WIELDER_SELFDAMAGE") == 1 then
                emulateWielder(caster, originalStats) 
            end
        end
        if spell == "Shout_TraceWeapon_Caliburn" then
            print("Caliburn cast")
            originalStats = {entity.Stats.Abilities[2], entity.Stats.Abilities[3], entity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount}
            wielderStrength = params[1]
            wielderDexterity = params[2]
            wielderMovementSpeed = params[3]
            
            caliburnCheck = true

            if Osi.HasActiveStatus(caster, "DASH") == 1 then
                originalStats[3] = originalStats[3]/2
            end
            if Osi.HasActiveStatus(caster, "LONGSTRIDER") == 1 then
                originalStats[3] = originalStats[3] - 3
            end

            emulateWielderCheck = true
            print("Stats of melee reproduction traced weapon tracked")
        end


        

    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER_MELEE" then
        Ext.Timer.WaitFor(1250,function()
            cooldownHelper("Melee Main Weapon")
            if Osi.HasMeleeWeaponEquipped(object, "Offhand") == 1 or Osi.GetEquippedShield(object) ~= nil then
                cooldownHelper("Melee Offhand Weapon")
            end
    
        end)
    end

    if status == "FAKER_RANGED" then
        Ext.Timer.WaitFor(1250,function()
            cooldownHelper("Ranged Main Weapon")
            if Osi.HasRangedWeaponEquipped(object, "Offhand") == 1 then
                cooldownHelper("Ranged Offhand Weapon")
            end

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
--             emulateWielder(object, originalStats)
--         end

--     end

-- end)

-- Shout Aria
Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID) 
    if spell == "Shout_Aria_1" or spell == "Shout_Aria_2" or spell == "Shout_Aria_3" or spell == "Shout_Aria_4" or spell == "Shout_Aria_5" or spell == "Shout_Aria_6" or spell == "Shout_Aria_7" or spell == "Shout_Aria_8" then
        print(spell .. " detected")

        if Osi.HasActiveStatus(caster, "APPLY_ARIA_1") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_2") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_3") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_4") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_5") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_6") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_7") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_8") == 0 then
            Osi.ApplyStatus(caster, "APPLY_ARIA_1", 10, 100, caster)

        elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_1") == 1 and Osi.HasPassive(caster, "Passive_Aria_Two") == 1 then
            Osi.ApplyStatus(caster, "APPLY_ARIA_2", 10, 100, caster)

        elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_2") == 1 and Osi.HasPassive(caster, "Passive_Aria_Three") == 1 then
            Osi.ApplyStatus(caster, "APPLY_ARIA_3", 10, 100, caster)

        elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_3") == 1 and Osi.HasPassive(caster, "Passive_Aria_Four") == 1 then
            Osi.ApplyStatus(caster, "APPLY_ARIA_4", 10, 100, caster)

        elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_4") == 1 and Osi.HasPassive(caster, "Passive_Aria_Five") == 1 then
            Osi.ApplyStatus(caster, "APPLY_ARIA_5", 10, 100, caster)

        elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_5") == 1 and Osi.HasPassive(caster, "Passive_Aria_Six") == 1 then
            Osi.ApplyStatus(caster, "APPLY_ARIA_6", 10, 100, caster)

        elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_6") == 1 and Osi.HasPassive(caster, "Passive_Aria_Seven") == 1 then
            Osi.ApplyStatus(caster, "APPLY_ARIA_7", 10, 100, caster)

        elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_7") == 1 and Osi.HasPassive(caster, "Passive_Aria_Eight") == 1 then
            Osi.ApplyStatus(caster, "APPLY_ARIA_8", 10, 100, caster)

        end

    end

end)

Ext.Osiris.RegisterListener("CombatEnded", 1, "before", function(combatGuid) 
    if Osi.CombatGetInvolvedPartyMember(combatGuid,1) == fakerCharacter or Osi.CombatGetInvolvedPartyMember(combatGuid,2) == fakerCharacter or Osi.CombatGetInvolvedPartyMember(combatGuid,3) == fakerCharacter or Osi.CombatGetInvolvedPartyMember(combatGuid,4) == fakerCharacter then

        local entity = Ext.Entity.Get(fakerCharacter)
        for keyStatus, entryStatus in pairs(entity.ServerCharacter.StatusManager.Statuses) do
            if entryStatus.StackId:match("ARIA_") == "ARIA_" then
                print("Removing lingering aria " .. entryStatus.StackId)
                Osi.RemoveStatus(fakerCharacter, entryStatus.StackId)
            end
        end 

    end
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID) 
    if status:match("APPLY_ARIA") == "APPLY_ARIA" then
        local entity = Ext.Entity.Get(object)
        for key, entry in pairs(entity.SpellBook.Spells) do
            if (entry.Id.OriginatorPrototype):match("Shout_Aria") == "Shout_Aria" then
                print("Removing " .. entry.Id.OriginatorPrototype)
                Osi.RemoveSpell(fakerCharacter, entry.Id.OriginatorPrototype)
                break
            end

        end

        Osi.TimerLaunch("Aria Timer", 125)

    end

end)

Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer) 
    if timer == "Aria Timer" then
        addAria(fakerCharacter)

    end

end)

Ext.Osiris.RegisterListener("RespecCompleted", 1, "after", function(character) 
    if character == fakerCharacter then
        addAria(character)
    end
end)

function addAria(character)
    local entity = Ext.Entity.Get(character)
    for key, entry in pairs(entity.SpellBook.Spells) do
        if (entry.Id.OriginatorPrototype):match("Shout_Aria") == "Shout_Aria" then
            Osi.RemoveSpell(character, entry.Id.OriginatorPrototype)
            break
        end

    end

    if Osi.HasPassive(character, "Passive_Aria_Eight") == 1 then
        AddSpell(character, "Shout_Aria_8",0)
    elseif Osi.HasPassive(character, "Passive_Aria_Seven") == 1 then
        AddSpell(character, "Shout_Aria_7",0)
    elseif Osi.HasPassive(character, "Passive_Aria_Six") == 1 then
        AddSpell(character, "Shout_Aria_6",0)
    elseif Osi.HasPassive(character, "Passive_Aria_Five") == 1 then
        AddSpell(character, "Shout_Aria_5",0)
    elseif Osi.HasPassive(character, "Passive_Aria_Four") == 1 then
        AddSpell(character, "Shout_Aria_4",0)
    elseif Osi.HasPassive(character, "Passive_Aria_Three") == 1 then
        AddSpell(character, "Shout_Aria_3",0)
    elseif Osi.HasPassive(character, "Passive_Aria_Two") == 1 then
        AddSpell(character, "Shout_Aria_2",0)
    elseif Osi.HasPassive(character, "Passive_Aria_One") == 1 then
        AddSpell(character, "Shout_Aria_1",0)
    end

end

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