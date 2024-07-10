templateArray = ['new entry "Shout_TraceWeapon_Template';...
                 'type "SpellData"';...
                 'data "SpellType" "Shout"';...
                 'using "Shout_TraceWeapon"';...
                 'data "Icon" "Action_Paladin_SacredWeapon"';...
                 'data "DisplayName" "h08bf2cfeg4d3eg4f8agac64g5622cd9d5551;1"';...
                 'data "Description "h9786436ag6854g4471gb89cgb7966937b899;6"';...
                 'data "DescriptionParams" "This weapon was;2;3;4"';...
                 'data "SpellProperties" "SummonInInventory(407954e3-71e4-4611-9221-0ba3ea71d6e8,2,1,true,true,true,,,REPRODUCTION,REPRODUCTION)"';...
                 'data "SpellContainerID" "Shout_TraceWeapon"';...
                 'data "SpellFlags" "UNUSED_D"';...
                 ""];

templateFile = templateArray;
for i = 1:1:999
    for j = 1:1:12
        tempArray = templateArray;
        if i < 10
            tempArray(1) = tempArray(1) + "00" + i + """";
        elseif i < 100
            tempArray(1) = tempArray(1) + "0" + i + """";
        else
            tempArray(1) = tempArray(1) + + i + """";
        end
        writelines(tempArray(j),"Spell_TraceTemplate.txt",WriteMode="append")
    end
end