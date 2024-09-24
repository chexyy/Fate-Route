function spawnUBW(character, x, y, z)
    Ext.Timer.WaitFor(125, function()
        local entity = Ext.Entity.Get(character)
        if x == nil or y == nil or z == nil then
            x, y, z = Osi.GetPosition(character)
            local localUBWCoordinates = {x, y, z + 1}
            entity.Vars.UBWCoordinates = localUBWCoordinates
            print("Wrote UBWCoordinates to (" .. localUBWCoordinates[1] .. ", " .. localUBWCoordinates[2] .. "," .. localUBWCoordinates[3] .. ")")
        end

        -- spawning boundary
            realityMarble = Osi.CreateAt("4567ecad-2304-42db-b8ed-0ca6bb8edfb5", x, y, z, 1, 1, "UBW Spawn")
            Osi.SetMovable(realityMarble, 0)
            Osi.SetMovable(realityMarble, 1)
            UBWeffects =  {
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 5.25),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 6),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 5.85),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 5.65)

                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x-2, y+1, z, 5.6),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x-2, y+1, z, 6.35),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x-2, y+1, z, 6.1),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x-2, y+1, z, 6)
                Osi.PlayLoopEffectAtPosition("11746d2f-93d6-44c3-9b80-44929199f1da", x, y, z, 1)
            }

        -- spawning weapons
            local localWeaponCatalog = entity.Vars.weaponCatalog
            local weaponList = {}
            for weaponKey = 1,26,1 do -- cycles through weapon types
                local specificWeaponList = {} -- selects weapons from each weapon type
                for rarity = 5,1,-1 do -- cycles through each rarity
                    if localWeaponCatalog[weaponKey][rarity] ~= nil  then
                        -- if next(localWeaponCatalog[weaponKey][rarity]) ~= nil and #specificWeaponList < 7 then
                        if next(localWeaponCatalog[weaponKey][rarity]) ~= nil then
                            -- print("Running inorderTraversalUBW")
                            -- specificWeaponList = inorderTraversalUBW(localWeaponCatalog[weaponKey][rarity], specificWeaponList, weaponKey, rarity, math.random() > 0.5)
                            specificWeaponList = inorderTraversalUBWnotRandom(localWeaponCatalog[weaponKey][rarity], specificWeaponList, weaponKey, rarity)
                        end
                    end
                end
                for i =1, #specificWeaponList do -- concatenates tables
                    weaponList[#weaponList+1] = specificWeaponList[i]
                end
            end 
            _D(weaponList)
            createdObjectList = {}
            UBWSpawnTimer = true
            for key, entry in pairs(weaponList) do
                Ext.Timer.WaitFor(math.random(200,1500), function()
                    UBWWeaponTransform(entry, x, y, z)
                end)
            end
            -- Ext.Timer.WaitFor(2500, function()
            --     print("Created object List")
            --     _D(createdObjectList)
            -- end)

        -- spawning push/pull clone
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

function UBWWeaponTransform(weapon, x, y, z)
    -- Ext.Timer.WaitFor(math.random(100, 220), function()
        UBWSpawnTimer = false
        local radius = math.random(45,145)/10
        local angle = math.random(2*3.14*100)/100
        local xWeapon = radius*math.cos(angle)
        local zWeapon = radius*math.sin(angle)
        local createdObject = Osi.CreateAt(weapon, x+xWeapon, y+50, z+zWeapon, 1, 1, "UBW")

        Ext.Timer.WaitFor(250, function()
            if createdObject ~= nil then 
                local heightDiff = 0.15
                heightDiff = Ext.Entity.Get(createdObject).Bound.Bound.AIBounds["Hit"].Size or 0.15
                Osi.ToTransform(createdObject, x+xWeapon, y+50, z+zWeapon, 1, 90, 90)
                Osi.TeleportToPosition(createdObject, x+xWeapon, y+50, z+zWeapon, "UBW Weapon Creation Teleport", 0, 0, 0, 0, 1)
                local x, y, z = Osi.GetPosition(createdObject)
                Osi.TeleportToPosition(createdObject, x, y+heightDiff, z, "UBW Weapon Creation Teleport", 0, 0, 0, 0, 0)
                -- Osi.CreateProjectileStrikeAt(createdObject, "Projectile_UBW_WeaponSpawn_VFX")
                Osi.PlayEffectAtPosition("fe512e56-8f48-31b5-7432-6e1d1d091881", x, y+heightDiff, z, 1)
                print("Placed " .. Ext.Loca.GetTranslatedString(Ext.Entity.Get(createdObject).DisplayName.NameKey.Handle.Handle))
                
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
                    Osi.ApplyStatus(createdObject, "REPLICATED_WITHIN", -1, 100, createdObject)

                end)

                local x5, y5, z5 = Osi.GetPosition(createdObject)
                _D({createdObject, {x5,y5,z5}})
                if createdObjectList == nil then
                    createdObjectList = {}
                end
                table.insert(createdObjectList, {createdObject, {x5,y5,z5}})
            end
            UBWSpawnTimer = true
        end)
    -- end)

end

function inorderTraversalUBWnotRandom(wepTypeRarity, weaponList, weaponType, rarity)
    if wepTypeRarity ~= nil and wepTypeRarity ~= {} then

        -- left
            if (wepTypeRarity.left ~= nil) then
                weaponList = inorderTraversalUBWnotRandom(wepTypeRarity.left, weaponList, weaponType, rarity, math.random() > 0.5)
            end

        -- parent
            local found = false
            local weapon = wepTypeRarity.data.spellProperties:match("[%w]+-[%w]+-[%w]+-[%w]+-[%w]+")
            for key, entry in pairs(weaponList) do
                if entry == weapon then
                    found = true
                    break
                end
            end
            if found == false then
                table.insert(weaponList, weapon)
                -- print("Added " .. weapon .. " to specific weapon List")
                -- _D(weaponList)
            end 
                
        -- right
            if (wepTypeRarity.right ~= nil) then
                weaponList = inorderTraversalUBWnotRandom(wepTypeRarity.right, weaponList, weaponType, rarity, math.random() > 0.5)
            end

            return weaponList

    end

end


function inorderTraversalUBW(wepTypeRarity, weaponList, weaponType, rarity, randomCheck)
    if wepTypeRarity ~= nil and wepTypeRarity ~= {} then

        -- left
            if (wepTypeRarity.left ~= nil) and #weaponList < 7 then
                weaponList = inorderTraversalUBW(wepTypeRarity.left, weaponList, weaponType, rarity, math.random() > 0.5)
            end

        -- parent
            local found = false
            local weapon = wepTypeRarity.data.spellProperties:match("[%w]+-[%w]+-[%w]+-[%w]+-[%w]+")
            if randomCheck == true and #weaponList < 7 then
                for key, entry in pairs(weaponList) do
                    if entry == weapon then
                        found = true
                        break
                    end
                end
                if found == false then
                    table.insert(weaponList, weapon)
                    -- print("Added " .. weapon .. " to specific weapon List")
                    -- _D(weaponList)
                end 
            end
                
        -- right
            if (wepTypeRarity.right ~= nil) and #weaponList < 7 then
                weaponList = inorderTraversalUBW(wepTypeRarity.right, weaponList, weaponType, rarity, math.random() > 0.5)
            end

            return weaponList

    end

end

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID) 
    if spell == "Shout_Aria_8_UBW" then
        local x, y, z = Osi.GetPosition(caster)
        -- Osi.CreateProjectileStrikeAt(caster, "Projectile_UBW_Spawn_VFX")
        -- Osi.CreateProjectileStrikeAt(caster, "Projectile_UBW_Delete_VFX")
        realityMarble, UBWeffects = spawnUBW(caster, nil, nil, nil)
    end

end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spell, spellType, spellElement, storyActionID) 

    if spell == "Target_UBW_InfiniteSwordDance" then
        local shotWeaponList = {}

        -- farthest/closest weapons
        -- for key, entryObject in pairs(createdObjectList) do
        --     if #shotWeaponList < 5 then
        --         table.insert(shotWeaponList,entryObject)
        --     else
        --         for i = 1, #shotWeaponList do
        --             if Osi.GetDistanceTo(shotWeaponList[i][1],target) < Osi.GetDistanceTo(entryObject[1],target) then
        --                local found = false
        --                 for j = 1, #shotWeaponList do
        --                     if shotWeaponList[j][1] == entryObject[1] then
        --                         found = true
        --                         break
        --                     end
        --                 end

        --                 if found == false then
        --                     print("Replacing " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(shotWeaponList[i][1])) .. " (distance: " .. Osi.GetDistanceTo(shotWeaponList[i][1],target) .. ") with " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(entryObject[1])) .. " (distance: " .. Osi.GetDistanceTo(entryObject[1],target) .. ")")
        --                     shotWeaponList[i] = entryObject
        --                 end
        --             end
        --         end
        --     end
        -- end

        -- random
        table.insert(shotWeaponList, createdObjectList[math.random(#createdObjectList)])
        for i = 1,6 do
            local weapon = createdObjectList[math.random(#createdObjectList)]
            local found = false
            for j = 1, #shotWeaponList do
                if shotWeaponList[j][1] == weapon[1] then
                    found = true
                    break
                end
            end

            if found == false then
                table.insert(shotWeaponList, weapon)
            end

        end

        -- in sight
        -- while #shotWeaponList < 7 do
        --     local weapon = createdObjectList[math.random(#createdObjectList)]
        --     local found = false
        --     for j = 1, #shotWeaponList do
        --         if shotWeaponList[j][1] == weapon[1] then
        --             found = true
        --             break
        --         end
        --     end

        --     if found == false and Osi.HasLineOfSight(weapon[1], target) == 1then
        --         table.insert(shotWeaponList, weapon)
        --     end

        -- end
        
        print("Final shot weapon list")
        for i = 1, #shotWeaponList do
            print(Osi.ResolveTranslatedString(Osi.GetDisplayName(shotWeaponList[i][1])) .. " (distance: " .. Osi.GetDistanceTo(shotWeaponList[i][1],target) .. ")")
        end

        for key, entryShot in pairs(shotWeaponList) do
            -- Osi.AddBoosts(entryShot[1], "Attribute(Floating)", "UBW - Infinite Sword Dance - Float", caster)
            Osi.SetGravity(entryShot[1],1)
            Osi.ItemMoveToPosition(entryShot[1], entryShot[2][1], entryShot[2][2]+6.5, entryShot[2][3], 1.75, 1, "UBW - Infinite Sword Dance")
            Osi.SteerTo(entryShot[1], target, 0)
            Ext.Timer.WaitFor(150, function()
                print("Moved " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(entryShot[1])))
                Osi.UseSpell(caster, "Throw_UBW_Manipulation", target, entryShot[1],1)
                -- Osi.CreateProjectileStrikeAt(entryShot[1], "Projectile_UBW_InfiniteSwordDanceMove_VFX")
            end)
        end
    end

end)

Ext.Osiris.RegisterListener("OnThrown", 7, "after", function(thrownObject, thrownObjectTemplate, thrower, storyActionID, throwPosX, throwPosY, throwPosZ) 

    if Osi.HasActiveStatus(thrownObject, "REPLICATED_WITHIN") == 1 then
        Osi.SetGravity(thrownObject, 1)
        Osi.CreateProjectileStrikeAtPosition(throwPosX, throwPosY, throwPosZ, "Projectile_UBW_InfiniteSwordDanceMove_VFX")
        Ext.Timer.WaitFor(math.random(600,1350), function()
            print("Throw detected for " .. thrownObject)
            -- Ext.Timer.WaitFor(math.random(600,1350), function()
                for i = 1, #createdObjectList do
                    if createdObjectList[i][1] == thrownObject:match("[%w]+-[%w]+-[%w]+-[%w]+-[%w]+") then
                        local x2,y2,z2 = Osi.GetPosition(createdObjectList[i][1])
                        -- Osi.CreateProjectileStrikeAt(createdObjectList[i][1], "Projectile_UBW_WeaponSpawn_VFX")
                        Osi.PlayEffectAtPosition("fe512e56-8f48-31b5-7432-6e1d1d091881", x2, y2, z2, 1)
                        local x = createdObjectList[i][2][1]
                        local y = createdObjectList[i][2][2]
                        local z = createdObjectList[i][2][3]
                        Osi.ToTransform(createdObjectList[i][1], x, y, z, 1, 90, 90)
                        Osi.TeleportToPosition(createdObjectList[i][1], x, y, z, "UBW Weapon Creation Teleport", 0, 0, 0, 0, 0)
                        -- Osi.CreateProjectileStrikeAt(createdObjectList[i][1], "Projectile_UBW_WeaponSpawn_VFX")
                        Osi.PlayEffectAtPosition("fe512e56-8f48-31b5-7432-6e1d1d091881", x, y, z, 1)

                        print("Moving back: " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(createdObjectList[i][1])) .. " to (" .. x .. ", " .. y .. ", z)" .. " id: " .. createdObjectList[i][1])
                        break
                    end
                end

            -- end)
        end)
    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "UBW_PUSH_TRIGGER" then
        print("Detected outside object attempting to break in")
        UseSpell(fakerCharacter, "Target_UBW_Push", object,object,1)
    end
    if status == "UBW_PULL_TRIGGER" then
        print("Detected inside object attempting to escape")
        UseSpell(fakerCharacter, "Target_UBW_Pull", object,object,1)
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    if (status == "APPLY_ARIA_8" or status == "SEPARATED_FROM_REALITY") and HasActiveStatus(object, "STRUCTURAL_GRASP") == 1 then
        local entity = Ext.Entity.Get(object)
        Osi.RemoveStatus(object, "APPLY_ARIA_8", object)
        addAria(object)

        Ext.Timer.WaitFor(800, function()
            local localUBWCoordinates = entity.Vars.UBWCoordinates
            if localUBWCoordinates ~= nil then
                -- Osi.CreateProjectileStrikeAtPosition(localUBWCoordinates[1], localUBWCoordinates[2], localUBWCoordinates[3], "Projectile_UBW_Delete_VFX")
                Osi.UnloadItem(realityMarble)
                for key, entry in pairs(UBWeffects) do
                    Osi.StopLoopEffect(entry)
                end
                for key, entry in pairs(createdObjectList) do
                    Osi.UnloadItem(entry[1])
                end
                UBWeffects = nil
                realityMarble = nil
                entity.Vars.UBWCoordinates = nil
            end
        end)
    end

    if status == "APPLY_ARIA_7" then
        addAria(object)

    end

end)

Ext.Osiris.RegisterListener("TurnEnded", 1, "before", function(object) 
    if HasActiveStatus(object, "APPLY_ARIA_8") == 1 then
        if Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount <= 15 then
            Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount - Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount
            Osi.RemoveStatus(object,"APPLY_ARIA_8",object)
            print("Not enough magical energy")
        else
            Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount - 15
        end

    end

    if HasActiveStatus(object, "UBW_PUSH_TRIGGER") == 1 then
        print("Detected outside object still stuck trying to break in")
        UseSpell(fakerCharacter, "Target_UBW_Push", object,object,1)
    end

    if HasActiveStatus(object, "UBW_PULL_TRIGGER") == 1 then
        print("Detected insde object still stuck trying to escape in")
        UseSpell(fakerCharacter, "Target_UBW_Pull", object,object,1)
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

Ext.Osiris.RegisterListener("TurnEnded", 1, "before", function(object) 
    if HasActiveStatus(object, "STRUCTURAL_GRASP") == 1 then
        Ext.Timer.WaitFor(350, function()
            local entity = Ext.Entity.Get(object)
            for keyStatus, entryStatus in pairs(entity.ServerCharacter.StatusManager.Statuses) do
                if entryStatus.StackId:match("ARIA_") == "ARIA_" then
                    print("Removing lingering aria " .. entryStatus.StackId)
                    Osi.RemoveStatus(object, entryStatus.StackId)
                end
            end 
        end)
    end

end)


Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID) 
    if spell:match("Shout_Aria") == "Shout_Aria" and spell ~= "Shout_Aria_Dismiss_UBW" then
        print(spell .. " detected")

        -- if Osi.HasActiveStatus(caster, "APPLY_ARIA_1") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_2") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_3") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_4") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_5") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_6") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_7") == 0 and Osi.HasActiveStatus(caster, "APPLY_ARIA_8") == 0 then
        --     Osi.ApplyStatus(caster, "APPLY_ARIA_1", 10, 100, caster)

        -- elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_1") == 1 and Osi.HasPassive(caster, "Passive_Aria_Two") == 1 then
        --     Osi.ApplyStatus(caster, "APPLY_ARIA_2", 10, 100, caster)

        -- elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_2") == 1 and Osi.HasPassive(caster, "Passive_Aria_Three") == 1 then
        --     Osi.ApplyStatus(caster, "APPLY_ARIA_3", 10, 100, caster)

        -- elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_3") == 1 and Osi.HasPassive(caster, "Passive_Aria_Four") == 1 then
        --     Osi.ApplyStatus(caster, "APPLY_ARIA_4", 10, 100, caster)

        -- elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_4") == 1 and Osi.HasPassive(caster, "Passive_Aria_Five") == 1 then
        --     Osi.ApplyStatus(caster, "APPLY_ARIA_5", 10, 100, caster)

        -- elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_5") == 1 and Osi.HasPassive(caster, "Passive_Aria_Six") == 1 then
        --     Osi.ApplyStatus(caster, "APPLY_ARIA_6", 10, 100, caster)

        -- elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_6") == 1 and Osi.HasPassive(caster, "Passive_Aria_Seven") == 1 then
        --     Osi.ApplyStatus(caster, "APPLY_ARIA_7", 10, 100, caster)

        --     if Osi.HasPassive(caster, "Passive_Aria_Eight") == 1 then
        --         print("UBW!")
        --         Osi.RemoveSpell(caster, "Shout_Aria_8")
        --         Ext.Timer.WaitFor(150, function()
        --             Osi.AddSpell(caster, "Shout_Aria_8_UBW", 0)
        --         end)
                
        --     end

        -- elseif Osi.HasActiveStatus(caster, "APPLY_ARIA_7") == 1 then
        --     print("Granting aria 8")
        --     Osi.RemoveStatus(caster, "APPLY_ARIA_7", caster)
        --     Ext.Timer.WaitFor(50, function()
        --         Osi.ApplyStatus(caster, "APPLY_ARIA_8", -1, 100, caster)
        --     end)

        --     Osi.RemoveSpell(caster, "Shout_Aria_8_UBW")
        --     Ext.Timer.WaitFor(50, function()
        --         Osi.AddSpell(caster, "Shout_Aria_Dismiss_UBW", 0)
        --     end)

        -- end

        if Osi.HasActiveStatus(caster, "APPLY_ARIA_7") == 1 then
            Osi.RemoveSpell(caster, "Shout_Aria_8_UBW")
            Ext.Timer.WaitFor(50, function()
                Osi.AddSpell(caster, "Shout_Aria_Dismiss_UBW", 0)
            end)

        end
    end

    -- if spell == "Shout_Aria_Dismiss_UBW" then
    --     addAria(caster)
    -- end

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

-- Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID) 
--     if status:match("APPLY_ARIA") == "APPLY_ARIA" and status ~= "APPLY_ARIA_6" and status ~= "APPLY_ARIA_7" and status ~= "APPLY_ARIA_8" then
--         -- local entity = Ext.Entity.Get(object)
--         -- for key, entry in pairs(entity.SpellBook.Spells) do
--         --     if (entry.Id.OriginatorPrototype):match("Shout_Aria") == "Shout_Aria" then
--         --         print("Removing " .. entry.Id.OriginatorPrototype)
--         --         Osi.RemoveSpell(fakerCharacter, entry.Id.OriginatorPrototype)
--         --         break
--         --     end

--         -- end

--         Ext.Timer.WaitFor(50, function()
--             print("Replaced when status was " .. status)
--             addAria(fakerCharacter)
--         end)

--     end

-- end)

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

    if Osi.HasPassive(character, "Passive_Aria_Eight") == 1 and Osi.HasActiveStatus(character, "APPLY_ARIA_8") == 1 then
        AddSpell(character, "Shout_Aria_Dismiss_UBW",0)
    elseif Osi.HasPassive(character, "Passive_Aria_Eight") == 1 and Osi.HasActiveStatus(character, "APPLY_ARIA_7") == 1 then
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