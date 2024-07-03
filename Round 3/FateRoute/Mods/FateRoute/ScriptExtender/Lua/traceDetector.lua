-- function weaponType
function weaponType(weaponType)
    if weaponType == "7609654e-b213-410d-b08f-6d2930da6411" then -- battleaxe
        return 1

    elseif weaponType == "9b333d67-365f-41fa-80b2-08e86588e9ac" then -- club
        return 2

    elseif weaponType == "7490e5d0-d346-4b0e-80c6-04e977160863" then -- dagger
        return 3

    elseif weaponType == "5d7b1304-6d20-4d60-ba1b-0fbb491bfc18" then -- flail
        return 4
        
    elseif weaponType == "7a15ea4f-cb00-4201-8e7f-024627e3d014" then -- glaive
        return 5

    elseif weaponType == "02da79f5-6f13-4f90-9819-102e37693f48" then -- greataxe
        return 6

    elseif weaponType == "ab44887d-0eb0-4fef-bd9d-943ea8971aa2" then -- greatclub
        return 7

    elseif weaponType == "aec4ed1a-993b-491f-a2db-640bf11869c1" then -- greatsword
        return 8
        
    elseif weaponType == "2c74855f-769a-43f5-b6db-48c4c47721ff" then -- halberd
        return 9

    elseif weaponType == "09dd1e1e-6d9f-4cc6-b514-68e981c80543" then -- handaxe
        return 10

    elseif weaponType == "b6e3bfa1-2c63-404f-becb-21d047aacce1" then -- javelin
        return 11

    elseif weaponType == "edc46cc0-25d0-4da9-bfcb-edba239edcce" then -- light hammer
        return 12

    elseif weaponType == "96a99a42-ec5d-4081-9d62-c9e3f0057136" then -- longsword
        return 13

    elseif weaponType == "c29fc6ce-0482-420d-a839-41a0bab95c2d" then -- mace
        return 14

    elseif weaponType == "2503012b-9cc4-491c-a068-282f8cea8707" then -- maul
        return 15

    elseif weaponType == "aa4cfcea-aee8-44b9-a460-e7231df796b1" then -- morningstar
        return 16
        
    elseif weaponType == "ca1a548b-f409-4cad-af5a-dfdd5834c709" then -- pike
        return 17

    elseif weaponType == "b428632e-3137-47aa-ae8f-ddff6fc27cc8" then -- quarterstaff
        return 18

    elseif weaponType == "aeaf4e95-38d7-45ec-8900-40bc9e6106b0" then -- rapier
        return 19
        
    elseif weaponType == "206f9701-7b24-4eaf-9ac4-a47746c251e2" then -- scimitar
        return 20

    elseif weaponType == "c826fd1e-4780-43d4-b49b-87f30c060fe6" then -- shortsword
        return 21

    elseif weaponType == "bfdc63bd-b8f6-4eac-9363-0c71882ff46f" then -- sickle
        return 22

    elseif weaponType == "fef6b399-19da-4d4b-b1ec-c79dff7f46c3" then -- spear
        return 23

    elseif weaponType == "c808f076-4a0f-422a-97db-e985ce35f3f9" then -- trident
        return 24

    elseif weaponType == "eed87cdb-c5ee-45c2-9a5a-6949dce87a1e" then -- warpick
        return 25

    elseif weaponType == "1dff197e-b74c-4173-94d3-e1323239556c" then -- warhammer
        return 26

    elseif weaponType == "c23ac9ef-5b47-4c2d-8ce5-7b60a8b34787" then -- dart
        return 27

    elseif weaponType == "1c12ee6d-50e2-459f-90c8-ae56701190ce" then -- hand crossbow
        return 28

    elseif weaponType == "2cc23bb9-d777-4265-a34c-333528628b90" then -- heavy crossbow
        return 29

    elseif weaponType == "a302a8e2-a3f9-41e1-a68c-70a453e65399" then -- light crossbow
        return 30

    elseif weaponType == "557d335c-0780-4665-9802-709a7d202dba" then -- longbow
        return 31

    elseif weaponType == "81197304-7116-4d7b-8ef4-207bbf636682" then -- shortbow
        return 32

    elseif weaponType == "59c686ae-c70c-453a-a6ce-8ffceb82026d" then -- sling
        return 33

    end
end

Ext.Osiris.RegisterListener("SavegameLoaded", 0, "after", function()
    


)