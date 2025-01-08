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

rushAttack = Ext.Stats.Get("Rush_SpringAttack")
rushAttack.Cooldown = "None"
rushAttack:Sync()
Osi.RemoveSpell(GetHostCharacter(),"Rush_SpringAttack")
Osi.AddSpell(GetHostCharacter(),"Rush_SpringAttack",0)

rushAttack = Ext.Stats.Get("Rush_SpringAttack")
rushAttack.Cooldown = "OncePerShortRest"
rushAttack:Sync()
Osi.RemoveSpell(GetHostCharacter(),"Rush_SpringAttack")
Osi.AddSpell(GetHostCharacter(),"Rush_SpringAttack",0)

string = '&lt;LSTag Type="Spell" Tooltip="Shout_TraceWeapon_TemplateDescription1"&gt;Shield of Devotion&lt;/LSTag&gt;'

Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
    local entity = Ext.Entity.Get(defender);
    Ext.IO.SaveFile("Nightsong.json", Ext.DumpExport(entity:GetAllComponents()))

end)

Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
    print("Defender is " .. defender)
    print("Attack owner is " .. attackerOwner)
    print("Attacker2 is " .. attacker2)
    print("Damage type is " .. damageType)
    print("Damage amount is " .. damageAmount)
    print("Damage cause is " .. damageCause)
    print("Story action ID is " .. storyActionID)

end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    if caster == 

end)

--[[
meleeTemplate = Osi.GetTemplate(Osi.GetEquippedItem(GetHostCharacter(), "Melee Main Weapon"))
createdObject = Osi.CreateAtObject(meleeTemplate, GetHostCharacter(), 1, 1, "UBW", 1)
x, y, z = Osi.GetPosition(GetHostCharacter())
Ext.Timer.WaitFor(100,function()
    -- _D(Ext.Entity.Get(createdObject):GetAllComponents())
    local heightDiff = Ext.Entity.Get(createdObject).Bound.Bound.AIBounds["Hit"].Size
    Osi.ToTransform(createdObject, x, y+heightDiff*1.2, z, 1, 90, 90)
end)
]]--


copiedChar = Osi.CreateAtObject(Osi.GetTemplate(GetHostCharacter()), GetHostCharacter(), 1, 1, "UBW", 1)
equipmentSlots = {"Amulet", "Boots", "Breast", "Cloak", "Helmet", "Ring", "Ring2"}
for key, slot in pairs(equipmentSlots) do
    local item = Osi.GetEquippedItem(GetHostCharacter(), slot)
    if item ~= nil then
        Osi.TemplateAddTo(Osi.GetTemplate(item), copiedChar, 1, 0)
        Ext.Timer.WaitFor(150, function()
            Osi.Equip(copiedChar, Osi.GetItemByTemplateInInventory(Osi.GetTemplate(item), copiedChar), 0, 0, 1)
        end)
    end
end

meleeWeaponTracker = _C().Vars.meleeWeaponTracker
if meleeWeaponTracker ~= nil then
    local item = meleeWeaponTracker[1]
    Osi.TemplateAddTo(Osi.GetTemplate(item), copiedChar, 1, 0)
    Ext.Timer.WaitFor(150, function()
        Osi.Equip(copiedChar, Osi.GetItemByTemplateInInventory(Osi.GetTemplate(item), copiedChar), 0, 0, 1)
    end)

    if meleeWeaponTracker[2] ~= nil then
        local item = meleeWeaponTracker[2]
        Osi.TemplateAddTo(Osi.GetTemplate(item), copiedChar, 1, 0)
        Ext.Timer.WaitFor(150, function()
            Osi.Equip(copiedChar, Osi.GetItemByTemplateInInventory(Osi.GetTemplate(item), copiedChar), 0, 0, 1)
        end)

    end

end

rangedWeaponTracker = _C().Vars.rangedWeaponTracker
if rangedWeaponTracker ~= nil then
    local item = rangedWeaponTracker[1]
    Osi.TemplateAddTo(Osi.GetTemplate(item), copiedChar, 1, 0)
    Ext.Timer.WaitFor(150, function()
        Osi.Equip(copiedChar, Osi.GetItemByTemplateInInventory(Osi.GetTemplate(item), copiedChar), 0, 0, 1)
    end)

    if rangedWeaponTracker[2] ~= nil then
        local item = rangedWeaponTracker[2]
        Osi.TemplateAddTo(Osi.GetTemplate(item), copiedChar, 1, 0)
        Ext.Timer.WaitFor(150, function()
            Osi.Equip(copiedChar, Osi.GetItemByTemplateInInventory(Osi.GetTemplate(item), copiedChar), 0, 0, 1)
        end)

    end

end

for key, class in pairs(_C().Classes.Classes) do
    _D(class)

end

Osi.GiveInspirationPoints(GetHostCharacter(), 1, "A Thousand Blades", "Recreated a total of 1000 weapons seen previously.")

--[[
local x, y, z = Osi.GetPosition(GetHostCharacter())
Osi.UseSpellAtPosition(GetHostCharacter(), "Projectile_Jump", x,y+5,z, 1)
Osi.UseSpell(GetHostCharacter(), "Throw_Throw", laezel, GetEquippedWeapon(GetHostCharacter()),1)
]]--

--[[
local x, y, z = Osi.GetPosition(GetHostCharacter())
Osi.UseSpellAtPosition(GetHostCharacter(), "Projectile_Jump", x,y+5,z, 1)
Ext.Timer.WaitFor(100, function()
   Osi.Freeze(GetHostCharacter()) 
end)
]]--

test = true
local x, y, z = Osi.GetPosition(GetHostCharacter())
while test == true do
    Osi.TeleportToPosition(GetHostCharacter(),x,y+5,z)
end

--[[
local x,y,z = Osi.GetPosition(GetHostCharacter())
Osi.PlayEffectAtPositionAndRotation("05c0e507-b7b3-df35-7aa9-7186bd880caf", x,y,z, 50, 0.75)
]]--

--[[
local x,y,z = Osi.GetPosition(GetHostCharacter())
Osi.PlayEffectAtPositionAndRotation("38529fa9-9bf8-05b5-d26b-d1fba6e23a02", x,y,z, 50, 0.35)
]]--

--[[
local x,y,z = Osi.GetPosition(GetHostCharacter())
Osi.PlayEffectAtPositionAndRotation("5123bb90-0084-e389-0cb5-332110a18fa6", x,y,z, 50, 0.65)
]]--


x,y,z = Osi.GetPosition(GetHostCharacter())
spear = Osi.CreateAt("2eeabe97-8f29-4f4f-827e-6cfcd8fd1779", x,y,z, 1, 1, "Spawned")

x2,y2,z2 = Osi.GetPosition(spear)
Osi.ItemMoveToPosition(spear, x2, y2+2, z, 1, 1, "")

height = y+3.5
for i = 1,3 do
    rho = heigh

    height++
end

--[[
local x,y,z = Osi.GetPosition(GetHostCharacter())
print(Osi.FindValidPosition(x, y+50, z, 0.001, GetHostCharacter(), 0))
]]--

print(Osi.FindValidPosition(885, -50, -25, 1, GetHostCharacter(), 0))

