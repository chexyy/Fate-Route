Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID) 
    if Osi.HasPassive(defender, "Passive_BladeReconstitution") == 1 then
        local entity = Ext.Entity.Get(defender)
        if entity.Health.Hp <= entity.Health.MaxHp*0.25 then
            Osi.UseSpell(defender,"Shout_BladeReconstitution",defender)
            print("Blade reconstitution triggered")
        end
    end

end)