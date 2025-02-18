require "System\\ScriptCore"
require "System\\ScriptDefines"

local Ativado		= true
local Debug			= false

local InterfaceOpen = false
local Wid 			= 250
local FixAlign 		= 0
local Comp 			= 20
local AltFoot 		= 230
local AltBtn 		= 178
local IsClicked		= false

local MobAtual = 1
local MobQtd = 1
local MobRange = 10
local MobDir = -1

local x
local PreAdded = false

local Preview = false

local NaoExistem = {50, 68}

CheckIndex = function(Index)
	local MobMap = {}
	for _, v in ipairs(NaoExistem) do
		MobMap[v] = true
	end

	return MobMap[Index] or false
end

if Ativado then
	if Debug then ConsoleOn(1) end
	
	Fecha = function()
		InterfaceOpen = false
	end

	BridgeFunctionAttach("LuaMouseEvent", "Teclado")

	Teclado = function()
		if CheckWindow(1) or CheckWindow(12) or CheckWindow(14) or CheckWindow(33) or CheckWindow(65) then
			Fecha()
			return false
		end
		
		-- Impede de usar o comando sem estar dentro do mapa
		if (SceneFlag()~= 5) then return false end 
		
		local X = (GetWindowsX()/2)-(300/2) -- Posição X para o fundo ajustado
		local Y = (GetWindowsY()/2)-(Wid/2) - FixAlign -- Posição Y para o fundo ajustado	
		
		if (CheckMouseIn(X + 264, Y - 1, 36, 29) and IsRelease(0x01)) and InterfaceOpen then
			Fecha()			
			return false
		end
		
		-- Fecha ao pressionar ESQ ou X
		if IsPress(0x1B) or IsPress(0x58) then
			Fecha()
			return false
		end
		
		if IsPress(0x41) then -- Letra A
			InterfaceOpen = not InterfaceOpen
		end
			
		if InterfaceOpen then		
			-- Evita andarao clicar em algum lugar da tela
			if CheckMouseIn(X, Y, 300, 280) then return true end
		end
		
		return false
	end

	BridgeFunctionAttach("LuaWork", "DrawInterface")

	DrawInterface = function()			
		if InterfaceOpen then	
			local X = (GetWindowsX()/2)-(300/2) -- Posição X para o fundo ajustado
			local Y = (GetWindowsY()/2)-(Wid/2) - FixAlign -- Posição Y para o fundo ajustado			


			DrawBarBorder(0, 0, 0, 120 , 255, 0, 0, 0, X, Y, 300, 270)
			
			SetBlend(1)

			-- Ajustar os componentes do fundo conforme necessário
			RenderImage(31588, X, Y, 300, 64, 64, 0, 62, 64) -- Centro Sup
			RenderImage(31588, X, Y, 64, 64, 0, 0, 64, 64) -- Ponta Sup Esq
			RenderImage(31588, X + 236, Y, 64, 64, 126, 0, 64, 64) -- Ponta Sup Dir
			
			
			CustomText(0, 17, X, Y + 8, 240,230,140, 200, 0, 0, 0, 0, 300, 3, "Criador de Spots")
			SetBlend(0)			

			for b = 0, Comp do
				RenderImage(31589, X, Y + 64 + (b * 10), 21, 10.45, 0, 0, 21, 9) -- Lateral Esq
				RenderImage(31590, X + 279, Y + 64 + (b * 10), 21, 10.45, 0, 0, 20.5, 9) -- Lateral Dir
			end

			RenderImage(31357, X, Y + AltFoot, 300, 45, 64, 0, 62, 45) -- Centro Inf
			RenderImage(31357, X, Y + AltFoot, 64, 45, 0, 0, 64, 45) -- Ponta Inf Esq
			RenderImage(31357, X + 236, Y + AltFoot, 64, 45, 126, 0, 64, 45) -- Ponta Inf Dir

			if CheckMouseIn(X + 264, Y - 1, 36, 29) and IsRepeat(0x01) then
				RenderImage(32453, X + 264, Y - 1, 36, 29, 0, 29, 36, 29); -- Botão fechar
			else
				RenderImage(32453, X + 264, Y - 1, 36, 29, 0, 0, 36, 29); -- Botão fechar
			end
			
			RenderMonsterSkin(MobAtual, X+20, Y+62, 65, 65, 1, 90)			
			
			if not CheckMouseIn(X + 15, Y + 135, 20, 20) then
				RenderImage(31658, X + 15, Y + 135, 100, 20, 0, 0, 100, 20)
			else
				RenderImage(31658, X + 15, Y + 135, 100, 20, 0, 20, 100, 20)
				
				if IsPress(0x01) then IsClicked = true end
					
				if IsRelease(0x01) and IsClicked then
					if MobAtual > 1 then MobAtual = MobAtual - 1 end
					
					if CheckIndex(MobAtual) then MobAtual = MobAtual - 1 end
					IsClicked = false
				end
			end		
			
			if not CheckMouseIn(X + 68, Y + 135, 20, 29) then
				RenderImage(31659, X + 68, Y + 135, 100, 20, 0, 0, 100, 20)
			else
				RenderImage(31659, X + 68, Y + 135, 100, 20, 0, 20, 100, 20)
				
				if IsPress(0x01) then IsClicked = true end
					
				if IsRelease(0x01) and IsClicked then
					MobAtual = MobAtual + 1
					
					if CheckIndex(MobAtual) then MobAtual = MobAtual + 1 end
					IsClicked = false
				end
			end
			
			DrawBarBorder(0, 0, 0, 120, 160, 160, 160, 180, X + 10, Y + 168, 280, 16)	
			
			SetBlend(1)
			CustomText(0, 17, X, Y + 170, 240,230,140, 200, 0, 0, 0, 0, 300, 3, string.format("%d - %s", MobAtual, GetMonsterName(MobAtual)))
			SetBlend(0)
					
			if not CheckMouseIn(X + 15, Y + 200, 108, 29) then
				RenderImage(0x7A5E, X + 15, Y + 200, 108, 29, 0, 58, 108, 29)
			else
				RenderImage(0x7A5E, X + 15, Y + 200, 108, 29, 0, 0, 108, 29)
				
				if not Preview then				
					if IsPress(0x01) then IsClicked = true end
					
					if IsRelease(0x01) and IsClicked then
						SendChat(string.format("/addm %d %d %d %d", MobAtual, MobQtd, MobRange, MobDir))
						
						PreAdded = true
						Preview = true
						IsClicked = false						
					end					
				else
					if IsPress(0x01) then IsClicked = true end
					
					if IsRelease(0x01) and IsClicked then
						SendChat("/sn");
						
						Preview = false
						IsClicked = false						
					end
				end
			end	
			
			if Preview == false then
				CustomText(0, 16, X + 15, Y + 200 + 8, 240,230,140, 200, 0, 0, 0, 0, 108, 3, "Pré Visualizar")
			else
				CustomText(0, 16, X + 15, Y + 200 + 8, 240,230,140, 200, 0, 0, 0, 0, 108, 3, "Cancelar Pré Vis.")
			end
			
			if not CheckMouseIn(X + 15, Y + 230, 108, 29) then
				RenderImage(0x7A5E, X + 15, Y + 230, 108, 29, 0, 58, 108, 29)
			else

				RenderImage(0x7A5E, X + 15, Y + 230, 108, 29, 0, 0, 108, 29)
				
				if IsPress(0x01) then IsClicked = true end
					
				if IsRelease(0x01) and IsClicked then
					SendChat("/sy")
					
					x = GetTickCount()
					
					Preview = false
					IsClicked = false						
				end
			end	
			CustomText(0, 16, X + 15, Y + 230 + 8, 240,230,140, 200, 0, 0, 0, 0, 108, 3, "Adicionar Spot")		
			
			-- Quantidade monstros [inicio]
			
			CustomText(0, 16, X + 90, Y + 60, 240,230,140, 200, 0, 0, 0, 0, 150, 0, string.format("Quantidade Monstros: %d", MobQtd))
			
			DrawBarBorder(0, 0, 0, 120 , 243, 156, 18, 255, X + 240, Y + 60, 15, 15)
			DrawBarBorder(0, 0, 0, 120 , 243, 156, 18, 255, X + 260, Y + 60, 15, 15)
			
			SetBlend(1)
			CustomText(1, 16, X + 240, Y + 60, 170, 183, 184 , 200, 0, 0, 0, 0, 15, 3, "-")
			CustomText(1, 16, X + 261, Y + 62, 170, 183, 184 , 200, 0, 0, 0, 0, 15, 3, "+")
			SetBlend(0)
			
			if CheckMouseIn(X + 240, Y + 60, 20, 20) then
				if IsPress(0x01) then IsClicked = true end
				
				if IsRelease(0x01) and IsClicked then
					if MobQtd >= 2 then MobQtd = MobQtd - 1 end
					IsClicked = false
				end	
			end
			
			if CheckMouseIn(X + 260, Y + 60, 20, 20) then				
				if IsPress(0x01) then IsClicked = true end
				
				if IsRelease(0x01) and IsClicked then
					if MobQtd >= 1 then MobQtd = MobQtd + 1 end
					IsClicked = false
				end			
			end
			
			-- Quantidade monstros [fim]			
			-- Range monstros [inicio]
			
			CustomText(0, 16, X + 90, Y + 80, 240,230,140, 200, 0, 0, 0, 0, 150, 0, string.format("Range Monstros: %d", MobRange))
			
			DrawBarBorder(0, 0, 0, 120 , 243, 156, 18, 255, X + 240, Y + 80, 15, 15)
			DrawBarBorder(0, 0, 0, 120 , 243, 156, 18, 255, X + 260, Y + 80, 15, 15)
			
			SetBlend(1)
			CustomText(1, 16, X + 240, Y + 80, 170, 183, 184 , 200, 0, 0, 0, 0, 15, 3, "-")
			CustomText(1, 16, X + 261, Y + 82, 170, 183, 184 , 200, 0, 0, 0, 0, 15, 3, "+")
			SetBlend(0)
			
			if CheckMouseIn(X + 240, Y + 80, 20, 20) then
				if IsPress(0x01) then IsClicked = true end
				
				if IsRelease(0x01) and IsClicked then
					if MobRange >= 2 then MobRange = MobRange - 1 end
					IsClicked = false
				end	
			end
			
			if CheckMouseIn(X + 260, Y + 80, 20, 20) then				
				if IsPress(0x01) then IsClicked = true end
				
				if IsRelease(0x01) and IsClicked then
					if MobRange >= 1 then MobRange = MobRange + 1 end
					IsClicked = false
				end			
			end
			
			-- Range monstros [fim]			
			-- Dir monstros [inicio]
			
			CustomText(0, 16, X + 90, Y + 100, 240,230,140, 200, 0, 0, 0, 0, 150, 0, string.format("Direção Monstros: %d", MobDir))
			
			--[[-1 = aleatorio
			0 = diag esq cima
			1 = esq
			2 = diag esq baixo
			3 = baixo
			4 = diag dir baixo
			5 = dir
			6 = diag dir cima
			7 = cima]]
			
			if MobDir == -1 then
				RenderImage(31758, X + 250, Y + 107, 20, 15, 0, 0, 20, 15) -- Cima
			elseif MobDir == 0 then
				RenderImage(31758, X + 235, Y + 112, 20, 15, 0, 0, 20, 15) -- Diag esq cima
			elseif MobDir == 1 then
				RenderImage(31758, X + 235, Y + 112, 20, 15, 0, 0, 20, 15) -- Esq
			elseif MobDir == 2 then
				RenderImage(31758, X + 265, Y + 138, 20, 15, 0, 0, 20, 15) -- Diag esq baixo
			elseif MobDir == 3 then
				RenderImage(31758, X + 250, Y + 145, 20, 15, 0, 0, 20, 15) -- Baixo
			elseif MobDir == 4 then
				RenderImage(31758, X + 265, Y + 138, 20, 15, 0, 0, 20, 15) -- Diag dir baixo
			elseif MobDir == 5 then
				RenderImage(31758, X + 270, Y + 125, 20, 15, 0, 0, 20, 15) -- Dir
			elseif MobDir == 6 then
				RenderImage(31758, X + 265, Y + 112, 20, 15, 0, 0, 20, 15) -- Diag dir cima
			elseif MobDir == 7 then
				RenderImage(31758, X + 250, Y + 107, 20, 15, 0, 0, 20, 15) -- Cima
			end
			
			if not CheckMouseIn(X + 250, Y + 107, 20, 15) and (MobDir ~= 7) then
				RenderImage(31758, X + 250, Y + 107, 20, 15, 0, 15, 20, 15) -- Cima
			else
				RenderImage(31758, X + 250, Y + 107, 20, 15, 0, 0, 20, 15) -- Cima
				
				if IsRelease(0x01) then
					MobDir = 7
				end	
			end
			
			if not CheckMouseIn(X + 270, Y + 125, 20, 15) and (MobDir ~= 5) then
				RenderImage(31758, X + 270, Y + 125, 20, 15, 0, 15, 20, 15) -- Dir
			else
				RenderImage(31758, X + 270, Y + 125, 20, 15, 0, 0, 20, 15) -- Dir
				
				if IsRelease(0x01) then
					MobDir = 5
				end	
			end
			
			if not CheckMouseIn(X + 250, Y + 145, 20, 15) and (MobDir ~= 3) then
				RenderImage(31758, X + 250, Y + 145, 20, 15, 0, 15, 20, 15) -- Baixo
			else
				RenderImage(31758, X + 250, Y + 145, 20, 15, 0, 0, 20, 15) -- Baixo
				
				if IsRelease(0x01) then
					MobDir = 3
				end	
			end
			
			if not CheckMouseIn(X + 230, Y + 125, 20, 15) and (MobDir ~= 1) then
				RenderImage(31758, X + 230, Y + 125, 20, 15, 0, 15, 20, 15) -- Esq
			else
				RenderImage(31758, X + 230, Y + 125, 20, 15, 0, 0, 20, 15) -- Esq
				
				if IsRelease(0x01) then
					MobDir = 1
				end	
			end
			
			if not CheckMouseIn(X + 250, Y + 125, 20, 15) and (MobDir ~= -1) then
				RenderImage(31758, X + 250, Y + 125, 20, 15, 0, 15, 20, 15) -- meio	
			else
				RenderImage(31758, X + 250, Y + 125, 20, 15, 0, 0, 20, 15) -- meio	
				
				if IsRelease(0x01) then
					MobDir = -1
				end	
			end
			
			if not CheckMouseIn(X + 265, Y + 112, 20, 15) and (MobDir ~= 6) then
				RenderImage(31758, X + 265, Y + 112, 20, 15, 0, 15, 20, 15) -- Diag dir cima
			else
				RenderImage(31758, X + 265, Y + 112, 20, 15, 0, 0, 20, 15) -- Diag dir cima
				
				if IsRelease(0x01) then
					MobDir = 6
				end	
			end
			
			if not CheckMouseIn(X + 265, Y + 138, 20, 15) and (MobDir ~= 4) then
				RenderImage(31758, X + 265, Y + 138, 20, 15, 0, 15, 20, 15) -- Diag dir baixo
			else
				RenderImage(31758, X + 265, Y + 138, 20, 15, 0, 0, 20, 15) -- Diag dir baixo
				
				if IsRelease(0x01) then
					MobDir = 4
				end	
			end
			
			if not CheckMouseIn(X + 235, Y + 112, 20, 15) and (MobDir ~= 0) then
				RenderImage(31758, X + 235, Y + 112, 20, 15, 0, 15, 20, 15) -- Diag esq cima
			else
				RenderImage(31758, X + 235, Y + 112, 20, 15, 0, 0, 20, 15) -- Diag esq cima
				
				if IsRelease(0x01) then
					MobDir = 0
				end	
			end
			
			if not CheckMouseIn( X + 235, Y + 138, 20, 15) and (MobDir ~= 2) then
				RenderImage(31758, X + 235, Y + 138, 20, 15, 0, 15, 20, 15) -- Diag esq baixo		
			else
				RenderImage(31758, X + 235, Y + 138, 20, 15, 0, 0, 20, 15) -- Diag esq baixo

				if IsRelease(0x01) then
					MobDir = 2
				end					
			end	
			
			-- Dir monstros [fim]
			
			CustomText(0, 16, X + 175, Y + 190, 240,230,140, 200, 0, 0, 0, 0, 108, 3, string.format("Posição X Atual: %d", MyCoordX()))
			CustomText(0, 16, X + 175, Y + 205, 240,230,140, 200, 0, 0, 0, 0, 108, 3, string.format("Posição Y Atual: %d", MyCoordY()))
			
			if not CheckMouseIn(X + 175, Y + 230, 108, 29) then
				RenderImage(0x7A5E, X + 175, Y + 230, 108, 29, 0, 58, 108, 29)
			else
				RenderImage(0x7A5E, X + 175, Y + 230, 108, 29, 0, 0, 108, 29)
				
				if IsPress(0x01) then IsClicked = true end
				
				if IsRelease(0x01) and IsClicked then
					MobAtual = 1
					MobQtd = 1
					MobRange = 10
					MobDir = -1

					IsClicked = false
				end	
			end	
			CustomText(0, 16, X + 175, Y + 230 + 8, 240,230,140, 200, 0, 0, 0, 0, 108, 3, "Resetar")
		end
		
		if ((x ~= 0) and PreAdded) then
			if GetTickCount() - x > 1000 then
				x = 0
				PreAdded = false
				
				SendChat("/reload monster")
			end
		end
	end
end