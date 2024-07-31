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
        
        print("Faker melee removed")
        if mainWeapon ~= nil then
            if Osi.HasActiveStatus(mainWeapon, "REPRODUCTION_MELEE") == 1 then
                local mainWeaponTemplate = Osi.GetTemplate(mainWeapon)
                if GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter) ~= nil then
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplate,fakerCharacter))
                end
                Osi.TemplateRemoveFrom(mainWeaponTemplate, fakerCharacter, 1)
                print("Attempted to remove " .. mainWeaponTemplate)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                Ext.Timer.WaitFor(1000, function()
                    print("Attempting to unload")
                    Osi.UnloadItem(mainWeapon)
                    Osi.UnloadItem(mainWeaponTemplate)
                    Osi.UnloadItem(mainWeapon)
                end)
            end

        end

        if offhandWeapon ~= nil then
            if Osi.HasActiveStatus(offhandWeapon, "REPRODUCTION_MELEE_OFFHAND") == 1 or Osi.HasActiveStatus(offhandWeapon, "REPRODUCTION_MELEE_SHIELD") == 1 then
                local offhandWeaponTemplate = Osi.GetTemplate(offhandWeapon)
                if GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter) ~= nil then
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplate,fakerCharacter))
                end
                Osi.TemplateRemoveFrom(offhandWeaponTemplate, fakerCharacter, 1)
                Osi.UnloadItem(offWeapon)
                print("Attempted to remove " .. offhandWeaponTemplate)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                Ext.Timer.WaitFor(1000, function()
                    Osi.UnloadItem(offhandWeapon)
                    Osi.UnloadItem(offhandWeaponTemplate)
                    Osi.UnloadItem(offhandWeapon)
                end)
            end
        end
        
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

        print("Faker ranged removed")
        if mainWeaponRanged ~= nil then 
            if Osi.HasActiveStatus(mainWeaponRanged, "REPRODUCTION_RANGED") == 1 then
                local mainWeaponTemplateRanged = Osi.GetTemplate(mainWeaponRanged) 
                if GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter) ~= nil then
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(mainWeaponTemplateRanged,fakerCharacter))
                end
                Osi.TemplateRemoveFrom(mainWeaponTemplateRanged, fakerCharacter, 1)
                print("Attempted to remove " .. mainWeaponTemplateRanged)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                Ext.Timer.WaitFor(1000, function()
                    Osi.UnloadItem(mainWeaponRanged)
                    Osi.UnloadItem(mainWeaponTemplateRanged)
                    Osi.UnloadItem(mainWeaponRanged)
                end)
            end
        end

        if offhandWeaponRanged ~= nil then
            if Osi.HasActiveStatus(offhandWeaponRanged, "REPRODUCTION_RANGED_OFFHAND") == 1 then
                local offhandWeaponTemplateRanged = Osi.GetTemplate(offhandWeaponRanged)
                if GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter) ~= nil then
                    Osi.Unequip(fakerCharacter,GetItemByTemplateInInventory(offhandWeaponTemplateRanged,fakerCharacter))
                end
                Osi.TemplateRemoveFrom(offhandWeaponTemplateRanged, fakerCharacter, 1)
                print("Attempted to remove " .. offhandWeaponTemplateRanged)
                Osi.SetWeaponUnsheathed(fakerCharacter, 0, 0)
                Osi.SetWeaponUnsheathed(fakerCharacter, 1, 0)
                Ext.Timer.WaitFor(1000, function()
                    Osi.UnloadItem(offhandWeaponRanged)
                    Osi.UnloadItem(offhandWeaponTemplateRanged)
                    Osi.UnloadItem(offhandWeaponRanged)
                end)
            end
        end

    end


end)

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spellName, spellType, spellElement, storyActionID) 
    if spellName == "Throw_Alteration_Arrow" then
        if (Osi.HasPassive(caster, "MAG_HomingWeapon_Passive") == 0) then
            -- if HasMeleeWeaponEquipped(caster, "Mainhand") == 1 then
            --     mainWeaponTemplateArrow = GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")
            -- end
            -- if HasMeleeWeaponEquipped(caster, "Offhand") == 1 then
            --     offhandWeaponTemplateArrow = GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")
            -- end
            -- print("Detected alteration arrow used")
            -- Osi.TimerLaunch("Alteration Arrow", 4000)
        -- else
            -- Osi.TimerLaunch("Alteration Arrow: Returning", 4000)

            Ext.Timer.WaitFor(4000, function()
                if Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker ~= nil then
                    mainWeapon = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[1]
                    print("Main melee weapon is " .. mainWeapon)
        
                    if Osi.HasActiveStatus(mainWeapon, "REPRODUCTION_MELEE") == 0 then
                        Osi.ApplyStatus(mainWeapon, "REPRODUCTION_MELEE", -1, 100, fakerCharacter)
                        print("Reapplied reproduction melee on main weapon: " .. mainWeapon)

                        -- if Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon") ~= mainWeapon then
                        --     print("Shot weapon not equipped")
                        --     Osi.TemplateAddTo(Osi.GetTemplate(mainWeapon), fakerCharacter, 1, 0)
                        --     Ext.Timer.WaitFor(50, function()
                        --         Osi.Equip(fakerCharacter, Osi.GetItemByTemplateInInventory(Osi.GetTemplate(mainWeapon), fakerCharacter), 1, 0, 1)
                        --         Ext.Timer.WaitFor(50, function()
                        --             local equippedWeapon = Osi.GetEquippedItem(fakerCharacter, "Melee Main Weapon")
                        --             print("Attempting to case effect spell")
                        --             UseSpell(caster, "Target_Alteration_Arrow_ApplyWeaponFunctor_Main", target)
                        --             Ext.Timer.WaitFor(50, function()
                        --                 Osi.Unequip(fakerCharacter, Osi.GetItemByTemplateInInventory(Osi.GetTemplate(equippedWeapon), fakerCharacter))
                        --                 Ext.Timer.WaitFor(50, function()
                        --                     Osi.TemplateRemoveFrom(Osi.GetTemplate(equippedWeapon), fakerCharacter, 1)
                        --                 end)
                        --             end)
                        --         end)
                        --     end)
                        -- end
                    end

                    if Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[2] ~= nil then
                        offWeapon = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[2]
                        print("Offhand melee weapon is " .. offWeapon)
                        -- print(weaponTypeDictionary(Ext.Entity.Get(offWeapon).ServerTemplateTag.Tags))

                        if weaponTypeDictionary(Ext.Entity.Get(offWeapon).ServerTemplateTag.Tags) ~= nil then
                            if Osi.HasActiveStatus(offWeapon, "REPRODUCTION_MELEE_OFFHAND") == 0 then
                                Osi.ApplyStatus(offWeapon, "REPRODUCTION_MELEE_OFFHAND", -1, 100, fakerCharacter)
                                print("Reapplied reproduction melee (offhand) on offhand weapon: " .. offWeapon)
                            end
    
                        end
                    end
                end

                

                
            end)
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
        local mainWeapon = Ext.Entity.Get(fakerCharacter).Vars.meleeWeaponTracker[1]
        Osi.ApplyStatus(mainWeapon, "REPRODUCTION_MELEE", -1, 100, fakerCharacter)
    end

end)

-- manaburst damage increase
Ext.Osiris.RegisterListener("CastSpell", 5, "before", function(caster, spell, spellType, spellElement, storyActionID)
    if spell == "Zone_ManaBurst_Caliburn" then
        local magicalEnergy = entity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount
        Osi.AddBoosts(caster, "RollBonus(Damage," .. magicalEnergy .. ")", "Mana Burst Drain", caster)
        entity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = entity.ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount - magicalEnergy

        Ext.Timer.WaitFor(1250, function()
            Osi.RemoveBoosts(caster, "RollBonus(Damage," .. magicalEnergy .. ")", 1, "Mana Burst Drain", caster)
        end)

    end

end)

print("Weapon listeners loaded")