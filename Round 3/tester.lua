traceVarMainHand = Ext.Stats.Create("Trace_Greatsword", "SpellData", "Shout_FlameBlade")
traceVarMainHand.Icon = "Item_MAG_Invisible_Pike_GLOW"
traceVarMainHand.UseCosts = "BonusActionPoint:1"
traceVarMainHand.DisplayName = "Invisible Pike"
traceVarMainHand:Sync()
Osi.AddSpell(GetHostCharacter(),"Trace_Greatsword")

function AddCustomSpell(character)
    newSpell = Ext.Stats.Create("New_Spell_Name", "SpellData", "Shout_FlameBlade")
    print(newSpell.Name)
    newSpell.Description = "hf455caa6gc4c4g4b78gb386g9bb2d8fa1f5b"
    newSpell.DisplayName = "h2a08b068g277cg428agb5b3g3e330e4c4b0b"
    newSpell:Sync()
    AddSpell(character,"New_Spell_Name")
end

function AddContainerSpell(character) 
    baseSpell = Ext.Stats.Get("Container_Spell")
    containerList = baseSpell.ContainerSpells
    containerList = containerList .. ";New_Spell_Name"
    baseSpell.ContainerSpells = containerList
    baseSpell:Sync()
    _P("containerList: " .. containerList)
    if Osi.HasSpell(character, 'Container_Spell') ~= 0 then
        Osi.RemoveSpell(character, 'Container_Spell', 1)
    end
    Osi.AddSpell(character, 'Container_Spell', 0, 1) 
end

AddCustomSpell(GetHostCharacter())
AddContainerSpell(GetHostCharacter())

newSpell2 = Ext.Stats.Create("Test_Spell4", SpellData, "Parent_Spell")
newSpell2.Description = "hf455caa6gc4c4g4b78gb386g9bb2d8fa1f5b"
newSpell2.DisplayName = "h2a08b068g277cg428agb5b3g3e330e4c4b0b"
newSpell2:Sync()
AddSpell(GetHostCharacter(),"Test_Spell4")

newSpell8 = Ext.Stats.Create("New_Spell_Name8", "SpellData", "Shout_FlameBlade")
newSpell8:Sync()
AddSpell(GetHostCharacter(),"New_Spell_Name8")

--[[
local baseSpell = Ext.Stats.Get("Shout_TraceWeapon")
baseSpell.DisplayName = Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).DisplayName.NameKey.Handle.Handle
baseSpell:Sync()
]]--

PersistentVars["testSpell2"] = Ext.Stats.Create("Test Spell2", "SpellData", "Shout_FlameBlade")
testSpell2:SetRawAttribute("DisplayName", hd73c56d852324fae83d55aa34308bb3bcc0e)
testSpell2:Sync()
AddSpell(GetHostCharacter(), "Test Spell2")
print(Ext.Stats.Get("Test Spell2").TargetConditions)

testSpellChange = Ext.Stats.Create("Test Spell Changed", "SpellData", "Shout_FlameBlade")
testSpellChange.TargetConditions = "Self()"
testSpellChange:Sync()
AddSpell(GetHostCharacter(), "Test Spell Changed")
print(Ext.Stats.Get("Test Spell Changed").TargetConditions)

AddSpell(GetHostCharacter(), "Shout_FlameBlade")
print(Ext.Stats.Get("Shout_FlameBlade").TargetConditions)

Ext.IO.SaveFile("CharacterEntitySummonTable.json", Ext.DumpExport(Ext.Entity.Get(GetHostCharacter()):GetAllComponents()))
tracebladeTemplate:SetRawAttribute("SpellProperties", "AI_IGNORE:SummonInInventory(cd6c6adc-8792-4378-8c63-8169cfad6c55,2,1,true,true,true,,,,,KNOCKED_OUT_SUMMON_DISMISS)")
KNOCKED_OUT_SUMMON_DISMISS

-- Ext.Osiris.RegisterListener("TemplateUnequipped", 2, "after", function(itemTemplate,character)
--     if itemTemplate == mainWeaponTemplate then
--         Osi.AddSpell(GetHostCharacter(), "Trace_" .. string.gsub(mainWeaponTemplate,"_%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x",""), "SpellData", "Shout_TraceWeapon_Template")
--     end

-- end)

-- print(Ext.Stats.Get(string.gsub(Osi.GetTemplate(GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")),"_%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x","")))
-- print(string.gsub(Osi.GetTemplate(GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")),"_%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x",""))
-- print(Ext.Stats.Get("MAG_Invisible_Pike").Rarity)
-- print(Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).Use.BoostsOnEquipMainHand)
-- print(Ext.Entity.Get(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon")).ServerItem.Template.Id)
-- print(Ext.GetStatString(GetEquippedItem(GetHostCharacter(),"Melee Main Weapon")))
-- print(GetUUID(GetEquippedItem(GetHostCharacter(),"Melee Main Weapon")))