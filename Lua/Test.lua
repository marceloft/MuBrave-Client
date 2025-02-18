require "System\\ScriptCore"
require "System\\ScriptDefines"

local Enabled = false
if not Enabled then
    return
end

local width = 200
local height = 300

BridgeFunctionAttach("LuaWork", "Test_LuaWork")

-- Retorna posição relativa à resolução da tela
local function getWindowPosition()
    local windowX = GetWindowsX()
    local windowY = GetWindowsY()

    local X = (windowX * 0.5) - (width / 2) -- Centraliza no meio da tela
    local Y = (windowY * 0.5) - (height / 2)  -- Ajusta para aparecer um pouco acima do meio

    return X, Y
end

function Test_LuaWork()
    local X, Y = getWindowPosition()
    SetBlend(1)
    DrawBarBorder(0, 0, 0, 255, 255, 255, 255, 150, X, Y, width, height)
end