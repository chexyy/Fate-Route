templateArray = ['new entry "WEAPON_DESCRIPTION_TEMPLATE';...
                 'type "StatusData"';...
                 'data "StatusType" "BOOST"';...
                 'data "StackId" "WEAPON_DESCRIPTION_TEMPLATE';...
                 'data "Icon" "PassiveFeature_PactOfTheBlade"';...
                 'data "DisplayName" "hbb03389153034c47a5c18ce5f66198fc42d7;1"';...
                 'data "Description" "';...
                 'data "DescriptionParams" "1"';...
                 'data "Boosts" "UnlockSpell(Shout_TraceWeapon_TemplateDescription';...
                 'data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"';...
                 ""];



randomCharacter = ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"];

length = 999;
handleArray = strings([1 length]);
for z = 1:1:length
    tempHandle = "h";
    for b = 1:1:36
            tempHandle = tempHandle + randomCharacter(randi(36));
    end
    handleArray(z) = tempHandle;
end

for i = 1:1:length
    for j = 1:1:11
        tempArray = templateArray;
        tempArray(1) = tempArray(1) + i + '"';
        tempArray(4) = tempArray(4) + i + '"';
        tempArray(7) = tempArray(7) + handleArray(i) + '"';
        tempArray(9) = tempArray(9) + i + ')"';
        writelines(tempArray(j),"Status_WeaponDescriptions.txt",WriteMode="append")
    end
end

for a = 1:1:length
    line = '<content contentuid="' + handleArray(a) + '" version="1">A reflection of &lt;LSTag Type="Spell" Tooltip="Shout_TraceWeapon_TemplateDescription' + a + '"&gt;[1]&lt;/LSTag&gt;.</content>';
    writelines(line, "loca_file.txt", WriteMode="append")
end