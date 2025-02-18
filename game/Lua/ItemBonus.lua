require "System\\ScriptCore"
require "System\\ScriptDefines"

BridgeFunctionAttach("LuaPacketRecv", "ItemBonus_LuaPacketRecv")
BridgeFunctionAttach("LuaEntryProc", "ItemBonus_LuaEntryProc")
BridgeFunctionAttach("LuaMouseEvent", "ItemBonus_LuaMouseEvent")

local previousItems = {
    Sword = -1,
    Shield = -1,
    Helm = -1,
    Armor = -1,
    Pants = -1,
    Gloves = -1,
    Boots = -1,
    Wing = -1,
    Pet = -1
}

ItemBonus_LuaEntryProc = function()
    LogText("ItemBonusTest.lua started")
end

local function SendEquippedItems()
    Send(string.format("ItemBonus#CurrentItems#%d#%d#%d#%d#%d#%d#%d#%d#%d", previousItems.Sword, previousItems.Shield, previousItems.Helm, previousItems.Armor, previousItems.Pants, previousItems.Gloves, previousItems.Boots, previousItems.Wing, previousItems.Pet))
end

local function GetSetOnLogIn()
    previousItems.Sword     = GetSwordSlot()
    previousItems.Shield    = GetShieldSlot()
    previousItems.Helm      = GetHelmSlot()
    previousItems.Armor     = GetArmorSlot()
    previousItems.Pants     = GetPantsSlot()
    previousItems.Gloves    = GetGlovesSlot()
    previousItems.Boots     = GetBootsSlot()
    previousItems.Wing      = GetWingSlot()
    previousItems.Pet       = GetPetSlot()
    LogText(string.format("Inventario de %s carregado!", CharName()))
    SendEquippedItems()
end

ItemBonus_LuaMouseEvent = function()
    if CheckWindow(Inventory) then
        local currentItemsInv = {
            Sword     = GetSwordSlot(),
            Shield    = GetShieldSlot(),
            Helm      = GetHelmSlot(),
            Armor     = GetArmorSlot(),
            Pants     = GetPantsSlot(),
            Gloves    = GetGlovesSlot(),
            Boots     = GetBootsSlot(),
            Wing      = GetWingSlot(),
            Pet       = GetPetSlot(),
        }
    
        -- Verifica se algum slot de previousItems foi alterado
        for slot, previousItemIndex in pairs(previousItems) do
            local currentItemIndex = currentItemsInv[slot] or -1
            
            -- Se o item atual for diferente do anterior, detecta a mudança
            if currentItemIndex ~= previousItemIndex then
                LogText(string.format("%s mudou de %d para %d", slot, previousItemIndex, currentItemIndex))
                
                --Send(string.format("ItemBonus#ItemChanged#%s#%d", slot, currentItemIndex))  -- Mudança: slot agora é uma string
    
                -- Atualiza o previousItems com o novo valor
                previousItems[slot] = currentItemIndex  -- Mudança aplicada aqui
            end
        end

        SendEquippedItems()
    end
end

ItemBonus_LuaPacketRecv = function(aIndex, str)
    if (obterElemento(str, 0) == "ItemBonus") then
        if (obterElemento(str, 1) == "CharLogged") then
            LogText("Recebeu pacote do servidor")
            GetSetOnLogIn()
        elseif (obterElemento(str, 1) == "MapChange") then
            Send("ItemBonus#MapChanged")
        end
    end
end
