AddBoosts(GetHostCharacter(), "ActionResource(MagicalEnergy,5,0)", "", "")
AddBoosts(GetHostCharacter(), "ActionResource(ActionPoint,20,0)", "", "")
AddBoosts(GetHostCharacter(), "ActionResource(BonusActionPoint,1,0)", "", "")
AddBoosts(GetHostCharacter(), "ActionResource(KiPoint,20,0)", "", "")

AddBoosts(GetHostCharacter(), "RestoreResource(ActionPoint,100%,0)", "Test", GetHostCharacter())
Osi.AddActionPoints(GetHostCharacter(), 1)

TemplateAddTo("fce90430-b99f-4981-bfa6-390bb3be1e63", GetHostCharacter(), 1)
TemplateAddTo("4567ecad-2304-42db-b8ed-0ca6bb8edfb5", GetHostCharacter(), 1) -- UBW

Ext.IO.SaveFile("Latest Shirou.json", Ext.DumpExport(_C():GetAllComponents()))

local experience = -100000

for position, partymember in pairs(Osi.DB_Players:Get(nil)) do
    for _, guid in pairs(partymember) do
        Osi.AddExplorationExperience(guid, experience)
    end   
end

AddSpell(GetHostCharacter(), "Throw_Alteration_BrokenPhantasm", 0, 0)

Osi.TemplateDropFromCharacter("4567ecad-2304-42db-b8ed-0ca6bb8edfb5", Osi.GetHostCharacter(), 1)
Osi.TemplateDropFromCharacter("38b646d1-77b0-4721-bd7b-1a717c0073c8", Osi.GetHostCharacter(), 1)

Osi.AddBoosts(GetHostCharacter(), "Invulnerable()", "Console", GetHostCharacter())
Osi.AddActionPoints(GetHostCharacter(), 1)

Osi.SetHitpointsPercentage(GetHostCharacter(), 100)

--[[
local x, y, z = Osi.GetPosition(GetHostCharacter())
Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 2)
]]--

local level = 12
for position, partymember in pairs(Osi.DB_Players:Get(nil)) do
    for _, guid in pairs(partymember) do
        Osi.SetLevel(guid, level)
    end   
end

local exp = 27500
for position, partymember in pairs(Osi.DB_Players:Get(nil)) do
    for _, guid in pairs(partymember) do
        Osi.AddExplorationExperience(guid, exp)
    end   
end

Osi.SetFaction(GetHostCharacter(),"64321d50-d516-b1b2-cfac-2eb773de1ff6")

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spell, spellType, spellElement, storyActionID)  
    if Osi.HasPassive(caster, "Passive_WeaponCatalog") == 1 then
        print(target)
    end

end)

_C().ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].Amount = _C().ActionResources.Resources["7dd6369a-23d3-4cdb-ba9a-8e02e8161dc0"][1].MaxAmount

Osi.TeleportToPosition(GetHostCharacter(), -53.487, 497, -81.703, "", 0, 0, 0, 1, 1)

Osi.TeleportToPosition(GetHostCharacter(), 605.098, 354.853, -743.957, "", 0, 0, 0, 1, 1)