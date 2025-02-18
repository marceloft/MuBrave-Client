require "System\\ScriptCore"
require "System\\ScriptDefines"

local Enabled = true
-- Configurações iniciais
local WHButtons = false
local bauAberto = false
local maxBaus = 0
local bau = 0
local windowSize = {
    {X = 819, Y = 614, XEInv = 169, XDInv = 250, XEInvEx = -21, XDInvEx = 60, YInv = 148},     -- 1024x768
    --{X = 1024, Y = 819, XEInv = 220, XDInv = 292, XEInvEx = 30, XDInvEx = 102, YInv = 98},    -- 1280x1024
    {X = 910, Y = 512, XEInv = 220, XDInv = 292, XEInvEx = 30, XDInvEx = 102, YInv = 98},     -- 1366x768
    {X = 960, Y = 600, XEInv = 247, XDInv = 315, XEInvEx = 57, XDInvEx = 125, YInv = 142},     -- 1440x900
    {X = 1066, Y = 600, XEInv = 300, XDInv = 368, XEInvEx = 110, XDInvEx = 178, YInv = 141},    -- 1600x900
}

BridgeFunctionAttach("LuaPacketRecv", "Warehouse_WHRecv")
BridgeFunctionAttach("LuaWork", "Warehouse_WareHouse")
BridgeFunctionAttach("LuaMouseEvent", "Warehouse_WHEvent")
BridgeFunctionAttach("LuaEntryProc", "Warehouse_LuaEntryProc")


Warehouse_LuaEntryProc = function()
    LogText("Warehouse.lua started")
end
--[[BridgeFunctionAttach("OnNpcTalk", "Warehouse_OnNpcTalk")

NPCGuildCheck = function (aIndex, bIndex)
	local NPC = GetObjectClass(aIndex)
	
	if NPC ~= 241 then
		Send(bIndex, "WareHouse#TalkGuild#true")
	else
		Send(bIndex, "WareHouse#TalkGuild#false")
	end
	
	return 0
end
]]
-- Função para processar as mensagens recebidas
Warehouse_WHRecv = function (aIndex, str)
    if (obterElemento(str, 0) == "WareHouse") then
        if (obterElemento(str, 1) == "MaxVault") then
            maxBaus = obterElemento(str, 2)
        end
        if (obterElemento(str, 1) == "ResetBau") then
            bau = 0
        end
    end
end

-- Função para calcular a posição baseada na resolução
local function getWindowPosition()
    local windowX = GetWindowsX()
    local windowY = GetWindowsY()

    local X = (windowX / 2) - (188 / 2) -- Centraliza baseado na largura da janela
    local Y = (windowY / 2) - (300 / 2) -- Centraliza baseado na altura da janela

    return X, Y
end

-- Função para renderizar os botões de navegação do baú
Warehouse_WareHouse = function ()
    if Enabled then

        if WHButtons then
            --LogText(string.format("Window X: %d, Y: %d", GetWindowsX(), GetWindowsY()))
            --local X = (GetWindowsX()/2) - (188/2)
            --local Y = (GetWindowsY()/2) - (300/2)
            local X, Y = getWindowPosition()
            local windowX = GetWindowsX()
            local windowY = GetWindowsY()

            SetBlend(1) -- Ativa o Alpha

            for _,res in ipairs(windowSize) do
                if (windowX == res.X) then
                    if (windowY == res.Y) then
                        if not CheckWindow(77) then
                            RenderImage(31658, X + res.XEInv, Y - res.YInv, 30, 15, 0, 0, 36, 18) -- Botão esquerdo
                            RenderImage(31659, X + res.XDInv, Y - res.YInv, 30, 15, 0, 0, 36, 18) -- Botão direito 
                        else
                            RenderImage(31658, X + res.XEInvEx, Y - res.YInv, 30, 15, 0, 0, 36, 18) -- Botão esquerdo
                            RenderImage(31659, X + res.XDInvEx, Y - res.YInv, 30, 15, 0, 0, 36, 18) -- Botão direito
                        end
                    end
                end
            end

        end

    end
end

function Warehouse_ExecutaBotoes(X1, Y1, X2, Y2)
    -- Verifica se o mouse está na área do botão de aumentar o valor do baú e se o botão do mouse foi liberado
    if CheckMouseIn(X1, Y1, 15, 15) and IsRelease(0x01) then
        if bau >= 0 and bau < (maxBaus - 1) then
            bau = bau + 1
            if CheckWindow(8) then
                CloseWindow(8)
                Send(string.format("WareHouse#Trocar#%d", bau))
            end
        elseif bau == maxBaus - 1 then
            Send("WareHouse#LimiteBau")
        end
        return true -- Impede o movimento do personagem se o mouse estiver sobre esta área
    end
    -- Verifica se o mouse está na área do botão de diminuir o valor do baú e se o botão do mouse foi liberado
    if CheckMouseIn(X2, Y2, 15, 15) and IsRelease(0x01) then
        if bau > 0 and bau <= (maxBaus - 1) then
            bau = bau - 1
            if CheckWindow(8) then
                CloseWindow(8)
                Send(string.format("WareHouse#Trocar#%d", bau))
            end
        end
        return true -- Impede o movimento do personagem se o mouse estiver sobre esta área
    end

end

-- Função para lidar com eventos de manipulação do baú
Warehouse_WHEvent = function ()

    if Enabled then
        local X, Y = getWindowPosition()
        local windowX = GetWindowsX()
        local windowY = GetWindowsY()

        -- Verifica se a tecla ESC foi pressionada para ocultar os botões
        if IsPress(0x1B) then
            WHButtons = false
        end

        -- Atualiza o estado dos botões com base no estado da janela do baú
        WHButtons = CheckWindow(8)

        -- Envia informação de que o bau foi aberto
        if CheckWindow(8) and bauAberto == false then
            Send("WareHouse#AbriuBau")
            bauAberto = true
        elseif not CheckWindow(8) then
            bauAberto = false
        end

        for _,res in ipairs(windowSize) do
            if (windowX == res.X) then
                if (windowY == res.Y) then
                    if not CheckWindow(77) then
                        Warehouse_ExecutaBotoes(X + res.XDInv, Y - res.YInv, X + res.XEInv, Y - res.YInv)
                    else
                        Warehouse_ExecutaBotoes(X + res.XDInvEx, Y - res.YInv, X + res.XEInvEx, Y - res.YInv)
                    end
                end
            end
        end

        return false -- Permite o movimento do personagem se o mouse não estiver sobre as áreas dos botões

    end

end