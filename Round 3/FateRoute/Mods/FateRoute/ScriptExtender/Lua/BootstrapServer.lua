Ext.Require("traceClasses.lua")
Ext.Require("traceWeaponFunctions.lua")
Ext.Require("traceGeneralListener.lua")
Ext.Require("traceDetector.lua")
Ext.Require("fakerPassives.lua")
Ext.Require("weaponListener.lua")
Ext.Require("UnlimitedBladeWorks.lua")

local startTime = Ext.Utils.MonotonicTime()
while Ext.Utils.MonotonicTime() - startTime < 5000 do
end
Ext.Require("UnlimitedBladeWorksv2.lua")