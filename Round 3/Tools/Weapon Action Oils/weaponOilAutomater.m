clear 
clc

rangedOrMelee = "Melee";
if rangedOrMelee == "Melee"
    weaponActions = readtable('MeleeActions.xlsx');
else
    weaponActions = readtable('RangedActions.xlsx', 'ReadVariableNames', true);
end

for key = 1:1:height(weaponActions)
    weaponSkill = string(table2cell(weaponActions(key,"WeaponSkill")));
    spellID = string(table2cell(weaponActions(key,"SpellID")));
    rarity = string(table2cell(weaponActions(key,"Rarity")));
    act = str2double(string(table2cell(weaponActions(key,"Act"))));
    
    displayNameHandle = handleCreator('Weapon Oil: ' + weaponSkill);
    descriptionHandle = handleCreator('Coats your active weapon in crystalized experiences, allowing you to perform &lt;LSTag Type="Spell" Tooltip="' + spellID + "_WeaponOil" + '"&gt;' + weaponSkill + '&lt;/LSTag&gt;.');
    dippedDisplayNameHandle = handleCreator('Coated in Weapon Oil: ' + weaponSkill);
    dippedDescriptionHandle = handleCreator("Allows this weapon's user to perform &lt;LSTag Type=""Spell"" Tooltip=" + spellID + "_WeaponOil" + "&gt;" + weaponSkill + "&lt;/LSTag&gt;.");
    combinedName = strrep(weaponSkill,' ','');
    combinedNameCaps = upper(combinedName);
    uuid = uuidCreator();

    rootTemplateMaker(displayNameHandle,descriptionHandle,uuid,combinedName,combinedNameCaps)
    objectMaker(rarity,act,combinedName,uuid)
    statusMaker(displayNameHandle,descriptionHandle,dippedDisplayNameHandle,dippedDescriptionHandle,combinedName,combinedNameCaps,rangedOrMelee)
    passiveMaker(combinedName,combinedNameCaps,spellID)
    spellMaker(spellID)

end

% handle maker
function tempHandle = handleCreator(message)
    randomCharacter = ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"];
    tempHandle = "h";
    for i = 1:1:36
        tempHandle = tempHandle + randomCharacter(randi(36));
    end
    line = '    <content contentuid="' + tempHandle + '" version="1">' + message + '</content>';
    writelines(line, "loca_file.txt", WriteMode="append")
end

% uuid creator
function uuid = uuidCreator()
    randomCharacter = ["a" "b" "c" "d" "e" "f" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"];
    uuid = "";
    uuidSectionLengths = [8,4,4,4,12];
    for i = 1:1:length(uuidSectionLengths)
       for lengths = 1:1:uuidSectionLengths(i)
            uuid = uuid + randomCharacter(randi(length(randomCharacter)));
       end
       if i ~= length(uuidSectionLengths)
        uuid = uuid + "-";
       end
    end

end

% root template maker
function rootTemplateMaker(displayNameHandle,descriptionHandle,newUUID,combinedName,combinedNameCaps)
    templateRootTemplate = readtable('weaponOilRootTemplate.xlsx', 'ReadVariableNames', false);
    for i = 1:1:height(templateRootTemplate)
        line = string(table2cell(templateRootTemplate(i,1)));
        line = strrep(line,"REPLACEDISPLAYNAMEHANDLE",displayNameHandle);
        line = strrep(line,"REPLACEDESCRIPTIONHANDLE",descriptionHandle);
        line = strrep(line,"REPLACENEWUUID",newUUID);
        line = strrep(line,"REPLACECOMBINEDNAMENOCAPS",combinedName);
        line = strrep(line,"REPLACECOMBINEDNAMECAPS",combinedNameCaps);
        writelines(line, "WeaponActionOils_root_templates.txt", WriteMode="append")

    end
end

% object maker
function objectMaker(rarity,act,combinedName,newUUID)
    templateObject = readtable('weaponOilObjectTemplate.xlsx', 'ReadVariableNames', false);
    rarities = ["Uncommon", "Rare", "Very Rare", "Legendary"];
    rarityValues = [2, 3, 4, 5];
    rarityDictionary = dictionary(rarities,rarityValues);
    for i = 1:1:height(templateObject)
        line = string(table2cell(templateObject(i,1)));
        line = strrep(line,"REPLACECOMBINEDNAMENOCAPS",combinedName);
        line = strrep(line,"REPLACENEWUUID",newUUID);
        line = strrep(line,"REPLACERARITY",rarity);
        line = strrep(line,"REPLACEVALUE",num2str(rarityDictionary(rarity)*act*75));
        writelines(line, "Objects.txt", WriteMode="append")
    end
end

% status maker
function statusMaker(displayNameHandle,descriptionHandle,dippedDisplayNameHandle,dippedDescriptionHandle,combinedName,combinedNameCaps,rangedOrMelee)
    if rangedOrMelee == "Melee"
        templateOilBase = readtable('weaponOilBaseTemplateMelee.xlsx', 'ReadVariableNames', false);
    else
        templateOilBase = readtable('weaponOilBaseTemplateRanged.xlsx', 'ReadVariableNames', false);
    end
    for i = 1:1:height(templateOilBase)
        line = string(table2cell(templateOilBase(i,1)));
        line = strrep(line,"REPLACECOMBINEDNAMENOCAPS",combinedName);
        line = strrep(line,"REPLACECOMBINEDNAMECAPS",combinedNameCaps);
        line = strrep(line,"REPLACEDISPLAYNAMEHANDLE",displayNameHandle);
        line = strrep(line,"REPLACEDESCRIPTIONHANDLE",descriptionHandle);
        writelines(line, "Status.txt", WriteMode="append")
    end

    templateDipped = readtable('weaponOilDippedTemplate.xlsx', 'ReadVariableNames', false);
    for i = 1:1:height(templateDipped)
        line = string(table2cell(templateDipped(i,1)));
        line = strrep(line,"REPLACECOMBINEDNAMECAPS",combinedNameCaps);
        line = strrep(line,"REPLACECOMBINEDNAMENOCAPS",combinedName);
        line = strrep(line,"REPLACEDISPLAYNAMEDIPPEDHANDLE",dippedDisplayNameHandle);
        line = strrep(line,"REPLACEDESCRIPTIONDIPPEDHANDLE",dippedDescriptionHandle);
        writelines(line, "Status.txt", WriteMode="append")
    end
end

% passive
function passiveMaker(combinedName,combinedNameCaps,spellID)
    templateObject = readtable('weaponOilPassiveTemplate.xlsx', 'ReadVariableNames', false);
    for i = 1:1:height(templateObject)
        line = string(table2cell(templateObject(i,1)));
        line = strrep(line,"REPLACECOMBINEDNAMECAPS",combinedNameCaps);
        line = strrep(line,"REPLACECOMBINEDNAMENOCAPS",combinedName);
        line = strrep(line,"REPLACESPELLNAME",spellID + "_WeaponOil");
        writelines(line, "Passives.txt", WriteMode="append")
    end
end

% spell
function spellMaker(spellID)
    templateObject = readtable('weaponOilSpellTemplate.xlsx', 'ReadVariableNames', false);
    for i = 1:1:height(templateObject)
        line = string(table2cell(templateObject(i,1)));
        line = strrep(line,"REPLACESPELLNAMEANDPREFIX",spellID + "_WeaponOil");
        line = strrep(line,"REPLACESPELLTYPE",extractBefore(spellID,"_"));
        line = strrep(line,"REPLACESPELLNAME",spellID);
        writelines(line, "Spell.txt", WriteMode="append")
    end
end