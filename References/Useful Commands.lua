AddBoosts(GetHostCharacter(), "ActionResource(MagicalEnergy,5,0)", "", "")

TemplateAddTo("fce90430-b99f-4981-bfa6-390bb3be1e63", GetHostCharacter(), 1)

Ext.IO.SaveFile("Latest Shirou.json", Ext.DumpExport(_C():GetAllComponents()))