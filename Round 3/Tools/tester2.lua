local x, y, z = Osi.GetPosition(GetHostCharacter())
copiedChar = Osi.CreateAt(Osi.GetTemplate(GetHostCharacter()), x+30, y, z+30, 1, 1, "UBW")

function performFunctor(copiedChar)
    Ext.Timer.WaitFor(100, function()
        -- print("Name is " .. copyEntity.DisplayName.UnknownKey.)
        Ext.Timer.WaitFor(100, function()
            Osi.TeleportTo(copiedChar, GetHostCharacter())
            Ext.Timer.WaitFor(100, function()
                print("Using Spell")
                Osi.UseSpell(copiedChar, "Target_Alteration_Arrow_ApplyWeaponFunctor", GetHostCharacter())
                Ext.Timer.WaitFor(1000, function()
                    Osi.TeleportToPosition(copiedChar, 1, 1, 1)
                    Ext.Timer.WaitFor(2000, function()
                        Osi.RequestDeleteTemporary(copiedChar)
                    end)
                end)
            end)
        end)
    end)


end

Ext.Timer.WaitFor(1000, function()
    local copyEntity = Ext.Entity.Get(copiedChar)
    Ext.Entity.Get(copiedChar).LevelUp.LevelUps = _C().LevelUp.LevelUps
    for key, class in pairs(_C().Classes.Classes) do -- classes
        copyEntity.Classes.Classes[key] = class
    end

    Osi.SetLevel(copiedChar, Osi.GetLevel(GetHostCharacter()))

    for key, entry in pairs(_C().Stats) do
        Ext.Entity.Get(copiedChar).Stats[key] = entry 

    end

    Osi.SetStoryDisplayName(copiedChar, tostring(_C().ServerDisplayNameList.Names[2].Name))

    for key, entry in pairs(_C().StatusContainer.Statuses) do
        if Osi.HasActiveStatus(copiedChar, entry) == 0 and entry ~= "FAKER_MELEE" and entry ~= "FAKER_RANGED" and entry ~= "STRUCTURAL_GRASP" then
            Osi.ApplyStatus(copiedChar, entry, 15, -1, copiedChar)
        end

    end
    
    for key, resource in pairs(_C().ActionResources.Resources) do
        copyEntity.ActionResources.Resources[key] = resource
    end

    Osi.CopyCharacterEquipment(copiedChar, GetHostCharacter())
    local meleeWeaponTracker = _C().Vars.meleeWeaponTracker
    meleeWeaponTracker = meleeWeaponTracker or {}
    Ext.Timer.WaitFor(500, function()
        Osi.AddBoosts(copiedChar, "Invisibility()", "Apply Weapon Functors - Arrow", copiedChar)
        if #meleeWeaponTracker == 2 then
            local mainWeapon = Osi.GetTemplate(meleeWeaponTracker[1])
            local offWeapon = Osi.GetTemplate(meleeWeaponTracker[2])

            Osi.TemplateAddTo(mainWeapon,copiedChar,1,0)
            Osi.TemplateAddTo(offWeapon,copiedChar,1,0)

            Ext.Timer.WaitFor(500, function()
                Osi.Equip(copiedChar, GetItemByTemplateInInventory(mainWeapon,copiedChar),1,0)
                Osi.Equip(copiedChar, GetItemByTemplateInInventory(offWeapon,copiedChar),1,0)
                performFunctor(copiedChar)
            end)
        elseif #meleeWeaponTracker == 1 then
            local mainWeapon = Osi.GetTemplate(meleeWeaponTracker[1])

            Osi.TemplateAddTo(mainWeapon,copiedChar,1,0)

            Ext.Timer.WaitFor(500, function()
                Osi.Equip(copiedChar, GetItemByTemplateInInventory(mainWeapon,copiedChar),1,0)
                performFunctor(copiedChar)
            end)
        end
    end)

    Ext.IO.SaveFile("Copy Character.json", Ext.DumpExport(Ext.Entity.Get(copiedChar):GetAllComponents()))
end)

test = Ext.Stats.Create("TRIGGEROFF_MELEE_EXTRA", "StatusData", "TRIGGEROFF_MELEE")

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "before", function(caster, target, spell, spellType, spellElement, storyActionID)
    print("Caster is " .. caster)
    print("Target is " .. target)
    print("Spell is " .. spell)
    print("Spelltype is " .. spellType)

end)

weapon = "d2fe9a24-affd-464a-b757-a48d6f50dd7d"
x,y,z = Osi.GetPosition(GetHostCharacter())
createdObject = Osi.CreateAt(weapon, x, y, z, 1, 1, "UBW")
Ext.Timer.WaitFor(100, function()
    local rarity = Ext.Entity.Get(createdObject).Value.Rarity + 1
    if rarity == 5 then
    Osi.ApplyStatus(createdObject, "REPRODUCTION_LEGENDARY", -1, 100, createdObject)                        
    elseif rarity == 4 then
        Osi.ApplyStatus(createdObject, "REPRODUCTION_VERYRARE", -1, 100, createdObject)
    elseif rarity == 3 then
        Osi.ApplyStatus(createdObject, "REPRODUCTION_RARE", -1, 100, createdObject)
    elseif rarity == 2 then
        Osi.ApplyStatus(createdObject, "REPRODUCTION_UNCOMMON", -1, 100, createdObject)
    end
    Osi.ApplyStatus(createdObject, "REPRODUCTION_MELEE", -1, 100, createdObject)
end)
Osi.ToTransform(createdObject, x, y, z, 1, 90, 90)