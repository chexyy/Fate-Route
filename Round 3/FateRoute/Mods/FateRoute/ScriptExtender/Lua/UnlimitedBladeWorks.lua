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
            Osi.SetCanInteract(realityMarble, 0)
            -- UBWeffects =  {
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 5.25),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 6),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 5.85),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 5.65)

                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x-2, y+1, z, 5.6),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x-2, y+1, z, 6.35),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x-2, y+1, z, 6.1),
                -- Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x-2, y+1, z, 6)
            --     Osi.PlayLoopEffectAtPosition("11746d2f-93d6-44c3-9b80-44929199f1da", x, y, z, 1)
            -- }

        -- spawning weapons
            local localWeaponCatalog = entity.Vars.weaponCatalog
            local weaponList = {}

            -- all weapons
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

            -- limited number of weapons
                -- for weaponKey = 1,26,1 do -- cycles through weapon types
                --     local specificWeaponList = {} -- selects weapons from each weapon type
                --     for rarity = 5,1,-1 do -- cycles through each rarity
                --         if localWeaponCatalog[weaponKey][rarity] ~= nil then
                --             -- if next(localWeaponCatalog[weaponKey][rarity]) ~= nil and #specificWeaponList < 7 then
                --             if next(localWeaponCatalog[weaponKey][rarity]) ~= nil then
                --                 -- print("Running inorderTraversalUBW")
                --                 -- specificWeaponList = inorderTraversalUBW(localWeaponCatalog[weaponKey][rarity], specificWeaponList, weaponKey, rarity, math.random() > 0.5)
                --                 specificWeaponList = inorderTraversalUBWnotRandom(localWeaponCatalog[weaponKey][rarity], specificWeaponList, weaponKey, rarity)
                --             end
                --         end
                --     end
                --     for i =1, #specificWeaponList do -- concatenates tables
                --         if math.random(1,10) < 4 then 
                --             weaponList[#weaponList+1] = specificWeaponList[i]
                --         end
                --     end
                -- end 
            table.insert(weaponList, "5d59144e-5ad7-4283-b3c5-e25724d70161") -- caliburn
            table.insert(weaponList, "891f5040-675b-49bf-a46f-25203653905a") -- rulebreaker
            _D(weaponList)
            createdObjectList = {}
            -- UBWSpawnTimer = true
            local timerArray = {}
            timerArray[1] = math.random(15,40)
            for i = 2,#weaponList do
                timerArray[i] = 15 + timerArray[i-1]
            end
            for key, entry in pairs(weaponList) do
                Ext.Timer.WaitFor(250+timerArray[key], function()
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

        Ext.Timer.WaitFor(5000,function()
            local localUBWObjects = {realityMarble, createdObjectList}
            entity.Vars.UBWObjects = localUBWObjects
            print("UBWObjects saved")
        end)

        return realityMarble, UBWeffects
    end)

end

function UBWWeaponTransform(weapon, x, y, z)
    -- Ext.Timer.WaitFor(math.random(100, 220), function()
        -- UBWSpawnTimer = false

        local radius
        local angle
        local xWeapon
        local zWeapon
        
        radius = math.random(55,155)/10
        angle = math.random(2*3.14*100)/100
        xWeapon = radius*math.cos(angle)
        zWeapon = radius*math.sin(angle)
        while Osi.FindValidPosition(x+xWeapon, y, z+zWeapon, 0.001, GetHostCharacter(), 0) == nil do
            radius = math.random(55,155)/10
            angle = math.random(2*3.14*100)/100
            xWeapon = radius*math.cos(angle)
            zWeapon = radius*math.sin(angle)
            print("Replaced coordinates to (" .. x+xWeapon .. ", " .. y .. ", " .. z+zWeapon .. ")")
        end

        local createdObject = Osi.CreateAt(weapon, x+xWeapon, y+50, z+zWeapon, 1, 1, "UBW")

        Ext.Timer.WaitFor(250, function()
            if createdObject ~= nil then 
                local heightDiff = 0.15
                heightDiff = Ext.Entity.Get(createdObject).Bound.Bound.AIBounds["Hit"].Size or 0.15
                Osi.ToTransform(createdObject, x+xWeapon, y+50, z+zWeapon, 1, 90, 90)
                Osi.TeleportToPosition(createdObject, x+xWeapon, y+50, z+zWeapon, "UBW Weapon Creation Teleport", 0, 0, 0, 0, 1)
                local x2, y2, z2 = Osi.GetPosition(createdObject)
                Osi.TeleportToPosition(createdObject, x2, y2+heightDiff, z2, "UBW Weapon Creation Teleport", 0, 0, 0, 0, 0)
                -- Osi.CreateProjectileStrikeAt(createdObject, "Projectile_UBW_WeaponSpawn_VFX")
                Osi.PlayEffectAtPosition("fe512e56-8f48-31b5-7432-6e1d1d091881", x2, y2+heightDiff, z2, 1)
                -- Osi.PlayEffectAtPosition("017ffff6-69b9-5747-f964-76e3098eba74", x2, y2+heightDiff, z2, 1)
                Osi.SetCanPickUp(createdObject, 0)
                -- Osi.SetCanInteract(createdObject, 0)
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
                table.insert(createdObjectList, UBWWeaponObject:new(createdObject, {x5,y5,z5}))
            end
            -- UBWSpawnTimer = true
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

Ext.Osiris.RegisterListener("CastSpell", 5, "before", function(caster, spell, spellType, spellElement, storyActionID) 
    if spell == "Shout_Aria_8_UBW" then
        local x, y, z = Osi.GetPosition(caster)
        -- Osi.CreateProjectileStrikeAt(caster, "Projectile_UBW_Spawn_VFX")
        -- Osi.CreateProjectileStrikeAt(caster, "Projectile_UBW_Delete_VFX")

        if UBWCoords(Osi.GetRegion(caster)) ~= nil then
            Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").withinUBW = {}
            Osi.RemoveSpell(caster, "Shout_Aria_8_UBW")
            x, y, z = Osi.GetPosition(caster)
            Ext.Entity.Get(caster).Vars.preUBWPosition = {x,y,z}
            spawnUBWv2(caster)  
            print("Spawning Reality Marble v2")
        -- else
        --     realityMarble, UBWeffects = spawnUBW(caster, nil, nil, nil)   
        else
            print("Trying to spawn UBW in invalid region")
        end     
    end

end)

-- function spawnCloneUBW()
    --         local copiedChar = Osi.CreateOutOfSightAtDirectionFromObject(Osi.GetTemplate(fakerCharacter), fakerCharacter, fakerCharacter, 1, 0, "UBW")
    --         print("Clone successful")
    --         Ext.Timer.WaitFor(500, function()
    --             Osi.Transform(copiedChar, Osi.GetTemplate(fakerCharacter), "c7c3381e-b901-416e-a0c4-bc745e1ff54a")
    --             Osi.SetLevel(copiedChar, Osi.GetLevel(fakerCharacter))
    --             Ext.Timer.WaitFor(100, function()
    --                 Osi.SetCharacterOnPortraitPainting(copiedChar, fakerCharacter)
    --                 Osi.CopyCharacterEquipment(copiedChar, fakerCharacter)
    --             end)
    --         end)
            
    --         Osi.SetImmortal(copiedChar, 1)
    --         Osi.ApplyStatus(copiedChar, "INVULNERABLE", -1, 100)
    --         Osi.AddBoosts(copiedChar, "Invisibility()", "Apply Weapon Functors - Arrow", copiedChar)
    --         -- Osi.SetVisible(copiedChar, 0)
    --         Osi.SetStoryDisplayName(copiedChar, tostring(Ext.Entity.Get(fakerCharacter).ServerDisplayNameList.Names[2].Name))
    --         Osi.TeleportTo(copiedChar, fakerCharacter, "UBW Clone Teleport", 0, 0, 0, 1, 1)

    --         print("Returning " .. copiedChar)
    --         return copiedChar
    -- end

-- function swordDanceUBWClone(target)
    --     -- Ext.Timer.WaitFor(100, function()
    --         local copiedChar = Osi.CreateOutOfSightAtDirectionFromObject(Osi.GetTemplate(fakerCharacter), fakerCharacter, fakerCharacter, 1, 0, "UBW")
    --         print("Clone successful")
    --         Ext.Timer.WaitFor(500, function()
    --             Osi.Transform(copiedChar, Osi.GetTemplate(fakerCharacter), "c7c3381e-b901-416e-a0c4-bc745e1ff54a")
    --             Osi.SetLevel(copiedChar, Osi.GetLevel(fakerCharacter))
    --             Ext.Timer.WaitFor(500, function()
    --                 Osi.SetCharacterOnPortraitPainting(copiedChar, fakerCharacter)
    --                 Osi.CopyCharacterEquipment(copiedChar, fakerCharacter)

    --                 Osi.SetImmortal(copiedChar, 1)
    --                 Osi.ApplyStatus(copiedChar, "INVULNERABLE", -1, 100)
    --                 Osi.AddBoosts(copiedChar, "Invisibility()", "Apply Weapon Functors - Arrow", copiedChar)
    --                 -- Osi.SetVisible(copiedChar, 0)
    --                 Osi.SetStoryDisplayName(copiedChar, tostring(Ext.Entity.Get(fakerCharacter).ServerDisplayNameList.Names[2].Name))
    --                 Osi.TeleportTo(copiedChar, fakerCharacter, "UBW Clone Teleport", 0, 0, 0, 1, 1)

    --                 _D(shotWeaponList)
    --                 for i = #shotWeaponList/2, #shotWeaponList do
    --                     Osi.SetGravity((shotWeaponList[i])[1],1)
    --                     Osi.ItemMoveToPosition((shotWeaponList[i])[1], (shotWeaponList[i])[2][1], (shotWeaponList[i])[2][2]+6.5, (shotWeaponList[i])[2][3], 1.75, 1, "UBW - Infinite Sword Dance")
    --                     Osi.SteerTo((shotWeaponList[i])[1], target, 0)

    --                     Ext.Timer.WaitFor(math.random(100,200), function()
    --                         print("Moved " .. Osi.ResolveTranslatedString(Osi.GetDisplayName((shotWeaponList[i])[1])))
    --                         Osi.UseSpell(copiedChar, "Throw_UBW_Manipulation", target, (shotWeaponList[i])[1],1)

    --                     end)
    --                 end
    --             end)
    --         end)        
            
    --     -- end)

    -- end

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spell, spellType, spellElement, storyActionID) 

    if spell == "Target_UBW_InfiniteSwordDance" then
        local shotWeaponList = {}
        local createdObjectList = Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)]
        -- ISDTarget = target

        -- farthest/closest weapons
            -- for key, entryObject in pairs(createdObjectList) do
            --     if #shotWeaponList < 11 then
            --         table.insert(shotWeaponList,entryObject)
            --     else
            --         for i = 1, #shotWeaponList do
            --             if Osi.GetDistanceTo(shotWeaponList[i].objectUUID,target) < Osi.GetDistanceTo(entryObject.objectUUID,target) then
            --                local found = false
            --                 for j = 1, #shotWeaponList do
            --                     if shotWeaponList[j].objectUUID == entryObject.objectUUID then
            --                         found = true
            --                         break
            --                     end
            --                 end

            --                 if found == false then
            --                     print("Replacing " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(shotWeaponList[i].objectUUID)) .. " (distance: " .. Osi.GetDistanceTo(shotWeaponList[i].objectUUID,target) .. ") with " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(entryObject.objectUUID)) .. " (distance: " .. Osi.GetDistanceTo(entryObject.objectUUID,target) .. ")")
            --                     shotWeaponList[i] = entryObject
            --                 end
            --             end
            --         end
            --     end
            -- end

        -- random
            -- table.insert(shotWeaponList, createdObjectList[math.random(#createdObjectList)])
            -- for i = 1,20 do
            --     local weapon = createdObjectList[math.random(#createdObjectList)]
            --     local found = false
            --     for j = 1, #shotWeaponList do
            --         if shotWeaponList[j].objectUUID == weapon.objectUUID then
            --             found = true
            --             break
            --         end
            --     end

            --     if found == false then
            --         table.insert(shotWeaponList, weapon)
            --     end

            -- end

        -- disttance based
        while #shotWeaponList < 20 do
            local weapon = createdObjectList[math.random(#createdObjectList)]
            local found = false
            for j = 1, #shotWeaponList do
                if shotWeaponList[j].objectUUID == weapon.objectUUID then
                    found = true
                    break
                end
            end

            if found == false and Osi.GetDistanceTo(weapon.objectUUID,target) < 20 then
                table.insert(shotWeaponList, weapon)
            end

        end

        --  valid position
        -- while #shotWeaponList < 20 do
        --     local weapon = createdObjectList[math.random(#createdObjectList)]
        --     local found = false

        --     -- checks if weapon is already in the list to be shot
        --     for j = 1, #shotWeaponList do
        --         if shotWeaponList[j].objectUUID == weapon.objectUUID then
        --             found = true
        --             break
        --         end
        --     end

        --     -- if weapon isn't in the list, checks its position
        --     if found == false then
        --         local xTarget, yTarget, zTarget = Osi.GetPosition(target)
        --         local valid = true
        --         for time = 0.1,1,0.15 do
        --             if Osi.FindValidPosition(xTarget+time*(weapon.objectPosition[1]-xTarget), yTarget+time*(weapon.objectPosition[2]-yTarget+5.25), zTarget+time*(weapon.objectPosition[3]-zTarget), 0.1, weapon.objectUUID, 0) == nil then
        --                 valid = false
        --                 print("Line between the target (" .. xTarget .. ", " .. yTarget .. ", " .. zTarget .. ") and " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(weapon.objectUUID)) .. " (" .. weapon.objectPosition[1] .. ", " .. weapon.objectPosition[2]+5.25 .. ", " .. weapon.objectPosition[3]-zTarget .. ")" .. " was not valid for time = " .. time ..  " at: (" .. xTarget+time*(weapon.objectPosition[1]-xTarget) .. ", " .. yTarget+time*(weapon.objectPosition[2]-yTarget+5.25) .. ", " .. zTarget+time*(weapon.objectPosition[3]-zTarget) .. "); selecting another weapon")
        --                 break
        --             end
        --         end

        --         -- if the line between the target and the object is valid, then puts it in the list 
        --         if valid == true then
        --             table.insert(shotWeaponList, weapon)
        --         end
        --     end

        -- end

        -- clone
            -- local copiedChar = spawnCloneUBW()
            -- Ext.Timer.WaitFor(500, function()
            --     local shotWeaponListClone = {}
            --     table.insert(shotWeaponListClone, createdObjectList[math.random(#createdObjectList)])
            --     for i = 1,9 do
            --         local weapon = createdObjectList[math.random(#createdObjectList)]
            --         local found = false
            --         for j = 1, #shotWeaponListClone do
            --             if shotWeaponListClone[j][1] == weapon.objectUUID then
            --                 found = true
            --                 break
            --             end
            --         end

            --         if found == false then
            --             table.insert(shotWeaponListClone, weapon)
            --         end

            --     end

            --     for key, entryShot in pairs(shotWeaponListClone) do
            --         -- Osi.AddBoosts(entryShot.objectUUID, "Attribute(Floating)", "UBW - Infinite Sword Dance - Float", caster)
            --         Osi.SetGravity(entryShot.objectUUID,1)
            --         Osi.ItemMoveToPosition(entryShot.objectUUID, entryShot.objectPosition[1], entryShot.objectPosition[2]+6.5, entryShot.objectPosition[3], 1.75, 1, "UBW - Infinite Sword Dance")
            --         Osi.SteerTo(entryShot.objectUUID, target, 0)
            --         Ext.Timer.WaitFor(150, function()
            --             print("Moved " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(entryShot.objectUUID)))
            --             Osi.UseSpell(copiedChar, "Throw_UBW_Manipulation", target, entryShot.objectUUID,1)
            --             -- Osi.CreateProjectileStrikeAt(entryShot.objectUUID, "Projectile_UBW_InfiniteSwordDanceMove_VFX")
            --         end)
            --     end
            --     Osi.RequestDeleteTemporary(copiedChar)
            -- end)

        -- in sight
            -- while #shotWeaponList < 11 do
            --     local weapon = createdObjectList[math.random(#createdObjectList)]
            --     local found = false
            --     for j = 1, #shotWeaponList do
            --         if shotWeaponList[j].objectUUID == weapon.objectUUID then
            --             found = true
            --             break
            --         end
            --     end

            --     -- if found == false and Osi.HasLineOfSight(weapon.objectUUID, target) == 1 then
            --     if found == false and Osi.HasLineOfSight(weapon.objectUUID, target) == 1 then
            --         table.insert(shotWeaponList, weapon)
            --     end

            -- end
        
        print("Final shot weapon list")
        for i = 1, #shotWeaponList do
            print(Osi.ResolveTranslatedString(Osi.GetDisplayName(shotWeaponList[i].objectUUID)) .. " (distance: " .. Osi.GetDistanceTo(shotWeaponList[i].objectUUID,target) .. ")")
        end

        local x, y, z = Osi.GetPosition(caster)
        for key, entryShot in pairs(shotWeaponList) do
            -- Osi.AddBoosts(entryShot.objectUUID, "Attribute(Floating)", "UBW - Infinite Sword Dance - Float", caster)
            Osi.SetGravity(entryShot.objectUUID,1)
            -- Osi.ItemMoveToPosition(entryShot.objectUUID, entryShot.objectPosition[1], entryShot.objectPosition[2]+7.5, entryShot.objectPosition[3], 1.75, 1, "UBW - Infinite Sword Dance")
            local xTarget, yTarget, zTarget = Osi.GetPosition(target)
            -- local xItem = x+math.random((xItem-xTarget)*100/5,(xItem-xTarget)*100/3)/100
            -- local yItem = y+math.random(50,60)/10
            -- local zItem = z+math.random((zItem-zTarget)*100/5,(zItem-zTarget)*100/3)/100

            local xItem = entryShot.objectPosition[1]
            local yItem = entryShot.objectPosition[2]+math.random(45,110)/10
            local zItem = entryShot.objectPosition[3]
            Osi.ToTransform(entryShot.objectUUID, entryShot.objectPosition[1],entryShot.objectPosition[2],entryShot.objectPosition[3], 90,math.deg(math.atan(xItem-xTarget,yItem-yTarget)),90)
            Osi.ItemMoveToPosition(entryShot.objectUUID, xItem, yItem, zItem, 6, 3, "UBW - Infinite Sword Dance")
            Osi.ItemRotateYToAngle(entryShot.objectUUID, math.deg(math.atan(xItem-xTarget,yItem-yTarget)), 100)
            
            -- Ext.Timer.WaitFor(150, function() -- important
                print("Moved " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(entryShot.objectUUID)))
                -- if math.random() > 0.5 then
                -- local xTarget, yTarget, zTarget = Osi.GetPosition(ISDTarget)
                
                -- Osi.ToTransform(entryShot.objectUUID,x,y,z,math.deg(math.atan(xTarget-xItem,yTarget-yItem)),math.deg(math.atan(xTarget-xItem,zTarget-zItem)),math.deg(math.tan(zTarget-zItem,yTarget-yItem)))
                -- Ext.Timer.WaitFor(math.random(500,1500), function()
                    if Osi.IsDead(target) == 0 then
                        Osi.UseSpell(caster, "Throw_UBW_Manipulation", target, entryShot.objectUUID,1)
                    end
                -- end)
                -- else 
                --     local x,y,z = Osi.GetPosition(target)
                --     local targetObject = Osi.CreateAt("8c77a7d6-c3dd-4f1e-8d91-86a305dbd174", x+(math.random(-700,700)/1000), y, z+(math.random(-700,700)/1000), 1, 1, "UBW Infinite Sword Dance Target Object")
                --     local xTarget,yTarget,zTarget = Osi.GetPosition(targetObject)
                --     print("Shooting at target object that is x: " .. x-xTarget .. " away and z: " .. z-zTarget .. " away")
                --     Osi.UseSpell(caster, "Throw_UBW_Manipulation", targetObject, entryShot.objectUUID,1)
                --     Ext.Timer.WaitFor(5000, function()
                --         Osi.UnloadItem(targetObject)
                --     end)
                -- end
                -- Osi.CreateProjectileStrikeAt(entryShot.objectUUID, "Projectile_UBW_InfiniteSwordDanceMove_VFX")
            -- end)
        end

        -- swordDanceUBWClone(target, shotWeaponList)
            -- for i = 1, #shotWeaponList/2 do
            --     -- Osi.AddBoosts(entryShot.objectUUID, "Attribute(Floating)", "UBW - Infinite Sword Dance - Float", caster)
            --     Osi.SetGravity((shotWeaponList[i])[1],1)
            --     Osi.ItemMoveToPosition((shotWeaponList[i])[1], (shotWeaponList[i])[2][1], (shotWeaponList[i])[2][2]+6.5, (shotWeaponList[i])[2][3], 1.75, 1, "UBW - Infinite Sword Dance")
            --     Osi.SteerTo((shotWeaponList[i])[1], target, 0)

            --     Ext.Timer.WaitFor(150, function()
            --         Osi.UseSpell(caster, "Throw_UBW_Manipulation", target, (shotWeaponList[i])[1],1)
            --         -- Osi.CreateProjectileStrikeAt(entryShot.objectUUID, "Projectile_UBW_InfiniteSwordDanceMove_VFX")
            --     end)
            -- end
        
    end

end)

-- Ext.Osiris.RegisterListener("Moved", 7, "after", function(item) 
    --     print(item)
    --     if (Osi.HasActiveStatus(item, "REPLICATED_WITHIN") == 1) then
    --         print("Move detected")
    --         if (ISDTarget ~= nil) then
    --             local x,y,z = Osi.GetPosition(item)
    --             local xTarget, yTarget, zTarget = Osi.GetPosition(ISDTarget)
                
    --             Osi.ToTransform(item,x,y,z,math.atan(xTarget-x,yTarget-y),math.atan(xTarget-x,yTarget-y),math.tan(zTarget-z))
    --             Ext.Timer.WaitFor(math.random(500,800), function() -- important
    --                 print("Moved " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(entryShot.objectUUID)))
    --                     Osi.UseSpell(caster, "Throw_UBW_Manipulation", target, item,1)
    --             end)

    --         end
    --     end

    -- end)


Ext.Osiris.RegisterListener("OnThrown", 7, "after", function(thrownObject, thrownObjectTemplate, thrower, storyActionID, throwPosX, throwPosY, throwPosZ) 

    if Osi.HasActiveStatus(thrownObject, "REPLICATED_WITHIN") == 1 then
        local createdObjectList = Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)]
        Osi.SetGravity(thrownObject, 1)
        Osi.CreateProjectileStrikeAtPosition(throwPosX, throwPosY, throwPosZ, "Projectile_UBW_InfiniteSwordDanceMove_VFX")
        Osi.PlayEffectAtPositionAndRotation("5123bb90-0084-e389-0cb5-332110a18fa6", throwPosX, throwPosY, throwPosZ, 50, 0.55)
        Ext.Timer.WaitFor(math.random(600,1350), function()
            print("Throw detected for " .. thrownObject)
            -- Ext.Timer.WaitFor(math.random(600,1350), function()
                for i = 1, #createdObjectList do
                    if createdObjectList[i].objectUUID == thrownObject:match("[%w]+-[%w]+-[%w]+-[%w]+-[%w]+") then
                        local x2,y2,z2 = Osi.GetPosition(createdObjectList[i].objectUUID)
                        -- Osi.CreateProjectileStrikeAt(createdObjectList[i].objectUUID, "Projectile_UBW_WeaponSpawn_VFX")
                        -- Osi.PlayEffectAtPosition("fe512e56-8f48-31b5-7432-6e1d1d091881", x2, y2, z2, 1)
                        local x = createdObjectList[i].objectPosition[1]
                        local y = createdObjectList[i].objectPosition[2]
                        local z = createdObjectList[i].objectPosition[3]
                        Osi.ToTransform(createdObjectList[i].objectUUID, x, y, z, 1, 90, 90)
                        Osi.TeleportToPosition(createdObjectList[i].objectUUID, x, y, z, "UBW Weapon Creation Teleport", 0, 0, 0, 0, 0)
                        -- Osi.CreateProjectileStrikeAt(createdObjectList[i].objectUUID, "Projectile_UBW_WeaponSpawn_VFX")
                        Osi.PlayEffectAtPosition("fe512e56-8f48-31b5-7432-6e1d1d091881", x, y, z, 1)

                        print("Moving back: " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(createdObjectList[i].objectUUID)) .. " to (" .. x .. ", " .. y .. ", z)" .. " id: " .. createdObjectList[i].objectUUID)
                        break
                    end
                end

            -- end)
        end)
    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    -- if status == "UBW_PUSH_TRIGGER" then
    --     print("Detected outside object attempting to break in")
    --     UseSpell(fakerCharacter, "Target_UBW_Push", object,object,1)
    -- end
    -- if status == "UBW_PULL_TRIGGER" then
    --     print("Detected inside object attempting to escape")
    --     UseSpell(fakerCharacter, "Target_UBW_Pull", object,object,1)
    -- end
    if status == "APPLY_ARIA_7" and Osi.HasPassive(object, 'Passive_Aria_Eight') == 1 then
        addAria(object)
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    -- if (status == "APPLY_ARIA_8" or status == "SEPARATED_FROM_REALITY") and HasActiveStatus(object, "STRUCTURAL_GRASP") == 1 then
    --     local entity = Ext.Entity.Get(object)
    --     Osi.RemoveStatus(object, "APPLY_ARIA_8", object)
    --     addAria(object)

    --     Ext.Timer.WaitFor(800, function()
    --         local localUBWCoordinates = entity.Vars.UBWCoordinates
    --         -- local localUBWObjects = entity.Vars.UBWObjects
    --         -- local realityMarble = localUBWObjects[1]
    --         -- local createdObjectList = localUBWObjects[2] 

    --         if localUBWCoordinates ~= nil then
    --             -- Osi.CreateProjectileStrikeAtPosition(localUBWCoordinates[1], localUBWCoordinates[2], localUBWCoordinates[3], "Projectile_UBW_Delete_VFX")
    --             Osi.UnloadItem(realityMarble)
    --             -- for key, entry in pairs(UBWeffects) do
    --             --     Osi.StopLoopEffect(entry)
    --             -- end
    --             -- if createdObjectList == nil then
    --             --     createdObjectList = entity.Vars.UBWObjects[2]
    --             --     print("Created object list was nil")
    --             -- end
    --             for key, entry in pairs(createdObjectList) do
    --                 Osi.UnloadItem(entry.objectUUID)
    --                 Osi.RequestDelete(entry.objectUUID)
    --             end
    --             -- UBWeffects = nil
    --             realityMarble = nil
    --             entity.Vars.UBWCoordinates = nil
    --             entity.Vars.UBWObjects = nil
    --         end
    --     end)
    -- end

    if status == "APPLY_ARIA_8" and HasActiveStatus(object, "STRUCTURAL_GRASP") == 1 then
        spawnUBWEffect(object)
        addAria(object)
        
        Ext.Timer.WaitFor(759, function()
            local entitiesInUBW = Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").withinUBW
            createdObjectList = Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)]
            print("Within UBW:")
            _D(entitiesInUBW)
            while #entitiesInUBW > 0 do
                local preUBWPosition = Ext.Entity.Get(entitiesInUBW[1]).Vars.preUBWPosition
                if #entitiesInUBW ~= 1 then
                    Osi.TeleportToPosition(entitiesInUBW[1], preUBWPosition[1], preUBWPosition[2], preUBWPosition[3], "Teleport Back from UBW", 0, 0, 0, 0, 1)
                else
                    Osi.TeleportToPosition(entitiesInUBW[1], preUBWPosition[1], preUBWPosition[2], preUBWPosition[3], "Teleport Back from UBW - Finish", 0, 0, 0, 0, 1)
                end
                Ext.Entity.Get(entitiesInUBW[1]).Vars.preUBWPosition = nil
                table.remove(entitiesInUBW, 1)
            end
            Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").withinUBW = nil
            -- Ext.Timer.WaitFor(1000, Osi.RemoveStatus(createdObjectList[1].objectUUID, "REPLICATED_WITHIN", fakerCharacter))
            -- Ext.Timer.WaitFor(1000, Osi.UnloadItem(createdObjectList[1].objectUUID), "REPLICATED_WITHIN", fakerCharacter)
            Ext.Timer.WaitFor(1000, Osi.SetEntityEvent(createdObjectList[1].objectUUID, "UBW Object Deletion", 1))
            
        end)

    end

    if status == "APPLY_ARIA_7" then
        addAria(object)
    end

end)

-- Ext.Osiris.RegisterListener("Teleported", 9, "after", function(target, cause, oldX, oldY, oldZ, newX, newY, newZ, spell)
--     if cause == "Teleport Back from UBW - Finish" then
--         Ext.Timer.WaitFor(1000, Osi.RemoveStatus(Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)][1].objectUUID, "REPLICATED_WITHIN", fakerCharacter))
--     end

-- end)

Ext.Osiris.RegisterListener("KilledBy", 4, "after", function(defender, attackOwner, attacker, storyActionID)
    if (Osi.HasPassive(defender, 'Passive_Aria_Eight') == 1) then
        local entity = Ext.Entity.Get(defender)
        addAria(defender)

        Osi.RemoveStatus(defender, "APPLY_ARIA_8", "UBW Faker killed")
        -- Ext.Timer.WaitFor(800, function()
        --     local localUBWCoordinates = entity.Vars.UBWCoordinates
        --     if localUBWCoordinates ~= nil then
        --         -- Osi.CreateProjectileStrikeAtPosition(localUBWCoordinates[1], localUBWCoordinates[2], localUBWCoordinates[3], "Projectile_UBW_Delete_VFX")
        --         Osi.UnloadItem(realityMarble)
        --         -- for key, entry in pairs(UBWeffects) do
        --         --     Osi.StopLoopEffect(entry)
        --         -- end
        --         for key, entry in pairs(createdObjectList) do
        --             Osi.UnloadItem(entry[1])
        --         end
        --         -- UBWeffects = nil
        --         realityMarble = nil
        --         entity.Vars.UBWCoordinates = nil
        --         entity.Vars.UBWObjects = nil
        --     end
        -- end)
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

    -- if HasActiveStatus(object, "UBW_PUSH_TRIGGER") == 1 then
    --     print("Detected outside object still stuck trying to break in")
    --     UseSpell(fakerCharacter, "Target_UBW_Push", object,object,1)
    -- end

    -- if HasActiveStatus(object, "UBW_PULL_TRIGGER") == 1 then
    --     print("Detected insde object still stuck trying to escape in")
    --     UseSpell(fakerCharacter, "Target_UBW_Pull", object,object,1)
    -- end

end)


-- Shout Aria
Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted extraDescriptionTable and statusApplyTable sync")

    local fakerCharacter = locateFaker()
    syncAllVariables(fakerCharacter)
    local entity = Ext.Entity.Get(fakerCharacter)

    -- Ext.Vars.RegisterUserVariable("UBWCoordinates", {})
        -- if UBWCoordinates == nil and Osi.HasActiveStatus(fakerCharacter, "APPLY_ARIA_8") == 1 then
        --     Ext.Timer.WaitFor(5000, function()
        --         local x, y, z = entity.Vars.UBWCoordinates
        --         -- realityMarble, UBWeffects = spawnUBW(fakerCharacter, x, y, z)
        --     end)
        -- end

        -- Ext.Vars.RegisterUserVariable("UBWObjects", {})
        -- if (createdObjectList == nil or realityMarble == nil) and Osi.HasActiveStatus(fakerCharacter, "APPLY_ARIA_8") == 1 then
        --     Ext.Timer.WaitFor(5000, function()
        --         realityMarble = entity.Vars.UBWObjects[1]
        --         createdObjectList = entity.Vars.UBWObjects[2]
        --     end)
        -- end

    for keyStatus, entryStatus in pairs(entity.ServerCharacter.StatusManager.Statuses) do
        if entryStatus.StackId:match("ARIA_") == "ARIA_" then
            print("Removing lingering aria " .. entryStatus.StackId)
            Osi.RemoveStatus(fakerCharacter, entryStatus.StackId)
        end
    end 

    if Osi.HasPassive(fakerCharacter, "Passive_Aria_One") == 1 then
        addAria(fakerCharacter)
    end

    Ext.Vars.RegisterUserVariable("preUBWPosition", {})

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

-- Ext.Osiris.RegisterListener("CastedSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID) 
--     if spell:match("Shout_Aria") == "Shout_Aria" and spell ~= "Shout_Aria_Dismiss_UBW" then
--         print(spell .. " detected")

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

    --     addAria(caster)
    -- end

    -- if spell == "Shout_Aria_Dismiss_UBW" then
    --     addAria(caster)
    -- end

-- end)

Ext.Osiris.RegisterListener("CombatEnded", 1, "before", function(combatGuid) 
    -- if Osi.CombatGetInvolvedPartyMember(combatGuid,1) == fakerCharacter or Osi.CombatGetInvolvedPartyMember(combatGuid,2) == fakerCharacter or Osi.CombatGetInvolvedPartyMember(combatGuid,3) == fakerCharacter or Osi.CombatGetInvolvedPartyMember(combatGuid,4) == fakerCharacter then

        local entity = Ext.Entity.Get(fakerCharacter)
        for keyStatus, entryStatus in pairs(entity.ServerCharacter.StatusManager.Statuses) do
            if entryStatus.StackId:match("ARIA_") == "ARIA_" then
                print("Removing lingering aria " .. entryStatus.StackId)
                Osi.RemoveStatus(fakerCharacter, entryStatus.StackId)
            end
        end 

        Osi.RemoveStatus(fakerCharacter, "APPLY_ARIA_8", "UBW Combat Ended")

    -- end
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
        addNoblePhantasms(character)
    end
end)

Ext.Osiris.RegisterListener("LeveledUp", 1, "after", function(character) 
    if character == fakerCharacter then
        addAria(character)
        addNoblePhantasms(character)
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
        -- AddSpell(character, "Shout_Aria_Dismiss_UBW",0)
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