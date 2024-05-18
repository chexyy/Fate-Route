Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == "Target_TraceWeapon" then

        if HasAppliedStatus(caster,"FAKER") then
            Osi.RemoveStatus(caster,"FAKER")
        end
        local uuid_pattern = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
        local beginningIndex, endingIndex = string.find(target, uuid_pattern)
        local targetUUID = string.sub(target,beginningIndex,endingIndex)
        
        if GetEquippedItem(targetUUID, "Melee Offhand Weapon") ~= nil then
            local offhandWeapon = GetEquippedItem(targetUUID, "Melee Offhand Weapon")
            offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
            Osi.TemplateAddTo(offhandWeaponTemplate,GetHostCharacter(),1,0) -- Gives offhand item

            offhandWeaponIcon = Ext.Entity.Get(Osi.GetEquippedItem(target, "Melee Offhand Weapon")):GetComponent("Icon").Icon
            offhandWeaponNameHandle = GetDisplayName(GetEquippedItem(target, "Melee Offhand Weapon"))
        end
        local mainWeapon = GetEquippedItem(targetUUID, "Melee Main Weapon")
        mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
        Osi.TemplateAddTo(mainWeaponTemplate,GetHostCharacter(),1,0) -- Gives item

        mainWeaponIcon = Ext.Entity.Get(Osi.GetEquippedItem(target, "Melee Main Weapon")):GetComponent("Icon").Icon
        mainWeaponNameHandle = GetDisplayName(GetEquippedItem(target, "Melee Main Weapon"))

        ApplyStatus(GetHostCharacter(),"FAKER",5,100)
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER" and mainWeaponTemplate ~= nil then
        Osi.Equip(GetHostCharacter(),GetItemByTemplateInInventory(mainWeaponTemplate,GetHostCharacter()),1,0)

        if offhandWeaponTemplate ~= nil then
            Osi.Equip(GetHostCharacter(),GetItemByTemplateInInventory(offhandWeaponTemplate,GetHostCharacter()),1,0)
        end
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    if status == "FAKER" then
        local spellName = "Trace_" .. string.gsub(mainWeaponTemplate,"_%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x","")
        if Ext.Stats.Get(spellName) == nil then
            local traceVarMainHand = Ext.Stats.Create(spellName, "SpellData", "Shout_TraceWeapon_Template")
            traceVarMainHand.Icon = mainWeaponIcon
            -- traceVarMainHand.DisplayName = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).DisplayName.NameKey.Handle.Handle
            traceVarMainHand.UseCosts = "BonusActionPoint:1;MagicalEnergy:0"
            
            local mainWeaponUUID = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).ServerItem.Template.Id
            traceVarMainHand:SetRawAttribute("DisplayName", Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).DisplayName.NameKey.Handle.Handle)
            traceVarMainHand:SetRawAttribute("SpellProperties", "AI_IGNORE:SummonInInventory(" .. mainWeaponUUID .. ",2,1,true,true,true,,,,,KNOCKED_OUT_SUMMON_DISMISS)")
            traceVarMainHand:SetRawAttribute("TargetConditions", "Self()")
            traceVarMainHand:SetRawAttribute("TargetRadius", "1.5")
            traceVarMainHand:SetRawAttribute("MaximumTargets", "2")
            
            -- .. ";SummonInInventory(" .. tostring(mainWeaponUUID) .. ",2,1,true,true,true)"

            -- sets use cost based on rarity
            if Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Value.Rarity == 0 then
                traceVarMainHand.UseCosts = "BonusActionPoint:1;MagicalEnergy:1"
            elseif Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Value.Rarity == 1 then
                traceVarMainHand.UseCosts = "BonusActionPoint:1;MagicalEnergy:2"
            elseif Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Value.Rarity == 2 then
                traceVarMainHand.UseCosts = "BonusActionPoint:1;MagicalEnergy:3"
            elseif Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Value.Rarity == 3 then
                traceVarMainHand.UseCosts = "BonusActionPoint:1;MagicalEnergy:4"
            elseif Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Value.Rarity == 4 then
                traceVarMainHand.UseCosts = "BonusActionPoint:1;MagicalEnergy:5"
            else
                traceVarMainHand.UseCosts = "BonusActionPoint:1;MagicalEnergy:2"
            end
        
            -- adding to spell
            local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")
            local containerList = baseSpell.ContainerSpells
            containerList = containerList .. spellName

            local baseSpellTest = Ext.Stats.Get("Shout_TraceWeapon_Test")
            local containerListTest = baseSpellTest.ContainerSpells
            containerListTest = containerListTest .. spellName


            -- in the case of a secondary weapon
            if offhandWeaponTemplate ~= nil then
                

            end

            traceVarMainHand:Sync()

            
            baseSpell.ContainerSpells = containerList
            baseSpellTest.ContainerSpells = containerListTest
            baseSpell:Sync()
            baseSpellTest:Sync()
        end
        
        Osi.Unequip(GetHostCharacter(),GetItemByTemplateInInventory(mainWeaponTemplate,GetHostCharacter()))
        Osi.TemplateRemoveFrom(mainWeaponTemplate, GetHostCharacter(), 1)

        if offhandWeaponTemplate ~= nil then
            Osi.Unequip(GetHostCharacter(),GetItemByTemplateInInventory(offhandWeaponTemplate,GetHostCharacter()))
            Osi.TemplateRemoveFrom(offhandWeaponTemplate, GetHostCharacter(), 1)
        end
    end

end)

-- Ext.Osiris.RegisterListener("TemplateUnequipped", 2, "after", function(itemTemplate,character)
--     if itemTemplate == mainWeaponTemplate then
--         Osi.AddSpell(GetHostCharacter(), "Trace_" .. string.gsub(mainWeaponTemplate,"_%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x",""), "SpellData", "Shout_TraceWeapon_Template")
--     end

-- end)

-- print(Ext.Stats.Get(string.gsub(Osi.GetTemplate(GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")),"_%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x","")))
-- print(string.gsub(Osi.GetTemplate(GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")),"_%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x",""))
-- print(Ext.Stats.Get("MAG_Invisible_Pike").Rarity)
-- print(Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Use.BoostsOnEquipMainHand)
-- print(Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).ServerItem.Template.Id)
-- print(Ext.GetStatString(GetEquippedItem(GetHostCharacter(),"Melee Main Weapon")))
-- print(GetUUID(GetEquippedItem(GetHostCharacter(),"Melee Main Weapon")))