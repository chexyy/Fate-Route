Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    local fakerCharacter = object
    
    if status == "FAKER_MELEE" then
        local mainWeapon = GetEquippedItem(fakerCharacter, "Melee Main Weapon")
        if mainWeapon ~= nil then
            local mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
            if mainWeaponTemplate ~= nil then
                Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
                Osi.TemplateRemoveFrom(mainWeaponTemplate, fakerCharacter, 1)
                print("Attempted to remove " .. mainWeaponTemplate)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                Osi.UnloadItem(mainWeaponTemplate)
            end
        else
            if mainWeaponTemplate ~= nil then
                Osi.UnloadItem(mainWeaponTemplate)
            end
        end

        local offhandWeapon = GetEquippedItem(fakerCharacter, "Melee Offhand Weapon")
        if offhandWeapon ~= nil then
            local offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
            if offhandWeaponTemplate ~= nil then
                Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter))
                Osi.TemplateRemoveFrom(offhandWeaponTemplate, fakerCharacter, 1)
                Osi.UnloadItem(offhandWeaponTemplate)
                print("Attempted to remove " .. offhandWeaponTemplate)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                Osi.UnloadItem(offhandWeaponTemplate)
            end
        else
            if offhandWeaponTemplate ~= nil then
                Osi.UnloadItem(offhandWeaponTemplate)
            end
        end
        
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariables = {}

        wielderStrength = 0
        wielderDexterity = 0
        wielderMovementSpeed = 0
        wielderName = ""
        offhandWeaponTemplate = nil
        mainWeaponTemplate = nil
    end

    if status == "FAKER_RANGED" then 
        local mainWeaponRanged = GetEquippedItem(fakerCharacter, "Ranged Main Weapon")
        if mainWeaponRanged ~= nil then
            local mainWeaponTemplateRanged = Osi.GetTemplate(mainWeaponRanged)
            if mainWeaponTemplateRanged ~= nil then    
                Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter))
                Osi.TemplateRemoveFrom(mainWeaponTemplateRanged, fakerCharacter, 1)
                print("Attempted to remove " .. mainWeaponTemplateRanged)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                Osi.UnloadItem(mainWeaponTemplateRanged)
            end
        else
            if mainWeaponTemplateRanged ~= nil then
                Osi.UnloadItem(mainWeaponTemplateRanged)
            end
        end

        local offhandWeaponRanged = GetEquippedItem(fakerCharacter, "Ranged Offhand Weapon")
        if offhandWeaponRanged ~= nil then
            local offhandWeaponTemplateRanged = Osi.GetTemplate(offhandWeaponRanged)
            if offhandWeaponTemplateRanged ~= nil then
                Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter))
                Osi.TemplateRemoveFrom(offhandWeaponTemplateRanged, fakerCharacter, 1)
                print("Attempted to remove " .. offhandWeaponTemplateRanged)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                Osi.UnloadItem(offhandWeaponTemplateRanged)
            end
        else
            if offhandWeaponTemplateRanged ~= nil then
                Osi.UnloadItem(offhandWeaponTemplateRanged)
            end
        end
        
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.traceVariablesRanged = {}

        wielderStrengthRanged = 0
        wielderDexterityRanged = 0
        wielderMovementSpeedRanged = 0
        wielderNameRanged = ""
        offhandWeaponTemplateRanged = nil
        mainWeaponTemplateRanged = nil
    end

end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "before", function(caster, target, spellName, spellType, spellElement, storyActionID) 
    if spellName == "Throw_Alteration_Arrow" then
        if (Osi.HasPassive(caster, "MAG_HomingWeapon_Passive") == 0) then
            if HasMeleeWeaponEquipped(caster, "Mainhand") == 1 then
                mainWeaponTemplateArrow = GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")
            end
            if HasMeleeWeaponEquipped(caster, "Offhand") == 1 then
                offhandWeaponTemplateArrow = GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")
            end
            print("Detected alteration arrow used")
            Osi.TimerLaunch("Alteration Arrow", 4000)
        else
            Osi.TimerLaunch("Alteration Arrow: Returning", 4000)
        end
    end
end)

Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer)
    if timer == "Alteration Arrow" then
        if mainWeaponTemplateArrow ~= nil then
            Osi.UnloadItem(mainWeaponTemplateArrow)
            mainWeaponTemplateArrow = nil
            print("Main weapon attempted to be deleted from alteration arrow")
        end
        if offhandWeaponTemplateArrow ~= nil then
            Osi.UnloadItem(offhandWeaponTemplateArrow)
            offhandWeaponTemplateArrow = nil
            print("Offhand weapon attempted to be deleted from alteration arrow")
        end
        if HasMeleeWeaponEquipped(fakerCharacter, "Mainhand") == 0 then
            Osi.RemoveStatus(fakerCharacter,"FAKER_MELEE")
        end

        print("Shot weapon attempted to be deleted end")
    elseif timer == "Alteration Arrow: Returning" then
        Osi.ApplyStatus(GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter), "REPRODUCTION_MELEE", GetStatusTurns(fakerCharacter, "FAKER_MELEE")*5, 100, fakerCharacter)
    end

end)

print("Weapon listeners loaded")