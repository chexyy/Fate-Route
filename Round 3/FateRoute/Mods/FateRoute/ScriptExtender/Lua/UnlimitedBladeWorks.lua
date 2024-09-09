function spawnUBW(character, x, y, z)
    Ext.Timer.WaitFor(200, function()
        if x == nil or y == nil or z == nil then
            x, y, z = Osi.GetPosition(character)
            local localUBWCoordinates = {x, y, z + 1}
            local entity = Ext.Entity.Get(character)
            entity.Vars.UBWCoordinates = localUBWCoordinates
            print("Wrote UBWCoordinates to (" .. localUBWCoordinates[1] .. ", " .. localUBWCoordinates[2] .. "," .. localUBWCoordinates[3] .. ")")
        end

        realityMarble = Osi.CreateAt("4567ecad-2304-42db-b8ed-0ca6bb8edfb5", x, y, z+1, 1, 1, "UBW Spawn")
        UBWeffects =  {
            Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 5.25),
            Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 6),
            Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 5.85),
            Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 5.65)
        }
    
        -- UBWClone = Osi.CreateOutOfSightAtDirectionFromObject(Osi.GetTemplate(fakerCharacter), fakerCharacter, fakerCharacter, 1, 0, "UBW")
        -- print("Clone successful")
        -- Ext.Timer.WaitFor(300, function()
        --     Osi.SetLevel(UBWClone, Osi.GetLevel(fakerCharacter))
        --     Osi.SetImmortal(UBWClone, 1)
        --     Osi.ApplyStatus(UBWClone, "INVULNERABLE", -1, 100)
        --     Osi.ApplyStatus(UBWClone, "FATE_CLONE_TOOL", -1, 100)
        --     Osi.SetStoryDisplayName(UBWClone, Osi.GetTranslatedString(GetDisplayName(fakerCharacter)))
        --     -- Osi.AddBoosts(UBWClone, "Invisibility()", "Apply Weapon Functors - Arrow", UBWClone)
        --     Osi.TeleportTo(UBWClone, caster)
        -- end)

        return realityMarble, UBWeffects
    end)

end

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID) 
    if spell == "Shout_Aria_8_UBW" then
        local x, y, z = Osi.GetPosition(caster)
        Osi.CreateProjectileStrikeAt(caster, "Projectile_UBW_Spawn_VFX")
        realityMarble, UBWeffects = spawnUBW(caster, nil, nil, nil)
    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "UBW_PUSH_TRIGGER" then
        print("Detected outside object attempting to break in")
        UseSpell(fakerCharacter, "Target_UBW_Push", object)
    end
    if status == "UBW_PULL_TRIGGER" then
        print("Detected inside object attempting to escape")
        UseSpell(fakerCharacter, "Target_UBW_Pull", object)
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    if (status == "APPLY_ARIA_8" or status == "SEPARATED_FROM_REALITY") and HasActiveStatus(object, "STRUCTURAL_GRASP") == 1 then
        local entity = Ext.Entity.Get(object)
        Osi.RemoveStatus(object, "APPLY_ARIA_8", object)

        local localUBWCoordinates = entity.Vars.UBWCoordinates
        if localUBWCoordinates ~= nil then
            Osi.CreateProjectileStrikeAtPosition(localUBWCoordinates[1], localUBWCoordinates[2], localUBWCoordinates[3], "Projectile_UBW_Delete_VFX")
            Osi.UnloadItem(realityMarble)
            for key, entry in pairs(UBWeffects) do
                Osi.StopLoopEffect(entry)
            end
            UBWeffects = nil
            realityMarble = nil
            entity.Vars.UBWCoordinates = nil
        end
    end

end)

-- Shout Aria
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted extraDescriptionTable and statusApplyTable sync")

    local fakerCharacter = locateFaker()
    syncAllVariables(fakerCharacter)
    local entity = Ext.Entity.Get(fakerCharacter)

    Ext.Vars.RegisterUserVariable("UBWCoordinates", {})
    if UBWCoordinates ~= nil then
        local x, y, z = entity.Vars.UBWCoordinates
        realityMarble, UBWeffects = spawnUBW(fakerCharacter, x, y, z)
    end

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

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID) 
    if spell:match("Shout_Aria") == "Shout_Aria" and spell ~= "Shout_Aria_Dismiss_UBW" then
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

            if Osi.HasPassive(caster, "Passive_Aria_Eight") == 1 then
                print("UBW!")
                Osi.RemoveSpell(caster, "Shout_Aria_8")
                Ext.Timer.WaitFor(150, function()
                    Osi.AddSpell(caster, "Shout_Aria_8_UBW", 0)
                end)
                
            end

        elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_7") == 1 then
            print("Granting aria 8")
            Osi.RemoveStatus(caster, "APPLY_ARIA_7", caster)
            Ext.Timer.WaitFor(50, function()
                Osi.ApplyStatus(caster, "APPLY_ARIA_8", -1, 100, caster)
            end)

            Osi.RemoveSpell(caster, "Shout_Aria_8_UBW")
            Ext.Timer.WaitFor(50, function()
                Osi.AddSpell(caster, "Shout_Aria_Dismiss_UBW", 0)
            end)

        end
    end

    if spell == "Shout_Aria_Dismiss_UBW" then
        addAria(caster)
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
    if status:match("APPLY_ARIA") == "APPLY_ARIA" and status ~= "APPLY_ARIA_6" and status ~= "APPLY_ARIA_7" and status ~= "APPLY_ARIA_8" then
        -- local entity = Ext.Entity.Get(object)
        -- for key, entry in pairs(entity.SpellBook.Spells) do
        --     if (entry.Id.OriginatorPrototype):match("Shout_Aria") == "Shout_Aria" then
        --         print("Removing " .. entry.Id.OriginatorPrototype)
        --         Osi.RemoveSpell(fakerCharacter, entry.Id.OriginatorPrototype)
        --         break
        --     end

        -- end

        Ext.Timer.WaitFor(50, function()
            print("Replaced when status was " .. status)
            addAria(fakerCharacter)
        end)

    end

end)

Ext.Osiris.RegisterListener("RespecCompleted", 1, "after", function(character) 
    if character == fakerCharacter then
        addAria(character)
    end
end)

Ext.Osiris.RegisterListener("LeveledUp", 1, "after", function(character) 
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

    if Osi.HasPassive(character, "Passive_Aria_Eight") == 1 and Osi.HasActiveStatus(character, "APPLY_ARIA_7") == 1 then
        AddSpell(character, "Shout_Aria_8_UBW",0)
    elseif Osi.HasPassive(character, "Passive_Aria_Eight") == 1 then
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

print("UBW Script loaded")