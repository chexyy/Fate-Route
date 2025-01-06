function UBWCoords(region)
    local coordDictionary = {
        ["CTY_Main_A"] = {-1565, 505, -291.75},
        ["SCL_Main_A"] = {80.5; 355; -1390},
        ["BGO_Main_A"] = {605; 355; -744},
        ["END_Main"] = {-1893.25, 205, 2670.25}
    }
    return coordDictionary[region]
end

function spawnUBWv2(character)
    local entity = Ext.Entity.Get(character)
    local x, y, z = Osi.GetPosition(character)
    entity.Vars.preUBWPosition = {x,y,z}

    UBWStartTime = Ext.Utils.MonotonicTime()
    spawnUBWEffect(character)
    generateUBWWeapons()
end

function spawnUBWEffect(character)
    local x, y, z = Osi.GetPosition(character)
    local loopEffect = Osi.PlayLoopEffectAtPosition("11746d2f-93d6-44c3-9b80-44929199f1da", x,y,z, 1)
    
    -- local startTime = Ext.Utils.MonotonicTime()
    -- while Ext.Utils.MonotonicTime() - startTime < 500 do
    -- end
    
    Osi.StopLoopEffect(loopEffect)

end

Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    print("Attempted extraDescriptionTable and statusApplyTable sync")

    local fakerCharacter = locateFaker()
    syncAllVariables(fakerCharacter)
    -- Osi.TeleportToPosition(fakerCharacter, -62.528369903564, 497, -91.052192687988, "", 0, 0, 0, 1, 1)
    Ext.Vars.RegisterUserVariable("preUBWPosition", {})
    Ext.Vars.RegisterModVariable("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5", "withinUBW", {})
    -- Ext.Timer.WaitFor(2000, function()
        Ext.Vars.RegisterModVariable("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5", "realityMarbleStorage", {})
        print("Read UBW file")
        if (Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage == nil or Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage == {}) then
            Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage = {}
        end
        -- if Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)] == nil and UBWCoords(Osi.GetRegion(fakerCharacter)) ~= nil then
        --     print("Generating UBW from table")
        --     generateUBWWeapons()
        -- elseif UBWCoords(Osi.GetRegion(fakerCharacter)) ~= nil then
        --     for key, entry in pairs(Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)]) do
        --         Osi.SetCanPickUp(entry.objectUUID, 0)
        --         Osi.SetCanInteract(entry.objectUUID,1)
        --     end
        -- end
    -- end)

end)

function generateUBWWeapons()
    Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)] = {}
    local localWeaponCatalog = Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog
    unorganizedList = {}
    for weaponKey = 1,26,1 do
        unorganizedList[weaponKey] = {}
        for rarity = 1,5,1 do
            unorganizedList[weaponKey][rarity] = {}
        end
    end

    for weaponKey = 1,26,1 do -- cycles through weapon types
        for rarity = 1,5,1 do -- cycles through each rarity
            local specificWeaponList = {} -- selects weapons from each weapon type
            if localWeaponCatalog[weaponKey][rarity] ~= nil  then
                if next(localWeaponCatalog[weaponKey][rarity]) ~= nil then
                    specificWeaponList = inorderTraversalUBWnotRandom(localWeaponCatalog[weaponKey][rarity], specificWeaponList, weaponKey, rarity)
                    unorganizedList[weaponKey][rarity] = specificWeaponList
                    if rarity < 3 and (weaponKey == 8 or weaponKey == 13 or weaponKey == 19 or weaponKey == 20 or weaponKey == 21 or weaponKey == 22)then
                        local weaponAmount = #unorganizedList[weaponKey][rarity]
                        for j = 1,weaponAmount do
                            for i = 1,15 do
                                unorganizedList[weaponKey][rarity][#unorganizedList[weaponKey][rarity]+1] = unorganizedList[weaponKey][rarity][j]
                            end
                        end
                    end
                end
            end
        end
    end 

    _D(unorganizedList)

    weaponKeyIndex = 1
    rarityIndex = 1
    dictionaryIndex = 1
    UBWWeaponTransformv2(unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex], rarityIndex, nil)

    UBWWeaponTransformv2("5d59144e-5ad7-4283-b3c5-e25724d70161", 5, "Caliburn") -- caliburn
    UBWWeaponTransformv2("891f5040-675b-49bf-a46f-25203653905a", 4, "Rulebreaker") -- rulebreaker

end

function UBWWeaponTransformv2Helper(weapon,rarity)
    if rarity > 2 then
        -- local startTime = Ext.Utils.MonotonicTime()
        -- while Ext.Utils.MonotonicTime() - startTime < 3000 do
        while weaponVerifier == false do
        end
        -- Ext.Timer.WaitFor(math.random(500), UBWWeaponTransformv2(weapon, rarity))
        UBWWeaponTransformv2(weapon, rarity)
    else
        for i = 1,20 do
            -- local startTime = Ext.Utils.MonotonicTime()
            -- while Ext.Utils.MonotonicTime() - startTime < 3000 do
            while weaponVerifier == false do
            end
            -- Ext.Timer.WaitFor(math.random(500), UBWWeaponTransformv2(weapon, rarity))
            UBWWeaponTransformv2(weapon, rarity)
        end
    end
end

function UBWWeaponTransformv2(weapon, rarity, noblePhantasm)
    -- local x = -64.34932
    local x = UBWCoords(Osi.GetRegion(fakerCharacter))[1]
    local y = UBWCoords(Osi.GetRegion(fakerCharacter))[2]
    local z = UBWCoords(Osi.GetRegion(fakerCharacter))[3]

    if noblePhantasm ~= nil then
        rarity = 5
    end

    local radius
    local angle
    local xWeapon
    local zWeapon

    local radiusDictionary = {{5,45},{5,40},{4,35},{3,30},{2,10}}

    radius = math.random(radiusDictionary[rarity][1]*10,radiusDictionary[rarity][2]*10)/10
    angle = math.random(2*3.14*100)/100
    xWeapon = radius*math.cos(angle)
    zWeapon = radius*math.sin(angle)
    while Osi.FindValidPosition(x+xWeapon, y, z+zWeapon, 0.001, GetHostCharacter(), 0) == nil do
        radius = math.random(radiusDictionary[rarity][1]*10,radiusDictionary[rarity][2]*10)/10
        angle = math.random(2*3.14*100)/100
        xWeapon = radius*math.cos(angle)
        zWeapon = radius*math.sin(angle)
        print("Replaced coordinates to (" .. x+xWeapon .. ", " .. y .. ", " .. z+zWeapon .. ")")
    end
    -- print("xWeapon: " .. xWeapon .. "; x coord: " .. x+xWeapon)
    -- print("zWeapon: " .. zWeapon .. "; z coord: " .. z+zWeapon)

    -- xWeapon = xWeapon*(math.random(0, 1)*2-1)
    -- zWeapon = zWeapon*(math.random(0, 1)*2-1)

    if noblePhantasm == "Caliburn" then
        xWeapon = 0
        zWeapon = 0
    end
    
    local createdObject = Osi.CreateAt(weapon, x+xWeapon, y, z+zWeapon, 0, 0, "UBW Create At")
    
    -- Ext.Timer.WaitFor(math.random(300,575), UBWweaponMove(createdObject, xWeapon, zWeapon, weapon,rarity))
    UBWweaponMove(createdObject, xWeapon, zWeapon, weapon,rarity)
end

function UBWweaponMove(createdObject, xWeapon, zWeapon, weaponTemplate,rarity)
    if createdObject ~= nil then 
        local x = UBWCoords(Osi.GetRegion(fakerCharacter))[1]
        local y = UBWCoords(Osi.GetRegion(fakerCharacter))[2]
        local z = UBWCoords(Osi.GetRegion(fakerCharacter))[3]

        Osi.ToTransform(createdObject, x+xWeapon, y, z+zWeapon, 1, 90, 90)
        Osi.TeleportToPosition(createdObject, x+xWeapon, y+10, z+zWeapon, "UBW Weapon Creation Teleport", 0, 0, 0, 0, 1)
        -- Ext.Timer.WaitFor(500, UBWWeaponMoveHelper(createdObject,weaponTemplate,rarity))
        UBWWeaponMoveHelper(createdObject,weaponTemplate,rarity)
    end

end

function UBWWeaponMoveHelper(createdObject,weaponTemplate,rarity)
    local heightDiff = Ext.Template.GetRootTemplate(weaponTemplate).AIBounds[1].Radius
    local x2, y2, z2 = Osi.GetPosition(createdObject)
    if weaponTemplate == "5d59144e-5ad7-4283-b3c5-e25724d70161" or weaponTemplate == "891f5040-675b-49bf-a46f-25203653905a" then
        Osi.TeleportToPosition(createdObject, x2, y2+heightDiff*2.5, z2, "UBW Weapon Creation Teleport Finished Noble Phantasm", 0, 0, 0, 0, 0)
    else
        Osi.TeleportToPosition(createdObject, x2, y2+heightDiff*2.5, z2, "UBW Weapon Creation Teleport Finished", 0, 0, 0, 0, 0)
    end
    -- Osi.SetCanPickUp(createdObject, 0)
    -- Osi.SetCanInteract(createdObject,0)
    print("Placed " .. Osi.ResolveTranslatedString(Ext.Template.GetRootTemplate(weaponTemplate).DisplayName.Handle.Handle) .. " with weapon template `" .. weaponTemplate .. "` at (" .. x2 .. ", " .. y2+heightDiff*2.5 .. ", " .. z2 .. ")")
    
    Ext.Timer.WaitFor(100, function()
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
    -- Osi.RequestPing(x5, y5, z5, createdObject, fakerCharacter)
    _D({createdObject, {x5,y5,z5}})
    Osi.PlayEffectAtPosition("265483fc-b3c6-310f-1e21-4123d2addba4", x5,y5,z5,0.5)
    Osi.PlayEffectAtPosition("fe512e56-8f48-31b5-7432-6e1d1d091881", x5, y5-heightDiff*2, z5, 0.6)
    -- weaponVerifier = true
    table.insert(Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)], UBWWeaponObject:new(createdObject, {x5,y5,z5}))

end

function deleteUBWObjects()
    local UBWGenerationDictionary = Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage
    Osi.RemoveStatus(entry.objectUUID, "REPLICATED_WITHIN", fakerCharacter)
    UBWGenerationDictionary[Osi.GetRegion(fakerCharacter)] = nil
    Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage = UBWGenerationDictionary

end

Ext.Osiris.RegisterListener("EntityEvent", 2, "after", function(object, event)
    if event == "UBW Weapon Creation Teleport Finished" and breakCreation == nil then
        print(event)
        dictionaryIndex = dictionaryIndex + 1
        if unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex] ~= nil and Ext.Template.GetRootTemplate(unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex]) ~= nil and unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex] ~= "a4bfb4e7-383c-4fcf-8644-a48fe3e07e63" then
            if Ext.Template.GetRootTemplate(unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex]).FileName:match("Globals") ~= nil or Ext.Template.GetRootTemplate(unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex]) == nil then
                print("False flag, firing skip event")
                Osi.SetEntityEvent(fakerCharacter, "UBW Weapon Creation Teleport Finished", 1)
            else
                print("Firing next function with weapon template: " .. unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex])
                UBWWeaponTransformv2(unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex], rarityIndex, nil)
            end
            
        else
            print("Dictionary increased")
            dictionaryIndex = dictionaryIndex + 1
            while unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex] == nil do
                print("Dictionary index reset, rarity increased")
                rarityIndex = rarityIndex + 1
                dictionaryIndex = 1

                if rarityIndex > 5 then
                    print("Weapon index increased")
                    dictionaryIndex = 1
                    rarityIndex = 1
                    weaponKeyIndex = weaponKeyIndex + 1
    
                    if weaponKeyIndex > 26 then
                        breakCreation = true
                        Osi.SetSubRegionName(GetHostCharacter(), "Unlimited Blade Works", 1)
                        Osi.ApplyStatus(fakerCharacter, "UBW_FINISHED_GENERATING", -1, 100, "")
                        local withinUBWtable = Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").withinUBW
                        Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").withinUBW = withinUBWtable
                        print("UBW finished generating in " .. (Ext.Utils.MonotonicTime() - UBWStartTime)/1000 .. " seconds")
                        for key, entry in pairs(Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)]) do
                            Osi.SetCanPickUp(entry.objectUUID, 0)
                            -- Osi.SetCanInteract(entry.objectUUID,0)

                        end

                        Ext.Timer.WaitFor(2500, Osi.SetEntityEvent(fakerCharacter, "UBW Generation Finished"))

                        break
                    end
                end
            end
            -- print("Found after while loop: " .. unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex])

            if breakCreation == nil and Ext.Template.GetRootTemplate(unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex]) ~= nil then
                UBWWeaponTransformv2(unorganizedList[weaponKeyIndex][rarityIndex][dictionaryIndex], rarityIndex, nil)
            else
                print("False flag, firing skip event")
                Osi.SetEntityEvent(fakerCharacter, "UBW Weapon Creation Teleport Finished", 1)
            end
        end
    end

    if event == "UBW Generation Finished" then
        local startTime = Ext.Utils.MonotonicTime()
        while Ext.Utils.MonotonicTime() - startTime < 2000 do
        end

        local UBWGenerationDictionary = Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage
        table.insert(UBWGenerationDictionary, nil)
        Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage = UBWGenerationDictionary
        Ext.Vars.DirtyModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5", "realityMarbleStorage")
        Ext.Vars.SyncModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5", "realityMarbleStorage")
        print("Weapons stored in UBW: " .. #Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)])
        -- Ext.IO.SaveFile("UBW Generated Weapons.json", Ext.DumpExport(Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage))
        Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage = Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage
        -- Osi.AutoSave()
    end

    if event == "UBW Object Deletion" then
        print("Trying to delete UBW object: " .. Ext.Loca.GetTranslatedString(Ext.Entity.Get(object).DisplayName.NameKey.Handle.Handle))
        Osi.UnloadItem(object)
        table.remove(createdObjectList, 1)
        if #createdObjectList > 0 then
            -- Osi.RemoveStatus(createdObjectList[1].objectUUID, "REPLICATED_WITHIN", fakerCharacter)
            Osi.SetEntityEvent(createdObjectList[1].objectUUID, "UBW Object Deletion")
        else
            local allDeleted = true
            for key, entry in pairs(Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)]) do
                if Ext.Entity.Get(entry) ~= nil then
                    allDeleted = false
                    createdObjectList = Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage[Osi.GetRegion(fakerCharacter)]
                    Ext.Timer.WaitFor(1000, Osi.SetEntityEvent(createdObjectList[1].objectUUID,"UBW Object Deletion"))
                    break
                end
            end
            if allDeleted == true then
                Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").realityMarbleStorage = {}
                print("Everything successfully deleted from UBW!!")
            end
        end

    end

end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "UBW_CAPTURED" then
        local x,y,z = Osi.GetPosition(object)
        local entity = Ext.Entity.Get(object)
        entity.Vars.preUBWPosition = {x,y,z}
        table.insert(Ext.Vars.GetModVariables("d80c56b3-5b89-4789-86a2-cbef2d7e1fa5").withinUBW, object)

        Ext.Timer.WaitFor(750, function()
            print("Attempted to capture " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(object)))
            local UBWRegionalCoords = UBWCoords(Osi.GetRegion(object))
            if Osi.IsEnemy(fakerCharacter, object) == 1 then
                local localUBWCoordinates = Ext.Entity.Get(fakerCharacter).Vars.preUBWPosition
                
                local x,y,z = Osi.GetPosition(object)
                local entity = Ext.Entity.Get(object)
                entity.Vars.preUBWPosition = {x,y,z}

                Osi.TeleportToPosition(object, UBWRegionalCoords[1] + x-localUBWCoordinates[1], UBWRegionalCoords[2], UBWRegionalCoords[3] + z-localUBWCoordinates[3], "", 0, 0, 0, 0, 1)
                Ext.Timer.WaitFor(300, Osi.SetSubRegionName(object, "Unlimited Blade Works", 1))
            else
                -- Ext.Timer.WaitFor(100, function()
                    if Osi.HasPassive(object, 'Passive_Aria_Eight') == 1 then -- faker
                        Osi.TeleportToPosition(object, UBWRegionalCoords[1]+1, UBWRegionalCoords[2], UBWRegionalCoords[3], "", 0, 0, 0, 0, 1)
                    else -- not faker
                        local localUBWCoordinates = Ext.Entity.Get(fakerCharacter).Vars.preUBWPosition
                        
                        local x,y,z = Osi.GetPosition(object)
                        local entity = Ext.Entity.Get(object)
                        entity.Vars.preUBWPosition = {x,y,z}

                        Osi.TeleportToPosition(object, UBWRegionalCoords[1] + x-localUBWCoordinates[1], UBWRegionalCoords[2], UBWRegionalCoords[3] + z-localUBWCoordinates[3], "", 0, 0, 0, 0, 1)
                    end
                -- end)
            end
        end)
    end

end)