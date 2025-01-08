-- Ext.Osiris.RegisterListener("MissedBy", 4, "after", function(defender, attackOwner, attacker, storyActionID)     
--     if (Osi.HasActiveStatus(attacker, "FAKER_MELEE") == 1 or Osi.HasActiveStatus(attackOwner, "FAKER_MELEE") == 1) and savingThrowTimer == nil then
--         local fakerCharacter = attacker or attackOwner
--         print("Attacker is " .. attacker .. " and defender is " .. defender)
--         if (Osi.HasActiveStatus(attacker, "REINFORCEMENT_OVEREDGE") == 1) then
--             if (Osi.HasPassive(attacker, "Passive_MentalBattle") == 1) then
--                 Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Intelligence", "13467824-03fd-4316-a0d1-5412cb6f9b2b", 1, "Image Failure Roll (Melee)")
--             else
--                 Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Intelligence", "13467824-03fd-4316-a0d1-5412cb6f9b2b", 0, "Image Failure Roll (Melee)")
--             end
--         else
--             if (Osi.HasPassive(attacker, "Passive_MentalBattle") == 1) then
--                 Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Intelligence", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 1, "Image Failure Roll (Melee)")
--             else
--                 Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Intelligence", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 0, "Image Failure Roll (Melee)")
--             end
--         end
--         Osi.TimerLaunch("Fate Saving Throw Timer",250)
--         savingThrowTimer = true
--     end

--     if (Osi.HasActiveStatus(attacker, "FAKER_RANGED") == 1 or Osi.HasActiveStatus(attackOwner, "FAKER_RANGED") == 1) and savingThrowTimer == nil then
--         local fakerCharacter = attacker or attackOwner
--         print("Attacker is " .. attacker .. " and defender is " .. defender)
--         if (Osi.HasActiveStatus(attacker, "REINFORCEMENT_OVERDRAW") == 1) then
--             if (Osi.HasPassive(attacker, "Passive_MentalBattle") == 1) then
--                 Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Intelligence", "13467824-03fd-4316-a0d1-5412cb6f9b2b", 1, "Image Failure Roll (Ranged)")
--             else
--                 Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Intelligence", "13467824-03fd-4316-a0d1-5412cb6f9b2b", 0, "Image Failure Roll (Ranged)")
--             end
--         else
--             if (Osi.HasPassive(attacker, "Passive_MentalBattle") == 1) then
--                 Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Intelligence", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 1, "Image Failure Roll (Ranged)")
--             else
--                 Osi.RequestPassiveRoll(fakerCharacter, fakerCharacter,"SavingThrow", "Intelligence", "f149a3ce-7625-4b9c-97b5-cfefaf791b64", 0, "Image Failure Roll (Ranged)")
--             end
--         end
--         Osi.TimerLaunch("Fate Saving Throw Timer",250)
--         savingThrowTimer = true
--     end
-- end)

-- Ext.Osiris.RegisterListener("RollResult", 6, "after", function(eventName, roller, rollSubject, resultType, isActiveRoll, criticality)
--     if eventName == "Image Failure Roll (Melee)" then 
--         local fakerCharacter = roller
--         if resultType == 0 then
--             Osi.RemoveStatus(fakerCharacter,"FAKER_MELEE")
--         end
--     end

--     if eventName == "Image Failure Roll (Ranged)" then 
--         local fakerCharacter = roller
--         if resultType == 0 then
--             Osi.RemoveStatus(fakerCharacter,"FAKER_RANGED")
--         end
--     end
-- end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if status == "REMOVE_FAKER_MELEE" or status == "MINDS_EYE_REMOVE" then
        Osi.RemoveStatus(object, "FAKER_MELEE", object)
    end
    if status == "REMOVE_FAKER_RANGED" then
        Osi.RemoveStatus(object, "FAKER_RANGED", object)
    end
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    if spell == "Shout_DispelWeapon_Melee" then
        Osi.RemoveStatus(caster, "FAKER_MELEE", caster)
    end

    if spell == "Shout_DispelWeapon_Ranged" then
        Osi.RemoveStatus(caster, "FAKER_MELEE", caster)
    end

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    
    if status == "FAKER_MELEE" then
        if Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker ~= nil then
            mainWeapon = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[1]
            print("Main melee weapon is " .. mainWeapon)

            if Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[2] ~= nil then
                offhandWeapon = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[2]
                print("Offhand melee weapon is " .. offhandWeapon)
            end
        end

        -- if Osi.HasActiveStatus(object, "FAKER_RANGED") == 0 then
        --     Osi.RemoveStatus(object, "EMULATE_WIELDER_ADDPASSIVE", object)
        -- end

        Ext.Timer.WaitFor(10, function()
            if Osi.HasPassive(fakerCharacter, "Passive_TriggerOff") == 1 then
                if Osi.HasActiveStatus(fakerCharacter, "TRIGGEROFF_MELEE") == 1 then
                    Osi.RemoveStatus(fakerCharacter, "TRIGGEROFF_MELEE", fakerCharacter)
                end
            end
        end)
        
        print("Faker melee removed")
        if mainWeapon ~= nil then
            if Osi.HasActiveStatus(mainWeapon, "REPRODUCTION_MELEE") == 1 then
                Osi.PlayEffect(fakerCharacter, "40126f74-d57d-e88a-8d6d-2c731f3300e9", "Dummy_R_HandFX",1)
                deleteTracedWeapon(fakerCharacter, mainWeapon)
                -- local mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
                -- if GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter) ~= nil then
                --     Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
                -- end
                -- Osi.TemplateRemoveFrom(mainWeaponTemplate, fakerCharacter, 1)
                -- print("Attempted to remove " .. mainWeaponTemplate)
                -- Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                -- Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                -- Ext.Timer.WaitFor(1000, function()
                --     print("Attempting to unload")
                --     Osi.UnloadItem(mainWeapon)
                --     Osi.UnloadItem(mainWeaponTemplate)
                --     Osi.UnloadItem(mainWeapon)
                -- end)
            end

        end

        if offhandWeapon ~= nil then
            if Osi.HasActiveStatus(offhandWeapon, "REPRODUCTION_MELEE_OFFHAND") == 1 or Osi.HasActiveStatus(offhandWeapon, "REPRODUCTION_MELEE_SHIELD") == 1 then
                Osi.PlayEffect(fakerCharacter, "40126f74-d57d-e88a-8d6d-2c731f3300e9", "Dummy_L_HandFX",1)
                deleteTracedWeapon(fakerCharacter, offhandWeapon)
                -- local offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
                -- if GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter) ~= nil then
                --     Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter))
                -- end
                -- Osi.TemplateRemoveFrom(offhandWeaponTemplate, fakerCharacter, 1)
                -- -- Osi.UnloadItem(offWeapon)
                -- print("Attempted to remove " .. offhandWeaponTemplate)
                -- Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                -- Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                -- Ext.Timer.WaitFor(1000, function()
                --     Osi.UnloadItem(offhandWeapon)
                --     Osi.UnloadItem(offhandWeaponTemplate)
                --     Osi.UnloadItem(offhandWeapon)
                -- end)
            end
        end
        

        Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker = nil
    end

    if status == "FAKER_RANGED" then 
        if Ext.Entity.Get(fakerCharacter).Vars.rangedWeaponTracker ~= nil then
            mainWeaponRanged = Ext.Entity.Get(fakerCharacter).Vars.rangedWeaponTracker[1]
            print("Main ranged weapon is " .. mainWeaponRanged)

            if Ext.Entity.Get(fakerCharacter).Vars.rangedWeaponTracker[2] ~= nil then
                offhandWeaponRanged = Ext.Entity.Get(fakerCharacter).Vars.rangedWeaponTracker[2]
                print("Offhand melee weapon is " .. offhandWeaponRanged)
            end
        end

        -- if Osi.HasActiveStatus(object, "FAKER_MELEE") == 0 then
        --     Osi.RemoveStatus(object, "EMULATE_WIELDER_ADDPASSIVE", object)
        -- end

        Ext.Timer.WaitFor(10, function()
            if Osi.HasPassive(fakerCharacter, "Passive_TriggerOff") == 1 then
                if Osi.HasActiveStatus(fakerCharacter, "TRIGGEROFF_RANGED") == 1 then
                    Osi.RemoveStatus(fakerCharacter, "TRIGGEROFF_RANGED", fakerCharacter)
                end
            end
        end)

        print("Faker ranged removed")
        if mainWeaponRanged ~= nil then 
            if Osi.HasActiveStatus(mainWeaponRanged, "REPRODUCTION_RANGED") == 1 then
                Osi.PlayEffect(fakerCharacter, "40126f74-d57d-e88a-8d6d-2c731f3300e9", "Dummy_R_HandFX",1)
                deleteTracedWeapon(fakerCharacter, mainWeaponRanged)
                -- local mainWeaponTemplateRanged = Osi.GetTemplate(mainWeaponRanged) 
                -- if GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter) ~= nil then
                --     Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter))
                -- end
                -- Osi.TemplateRemoveFrom(mainWeaponTemplateRanged, fakerCharacter, 1)
                -- print("Attempted to remove " .. mainWeaponTemplateRanged)
                -- Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                -- Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                -- Ext.Timer.WaitFor(1000, function()
                --     Osi.UnloadItem(mainWeaponRanged)
                --     Osi.UnloadItem(mainWeaponTemplateRanged)
                --     Osi.UnloadItem(mainWeaponRanged)
                -- end)
            end
        end

        if offhandWeaponRanged ~= nil then
            if Osi.HasActiveStatus(offhandWeaponRanged, "REPRODUCTION_RANGED_OFFHAND") == 1 then
                Osi.PlayEffect(fakerCharacter, "40126f74-d57d-e88a-8d6d-2c731f3300e9", "Dummy_L_HandFX",1)
                deleteTracedWeapon(fakerCharacter, offhandWeaponRanged)

                -- local offhandWeaponTemplateRanged = Osi.GetTemplate(offhandWeaponRanged)
                -- if GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter) ~= nil then
                --     Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter))
                -- end
                -- Osi.TemplateRemoveFrom(offhandWeaponTemplateRanged, fakerCharacter, 1)
                -- print("Attempted to remove " .. offhandWeaponTemplateRanged)
                -- Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                -- Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                -- Ext.Timer.WaitFor(1000, function()
                --     Osi.UnloadItem(offhandWeaponRanged)
                --     Osi.UnloadItem(offhandWeaponTemplateRanged)
                --     Osi.UnloadItem(offhandWeaponRanged)
                -- end)
            end
        end

        Ext.Entity.Get(fakerCharacter).Vars.rangedWeaponTracker = nil
    end

end)

function deleteTracedWeapon(character, weapon)
    Osi.Unequip(character, weapon)
    Osi.RequestDelete(weapon)
    print("Attempted to remove " .. weapon)
    Ext.Timer.WaitFor(1000, function()
        Osi.UnloadItem(weapon)
        Osi.UnloadItem(weapon)
        Osi.UnloadItem(weapon)
    end)
end

-- Alteration Arrow
Ext.Osiris.RegisterListener("UsingSpell", 5, "before", function(caster, spell, spellType, spellElement, storyActionID) 
    if spell:match("Throw_Alteration") == "Throw_Alteration" then

        Ext.Timer.WaitFor(100, function()
            local meleeWeaponTracker = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker
            meleeWeaponTracker = meleeWeaponTracker or {}
            if #meleeWeaponTracker > 0 then
                mainWeapon = meleeWeaponTracker[1]
                print("Main melee weapon is " .. mainWeapon)

                if Osi.HasActiveStatus(mainWeapon, "REPRODUCTION_MELEE") == 0 then
                    Osi.ApplyStatus(mainWeapon, "REPRODUCTION_MELEE", -1, 100, fakerCharacter)
                    print("Reapplied reproduction melee on main weapon: " .. mainWeapon)
                end
                Osi.ApplyStatus(mainWeapon, "RECENTLY_ALTERED_FIRED", 1, 100, fakerCharacter)
                if spellName == "Throw_Alteration_BrokenPhantasm" then
                    Osi.ApplyStatus(mainWeapon, "RECENTLY_ALTERED_FIRED_BP", 1, 100, fakerCharacter)
                    Ext.Timer.WaitFor(3500, function()
                        Osi.RemoveStatus(fakerCharacter, "FAKER_MELEE", fakerCharacter)
                    end)
                end
            end
            if #meleeWeaponTracker == 2 then
                offWeapon = meleeWeaponTracker[2]
                print("Offhand melee weapon is " .. offWeapon)

                if weaponTypeDictionary(Ext.Entity.Get(offWeapon).ServerTemplateTag.Tags) ~= nil then
                    if Osi.HasActiveStatus(offWeapon, "REPRODUCTION_MELEE_OFFHAND") == 0 then
                        Osi.ApplyStatus(offWeapon, "REPRODUCTION_MELEE_OFFHAND", -1, 100, fakerCharacter)
                        print("Reapplied reproduction melee (offhand) on offhand weapon: " .. offWeapon)
                    end
                    Osi.ApplyStatus(offWeapon, "RECENTLY_ALTERED_FIRED", 1, 100, fakerCharacter)
                    if spellName == "Throw_Alteration_BrokenPhantasm" then
                        Osi.ApplyStatus(mainWeapon, "RECENTLY_ALTERED_FIRED_BP", 1, 100, fakerCharacter)
                        Ext.Timer.WaitFor(3500, function()
                            Osi.RemoveStatus(fakerCharacter, "FAKER_MELEE", fakerCharacter)
                        end)
                    end
                end
            end

        end)
    end
end)

Ext.Osiris.RegisterListener("OnThrown", 7, "before", function(thrownObject, thrownObjectTemplate, thrower, storyActionID, throwPosX, throwPosY, throwPosZ) 
    if Osi.HasActiveStatus(thrownObject, "BROKEN_PHANTASM") == 1 then
        Osi.CreateProjectileStrikeAtPosition(throwPosX, throwPosY, throwPosZ, "Projectile_BrokenPhantasm_Explosion")
        Osi.CreateProjectileStrikeAtPosition(throwPosX, throwPosY, throwPosZ, "Projectile_BrokenPhantasm_Explosion_2")
        -- Osi.CreateProjectileStrikeAtPosition(throwPosX, throwPosY, throwPosZ, "Projectile_BrokenPhantasm_Explosion_3")
        Osi.PlayEffectAtPosition("5123bb90-0084-e389-0cb5-332110a18fa6", throwPosX, throwPosY, throwPosZ, 2.75)
        Osi.PlayEffectAtPositionAndRotation("5123bb90-0084-e389-0cb5-332110a18fa6", throwPosX, throwPosY, throwPosZ, 90, 2.75)
        Osi.PlayEffectAtPositionAndRotation("5123bb90-0084-e389-0cb5-332110a18fa6", throwPosX, throwPosY, throwPosZ, 165, 2.75)
        Osi.PlayEffectAtPositionAndRotation("5123bb90-0084-e389-0cb5-332110a18fa6", throwPosX, throwPosY, throwPosZ, 50, 2.75)
        Osi.PlayEffectAtPositionAndRotation("05c0e507-b7b3-df35-7aa9-7186bd880caf", throwPosX, throwPosY, throwPosZ, 50, 0.75)
        Osi.PlayEffectAtPositionAndRotation("38529fa9-9bf8-05b5-d26b-d1fba6e23a02", throwPosX, throwPosY, throwPosZ, 50, 0.35)
        Osi.RemoveStatus(fakerCharacter, "FAKER_MELEE", fakerCharacter)
    end
end)

-- Ext.Osiris.RegisterListener("OnThrown", 7, "after", function(thrownObject, thrownObjectTemplate, thrower, storyActionID, throwPosX, throwPosY, throwPosZ) 
--     if Osi.HasActiveStatus(thrownObject, "RECENTLY_ALTERED_FIRED") == 1 then
--         print("Detected thrown")
--         Ext.Timer.WaitFor(100, function()

--             if Osi.HasActiveStatus(thrownObject, "RECENTLY_ALTERED_FIRED") == 1 then
--                 if GetDistanceTo(thrownObject, Osi.GetClosestAlivePlayer(thrownObject)) > 1 then
--                     print("Trying to spawn clone for target:" .. Osi.GetClosestPlayer(thrownObject))
--                     spawnClone(Osi.GetClosestPlayer(thrownObject))
--                 end

--             elseif GetDistanceTo(thrownObject, Osi.GetClosestAlivePlayer(thrownObject)) > 1 then
--                 print("Trying to spawn clone for target:" .. Osi.GetClosestPlayer(thrownObject))
--                 spawnClone(Osi.GetClosestPlayer(thrownObject))
--             end
--         end)

--     end

-- end)

Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID) 
    if defender == throwTarget then
        Ext.Timer.WaitFor(100, function()
            local meleeWeaponTracker = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker
            meleeWeaponTracker = meleeWeaponTracker or {}
            if #meleeWeaponTracker > 0 then
                mainWeapon = meleeWeaponTracker[1]
                print("Main melee weapon is " .. mainWeapon)

                if Osi.HasActiveStatus(mainWeapon, "REPRODUCTION_MELEE") == 0 then
                    Osi.ApplyStatus(mainWeapon, "REPRODUCTION_MELEE", -1, 100, fakerCharacter)
                    print("Reapplied reproduction melee on main weapon: " .. mainWeapon)
                end
            end
            if #meleeWeaponTracker == 2 then
                offWeapon = meleeWeaponTracker[2]
                print("Offhand melee weapon is " .. offWeapon)

                if weaponTypeDictionary(Ext.Entity.Get(offWeapon).ServerTemplateTag.Tags) ~= nil then
                    if Osi.HasActiveStatus(offWeapon, "REPRODUCTION_MELEE_OFFHAND") == 0 then
                        Osi.ApplyStatus(offWeapon, "REPRODUCTION_MELEE_OFFHAND", -1, 100, fakerCharacter)
                        print("Reapplied reproduction melee (offhand) on offhand weapon: " .. offWeapon)
                    end

                end
            end

            print("Trying to spawn clone")
            if throwTarget ~= nil then
                throwTarget = nil
                if explodeDetection == true then
                    explodeDetection = nil
                    spawnClone(defender, true, true)
                else
                    spawnClone(defender, false, true)
                end
            end
        end)

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
        local mainWeapon = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[1]
        Osi.ApplyStatus(mainWeapon, "REPRODUCTION_MELEE", -1, 100, fakerCharacter)
    end

end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spellName, spellType, spellElement, storyActionID) 
    if spellName == "Throw_Alteration_BrokenPhantasm" then


    end
end)

-- overedge and overdraw
Ext.Osiris.RegisterListener("CharacterDisarmed", 3, "after", function(character, item, slotName) 
    if Osi.HasActiveStatus(item, "REINFORCEMENT_OVEREDGE_VISUAL") == 1 then
        Osi.RemoveStatus(character, "REINFORCEMENT_OVEREDGE")
    end
    if Osi.HasActiveStatus(item, "REINFORCEMENT_OVERDRAW_VISUAL") == 1 then
        Osi.RemoveStatus(character, "REINFORCEMENT_OVERDRAW")
    end
end)

Ext.Osiris.RegisterListener("Unequipped", 2, "after", function(character, item) 
    if Osi.HasActiveStatus(item, "REINFORCEMENT_OVEREDGE_VISUAL") == 1 then
        if Osi.GetEquippedItem(character, "Melee Main Weapon") ~= nil then
            if Osi.HasActiveStatus(Osi.GetEquippedItem(character, "Melee Main Weapon")) == 0 then
                Osi.RemoveStatus(character, "REINFORCEMENT_OVEREDGE")
            end
        else
            Osi.RemoveStatus(character, "REINFORCEMENT_OVEREDGE")
        end
    end
    if Osi.HasActiveStatus(item, "REINFORCEMENT_OVERDRAW_VISUAL") == 1 then
        if Osi.GetEquippedItem(character, "Ranged Main Weapon") ~= nil then
            if Osi.HasActiveStatus(Osi.GetEquippedItem(character, "Ranged Main Weapon")) == 0 then
                Osi.RemoveStatus(character, "REINFORCEMENT_OVERDRAW")
            end
        else
            Osi.RemoveStatus(character, "REINFORCEMENT_OVERDRAW")
        end
    end
end)

-- kanshou and bakuya overedge
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID) 
    if status == "REINFORCEMENT_OVEREDGE_VISUAL" and Osi.GetTemplate(object) == "MAG_Kanshou_6ed65431-193e-479a-a87d-77145d19ea96" then
        kanshouBakuyaOveredgeAdder("Kanshou", object)
    end
    if status == "REINFORCEMENT_OVEREDGE_VISUAL" and Osi.GetTemplate(object) == "MAG_Bakuya_410ff2bf-ec38-44f0-82bc-e57dadceb701" then
        kanshouBakuyaOveredgeAdder("Bakuya", object)
    end

end)

function kanshouBakuyaOveredgeAdder(kanshouOrBakuya, kanshouOrBakuyaItem)

    local template = ""
    if kanshouOrBakuya == "Kanshou" then
        template = "3834a058-2614-4e03-87ec-d2e76bf38f40"
    elseif kanshouOrBakuya == "Bakuya" then
        template = "6958d47b-d0fa-4b98-96b1-066086d01221"
    end

    Osi.TemplateAddTo(template, fakerCharacter, 1, 0)
    Ext.Timer.WaitFor(90, Osi.SendToCampChest(kanshouOrBakuyaItem, fakerCharacter))
    Ext.Timer.WaitFor(120, function()
        if Ext.Entity.Get(fakerCharacter).Vars.kanshouBakuyaOveredgeTracker == nil then
            Ext.Entity.Get(fakerCharacter).Vars.kanshouBakuyaOveredgeTracker = {}
        end
        local localkanshouBakuyaOveredgeTracker = Ext.Entity.Get(fakerCharacter).Vars.kanshouBakuyaOveredgeTracker
        local kanshouOrBakuyaOveredgeItem = Osi.GetItemByTemplateInInventory(template, fakerCharacter)
        Osi.ApplyStatus(kanshouOrBakuyaOveredgeItem, "REINFORCEMENT_OVEREDGE_VISUAL", 25, 100,fakerCharacter)
        Osi.ApplyStatus(fakerCharacter, "REINFORCEMENT_OVEREDGE", 25, 100,fakerCharacter)
        table.insert(localkanshouBakuyaOveredgeTracker, kanshouOrBakuyaOveredgeItem)
        Ext.Entity.Get(fakerCharacter).Vars.kanshouBakuyaOveredgeTracker = localkanshouBakuyaOveredgeTracker
        
        Osi.Equip(fakerCharacter, kanshouOrBakuyaOveredgeItem, 1, 0, 1)
    end)
end

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID) 
    if status == "FAKER_MELEE" and Osi.HasPassive(object, 'Passive_WeaponCatalog') == 1 then
        if Ext.Entity.Get(object).Vars.kanshouBakuyaOveredgeTracker ~= nil then
            local localkanshouBakuyaOveredgeTracker = Ext.Entity.Get(object).Vars.kanshouBakuyaOveredgeTracker
            for key, entry in pairs(localkanshouBakuyaOveredgeTracker) do
                local mainWeaponTemplate = Osi.GetTemplate(entry)
                if GetItemByTemplateInInventory(mainWeaponTemplate,object) ~= nil then
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,object))
                end
                Osi.TemplateRemoveFrom(mainWeaponTemplate, object, 1)
                print("Attempted to remove " .. mainWeaponTemplate)
                Osi.SetWeaponUnsheathed(object, 0, 0)
                Osi.SetWeaponUnsheathed(object, 1, 0)
                Ext.Timer.WaitFor(1000, function()
                    print("Attempting to unload Kanshou or Bakuya Overedge")
                    Osi.UnloadItem(entry)
                    Osi.UnloadItem(mainWeaponTemplate)
                    Osi.UnloadItem(entry)
                end)
            end
            localkanshouBakuyaOveredgeTracker = nil
            Ext.Entity.Get(object).Vars.kanshouBakuyaOveredgeTracker = localkanshouBakuyaOveredgeTracker
        end
    end

    if status == "REINFORCEMENT_OVEREDGE_VISUAL" then
        if Ext.Entity.Get(fakerCharacter).Vars.kanshouBakuyaOveredgeTracker ~= nil then
            print("Overedge status expired on overedge weapon")
            local localkanshouBakuyaOveredgeTracker = Ext.Entity.Get(fakerCharacter).Vars.kanshouBakuyaOveredgeTracker
            for key, entry in pairs(localkanshouBakuyaOveredgeTracker) do
                -- print(object)
                if Osi.GetTemplate(object) == Osi.GetTemplate(entry) then
                    local mainWeaponTemplate = Osi.GetTemplate(entry)
                    if GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter) ~= nil then
                        Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
                    end
                    Osi.TemplateRemoveFrom(mainWeaponTemplate, fakerCharacter, 1)
                    print("Attempted to remove " .. mainWeaponTemplate)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                    Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                    Ext.Timer.WaitFor(1000, function()
                        print("Attempting to unload Kanshou or Bakuya Overedge")
                        Osi.UnloadItem(entry)
                        Osi.UnloadItem(mainWeaponTemplate)
                        Osi.UnloadItem(entry)
                    end)

                    if string.find(mainWeaponTemplate, "Kanshou") ~= nil then
                        Ext.Timer.WaitFor(125, function()
                                Osi.Equip(fakerCharacter, Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[2],1,0,0)
                                Osi.RemoveStatus(Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[2], "REINFORCEMENT_OVEREDGE_VISUAL", fakerCharacter)
                        end)
                    elseif string.find(mainWeaponTemplate, "Bakuya") ~= nil then
                        Ext.Timer.WaitFor(125, function()
                            Osi.Equip(fakerCharacter, Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[1],1,0,0)
                            Osi.RemoveStatus(Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[1], "REINFORCEMENT_OVEREDGE_VISUAL", fakerCharacter)
                        end)
                    end

                    break
                    
                end
            end

        end
    end

end)

-- manaburst damage increase
-- Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "before", function(caster, target, spell, spellType, spellElement, storyActionID)
--     if spell == "Zone_ManaBurst_Caliburn" then
--         magicalEnergyExpended = Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount
--         Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount - magicalEnergyExpended
--         Osi.ApplyDamage(target, magicalEnergyExpended, "Radiant", caster)
--         print("Manaburst (Caliburn) detected on " .. target)
--         -- print("Adding RollBonus(Damage," .. magicalEnergyExpended .. ")")
--         -- Osi.AddBoosts(caster, "RollBonus(Damage," .. magicalEnergyExpended .. ")", "Mana Burst Drain", caster)
--         -- Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount - magicalEnergyExpended

--         -- Ext.Timer.WaitFor(1250, function()
--         --     Osi.RemoveBoosts(caster, "RollBonus(Damage," .. magicalEnergyExpended .. ")", 1, "Mana Burst Drain", caster)
--         -- end)

--     end

-- end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "before", function(caster, target, spell, spellType, spellElement, storyActionID)
    if spell == "Target_MainHandAttack_Caliburn" then
        -- Osi.ApplyStatus(caster,"CALIBURN_CRIT_BOOST",5, 100,caster)
        Ext.Timer.WaitFor(1800, function()
            -- local x,y,z = Osi.GetPosition(target)
            -- Osi.UseSpellAtPosition(caster, "Target_MainHandAttack_Caliburn_Followup", x, y, z)
            -- Osi.UseSpell(caster, "Target_MainHandAttack_Caliburn_Followup", target,target,1)
            Osi.Attack(caster, target, 0)
            print("Trying to followup caliburn")

            -- Ext.Timer.WaitFor(200, function()
            --     Osi.RemoveStatus(caster, "CALIBURN_CRIT_BOOST", caster)
            -- end)
        end)

    end
    -- if caster == fakerCharacter then
    --     print("Spell used is " .. spell)
    -- end

end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    if spell == "Shout_Charge_ManaBurst" then
        local magicalEnergyExpended = Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount
        Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = Ext.Entity.Get(fakerCharacter).ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount - magicalEnergyExpended
        ApplyStatus(caster, "MANABURST_CHANNELING_" .. Osi.RealToInteger(magicalEnergyExpended), 1, 100, caster)
        -- Ext.Timer.WaitFor(50, function()
        --     Osi.Freeze(caster)
        --     Ext.Timer.WaitFor(100, function()
        --         Osi.Unfreeze(caster)
        --     end)
        -- end)
        print("Manaburst (Caliburn) detected on " .. caster .. " with extra magical energy: " .. Osi.RealToInteger(magicalEnergyExpended))

    end

end)

-- kanshou and bakuya
-- Ext.Osiris.RegisterListener("CastSpellFailed", 5, "before", function(caster, spell, spellType, spellElement, storyActionID)
--     if spell == "Projectile_CraneWings" then
--         Osi.PushUnsheathedState(caster, 1)
--     end

-- end)

-- Ext.Osiris.RegisterListener("CastSpell", 5, "before", function(caster, spell, spellType, spellElement, storyActionID)
--     if spell == "Projectile_CraneWings" then
--         Ext.Timer.WaitFor(1000,Osi.PushUnsheathedState(caster, 1))
--     end

-- end)
-- Ext.Osiris.RegisterListener("StartedPreviewingSpell", 5, "before", function(caster, spell, isMostPowerful, hasMultipleLevels)
--     if spell == "Projectile_CraneWings" then
--         Osi.AddBoosts(Osi.GetEquippedItem(caster,"Melee Main Weapon"),"Invisibility()","Crane Wings Invisibility Helper", caster)
--     end

-- end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spell, spellType, spellElement, storyActionID)
    if spell == "Projectile_CraneWings" then
        craneWingsTarget = target
    end

    if Osi.HasActiveStatus(target,"CRANEWINGS_HOVERING") == 1 and craneWingsTarget == nil then
        if string.find(Ext.Stats.Get(spell).TooltipAttackSave,"Melee") ~= nil then
            RemoveStatus(target,"CRANEWINGS_HOVERING",caster)
            RemoveStatus(target,"CRANEWINGS_HOVERING_2",caster)
            print("Removed crane wings hovering")
        else
            for key, entry in pairs(Ext.Stats.Get(spell).SpellFlags) do
                if string.find(entry,"Melee") ~= nil then
                    RemoveStatus(target,"CRANEWINGS_HOVERING",caster)
                    RemoveStatus(target,"CRANEWINGS_HOVERING_2",caster)
                    print("Removed crane wings hovering")
                    break
                end
            end
        end
        
    end

end)

Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
    if craneWingsTarget == defender then
        if HasActiveStatus(craneWingsTarget, "CRANEWINGS_HOVERING") ~= 1 then
            ApplyStatus(craneWingsTarget, "CRANEWINGS_HOVERING", -1, 100, attackerOwner)
            print("Applied crane wings hovering")
        else
            ApplyStatus(craneWingsTarget, "CRANEWINGS_HOVERING_2", -1, 100, attackerOwner)
            print("Applied crane wings hovering")
        end
        craneWingsTarget = nil
    end

end)

-- Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, applyStoryActionID)
--     if status == "CRANEWINGS_HOVERING" then
--         Ext.Timer.WaitFor(800,Osi.ApplyDamage(object, math.random(6), "Slashing", fakerCharacter))
--     end

-- end)

-- Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID) 
--     if Osi.HasActiveStatus(attackerOwner, "EMULATE_WIELDER_SELFDAMAGE") == 1 then
        
--     end

-- end)

-- Ext.Osiris.RegisterListener("AttackedBy", 7, "before", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
--     if (attackOwner == fakerCharacter or attacker2 == fakerCharacter) and damageType == "Radiant" and damageAmount > 10 then
--         Ext.Timer.WaitFor(50, function()
--             if magicalEnergyExpended ~= nil and Ext.Entity.Get(defender).Vars.attackTimer == nil then
--                 print("Attempting to apply damage from Mana Burst: " .. magicalEnergyExpended)
--                 Osi.ApplyDamage(defender, magicalEnergyExpended, "Radiant", fakerCharacter)
--                 Ext.Timer.WaitFor(10000, function()
--                     local targetEntity = Ext.Entity.Get(character)
--                     local localTargetTimer = nil
--                     targetEntity.Vars.targetTimer = localTargetTimer
                
--                 end)
--             end
--         end)

--     end

-- end)

print("Weapon listeners loaded")