require "System\\ScriptCore"
require "System\\ScriptDefines"

local Enabled = false
if not Enabled then
    return
end

BridgeFunctionAttach("LuaWorkSS", "SSNews_LuaWorkSS")
BridgeFunctionAttach("LuaEntryProc", "SSNews_LuaEntryProc")

SSNews_LuaEntryProc = function()
    LogText("SelectServerNews.lua started")
end

local width = 300
local height = 600
-- Retorna posição relativa à resolução da tela
local function getWindowPosition()
    local windowX = GetWindowsX()
    local windowY = GetWindowsY()

    local X = (windowX * 0.86) - (width / 2) -- Centraliza no meio da tela
    local Y = (windowY * 0.5) - (height / 2)  -- Ajusta para aparecer um pouco acima do meio

    return X, Y
end

function SSNews_LuaWorkSS()
    local X, Y = getWindowPosition()
    SetBlend(1)
    DrawBarBorder(0, 0, 0, 180, 255, 255, 255, 0, X, Y, width, height)
end