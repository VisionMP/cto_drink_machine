cachedData = {}

local l_37 = 0
local l_3B = 0.306;
local l_3C = 0.31;
local l_3D = 0.98;
local l_45 = {0.0, -0.97, 0.05 }
local name = "Soda"

Citizen.CreateThread(function()
	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local sprunk = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_vend_soda_02"), false)
		local ecola = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_vend_soda_01"), false)		

		if DoesEntityExist(sprunk) or DoesEntityExist(ecola) or DoesEntityExist(water) then
			sleepThread = 5
			local markerCoords = GetOffsetFromEntityInWorldCoords(sprunk, 0.0, -0.97, 0.05)
			local distanceCheck1 = #(pedCoords - markerCoords)
			local markerCoords2 = GetOffsetFromEntityInWorldCoords(ecola, 0.0, -0.97, 0.05)
			local distanceCheck2 = #(pedCoords - markerCoords2)
			
			cash = exports["cto_framework"]:getData().cash
			
			if distanceCheck1 <= 1.0 then
				drawText3D(pedCoords, "Sprunk ~g~$~w~5 ~b~|~w~ Press ~r~E~w~")	

					if IsControlJustPressed(0, 38) then
						Sprunk(markerCoords,sprunk)
					end				
			elseif distanceCheck2 <= 1.0 then
				drawText3D(pedCoords, "eCola ~g~$~w~5 ~b~|~w~ Press ~r~E~w~")

					if IsControlJustPressed(0, 38) then
						eCola(markerCoords2,ecola)
					end		
			end
		end
		Citizen.Wait(sleepThread)
	end
end)

eCola = function(coords,maquina)   
	cash = exports["cto_framework"]:getData().cash        
	if cash >= Config.Price then	 
	Citizen.Wait(1000)
	EjecutarAnim(coords,maquina)
	local heal = GetEntityHealth(PlayerPedId())
	heal = heal + 20
	max = heal + 1
	SetEntityHealth(PlayerPedId(), heal)
	SetPedMaxHealth(PlayerPedId(),max + 1)
	TriggerServerEvent('PayForDrink')
	end 	
end

Sprunk = function(coords,maquina)   
	cash = exports["cto_framework"]:getData().cash        
	if cash >= Config.Price then	 
	Citizen.Wait(1000)
	EjecutarAnim(coords,maquina)
	AddArmourToPed(PlayerPedId(), 20)
	TriggerServerEvent('PayForDrink')
	end 	
end

requestDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

function EjecutarAnim(CoordsMaquina,maquina)
	if GetHashKey("prop_vend_soda_02") == GetEntityModel(maquina) then
		prop = "prop_ld_can_01b"
	elseif GetHashKey("prop_vend_soda_01") == GetEntityModel(maquina) then
		prop = "prop_ecola_can"	
    elseif GetHashKey("prop_vend_water_01") == GetEntityModel(maquina) then
	    prop = "prop_ld_flow_bottle"
    end
	RequestAmbientAudioBank("VENDING_MACHINE", 0)
	if GetFollowPedCamViewMode() == 4 then
		DicAnim = requestDict("mini@sprunk@first_person")
	else
		DicAnim = requestDict("mini@sprunk")
	end
	local taks TaskGoStraightToCoord(PlayerPedId(), CoordsMaquina, 1.0, 20000, GetEntityHeading(maquina), 0.1)
	Citizen.Wait(1000)
	while GetIsTaskActive(PlayerPedId(),task) do Citizen.Wait(1); end
	if IsEntityAtCoord(PlayerPedId(), CoordsMaquina, 0.1, 0.1, 0.1, 0, 1, 0) then
		local taks2 = TaskLookAtEntity(PlayerPedId(), maquina, 2000, 2048, 2);
		Citizen.Wait(1000)
		while GetIsTaskActive(PlayerPedId(),task2) do Citizen.Wait(1); end
		TaskPlayAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", 4.0, -1000.0, -1, 0x100000, 0.0, 0, 2052, 0);
		FreezeEntityPosition(PlayerPedId(),true)
	end
	while true do
		Citizen.Wait(1)
		
			if (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", 3)) then
				if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1") < 0.52) then
					if (not IsEntityAtCoord(PlayerPedId(), CoordsMaquina, 0.1, 0.1, 0.1, 0, 1, 0)) then
						sub_35e89(1);
					end
				end
				if (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", 3)) then
					if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1") > l_3C) then
						if (DoesEntityExist(l_37)) then
							if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1") > l_3D) then
								if (not IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT2", 3)) then
									TaskPlayAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT2", 4.0, -1000.0, -1, 0x100000, 0.0, 0, 2052, 0);
									TaskClearLookAt(PlayerPedId(), 0, 0);
								end
								if (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", 3)) then
									StopAnimTask(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", -1.5);
								end
							end
						else
							l_37 = CreateObjectNoOffset(GetHashKey(prop), CoordsMaquina, 1, 0, 0);
							AttachEntityToEntity(l_37, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1);
						end
					end
				end
			elseif (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT2", 3)) then
				if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT2") > 0.98) then
					if (not IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT3", 3)) then
						TaskPlayAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT3", 1000.0, -4.0, -1, 0x100030, 0.0, 0, 2048, 0);
						--UltimaFuncion()
						TaskClearLookAt(PlayerPedId(), 0, 0);
						--TriggerEvent("esx_status:add", "thirst", 200000)
					end
					
				end
			elseif (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT3", 3)) then
				if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT3") > l_3B) then
					
					if (RequestAmbientAudioBank("VENDING_MACHINE", 0)) then
						ReleaseAmbientAudioBank();
					end
					HintAmbientAudioBank("VENDING_MACHINE", 0);
					sub_35e89(1);
					break
				end
			end
	end
end

function sub_35e89(a_0) 
    if (DoesEntityExist(l_37)) then
        if (IsEntityAttached(l_37)) then
            DetachEntity(l_37, 1, 1)
            if (a_0) then
                ApplyForceToEntity(l_37, 1, 6.0, 10.0, 2.0, 0.0, 0.0, 0.0, 0, 1, 1, 0, 0, 1)
            end
        end
		FreezeEntityPosition(PlayerPedId(),false)
        SetObjectAsNoLongerNeeded(l_37)
		DeleteObject(l_37)
		l_37 = nil
    end
end

function drawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z + 1)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.4, 0.4)
    SetTextFont(7)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(_x, _y)
end
