-- statusTable

-- statusApply = {}
-- statusApply.__index = extraDescription

-- function statusApply:new(statusDisplayName, translatedWeaponDisplayName, statusIcon, statusBoosts)
--     local instance = setmetatable({}, traceVariables)
--     instance.statusDisplayName = statusDisplayName
--     instance.translatedWeaponDisplayName = translatedWeaponDisplayName
--     instance.statusIcon = statusIcon
--     instance.statusBoosts = statusBoosts
--     return instance
-- end

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

-- function addApplyStatus(character, weaponSlot, weaponUUID, extraSpellNum)
    
--     local weaponDisplayName = {Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).DisplayName.NameKey.Handle.Handle,Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).DisplayName.NameKey.Handle.Handle}
--     local entity = Ext.Entity.Get(character)
    
--     local statusNum = {}
--     for weaponNum = 1,2,1 do
--         local foundWeaponDescription = false
--         local localstatusApplyTable = entity.Vars.statusApplyTable or {}
--         if localstatusApplyTable ~= {} then
--             _D(localstatusApplyTable)
--             for i = 1,999,1 do
--                 local observedStatusTemplate = Ext.Stats.Get("WEAPON_DESCRIPTION_TEMPLATE" .. i)
--                 if observedStatusTemplate.DisplayName == weaponDisplayName[weaponNum] then
--                     foundWeaponDescription = true 
--                     statusNum[weaponNum] = i
--                     break
--                 end
--             end
            
--         end

--         if foundWeaponDescription == false then
--             local boosts = {}
--             local translatedWeaponDisplayName = {Osi.ResolveTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).DisplayName.NameKey.Handle.Handle),Osi.ResolveTranslatedString(Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).DisplayName.NameKey.Handle.Handle)}
--             local weaponIcon = {Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[1])).Icon.Icon,Ext.Entity.Get(Osi.GetEquippedItem(character, weaponSlot[2])).Icon.Icon}
            
--             for i = 1,999,1 do
--                 local observedStatusTemplate = Ext.Stats.Get("WEAPON_DESCRIPTION_TEMPLATE" .. i) 
--                 if observedStatusTemplate.DisplayName == "hbb03389153034c47a5c18ce5f66198fc42d7" then
--                     observedStatusTemplate:SetRawAttribute("DisplayName", weaponDisplayName[weaponNum])
--                     observedStatusTemplate.DescriptionParams = translatedWeaponDisplayName[weaponNum]

--                     print("Assigned Shout_TraceWeapon_TemplateDescription" .. extraSpellNum[weaponNum] .. " to status WEAPON_DESCRIPTION_TEMPLATE" .. i )
--                     boosts[weaponNum] = "UnlockSpell(Shout_TraceWeapon_TemplateDescription" .. extraSpellNum[weaponNum] .. ")"
--                     -- observedStatusTemplate.Boosts = boosts[weaponNum]
--                     observedStatusTemplate.Icon = weaponIcon[weaponNum]
--                     statusNum[weaponNum] = i
--                     observedStatusTemplate:Sync()
--                     break
--                 end
--             end

--             table.insert(localstatusApplyTable, statusApply:new(weaponDisplayName[weaponNum],translatedWeaponDisplayName[weaponNum],weaponIcon[weaponNum], boosts[weaponNum]))
--             entity.Vars.statusApplyTable = localstatusApplyTable

--         end
--     end

--     return statusNum

-- end