-- sync tables
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted traceTable, extraDescriptionTable, and statusApplyTable sync")
    syncAllVariables()

    Ext.Osiris.RegisterListener("CharacterMadePlayer", 1, "after", function(character)
        print("Attempted second traceTable, extraDescriptionTable, and statusApplyTable sync")
        syncAllVariables()
        
    end)
    
end)

-- apply reproduced trace stats and summon dual weapons if there
Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    local spellName = spell:gsub("%d","")
    if spellName == "Shout_TraceWeapon_Template" then
        print(spell .. " found to be a template")
        local observedTraceTemplate = Ext.Stats.Get(spell)
        local entity = Ext.Entity.Get(caster)
        if observedTraceTemplate.TooltipStatusApply ~= nil and observedTraceTemplate.TooltipStatusApply ~= "" then
            print(spell .. " found to have a tooltip")
            local toolTip = observedTraceTemplate.TooltipStatusApply
            local status = {}
            for capture in toolTip:gmatch("(WEAPON_DESCRIPTION_TEMPLATE%d*)") do
                table.insert(status, capture)   
            end
            _D(status)

            for keyStatus, entryStatus in pairs(status) do
                local observedStatusTemplate = Ext.Stats.Get(entryStatus)
                local localextraDescriptionTable = entity.Vars.extraDescriptionTable or {}

                if localextraDescriptionTable ~= {} then
                    print("Going through localextraDescriptionTable for dual weapons")
                    for key, entry in pairs(localextraDescriptionTable) do
                        print(observedStatusTemplate.DisplayName .. " compared to " .. entry.weaponDisplayName)
                        if observedStatusTemplate.DisplayName == entry.weaponDisplayName then
                            print("Dual weapon status-spell match found for " .. Osi.ResolveTranslatedString(observedStatusTemplate.DisplayName))
                            Osi.TemplateAddTo(entry.weaponTemplate,caster,1,0)
                            if keyStatus == 1 then
                                if entry.meleeOrRanged == "Melee" then
                                    dualWeaponsProjected = true
                                    mainWeaponTemplate = entry.weaponTemplate
                                else
                                    dualWeaponsProjectedRanged = true
                                    mainWeaponTemplateRanged = entry.weaponTemplate
                                end
                            else
                                if entry.meleeOrRanged == "Melee" then
                                    dualWeaponsProjected = true
                                    offhandWeaponTemplate = entry.weaponTemplate
                                    ApplyStatus(caster,"FAKER_MELEE",15,100)
                                else
                                    dualWeaponsProjectedRanged = true
                                    offhandWeaponTemplateRanged = entry.weaponTemplate
                                    ApplyStatus(caster,"FAKER_RANGED",15,100)
                                end
                            end
                        end
                    end
                end
            end
        end

        local descriptionParams = observedTraceTemplate.DescriptionParams
        local params = {}
        for capture in descriptionParams:gmatch("(%d*%.?%d+)") do
            table.insert(params, capture)   
        end
        
        local localTraceTable = entity.Vars.traceTable or {}
        if localTraceTable ~= {} then
            for key, entry in pairs(localTraceTable) do 
                if entry.DisplayName == Osi.ResolveTranslatedString(observedTraceTemplate.DisplayName) then
                    if entry.meleeOrRanged == "Melee" then
                        wielderStrength = params[1]
                        wielderDexterity = params[2]
                        wielderMovementSpeed = params[3]
                        print("Stats of melee reproduction traced weapon applied")
                    else
                        wielderStrengthRanged = params[1]
                        wielderDexterityRanged = params[2]
                        wielderMovementSpeedRanged = params[3]
                        print("Stats of ranged reproduction traced weapon applied")
                    end
                    break
                end
            end
        end

        if Osi.HasActiveStatus(caster, "EMULATE_WIELDER_SELFDAMAGE") == 1 then
           emulateWielder(caster, originalStats) 
        end

    end

end)

-- Timer for Saving Throw or Trace Equip
Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer)
    if timer == "Fate Saving Throw Timer" then
        savingThrowTimer = nil
    end

end)

-- Emulate Wielder
Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
    if (Osi.HasActiveStatus(attackerOwner, "EMULATE_WIELDER_SELFDAMAGE") == 1) and (Osi.HasActiveStatus(attackerOwner, "FAKER_MELEE") == 1 or Osi.HasActiveStatus(attackerOwner, "FAKER_RANGED") == 1) and savingThrowTimer == nil then
        print("Emulate wielder saving throw triggered")
        Osi.RequestPassiveRoll(attackerOwner, attackerOwner, "SavingThrow", "Constitution", "63c8b98d-25dc-455a-84e3-c84d0c12263b", 0, "Emulate Wielder Selfdamage")
        Osi.TimerLaunch("Fate Saving Throw Timer",500)
        savingThrowTimer = true
    end

end)

Ext.Osiris.RegisterListener("RollResult", 6, "after", function(eventName, roller, rollSubject, resultType, isActiveRoll, criticality)
    if eventName == "Emulate Wielder Selfdamage" then 
        if resultType == 0 then
            print("Emulate wielder lost health")
            Osi.ApplyDamage(roller, math.ceil(Osi.GetMaxHitpoints(roller)/5), "Force")
        end
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID) 
    if status == "EMULATE_WIELDER_CHECK" then
        local entity = Ext.Entity.Get(object)
        originalStats = {entity.Stats.Abilities[2], entity.Stats.Abilities[3], entity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount}
        emulateWielder(object, originalStats)
        emulateWielderCheck = true
    end

    if status == "EMULATE_WIELDER_SELFDAMAGE" and emulateWielderCheck == true then
        emulateWielder(object, originalStats)
        print("Attempted to reapply emulate wielder")
    end
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, applyStoryActionID) 
    if status == "EMULATE_WIELDER_SELFDAMAGE" then
        Osi.RemoveBoosts(object, emulateBoost, 1, "Emulate Wielder", "")
    end

end)

Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer)
    if timer == "Emulate Wielder Timer" then
        emulateBoost = emulateBoost
        Osi.AddBoosts(emulateWielderOwner, emulateBoost, "Emulate Wielder", "")
        emulateWielderOwner = nil
    end 

end)

-- variable sync
function syncAllVariables()
    Ext.Vars.RegisterUserVariable("traceTable", {})
    Ext.Vars.RegisterUserVariable("extraDescriptionTable", {})
    -- Ext.Vars.RegisterUserVariable("statusApplyTable", {})

    local entity = Ext.Entity.Get(GetHostCharacter())
    local localTraceTable = entity.Vars.traceTable or {}
    local localextraDescriptionTable = entity.Vars.extraDescriptionTable or {}
    -- local localstatusApplyTable = entity.Vars.statusApplyTable or {}
    
    if localextraDescriptionTable ~= {} then
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
                    observedDescriptionTemplate:SetRawAttribute("Sheathed", entry.meleeOrRanged)
                    observedDescriptionTemplate.FollowUpOriginalSpell = entry.followUpSpell
                    observedDescriptionTemplate.Icon = entry.weaponIcon
                    observedDescriptionTemplate:Sync()

                    local observedStatusTemplate = Ext.Stats.Get("WEAPON_DESCRIPTION_TEMPLATE" .. i) 
                    observedStatusTemplate:SetRawAttribute("DisplayName", entry.weaponDisplayName)
                    observedStatusTemplate.DescriptionParams = Osi.ResolveTranslatedString(entry.weaponDisplayName)
                    observedStatusTemplate.Icon = entry.weaponIcon
                    observedStatusTemplate:Sync()

                    print("This sync produced a spell for the description and status template: " .. Osi.ResolveTranslatedString(observedDescriptionTemplate.DisplayName) .. " for template #" .. i) 
                end
            end
        end
    end

    if localTraceTable ~= {} then
        _D(localTraceTable)
        for key, entry in ipairs(localTraceTable) do
            for i=1,999,1 do
                local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                if observedTraceTemplate.DisplayName == entry.DisplayName then
                    print("Found at index #" .. i)
                    break
                elseif observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                    -- copying over stats
                    Ext.Loca.UpdateTranslatedString(entry.Name, entry.Name)
                    observedTraceTemplate:SetRawAttribute("DisplayName", entry.DisplayName)
                    observedTraceTemplate.Icon = entry.Icon
                    observedTraceTemplate:SetRawAttribute("SpellProperties", entry.spellProperties)
                    observedTraceTemplate.UseCosts = entry.UseCosts

                    if entry.tooltipApply ~= nil then
                        observedTraceTemplate:SetRawAttribute("tooltipApply", tooltipApply)
                    else
                    
                    end

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

end



print("General listeners loaded")