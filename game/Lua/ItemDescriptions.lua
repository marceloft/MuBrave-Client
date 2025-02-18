require "System\\ScriptCore"
require "System\\ScriptDefines"

BridgeFunctionAttach("LuaWork", "ItemDescriptions_NewWork")
BridgeFunctionAttach("LuaEntryProc", "ItemDescriptions_LuaEntryProc")


ItemDescriptions_LuaEntryProc = function()
    LogText("ItemDescriptions.lua started")
end

local BCEntryLevels = {
    [985] = "15 ~ 80",
    [986] = "81 ~ 130",
    [987] = "131 ~ 180",
    [988] = "181 ~ 230",
    [989] = "231 ~ 280",
    [990] = "281 ~ 330",
    [991] = "331 ~ 400",
    [992] = "Master Level",
}

local DSEntryLevels = {
    [993] = "15 ~ 130",
    [994] = "131 ~ 180",
    [995] = "181 ~ 230",
    [996] = "231 ~ 280",
    [997] = "281 ~ 330",
    [998] = "331 ~ 400",
    [999] = "Master Level",
}
function ItemDescriptions_NewWork()
    -- Event Itens descriptions
    --Blood Castle
    for i = 985, 992, 1 do
        IntDescriptionValue(i, BCEntryLevels[i])
    end
    --Devil Square
    for i = 993, 999, 1 do
        IntDescriptionValue(i, DSEntryLevels[i])
    end

    IntDescriptionValue(0, "Recebe Mana Shield")
end
