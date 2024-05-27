traceTable = {}
traceTable.__index = traceTable

function traceTable:new(DisplayName, Icon, weaponUUID, UseCosts)
    local instance = setmetatable({}, traceTable)
    instance.DisplayName = DisplayName
    instance.Icon = Icon
    instance.weaponUUID = weaponUUID
    instance.UseCosts = UseCosts
    return instance
end

function loadglobalTraceTable()
    Mods.FateRoute.global_traceTable = Mods.FateRoute.global_traceTable or {}
    local traceTable = {}
    for i = 1,999,1 do
        if (Mods.FateRoute.global_traceTable[i] == {} or Mods.FateRoute.global_traceTable[i] == nil or Mods.FateRoute.global_traceTable[i] == null) then
            print("Value not found")
            print(Mods.FateRoute.global_traceTable[i])
            local DisplayName = "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551"
            local Icon = "Action_Paladin_SacredWeapon"
            local weaponUUID = "407954e3-71e4-4611-9221-0ba3ea71d6e8"
            local UseCosts = "BonusActionPoint:1;MagicalEnergy:1"
            Mods.FateRoute.global_traceTable[i] = traceTable.new(DisplayName, Icon, weaponUUID, UseCosts)

            traceTable[i] = Ext.Stats.Get(Shout_TraceWeapon_Template" .. i")
        else
            print("Value found is...")
            _D(Mods.FateRoute.global_traceTable[i])
            if Mods.FateRoute.global_traceTable[i].DisplayName ~= "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")
                local containerList = baseSpell.ContainerSpells

                local studiedSpell = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                studiedSpell:SetRawAttribute("DisplayName", Mods.FateRoute.global_traceTable[i].DisplayName)
                studiedSpell.Icon = Mods.FateRoute.global_traceTable[i].Icon
                studiedSpell:SetRawAttribute("SpellProperties", "ApplyStatus(Faker,100,2);AI_IGNORE:SummonInInventory(" .. Mods.FateRoute.global_traceTable[i].weaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
                studiedSpell.UseCosts = Mods.FateRoute.global_traceTable[i].DisplayName
                containerList = containerList .. ";Shout_TraceWeapon_Template" .. i

                studiedSpell:Sync()       
                baseSpell.ContainerSpells = containerList
                baseSpell:Sync()

                traceTable[i] = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
            end
        end
    end
    print("traceTable loaded")
    return traceTable
end

function loadglobalTraceTable()
    Mods.FateRoute.global_traceTable = Mods.FateRoute.global_traceTable or {}
    for i = 1,999,1 do
        if (Mods.FateRoute.global_traceTable[i] == {} or Mods.FateRoute.global_traceTable[i] == nil or Mods.FateRoute.global_traceTable[i] == null) then
            print("Value not found")
            print(Mods.FateRoute.global_traceTable[i])
            Mods.FateRoute.global_traceTable[i] = traceTable.new(Ext.Sta)
            return global_traceTable
        else
            print("Value found is...")
            _D(Mods.FateRoute.global_traceTable)
            for i = 1,999,1 do
                if Mods.FateRoute.global_traceTable[i].DisplayName ~= "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                    local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")
                    local containerList = baseSpell.ContainerSpells
                    containerList = containerList .. ";Shout_TraceWeapon_Template" .. i

                    Mods.FateRoute.traceTable[i]:Sync()       
                    baseSpell.ContainerSpells = containerList
                    baseSpell:Sync()
                end
            end
            print("Existing traceTable loaded")
        end
    end
    return Mods.FateRoute.traceTable
end


--
-- meta class
traceTableObject = {DisplayName = "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551", Icon = "Action_Paladin_SacredWeapon", weaponUUID = "407954e3-71e4-4611-9221-0ba3ea71d6e8", UseCosts = "BonusActionPoint:1;MagicalEnergy:1"}

function traceTableObject:new(DisplayName, Icon, weaponUUID, UseCosts)
    local instance = setmetatable({}, traceTable)
    instance.DisplayName = DisplayName
    instance.Icon = Icon
    instance.weaponUUID = weaponUUID
    instance.UseCosts = UseCosts
    return instance
end

function loadglobalTraceTable()
    local traceTable = {}
    for i = 1,999,1 do
        if (Mods.FateRoute.global_traceTable[i] == {} or Mods.FateRoute.global_traceTable[i] == nil or Mods.FateRoute.global_traceTable[i] == null) then
            local DisplayName = "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551"
            local Icon = "Action_Paladin_SacredWeapon"
            local weaponUUID = "407954e3-71e4-4611-9221-0ba3ea71d6e8"
            local UseCosts = "BonusActionPoint:1;MagicalEnergy:1"
            Mods.FateRoute.global_traceTable[i] = traceTableObject:new(DisplayName, Icon, weaponUUID, UseCosts)

            traceTable[i] = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
        else
            print("Value found is...")
            _D(Mods.FateRoute.global_traceTable[i])
            if Mods.FateRoute.global_traceTable[i].DisplayName ~= "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551" then
                local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")
                local containerList = baseSpell.ContainerSpells

                local studiedSpell = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
                studiedSpell:SetRawAttribute("DisplayName", Mods.FateRoute.global_traceTable[i].DisplayName)
                studiedSpell.Icon = Mods.FateRoute.global_traceTable[i].Icon
                studiedSpell:SetRawAttribute("SpellProperties", "ApplyStatus(Faker,100,2);AI_IGNORE:SummonInInventory(" .. Mods.FateRoute.global_traceTable[i].weaponUUID .. ",2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)")
                studiedSpell.UseCosts = Mods.FateRoute.global_traceTable[i].DisplayName
                containerList = containerList .. ";Shout_TraceWeapon_Template" .. i

                studiedSpell:Sync()       
                baseSpell.ContainerSpells = containerList
                baseSpell:Sync()

                traceTable[i] = Ext.Stats.Get("Shout_TraceWeapon_Template" .. i)
            end
        end
    end
    print("traceTable loaded")
end
--