-- Blade Reconstitution
Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID) 
    if Osi.HasPassive(defender, "Passive_BladeReconstitution") == 1 and savingThrowTimer == nil then
        local entity = Ext.Entity.Get(defender)
        bladeReconstitutionTurnCheck = entity.Vars.bladeReconstitutionTurnCheck or 0

        if entity.Health.Hp <= entity.Health.MaxHp*0.10 then
            if bladeReconstitutionTurnCheck < tonumber(Ext.Stats.Get("Passive_BladeReconstitution").ExtraDescriptionParams) and savingThrowTimer == nil then
                if Osi.HasActiveStatus(defender, "DOWNED") == 1 and Osi.IsDead(defender) == 0 then
                    Osi.RemoveStatus(defender, "DOWNED", defender)
                end
                Osi.UseSpell(defender,"Shout_BladeReconstitution",defender)
                Osi.TimerLaunch("Fate Saving Throw Timer",700)
                savingThrowTimer = true
                bladeReconstitutionTurnCheck = bladeReconstitutionTurnCheck + 1
                entity.Vars.bladeReconstitutionTurnCheck = bladeReconstitutionTurnCheck
            elseif bladeReconstitutionTurnCheck >= tonumber(Ext.Stats.Get("Passive_BladeReconstitution").ExtraDescriptionParams) and savingThrowTimer == nil then
                Osi.ObjectTimerLaunch(defender, "Blade Reconstitution Timer", 1, 1)
                print("Blade Reconstitution on cooldown")
            end
            print("Blade reconstitution triggered on being attacked. Its cooldown is " .. bladeReconstitutionTurnCheck .. " and its max uses per round is " .. Ext.Stats.Get("Passive_BladeReconstitution").ExtraDescriptionParams)
        end
    end

end)

Ext.Osiris.RegisterListener("TurnStarted", 1, "before", function(object) 
    if Osi.HasPassive(object, "Passive_BladeReconstitution") == 1 and savingThrowTimer == nil then
        local entity = Ext.Entity.Get(object)
        bladeReconstitutionTurnCheck = entity.Vars.bladeReconstitutionTurnCheck or 0

        if entity.Health.Hp <= entity.Health.MaxHp*0.10 and savingThrowTimer == nil then
            if bladeReconstitutionTurnCheck < tonumber(Ext.Stats.Get("Passive_BladeReconstitution").ExtraDescriptionParams) then
                if Osi.HasActiveStatus(object, "DOWNED") == 1 and Osi.IsDead(object) == 0 then
                    Osi.RemoveStatus(object, "DOWNED", object)
                    -- if Osi.HasActiveStatus(Os) then
                    fakerDowned = true
                end
                Osi.UseSpell(object,"Shout_BladeReconstitution",object)
                Osi.TimerLaunch("Fate Saving Throw Timer",1000)
                savingThrowTimer = true
                bladeReconstitutionTurnCheck = bladeReconstitutionTurnCheck + 1
                entity.Vars.bladeReconstitutionTurnCheck = bladeReconstitutionTurnCheck
            elseif bladeReconstitutionTurnCheck >= tonumber(Ext.Stats.Get("Passive_BladeReconstitution").ExtraDescriptionParams) and savingThrowTimer == nil then
                Osi.ObjectTimerLaunch(object, "Blade Reconstitution Timer", 1, 1)
                print("Blade Reconstitution on cooldown")
            end
            print("Blade reconstitution triggered on turn start. Its cooldown is " .. bladeReconstitutionTurnCheck .. " and its max uses per round is " .. Ext.Stats.Get("Passive_BladeReconstitution").ExtraDescriptionParams)
        end
    end

end)

Ext.Osiris.RegisterListener("ObjectTimerFinished", 2, "after", function(object, timer) 
    if (timer == "Blade Reconstitution Timer") then
        bladeReconstitutionTurnCheck = 0
        local entity = Ext.Entity.Get(fakerCharacter)
        entity.Vars.bladeReconstitutionTurnCheck = bladeReconstitutionTurnCheck
    end

end)

Ext.Osiris.RegisterListener("CombatRoundStarted", 2, "before", function(combatGuid, round) 
    if Osi.CombatGetGuidFor(fakerCharacter) == combatGuid then
        print("Blade reconstitution cooldown reset on this new round")
        local entity = Ext.Entity.Get(fakerCharacter)
        bladeReconstitutionTurnCheck = 0
        entity.Vars.bladeReconstitutionTurnCheck = bladeReconstitutionTurnCheck
    end

end)


-- Ext.Osiris.RegisterListener("StatusApplied", 2, "after", function(object, status, causee, storyActionID)
--     if status == "BODYOFSWORDS" then
--         print("Blade reconstitution failed")
--         Ext.Timer.WaitFor(100, function()
--             print("Applying damage from blade reconstitution")
--             Osi.ApplyDamage(object, Osi.AbilityGetDifficultyLevelMappedValue("BladeReconstitutionHP", Osi.GetLevel(object)), "Slashing", causee)
--         end)

--     end

-- end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    -- if spell == "Shout_BladeReconstitution" then
    --     if Osi.GetHitpoints(caster) <= Osi.GetMaxHitpoints(caster)/7 then
    --         Osi.TimerLaunch("Blade Reconstitution Downed", 300)
    --     end
    -- end

    if spell == "Shout_BladeReconstitution" then
        Ext.Timer.WaitFor(500, function()
            if Osi.HasActiveStatus(caster,"BODYOFSWORDS") == 1 then
                print("Blade reconstitution failed")
                Ext.Timer.WaitFor(100, function()
                    print("Applying damage from blade reconstitution")
                    local damageAmount = tonumber(Ext.StaticData.Get("484b0709-2060-4e70-999c-0011d74448f6", "LevelMap").LevelMaps[Osi.GetLevel(caster)].AmountOfDices)*4
                    if fakerDowned == true then
                        damageAmount = damageAmount * 1.25
                        fakerDowned = nil
                    end
                    if Osi.GetHitpoints(fakerCharacter) < damageAmount then
                        Osi.ApplyDamage(caster, math.random(damageAmount/4,damageAmount), "Slashing", caster)
                    else
                        Osi.ApplyStatus(caster, "DOWNED", -1, 100, caster)
                        Ext.Timer.WaitFor(50, function()
                            Osi.ApplyDamage(caster, math.random(damageAmount/4,damageAmount), "Slashing", caster)
                        end)
                    end
                end)

            end
        end)
    end

end)

-- Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer) 
--     if timer == "Blade Reconstitution Downed" then
--         Osi.ApplyStatus(fakerCharacter, "DOWNED", -1)
--         print("Downed by Blade Reconstitution")
--     end

-- end)



-- Emulate Wielder
-- Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
--     if (Osi.HasActiveStatus(attackerOwner, "EMULATE_WIELDER_SELFDAMAGE") == 1) and (Osi.HasActiveStatus(attackerOwner, "FAKER_MELEE") == 1 or Osi.HasActiveStatus(attackerOwner, "FAKER_RANGED") == 1) and savingThrowTimer == nil then
--         print("Emulate wielder saving throw triggered")
--         Osi.RequestPassiveRoll(attackerOwner, attackerOwner, "SavingThrow", "Constitution", "63c8b98d-25dc-455a-84e3-c84d0c12263b", 0, "Emulate Wielder Selfdamage")
--         Osi.TimerLaunch("Fate Saving Throw Timer",500)
--         savingThrowTimer = true
--     end

-- end)

-- Ext.Osiris.RegisterListener("RollResult", 6, "after", function(eventName, roller, rollSubject, resultType, isActiveRoll, criticality)
--     if eventName == "Emulate Wielder Selfdamage" then 
--         if resultType == 0 then
--             print("Emulate wielder lost health")
--             Osi.ApplyDamage(roller, math.ceil(Osi.GetMaxHitpoints(roller)/5), "Force")
--         end
--     end
-- end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID) 
    if status == "EMULATE_WIELDER_CHECK" then
        print("Status emulate applied")
        local entity = Ext.Entity.Get(object)
        originalStats = {entity.Stats.Abilities[2], entity.Stats.Abilities[3], entity.ActionResources.Resources["d6b2369d-84f0-4ca4-a3a7-62d2d192a185"][1].MaxAmount}
        entity.Vars.originalStats = originalStats
        
        if Osi.HasActiveStatus(object, "DASH") == 1 then
            originalStats[3] = originalStats[3]/2
        end
        if Osi.HasActiveStatus(object, "LONGSTRIDER") == 1 then
            originalStats[3] = originalStats[3] - 3
        end

        emulateWielder(object)
        emulateWielderCheck = true
    end

    Ext.Timer.WaitFor(500, function()
        if status == "EMULATE_WIELDER_SELFDAMAGE" and emulateWielderCheck == true then
            if Osi.HasMeleeWeaponEquipped(object, "Mainhand") == 1 then
                if Osi.HasActiveStatus(GetEquippedItem(object, "Melee Main Weapon"), "NOBLEPHANTASM") == 0 then
                    emulateWielder(object)
                    print("Attempted to reapply emulate wielder")
                end
            else
                emulateWielder(object)
                print("Attempted to reapply emulate wielder")
            end
        end
    end)

end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, applyStoryActionID) 
    if status == "EMULATE_WIELDER_SELFDAMAGE" and emulateBoost ~= nil then
        Osi.RemoveBoosts(object, emulateBoost, 1, "Emulate Wielder", "")
    end
    if status == "EMULATE_WIELDER_CHECK" then
        emulateWielderCheck = nil
    end

end)

Ext.Osiris.RegisterListener("UsingSpell", 4, "after", function(caster, spell, spellType, spellElement, storyActionID) 
    if Osi.HasActiveStatus(caster, "EMULATE_WIELDER_SELFDAMAGE") then
        print("Attempting to switch stats")
        local spell = Ext.Stats.Get(spell)
        if spell.PreviewCursor == "Melee" then
            emulateWielderChange(caster, originalStats, "Melee")
            print("Switched to melee")
        elseif spell.PreviewCursor == "Ranged" then
            emulateWielderChange(caster, originalStats, "Ranged")
            print("Switched to ranged")
        end

    end

end)