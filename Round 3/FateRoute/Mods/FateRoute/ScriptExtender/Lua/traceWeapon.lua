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

        end
        if offhandWeaponTemplate ~= nil then
            Osi.Equip(object,GetItemByTemplateInInventory(offhandWeaponTemplate,object),1,0)
        end 
    end

end)

Ext.Osiris.RegisterListener("TemplateEquipped", 2, "after", function(itemTemplate, character)
    if itemTemplate == mainWeaponTemplate then
        print("Mainhand item equipped")
        -- becoming trace-able
        -- doing action
        local entity = Ext.Entity.Get(character)
        local localTraceTable = entity.Vars.traceTable or {}
        local foundWeapon = 0
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
        -- becoming trace-able
        -- doing action
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
            Osi.Unequip(object,GetItemByTemplateInInventory(mainWeaponTemplate,object))
            Osi.TemplateRemoveFrom(mainWeaponTemplate, object, 1)
            mainWeaponTemplate = nil
        end

        if offhandWeaponTemplate ~= nil then
            Osi.Unequip(object,GetItemByTemplateInInventory(offhandWeaponTemplate,object))
            Osi.TemplateRemoveFrom(offhandWeaponTemplate, object, 1)
            offhandWeaponTemplate = nil
        end
    end

end)