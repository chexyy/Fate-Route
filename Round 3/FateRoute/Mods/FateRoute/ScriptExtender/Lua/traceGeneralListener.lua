Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted traceTable, extraDescriptionTable, and statusApplyTable sync")
    syncAllVariables()

    Ext.Osiris.RegisterListener("CharacterMadePlayer", 1, "after", function(character)
        print("Attempted second traceTable, extraDescriptionTable, and statusApplyTable sync")
        syncAllVariables()
        
    end)
    
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    local spellName = spell:gsub("%d","")
    if spellName == "Shout_TraceWeapon_Template" then
        print(spell .. " found to be a template")
        local observedTraceTemplate = Ext.Stats.Get(spell)
        if observedTraceTemplate.TooltipStatusApply ~= nil and observedTraceTemplate.TooltipStatusApply ~= "" then
            print(spell .. " found to have a tooltip")
            local toolTip = observedTraceTemplate.TooltipStatusApply
            local status = {}
            for capture in toolTip:gmatch("(WEAPON_DESCRIPTION_TEMPLATE%d*)") do
                table.insert(status, capture)   
            end
            _D(status)

            for keyStatus, entryStatus in pairs(status) do
                local entity = Ext.Entity.Get(caster)
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
    end

end)


-- Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(itemTemplate, character)
--     for key,entry in pairs(Ext.Entity.Get(GetItemByTemplateInInventory(itemTemplate,character)).StatusContainer.Statuses) do
--         if entry == "TRACE_RESETCOOLDOWN" then
--             print("Cooldown reset for trace reproduction weapon")
--             local boosts = Ext.Entity.Get(GetItemByTemplateInInventory(itemTemplate,character)).Use.Boosts
--             local mainhandBoosts = Ext.Entity.Get(GetItemByTemplateInInventory(itemTemplate,character)).Use.BoostsOnEquipMainHand
--             local offhandBoosts = Ext.Entity.Get(GetItemByTemplateInInventory(itemTemplate,character)).Use.BoostsOnEquipOffHand
--             resetWeaponCooldowns(fakerCharacter, boosts, mainhandBoosts, offhandBoosts)

--             Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
--             Osi.Equip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter),1,0)

--             local boosts = Ext.Entity.Get(GetItemByTemplateInInventory(itemTemplate,character)).Use.Boosts
--             local mainhandBoosts = Ext.Entity.Get(GetItemByTemplateInInventory(itemTemplate,character)).Use.BoostsOnEquipMainHand
--             local offhandBoosts = Ext.Entity.Get(GetItemByTemplateInInventory(itemTemplate,character)).Use.BoostsOnEquipOffHand
--             resetWeaponCooldowns(fakerCharacter, boosts, mainhandBoosts, offhandBoosts)
            
--         end
--     end

-- end)

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

    -- if localstatusApplyTable ~= {} then
    --     _D(localstatusApplyTable)
    --     for key, entry in pairs(localstatusApplyTable) do
    --         for i = 1,999,1 do
    --             local observedStatusTemplate = Ext.Stats.Get("WEAPON_DESCRIPTION_TEMPLATE" .. i)
    --             if observedStatusTemplate.DisplayName == entry.statusDisplayName then
    --                 print("Description check found at index #" .. i)
    --                 break
    --             elseif observedStatusTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
    --                 observedStatusTemplate:SetRawAttribute("DisplayName", entry.statusDisplayName)
    --                 observedStatusTemplate:SetRawAttribute("Description", entry.statusDescription)
    --                 observedStatusTemplate:SetRawAttribute("DescriptionParam", entry.translatedWeaponDisplayName)
    --                 -- observedStatusTemplate:SetRawAttribute("Boosts", entry.statusBoosts)
    --                 observedStatusTemplate.Icon = entry.statusIcon

    --                 observedStatusTemplate:Sync()
    --                 print("This sync produced a spell for the status template spell: " .. Osi.ResolveTranslatedString(observedStatusTemplate.DisplayName) .. " for template spell #" .. i) 
    --             end
    --         end
    --     end
    -- end

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

-- Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
--     local statusStats = Ext.Stats.Get(status) 

--     local entity = Ext.Entity.Get(object)
--     local localstatusApplyTable = entity.Vars.statusApplyTable or {}
--     if localstatusApplyTable ~= {} then
--         -- checks if status is the same
--         for key, entry in pairs(localstatusApplyTable) do
--             if entry.statusDisplayName == statusStats.DisplayName then
--                 print(Osi.ResolveTranslatedString(entry.statusDisplayName) .. " found in statusApplyTable")
--                 local localextraDescriptionTable = entity.Vars.extraDescriptionTable or {}
--                 -- checks for matching extra description spell
--                 if localextraDescriptionTable ~= {} then
--                     for keyExtra, entryExtra in pairs(localextraDescriptionTable) do
--                         if entryExtra.weaponDisplayName == entry.statusDisplayName then
--                             print(Osi.ResolveTranslatedString(entryExtra.weaponDisplayName) .. " found in extraDescriptionTable")
--                             local spellUsed = entry.statusBoosts
--                             spellUsed = spellUsed:gsub("UnlockSpell","")
--                             spellUsed = spellUsed:gsub("%(","")
--                             spellUsed = spellUsed:gsub("%)","")
--                             print(spellUsed)
--                             Osi.UseSpell(object,spellUsed, object)
--                         end
--                         break
--                     end
--                 end
--                 break
--             end
--         end
--     end

-- end)

-- Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
--     local statusStats = Ext.Stats.Get(status) 

--     local localstatusApplyTable = entity.Vars.statusApplyTable or {}
--     if localstatusApplyTable ~= {} then
--         for key, entry in pairs(localstatusApplyTable) do
--             if entry.statusDisplayName == statusStats.DisplayName then
--                 Osi.RemoveBoosts(object,entry.Boosts, 1, "Reproduction Status Remove","", "")
--                 break
--             end
--         end
--     end
-- end)