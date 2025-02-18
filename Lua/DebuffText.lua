require "System\\ScriptCore"
require "System\\ScriptDefines"

local XpDebuff_Enable = GetPrivateProfileIntA("XPDebuffNotification", "Enable", 1, "./Settings.ini")

if XpDebuff_Enable ~= 1 then
    return
end

local showDebuff = false
local pDebuffLvl = 0
local pDebuff = 0
local pMaxDebuff = 0
local width = 80
local height = 42
local bgSize = 80
local bgAlpha = 0
local textAlpha = 200
local lastUpdateTime = GetTickCount() -- Armazena o tempo da última atualização
local timeoutSeconds = 10 -- Tempo para auto ocultar as infos (em segundos)

BridgeFunctionAttach("LuaPacketRecv", "DebuffText_RecvServer")
BridgeFunctionAttach("LuaWork", "DebuffText_LuaWork")
BridgeFunctionAttach("LuaEntryProc", "DebuffText_LuaEntryProc")


DebuffText_LuaEntryProc = function()
    LogText("DebuffText.lua started")
end

-- Retorna posição relativa à resolução da tela
local function getWindowPosition()
    local windowX = GetWindowsX()
    local windowY = GetWindowsY()

    local X = (windowX * 0.285) - (width / 2) -- Centraliza no meio da tela
    local Y = windowY * 1.146  -- Ajusta para aparecer um pouco acima do meio (+ pra baixo \ - pra cima)

    return X, Y
end

local function RenderInfos()
        SetBlend(1)
        local X, Y = getWindowPosition()

        DrawBarBorder(0, 0, 0, 200, 255, 255, 255, 200, X, Y-180, width, height)
        RenderText(X, Y-179, 0, 0, 0, textAlpha, 255, 255, 255, 200, bgSize, 3, "XP MAP DEBUFF")
        RenderText(X, Y-168, 255, 255, 255, textAlpha, 0, 0, 0, bgAlpha, bgSize, 3, string.format("XP Debuff / Lvl: %d%%", pDebuffLvl))
        RenderText(X, Y-159.5, 255, 255, 255, textAlpha, 0, 0, 0, bgAlpha, bgSize, 3, string.format("XP Max Debuff: %d%%", pMaxDebuff))
        RenderText(X, Y-149.5, 255, 0, 0, textAlpha, 0, 0, 0, bgAlpha, bgSize, 3, string.format("XP Debuff: -%d%%", pDebuff))
end

function DebuffText_LuaWork()
    -- Se já está mostrando o Debuff, verifica se o tempo limite foi atingido
    if showDebuff then
        if (GetTickCount() - lastUpdateTime) > (timeoutSeconds * 1000) then
            LogText("XP Debuff ocultado por inatividade.") -- Loga a ocultação automática
            showDebuff = false
            return
        end

        RenderInfos()
    end
end

function DebuffText_RecvServer(aIndex, str)
    local command = obterElemento(str, 0)
    local status = obterElemento(str, 1)

    if command == "XpDebuff" then
        if status == "On" then
            local newDebuff = tonumber(obterElemento(str, 2)) -- Converte para número
            pDebuffLvl = tonumber(obterElemento(str, 3)) -- Converte para número
            pMaxDebuff = tonumber(obterElemento(str, 4)) -- Converte para número

            if newDebuff ~= pDebuff then -- Só loga se o valor for diferente
                LogText(string.format("XP Debuff atualizado: %d%%", newDebuff))
            end

            showDebuff = true
            pDebuff = newDebuff
            lastUpdateTime = GetTickCount() -- Atualiza o tempo da última comunicação

        elseif status == "Off" then
            LogText("XP Debuff desativado.") -- Loga quando o Debuff some
            showDebuff = false -- Oculta o texto da tela

        elseif status == "MapChange" then
            LogText("XP Debuff map change.")
            Send("XpDebuff#MapChanged")

        end
    end
end
