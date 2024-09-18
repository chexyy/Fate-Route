AddBoosts(GetHostCharacter(), "ActionResource(MagicalEnergy,5,0)", "", "")
AddBoosts(GetHostCharacter(), "ActionResource(ActionPoint,20,0)", "", "")

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

--[[
local x, y, z = Osi.GetPosition(GetHostCharacter())
Osi.PlayLoopEffectAtPosition("58980e41-1f0f-42c4-bd7b-9ad60296a4ce", x, y, z, 2)
]]--