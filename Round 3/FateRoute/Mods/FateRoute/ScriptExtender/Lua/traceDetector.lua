-- type
treeNode = {}
treeNode.__index = treeNode

function treeNode:new(key, data, left, right)
    local instance = setmetatable({}, treeNode)
    instance.key = key
    instance.data = data
    instance.left = left
    instance.right = right
    return instance
end

-- function detect weaponType
function weaponTypeDictionary(serverTemplateTags)
    for key, weaponType in pairs(serverTemplateTags) do
        if weaponType == "7609654e-b213-410d-b08f-6d2930da6411" then -- battleaxe
            return 1

        elseif weaponType == "9b333d67-365f-41fa-80b2-08e86588e9ac" then -- club
            return 2

        elseif weaponType == "7490e5d0-d346-4b0e-80c6-04e977160863" then -- dagger
            return 3

        elseif weaponType == "5d7b1304-6d20-4d60-ba1b-0fbb491bfc18" then -- flail
            return 4
            
        elseif weaponType == "7a15ea4f-cb00-4201-8e7f-024627e3d014" then -- glaive
            return 5

        elseif weaponType == "02da79f5-6f13-4f90-9819-102e37693f48" then -- greataxe
            return 6

        elseif weaponType == "ab44887d-0eb0-4fef-bd9d-943ea8971aa2" then -- greatclub
            return 7

        elseif weaponType == "aec4ed1a-993b-491f-a2db-640bf11869c1" then -- greatsword
            return 8
            
        elseif weaponType == "2c74855f-769a-43f5-b6db-48c4c47721ff" then -- halberd
            return 9

        elseif weaponType == "09dd1e1e-6d9f-4cc6-b514-68e981c80543" then -- handaxe
            return 10

        elseif weaponType == "b6e3bfa1-2c63-404f-becb-21d047aacce1" then -- javelin
            return 11

        elseif weaponType == "edc46cc0-25d0-4da9-bfcb-edba239edcce" then -- light hammer
            return 12

        elseif weaponType == "96a99a42-ec5d-4081-9d62-c9e3f0057136" then -- longsword
            return 13

        elseif weaponType == "c29fc6ce-0482-420d-a839-41a0bab95c2d" then -- mace
            return 14

        elseif weaponType == "2503012b-9cc4-491c-a068-282f8cea8707" then -- maul
            return 15

        elseif weaponType == "aa4cfcea-aee8-44b9-a460-e7231df796b1" then -- morningstar
            return 16
            
        elseif weaponType == "ca1a548b-f409-4cad-af5a-dfdd5834c709" then -- pike
            return 17

        elseif weaponType == "00a09d42-c23c-48b0-90cc-c67f6cbd9e3d" then -- quarterstaff
            return 18

        elseif weaponType == "aeaf4e95-38d7-45ec-8900-40bc9e6106b0" then -- rapier
            return 19
            
        elseif weaponType == "206f9701-7b24-4eaf-9ac4-a47746c251e2" then -- scimitar
            return 20

        elseif weaponType == "c826fd1e-4780-43d4-b49b-87f30c060fe6" then -- shortsword
            return 21

        elseif weaponType == "bfdc63bd-b8f6-4eac-9363-0c71882ff46f" then -- sickle
            return 22

        elseif weaponType == "fef6b399-19da-4d4b-b1ec-c79dff7f46c3" then -- spear
            return 23

        elseif weaponType == "c808f076-4a0f-422a-97db-e985ce35f3f9" then -- trident
            return 24

        elseif weaponType == "eed87cdb-c5ee-45c2-9a5a-6949dce87a1e" then -- warpick
            return 25

        elseif weaponType == "1dff197e-b74c-4173-94d3-e1323239556c" then -- warhammer
            return 26

        elseif weaponType == "c23ac9ef-5b47-4c2d-8ce5-7b60a8b34787" then -- dart
            return 27

        elseif weaponType == "1c12ee6d-50e2-459f-90c8-ae56701190ce" then -- hand crossbow
            return 28

        elseif weaponType == "2cc23bb9-d777-4265-a34c-333528628b90" then -- heavy crossbow
            return 29

        elseif weaponType == "a302a8e2-a3f9-41e1-a68c-70a453e65399" then -- light crossbow
            return 30

        elseif weaponType == "557d335c-0780-4665-9802-709a7d202dba" then -- longbow
            return 31

        elseif weaponType == "81197304-7116-4d7b-8ef4-207bbf636682" then -- shortbow
            return 32

        elseif weaponType == "59c686ae-c70c-453a-a6ce-8ffceb82026d" then -- sling
            return 33

        end

    end
end

-- function extra  tooltip description
function addExtraDescriptionRefined(target, weaponSlot, weaponUUID, meleeOrRanged)
    
    local weaponDisplayName = {Ext.Entity.Get(Osi.GetEquippedItem(target, weaponSlot[1])).DisplayName.NameKey.Handle.Handle,Ext.Entity.Get(Osi.GetEquippedItem(target, weaponSlot[2])).DisplayName.NameKey.Handle.Handle}
    local entity = Ext.Entity.Get(fakerCharacter)
    
    local extraSpellNum = {}
    for weaponNum = 1,2,1 do
        print("Weapon " .. weaponNum .. " is " .. Osi.ResolveTranslatedString(weaponDisplayName[weaponNum]))
        local foundWeaponDescription = false
        local localextraDescriptionTable = entity.Vars.extraDescriptionTable or {}
        if localextraDescriptionTable ~= {} then
            for i = 1,999,1 do
                local observedDescriptionTemplate = Ext.Stats.Get("Shout_TraceWeapon_TemplateDescription" .. i)
                if observedDescriptionTemplate.DisplayName == weaponDisplayName[weaponNum] then
                    foundWeaponDescription = true 

                    -- observedDescriptionTemplate.SpellContainerID = observedDescriptionTemplate.SpellContainerID .. ";" ..  originalSpell

                    entity.Vars.extraDescriptionTable = localextraDescriptionTable
                    extraSpellNum[weaponNum] = i
                    break
                end
            end
            
        end

        if foundWeaponDescription == false then
            local weaponDescription = {Ext.Entity.Get(Osi.GetEquippedItem(target, weaponSlot[1])).ServerItem.Template.Description.Handle.Handle,Ext.Entity.Get(Osi.GetEquippedItem(target, weaponSlot[2])).ServerItem.Template.Description.Handle.Handle}
            local weaponIcon = {Ext.Entity.Get(Osi.GetEquippedItem(target, weaponSlot[1])).Icon.Icon,Ext.Entity.Get(Osi.GetEquippedItem(target, weaponSlot[2])).Icon.Icon}
            
            for i = 1,999,1 do
                local observedDescriptionTemplate = Ext.Stats.Get("Shout_TraceWeapon_TemplateDescription" .. i) 
                if observedDescriptionTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                    observedDescriptionTemplate:SetRawAttribute("DisplayName", weaponDisplayName[weaponNum])
                    observedDescriptionTemplate:SetRawAttribute("Description", weaponDescription[weaponNum])
                    observedDescriptionTemplate:SetRawAttribute("Sheathing", meleeOrRanged)

                    if meleeOrRanged == "Melee" then
                        REPRODUCTION = "REPRODUCTION_MELEE"
                    else
                        REPRODUCTION = "REPRODUCTION_RANGED"
                    end

                    spellProperties = "AI_IGNORE:SummonInInventory(" .. weaponUUID[weaponNum] .. ",3,1,true,true,true,,," .. REPRODUCTION .. "," .. REPRODUCTION .. ")"
                    observedDescriptionTemplate:SetRawAttribute("SpellProperties", spellProperties)

                    observedDescriptionTemplate.Icon = weaponIcon[weaponNum]
                    observedDescriptionTemplate:Sync()

                    local observedStatusTemplate = Ext.Stats.Get("WEAPON_DESCRIPTION_TEMPLATE" .. i) 
                    observedStatusTemplate:SetRawAttribute("DisplayName", weaponDisplayName[weaponNum])
                    observedStatusTemplate.DescriptionParams = Osi.ResolveTranslatedString(weaponDisplayName[weaponNum])
                    observedStatusTemplate.Icon = weaponIcon[weaponNum]
                    observedStatusTemplate:Sync()

                    extraSpellNum[weaponNum] = i

                    break
                end
            end

            print(Osi.ResolveTranslatedString(weaponDisplayName[weaponNum]) .. " added to extraDescriptionTable")
            table.insert(localextraDescriptionTable, extraDescription:new(weaponDisplayName[weaponNum],weaponDescription[weaponNum],weaponIcon[weaponNum], spellProperties, meleeOrRanged))
            entity.Vars.extraDescriptionTable = localextraDescriptionTable
            
        end
    end

    return extraSpellNum

end

-- function BST
function insertBST(pointer, insert)
    -- if pointer doesn't exist
    if pointer == nil or pointer == {} or next(pointer) == nil then
        print("Adding root " .. insert.data.DisplayName .. " into weaponCatalog")
        
        return insert
    end

    -- if pointer exists
    if insert.key > pointer.key then
        print("Insert is greater than pointer")
        if pointer.right == nil or pointer.right == null  then -- if found and empty
            print("Adding " .. insert.data.DisplayName .. " into weaponCatalog")
            pointer.right = insert
        else -- if not found
            pointer.right = insertBST(pointer.right, insert) 
        end
    elseif insert.key < pointer.key then
        print("Insert is greater than pointer")
        if insert.left == nil or insert.left == null then -- if found and empty
            print("Adding " .. insert.data.DisplayName .. " into weaponCatalog")
            pointer.left = insert
        else -- if not found
            pointer.left = insertBST(pointer.left, insert)
        end
    else -- found, equal to and not empty
        print("Weapon found in weaponCatalog")
        if pointer.data.finesseWeapon ~= nil or pointer.data.meleeOrRanged == "Ranged" then -- if finesse weapon
            if pointer.data.wielderDexterity < insert.data.wielderDexterity then -- if dexterity is higher for the finesse weapon, then...
                print("Dexterity of " .. pointer.data.wielderDexterity .. " is being replaced with " .. insert.data.wielderDexterity)
                pointer.data.wielderDexterity = insert.data.wielderDexterity
                pointer.data.wielderStrength = insert.data.wielderStrength
                pointer.data.wielderMovementSpeed = insert.data.wielderMovementSpeed
                pointer.data.DisplayName = insert.data.DisplayName
            end 
        elseif pointer.data.wielderStrength < insert.data.Strength then -- if strength is higher for strength weapon then...
            print("Strength of " .. pointer.data.wielderStrength .. " is being replaced with " .. insert.data.wielderStrength)
            pointer.data.wielderStrength = insert.data.wielderStrength
            pointer.data.wielderDexterity = insert.data.wielderDexterity
            pointer.data.wielderMovementSpeed = insert.data.wielderMovementSpeed
            pointer.data.DisplayName = insert.data.DisplayName
        end
    end
        
    -- if pointer.key == insert.key then
    --     print("Weapon found in weaponCatalog")
    --     if pointer.data.finesseWeapon ~= nil or pointer.data.finesseWeapon ~= null or pointer.data.meleeOrRanged == "Ranged" then -- if finesse weapon
    --         if pointer.data.wielderDexterity < insert.wielderDexterity then -- if dexterity is higher for the finesse weapon, then...
    --             print("Dexterity of " .. pointer.data.wielderDexterity .. " is being replaced with " .. insert.data.wielderDexterity)
    --             pointer.data.wielderDexterity = insert.wielderDexterity
    --             pointer.data.wielderStrength = insert.wielderStrength
    --             pointer.data.wielderMovementSpeed = insert.wielderMovementSpeed
    --             pointer.data.DisplayName = insert.DisplayName
    --         end 
    --     elseif pointer.data.wielderStrength < insert.Strength then -- if strength is higher for strength weapon then...
    --         print("Strength of " .. pointer.data.wielderStrength .. " is being replaced with " .. insert.data.wielderStrength)
    --         pointer.data.wielderStrength = insert.wielderStrength
    --         pointer.data.wielderDexterity = insert.wielderDexterity
    --         pointer.data.wielderMovementSpeed = insert.wielderMovementSpeed
    --         pointer.data.DisplayName = insert.DisplayName
    --     end
    -- end

    return pointer
end


-- function insertBST(pointer, insert)
    --     if pointer.data == nil then -- if empty
    --         pointer = treeNode:new(insert.weaponName, insert, nil, nil)

    --         if pointer.data.traceIndex == nil then -- adding new spell
    --             print("Adding " .. pointer.data.DisplayName .. " into weaponCatalog")
    --             for i = 1,999,1 do
    --                 local observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
    --                 if ResolveTranslatedString(observedTraceTemplate.DisplayName) == pointer.data.DisplayName then -- exit
    --                     print(pointer.data.DisplayName .. " found")
    --                     return

    --                 elseif observedTraceTemplate.DisplayName == "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
    --                     -- copying over stats
    --                     pointer.data.traceIndex = i
    --                     Ext.Loca.UpdateTranslatedString(pointer.data.DisplayName, pointer.data.DisplayName)
    --                     observedTraceTemplate:SetRawAttribute("DisplayName", pointer.data.DisplayName)
    --                     observedTraceTemplate.Icon = pointer.data.Icon
    --                     observedTraceTemplate:SetRawAttribute("SpellProperties", pointer.data.spellProperties)
    --                     observedTraceTemplate:SetRawAttribute("Sheathing", pointer.data.meleeOrRanged)
    --                     observedTraceTemplate.UseCosts = pointer.data.UseCosts

    --                     if pointer.data.tooltipApply ~= nil then
    --                         observedTraceTemplate:SetRawAttribute("TooltipStatusApply", pointer.data.tooltipApply)
    --                         observedTraceTemplate:SetRawAttribute("DescriptionParams", "These weapons were;" .. pointer.data.wielderStrength .. ";" .. pointer.data.wielderDexterity .. ";" .. pointer.data.wielderMovementSpeed)
    --                     else
    --                         observedTraceTemplate:SetRawAttribute("DescriptionParams", "This weapon was;" .. pointer.data.wielderStrength .. ";" .. pointer.data.wielderDexterity .. ";" .. pointer.data.wielderMovementSpeed)
    --                     end

    --                     print("This sync produced a spell for " .. Osi.ResolveTranslatedString(observedTraceTemplate.DisplayName) .. " for template spell #" .. i) 
                        
    --                     Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog = localWeaponCatalog
                        
    --                     return
                        
    --                 end
    --             end
                
    --         end
    --     else -- if not empty
    --         if pointer.key == insert.weaponName then -- weapon found, check if stats are greater
    --             if pointer.data.finesseWeapon ~= nil or pointer.data.meleeOrRanged == "Ranged" then -- if finesse weapon
    --                 if pointer.data.wielderDexterity < insert.wielderDexterity then -- if dexterity is higher for the finesse weapon, then...
    --                     pointer.data.wielderDexterity = insert.wielderDexterity
    --                     pointer.data.wielderStrength = insert.wielderStrength
    --                     pointer.data.wielderMovementSpeed = insert.wielderMovementSpeed
    --                     pointer.data.DisplayName = insert.DisplayName
    --                 end 
    --             elseif pointer.data.wielderStrength < insert.Strength then -- if strength is higher for strength weapon then...
    --                 pointer.data.wielderStrength = insert.wielderStrength
    --                 pointer.data.wielderDexterity = insert.wielderDexterity
    --                 pointer.data.wielderMovementSpeed = insert.wielderMovementSpeed
    --                 pointer.data.DisplayName = insert.DisplayName
    --             end
    --             return -- exits after having found
            
    --         elseif pointer.key < insert.weaponName then -- if new weapon name is greater alphabetically then
    --             pointer = pointer.right

    --         else -- if new weapon name is smaller alphabetically then
    --             pointer = pointer.left
                
    --         end

    --     end
    -- end
--

function inorderTraversal(wepTypeRarity, traceIndices)
    if wepTypeRarity ~= nil and wepTypeRarity ~= {} then
        
        -- left
            if (wepTypeRarity.left ~= nil) then
                traceIndices = inorderTraversal(wepTypeRarity.left, traceIndices)
            end

        -- parent
            traceIndices = traceIndices+1
            print("Making spell for " .. wepTypeRarity.key .. " inside Shout_TraceWeapon_Template" .. traceIndices)
            if traceIndices < 10 then
                observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template00" .. traceIndices) -- getting trace template
            elseif traceIndices < 100 then
                observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template0" .. traceIndices) -- getting trace template
            else
                observedTraceTemplate = Ext.Stats.Get("Shout_TraceWeapon_Template" .. traceIndices) -- getting trace template
            end
            

            -- changing template
            Ext.Loca.UpdateTranslatedString(wepTypeRarity.data.DisplayName, wepTypeRarity.data.DisplayName) -- creating handle for display name
            observedTraceTemplate:SetRawAttribute("DisplayName", wepTypeRarity.data.DisplayName) -- setting display name
            observedTraceTemplate.Icon = wepTypeRarity.data.Icon -- setting icon
            observedTraceTemplate:SetRawAttribute("SpellProperties", wepTypeRarity.data.spellProperties) -- setting spell properties
            observedTraceTemplate:SetRawAttribute("Sheathing", wepTypeRarity.data.meleeOrRanged) -- setting sheathing
            observedTraceTemplate.UseCosts = wepTypeRarity.data.UseCosts -- setting usecosts
            if wepTypeRarity.data.tooltipApply ~= nil then -- checking if it's dual weapons
                observedTraceTemplate:SetRawAttribute("TooltipStatusApply", wepTypeRarity.data.tooltipApply) -- adding statuses if dual
                observedTraceTemplate:SetRawAttribute("DescriptionParams", "These weapons were;" .. wepTypeRarity.data.wielderStrength .. ";" .. wepTypeRarity.data.wielderDexterity .. ";" .. wepTypeRarity.data.wielderMovementSpeed) -- setting descriptionparams
            else
                observedTraceTemplate:SetRawAttribute("TooltipStatusApply", "  ")
                observedTraceTemplate:SetRawAttribute("DescriptionParams", "This weapon was;" .. wepTypeRarity.data.wielderStrength .. ";" .. wepTypeRarity.data.wielderDexterity .. ";" .. wepTypeRarity.data.wielderMovementSpeed)
            end

            observedTraceTemplate:Sync()  -- syncing template changes
            
        -- right
            if (wepTypeRarity.right ~= nil) then
                traceIndices = inorderTraversal(wepTypeRarity.right, traceIndices)
            end

            return traceIndices

    end

end

Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    
    -- change descriptions appropriately
    local traceMelee = Ext.Stats.Get("Shout_TraceWeapon_Melee")
    traceMelee:SetRawAttribute("Description","h5a42c8e19f57468d99487d79119824d4f360")

    local traceRanged = Ext.Stats.Get("Shout_TraceWeapon_Ranged")
    traceRanged:SetRawAttribute("Description","h209b718fc03d49a0b1e6246979b912330660")

    local traceNP = Ext.Stats.Get("Shout_TraceWeapon_NoblePhantasm")
    traceNP:SetRawAttribute("Description","hec37dd83ecc444f6a6507c8d3a165cc3e4c0")
    traceNP:Sync()

    -- check statuses
    fakerCharacter = locateFaker()

    local entity = Ext.Entity.Get(fakerCharacter)
    for keyStatus, entryStatus in pairs(entity.ServerCharacter.StatusManager.Statuses) do
        if entryStatus.StackId:match("STRUCTURAL_GRASP") == "STRUCTURAL_GRASP" then
            print("Removing lingering aria " .. entryStatus.StackId)
            Osi.RemoveStatus(fakerCharacter, entryStatus.StackId)
        end
    end 
    Osi.TimerLaunch("Apply Weapon Catalog", 2750)

    -- adding user variable
    Ext.Vars.RegisterUserVariable("weaponCatalog", {})
    Ext.Vars.RegisterUserVariable("targetTimer", {})
    Ext.Vars.RegisterUserVariable("emulateBoostVar", {})

    local entity = Ext.Entity.Get(fakerCharacter)
    local localWeaponCatalog = entity.Vars.weaponCatalog or {}

    print("localWeaponCatalog is:")
    _D(localWeaponCatalog)
    if localWeaponCatalog ~= {} and localWeaponCatalog ~= nil then -- if trace table has data
        if next(localWeaponCatalog) ~= nil then
            
            -- melee
            replaceContainer("Melee")
        
            -- ranged
            replaceContainer("Ranged")

        else
            print("Generating weapon catalog")
            local localWeaponCatalog = {}
            for weaponType = 1,33,1 do
                localWeaponCatalog[weaponType] = {}
                for rarity = 1,5,1 do
                    localWeaponCatalog[weaponType][rarity] = {}
                end
            end

            -- order
                -- Battleaxes = {}
                -- Clubs = {}
                -- Daggers = {}
                -- Flails = {}
                -- Glaives = {}
                -- Greataxes = {}
                -- Greatclubs = {}
                -- Greatswords = {}
                -- Halberds = {}
                -- Handaxes = {}
                -- Javelins = {}
                -- Lighthammers = {}
                -- Longswords = {}
                -- Maces = {}
                -- Mauls = {}
                -- Morningstars = {}
                -- Pikes = {}
                -- Quarterstaves = {}
                -- Rapiers = {}
                -- Scimitars = {}
                -- Shortswords = {}
                -- Sickles = {}
                -- Spears = {}
                -- Tridents = {}
                -- WarPicks = {}
                -- Warhammers = {}
                -- Darts = {}
                -- HandCrossbows = {}
                -- HeavyCrossbows = {}
                -- LightCrossbows = {}
                -- Longbows = {}
                -- Shortbows = {}
                -- Sling = {}

            -- adding into table
                -- localWeaponCatalog[1] = Battleaxes
                -- localWeaponCatalog[2] = Clubs
                -- localWeaponCatalog[3] = Daggers
                -- localWeaponCatalog[4] = Flails
                -- localWeaponCatalog[5] = Glaives
                -- localWeaponCatalog[6] = Greataxes
                -- localWeaponCatalog[7] = Greatclubs
                -- localWeaponCatalog[8] = Greatswords
                -- localWeaponCatalog[9] = Halberds
                -- localWeaponCatalog[10] = Handaxes
                -- localWeaponCatalog[11] = Javelins
                -- localWeaponCatalog[12] = Lighthammers
                -- localWeaponCatalog[13] = Longswords
                -- localWeaponCatalog[14] = Maces
                -- localWeaponCatalog[15] = Mauls
                -- localWeaponCatalog[16] = Morningstars
                -- localWeaponCatalog[17] = Pikes
                -- localWeaponCatalog[18] = Quarterstaves
                -- localWeaponCatalog[19] = Rapiers
                -- localWeaponCatalog[20] = Scimitars
                -- localWeaponCatalog[21] = Shortswords
                -- localWeaponCatalog[22] = Sickles
                -- localWeaponCatalog[23] = Spears
                -- localWeaponCatalog[24] = Tridents
                -- localWeaponCatalog[25] = WarPicks
                -- localWeaponCatalog[26] = Warhammers
                -- localWeaponCatalog[27] = Darts
                -- localWeaponCatalog[28] = HandCrossbows
                -- localWeaponCatalog[29] = HeavyCrossbows
                -- localWeaponCatalog[30] = LightCrossbows
                -- localWeaponCatalog[31] = Longbows
                -- localWeaponCatalog[32] = Shortbows
                -- localWeaponCatalog[33] = Sling

            entity.Vars.weaponCatalog = localWeaponCatalog
        end
    else
        print("Generating weapon catalog")
        local localWeaponCatalog = {}
        for weaponType = 1,33,1 do
            localWeaponCatalog[weaponType] = {}
            for rarity = 1,5,1 do
                localWeaponCatalog[weaponType][rarity] = {}
            end
        end
        
            -- order
                -- Battleaxes = {}
                -- Clubs = {}
                -- Daggers = {}
                -- Flails = {}
                -- Glaives = {}
                -- Greataxes = {}
                -- Greatclubs = {}
                -- Greatswords = {}
                -- Halberds = {}
                -- Handaxes = {}
                -- Javelins = {}
                -- Lighthammers = {}
                -- Longswords = {}
                -- Maces = {}
                -- Mauls = {}
                -- Morningstars = {}
                -- Pikes = {}
                -- Quarterstaves = {}
                -- Rapiers = {}
                -- Scimitars = {}
                -- Shortswords = {}
                -- Sickles = {}
                -- Spears = {}
                -- Tridents = {}
                -- WarPicks = {}
                -- Warhammers = {}
                -- Dart = {}
                -- HandCrossbows = {}
                -- HeavyCrossbows = {}
                -- LightCrossbows = {}
                -- Longbows = {}
                -- Shortbows = {}
                -- Sling = {}

            -- adding into table
                -- localWeaponCatalog[1] = Battleaxes
                -- localWeaponCatalog[2] = Clubs
                -- localWeaponCatalog[3] = Daggers
                -- localWeaponCatalog[4] = Flails
                -- localWeaponCatalog[5] = Glaives
                -- localWeaponCatalog[6] = Greataxes
                -- localWeaponCatalog[7] = Greatclubs
                -- localWeaponCatalog[8] = Greatswords
                -- localWeaponCatalog[9] = Halberds
                -- localWeaponCatalog[10] = Handaxes
                -- localWeaponCatalog[11] = Javelins
                -- localWeaponCatalog[12] = Lighthammers
                -- localWeaponCatalog[13] = Longswords
                -- localWeaponCatalog[14] = Maces
                -- localWeaponCatalog[15] = Mauls
                -- localWeaponCatalog[16] = Morningstars
                -- localWeaponCatalog[17] = Pikes
                -- localWeaponCatalog[18] = Quarterstaves
                -- localWeaponCatalog[19] = Rapiers
                -- localWeaponCatalog[20] = Scimitars
                -- localWeaponCatalog[21] = Shortswords
                -- localWeaponCatalog[22] = Sickles
                -- localWeaponCatalog[23] = Spears
                -- localWeaponCatalog[24] = Tridents
                -- localWeaponCatalog[25] = WarPicks
                -- localWeaponCatalog[26] = Warhammers
                -- localWeaponCatalog[27] = Dart
                -- localWeaponCatalog[28] = HandCrossbows
                -- localWeaponCatalog[29] = HeavyCrossbows
                -- localWeaponCatalog[30] = LightCrossbows
                -- localWeaponCatalog[31] = Longbows
                -- localWeaponCatalog[32] = Shortbows
                -- localWeaponCatalog[33] = Sling

            entity.Vars.weaponCatalog = localWeaponCatalog

    end

    -- Osi.AddSpell(fakerCharacter, "Shout_TraceWeapon_Melee", 0, 1)
    -- Osi.AddSpell(fakerCharacter, "Shout_TraceWeapon_Ranged", 0, 1)

end)

Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer)
    if timer == "Apply Weapon Catalog" then
        ApplyStatus(fakerCharacter, "STRUCTURAL_GRASP", -1, 100)
    end
    if timer == "Copy Weapon Timer" then
        copyWeaponTimer = nil
    end 
    
end)

function replaceContainer(weaponType)
    local localWeaponCatalog = Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog

    local spellContainer = ""
    local traceIndices = 0
    if weaponType == "Melee" then
        traceIndices = 0
        traceSpellName = "Shout_TraceWeapon_Melee"
        local isFilled = false

        for rarity = 5,1,-1 do -- cycles through each rarity
            for weaponKey = 1,26,1 do
                if localWeaponCatalog[weaponKey][rarity] ~= nil  then
                    if next(localWeaponCatalog[weaponKey][rarity]) ~= nil then
                        -- print("Weapon catalog of type " .. weaponKey .. " and rarity " .. rarity .. " is:")
                        -- _D(localWeaponCatalog[weaponKey][rarity])
                        traceIndices = inorderTraversal(localWeaponCatalog[weaponKey][rarity], traceIndices)
                        isFilled = true
                    end
                end
            end
        end

        if isFilled == true then
            for i = 1,traceIndices,1 do
                if i < 10 then
                    spellContainer = spellContainer .. "Shout_TraceWeapon_Template00" .. i .. ";"
                elseif i < 100 then
                    spellContainer = spellContainer .. "Shout_TraceWeapon_Template0" .. i .. ";"
                else
                    spellContainer = spellContainer .. "Shout_TraceWeapon_Template" .. i .. ";"
                end
            end
        end

    else
        traceIndices = 699
        traceSpellName = "Shout_TraceWeapon_Ranged"
        local isFilled = false

        for rarity = 5,1,-1 do -- cycles through each rarity
            for weaponKey = 27,33,1 do
                if localWeaponCatalog[weaponKey][rarity] ~= nil then
                    if next(localWeaponCatalog[weaponKey][rarity]) ~= nil then
                        traceIndices = inorderTraversal(localWeaponCatalog[weaponKey][rarity], traceIndices)
                        isFilled = true
                    end
                end
            end
        end

        if isFilled == true then
            for i = 700,traceIndices,1 do
                if i < 10 then
                    spellContainer = spellContainer .. "Shout_TraceWeapon_Template00" .. i .. ";"
                elseif i < 100 then
                    spellContainer = spellContainer .. "Shout_TraceWeapon_Template0" .. i .. ";"
                else
                    spellContainer = spellContainer .. "Shout_TraceWeapon_Template" .. i .. ";"
                end        
            end
        end

    end

    local traceSpell = Ext.Stats.Get(traceSpellName) 
    print("spellContainer for " .. traceSpellName .. " is: " .. spellContainer)
    traceSpell.ContainerSpells = spellContainer
    traceSpell:Sync()
    Osi.RemoveSpell(fakerCharacter,traceSpellName,1)
    -- Osi.AddSpell(fakerCharacter,traceSpellName,0,1)

end

function copyWeaponVision(character)
    local targetEntity = Ext.Entity.Get(character)
    local localTargetTimer = targetEntity.Vars.targetTimer
    
    if localTargetTimer == nil then

        -- attributes of trace character
            local strength = targetEntity.Stats.Abilities[2]
            local dexterity =  targetEntity.Stats.Abilities[3]
            local movementSpeed = targetEntity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount
            local wielderName = Osi.ResolveTranslatedString(targetEntity.DisplayName.NameKey.Handle.Handle)

        -- melee
        if Osi.HasMeleeWeaponEquipped(character, "Any") == 1 then
            local mainWeapon = Osi.GetEquippedItem(character, "Melee Main Weapon")
            _D("Main weapon of " .. character .. " is " .. mainWeapon)

            -- more attributes
                local icon = Ext.Entity.Get(mainWeapon).Icon.Icon
                local spellProperties = "ApplyStatus(FAKER_MELEE,100,3);"
                local meleeOrRanged = "Melee"
                local weaponName = Ext.Loca.GetTranslatedString(Ext.Entity.Get(mainWeapon).DisplayName.NameKey.Handle.Handle) 
                local rarity = Ext.Entity.Get(mainWeapon).Value.Rarity + 1

            -- check if finesse
                for key, entry in pairs(Ext.Stats.Get(Ext.Entity.Get(mainWeapon).ServerItem.Stats)["Weapon Properties"]) do
                    if entry == "Finesse" then
                        finesse = true
                        break
                    end
                end

            if Osi.HasMeleeWeaponEquipped(character, "Offhand") == 1 or Osi.GetEquippedShield(character) ~= nil then -- if offhand or shield
                local offWeapon = Osi.GetEquippedItem(character, "Melee Offhand Weapon")
                local weaponUUID = {Ext.Entity.Get(mainWeapon).ServerItem.Template.Id, Ext.Entity.Get(offWeapon).ServerItem.Template.Id}
        
                if Osi.HasMeleeWeaponEquipped(character, "Offhand") == 1 then -- if offhand
                    spellProperties = spellProperties .. "AI_IGNORE:SummonInInventory(" .. weaponUUID[1] .. ",3,1,true,true,true,,,REPRODUCTION_MELEE, REPRODUCTION_MELEE);AI_IGNORE:SummonInInventory(" .. weaponUUID[2] .. ",3,1,true,true,true,,,REPRODUCTION_MELEE_OFFHAND, REPRODUCTION_MELEE_OFFHAND)"
                else -- if shield
                    spellProperties = spellProperties .. "AI_IGNORE:SummonInInventory(" .. weaponUUID[1] .. ",3,1,true,true,true,,,REPRODUCTION_MELEE, REPRODUCTION_MELEE);AI_IGNORE:SummonInInventory(" .. weaponUUID[2] .. ",3,1,true,true,true,,,REPRODUCTION_MELEE_OFFHAND, REPRODUCTION_MELEE_SHIELD)"
                end

                local magicalEnergyCost = "MagicalEnergy:" .. rarity*2 + (Ext.Entity.Get(offWeapon).Value.Rarity)
                local extraSpellNum = addExtraDescriptionRefined(character, {"Melee Main Weapon", "Melee Offhand Weapon"}, weaponUUID, meleeOrRanged)
                local tooltipApply = "ApplyStatus(WEAPON_DESCRIPTION_TEMPLATE" .. extraSpellNum[1] .. ",100,3);ApplyStatus(WEAPON_DESCRIPTION_TEMPLATE" .. extraSpellNum[2] .. ",100,3)"

                local offWeaponName = Ext.Loca.GetTranslatedString(Ext.Entity.Get(offWeapon).DisplayName.NameKey.Handle.Handle) 
                if offWeaponName == weaponName then
                    weaponName = weaponName .. "s"
                    DisplayName = wielderName .. "'s " .. weaponName
                else
                    weaponName = weaponName .. " and " .. offWeaponName
                    DisplayName = wielderName .. "'s " .. weaponName
                end

                if Ext.Stats.Get(Ext.Entity.Get(mainWeapon).Data.StatsId).UseConditions == "" and Ext.Stats.Get(Ext.Entity.Get(offWeapon).Data.StatsId).UseConditions == "" then

                    local traceInsertMelee = treeNode:new(weaponName,traceObject:new(DisplayName, icon, weaponUUID, spellProperties, magicalEnergyCost, tooltipApply, strength, dexterity, movementSpeed, meleeOrRanged, nil,finesse))
                    local localWeaponCatalog = Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog
                    print("traceInsert, dual melee weapons, is...")
                    _D(traceInsertMelee)
                    local insertOutput = insertBST(localWeaponCatalog[weaponTypeDictionary(Ext.Entity.Get(mainWeapon).ServerTemplateTag.Tags)][rarity],traceInsertMelee) -- inserts into BST

                    localWeaponCatalog[weaponTypeDictionary(Ext.Entity.Get(mainWeapon).ServerTemplateTag.Tags)][rarity] = insertOutput
                    Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog = localWeaponCatalog

                    replaceContainer(meleeOrRanged)

                end

            else -- if lone weapon
                local weaponUUID = {Ext.Entity.Get(mainWeapon).ServerItem.Template.Id, nil}
                local DisplayName = wielderName .. "'s " .. weaponName
                spellProperties = spellProperties .. "AI_IGNORE:SummonInInventory(" .. weaponUUID[1] .. ",3,1,true,true,true,,,REPRODUCTION_MELEE, REPRODUCTION_MELEE)"
                local magicalEnergyCost = "MagicalEnergy:" .. rarity*2

                if Ext.Stats.Get(Ext.Entity.Get(mainWeapon).Data.StatsId).UseConditions == "" then

                    local traceInsertMelee = treeNode:new(weaponName,traceObject:new(DisplayName, icon, weaponUUID, spellProperties, magicalEnergyCost, nil, strength, dexterity, movementSpeed, meleeOrRanged, nil,finesse))
                    local localWeaponCatalog = Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog
                    print("traceInsert, lone melee weapon, is...")
                    _D(traceInsertMelee)
                    local insertOutput = insertBST(localWeaponCatalog[weaponTypeDictionary(Ext.Entity.Get(mainWeapon).ServerTemplateTag.Tags)][rarity],traceInsertMelee) -- inserts into BST

                    localWeaponCatalog[weaponTypeDictionary(Ext.Entity.Get(mainWeapon).ServerTemplateTag.Tags)][rarity] = insertOutput
                    Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog = localWeaponCatalog

                    replaceContainer(meleeOrRanged)

                end

            end

        end
        -- ranged
        if Osi.HasRangedWeaponEquipped(character, "Any") == 1 then
            local mainWeapon = Osi.GetEquippedItem(character, "Ranged Main Weapon")

            -- more attributes
                local icon = Ext.Entity.Get(mainWeapon).Icon.Icon
                local spellProperties = "ApplyStatus(FAKER_RANGED,100,3);"
                local meleeOrRanged = "Ranged"
                local weaponName = Ext.Loca.GetTranslatedString(Ext.Entity.Get(mainWeapon).DisplayName.NameKey.Handle.Handle) 
                local rarity = Ext.Entity.Get(mainWeapon).Value.Rarity + 1

            if Osi.HasRangedWeaponEquipped(character, "Offhand") == 1 then -- if offhand or shield
                local offWeapon = Osi.GetEquippedItem(character, "Ranged Offhand Weapon")
                local weaponUUID = {Ext.Entity.Get(mainWeapon).ServerItem.Template.Id, Ext.Entity.Get(offWeapon).ServerItem.Template.Id}
                spellProperties = spellProperties .. "AI_IGNORE:SummonInInventory(" .. weaponUUID[1] .. ",3,1,true,true,true,,,REPRODUCTION_RANGED, REPRODUCTION_RANGED);AI_IGNORE:SummonInInventory(" .. weaponUUID[2] .. ",3,1,true,true,true,,,REPRODUCTION_RANGED_OFFHAND, REPRODUCTION_RANGED_OFFHAND)"

                local magicalEnergyCost = "MagicalEnergy:" .. rarity*2 + (Ext.Entity.Get(offWeapon).Value.Rarity)
                local extraSpellNum = addExtraDescriptionRefined(character, {"Ranged Main Weapon", "Ranged Offhand Weapon"}, weaponUUID, meleeOrRanged)
                local tooltipApply = "ApplyStatus(WEAPON_DESCRIPTION_TEMPLATE" .. extraSpellNum[1] .. ",100,3);ApplyStatus(WEAPON_DESCRIPTION_TEMPLATE" .. extraSpellNum[2] .. ",100,3)"

                local offWeaponName = Ext.Loca.GetTranslatedString(Ext.Entity.Get(offWeapon).DisplayName.NameKey.Handle.Handle) 
                if offWeaponName == weaponName then
                    weaponName = weaponName .. "s"
                    local DisplayName = wielderName .. "'s " .. weaponName
                else
                    weaponName = weaponName .. " and " .. offWeaponName
                    local DisplayName = wielderName .. "'s " .. weaponName
                end

                if Ext.Stats.Get(Ext.Entity.Get(mainWeapon).Data.StatsId).UseConditions == "" and Ext.Stats.Get(Ext.Entity.Get(offWeapon).Data.StatsId).UseConditions == "" then -- check if usable by player

                    local traceInsertRanged = treeNode:new(weaponName,traceObject:new(DisplayName, icon, weaponUUID, spellProperties, magicalEnergyCost, tooltipApply, strength, dexterity, movementSpeed, meleeOrRanged, nil,nil))
                    local localWeaponCatalog = Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog
                    print("traceInsert, dual ranged weapons, is...")
                    _D(traceInsertRanged)
                    local insertOutput = insertBST(localWeaponCatalog[weaponTypeDictionary(Ext.Entity.Get(mainWeapon).ServerTemplateTag.Tags)][rarity],traceInsertRanged) -- inserts into BST

                    localWeaponCatalog[weaponTypeDictionary(Ext.Entity.Get(mainWeapon).ServerTemplateTag.Tags)][rarity] = insertOutput
                    Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog = localWeaponCatalog

                    replaceContainer(meleeOrRanged)

                end

            else -- if lone weapon
                local weaponUUID = {Ext.Entity.Get(mainWeapon).ServerItem.Template.Id, nil}
                local DisplayName = wielderName .. "'s " .. weaponName
                spellProperties = spellProperties .. "AI_IGNORE:SummonInInventory(" .. weaponUUID[1] .. ",3,1,true,true,true,,,REPRODUCTION_RANGED, REPRODUCTION_RANGED)"
                local magicalEnergyCost = "MagicalEnergy:" .. rarity*2

                if Ext.Stats.Get(Ext.Entity.Get(mainWeapon).Data.StatsId).UseConditions == "" then

                    local traceInsertRanged = treeNode:new(weaponName,traceObject:new(DisplayName, icon, weaponUUID, spellProperties, magicalEnergyCost, nil, strength, dexterity, movementSpeed, meleeOrRanged, nil,nil))
                    local localWeaponCatalog = Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog
                    print("traceInsert. lone ranged weapon, is...")
                    _D(traceInsertRanged)
                    local insertOutput = insertBST(localWeaponCatalog[weaponTypeDictionary(Ext.Entity.Get(mainWeapon).ServerTemplateTag.Tags)][rarity],traceInsertRanged) -- inserts into BST

                    localWeaponCatalog[weaponTypeDictionary(Ext.Entity.Get(mainWeapon).ServerTemplateTag.Tags)][rarity] = insertOutput
                    Ext.Entity.Get(fakerCharacter).Vars.weaponCatalog = localWeaponCatalog

                    replaceContainer(meleeOrRanged)

                end
                
            end
        end

        targetEntity.Vars.targetTimer = 1
        Ext.Timer.WaitFor(5000, targetTimerReset(character))

    end
end

function targetTimerReset(character)
    local targetEntity = Ext.Entity.Get(character)
    local localTargetTimer = nil
    targetEntity.Vars.targetTimer = localTargetTimer

end

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(character, status, causee, storyActionID)
    if status == "WEAPON_COPIED" then
        if copyWeaponTimer == nil then
            copyWeaponVision(character)
            Osi.TimerLaunch("Copy Weapon Timer", 1250)
            copyWeaponTimer = 1
        end

    end

end)

print("Trace detector loaded")