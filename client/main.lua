ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)
--------------------------------------------------------------------------------
-- NE RIEN MODIFIER
local CurrentDelivery 		  = false -- Le joeur en livraison ?
local DeliveryPoint			  = nil
local Blips 		  		  = {}
local district 		  		  = {}
local progress 		  		  = 1
local colis 		  	  	  = 0
local lettre 		  		  = 0
local isInService 			  = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
--------------------------------------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function IsJobTrucker() -- Check si le joueur est bien du métier
	if PlayerData ~= nil then
		local isJobTrucker = false
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'gopostal' then
			isJobTrucker = true
		end
		return isJobTrucker
	end
end

function Draw3DText(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = 0.5
   
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(1, 1, 0, 0, 255)
        SetTextEdge(0, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(2)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									CLOAKROOM	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function setUniform(playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms.male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		else
			if Config.Uniforms.female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		end
	end)
end

function cloakroom()
	if isInService then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local model = nil

			if skin.sex == 0 then
				model = GetHashKey("mp_m_freemode_01")
			else
				model = GetHashKey("mp_f_freemode_01")
			end

			RequestModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(1)
			end

			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)

			TriggerEvent('skinchanger:loadSkin', skin)
			TriggerEvent('esx:restoreLoadout')
    	end)
		isInService = false
	else
	    setUniform(PlayerPedId())
	    isInService = true
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									VEHICLE	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function VehiculeSpawner()
	local elements = {}
	local len = 0
	for i=1, #Config.Vehicle, 1 do len = len + 1 end

	local plate = Config.JobVehiclePlate


	if len > 1 then

		for i=1, #Config.Vehicle, 1 do
			table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Vehicle[i])), value = Config.Vehicle[i]})
		end


		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehiclespawner',
			{
				title    = _U('vehiclespawner'),
				elements = elements
			},
			function(data, menu)
				ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
					
					SetVehicleNumberPlateText(vehicle, plate)             	
					TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   
				end)

				menu.close()
			end,
			function(data, menu)
				menu.close()
			end
		)
	else
		ESX.Game.SpawnVehicle(Config.Vehicle[1], Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
			SetVehicleNumberPlateText(vehicle, plate)             			
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   
		end)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									Distribution	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function MenuDistribution()
	local elements = {
		-- Courrier
		{label      = _U('letter'),
		item       = 'letter',

		-- menu properties
		value      = 1,
		type       = 'slider',
		min        = 1,
		max        = 100},

		--Colis
		{label      = _U('colis'),
		item       = 'colis',

		-- menu properties
		value      = 1,
		type       = 'slider',
		min        = 1,
		max        = 100}
	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'distribution', {
		title    = _U('distribution'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'distribution_choice', {
			title    = 'x'.. data.current.value .. ' ' .. data.current.label,
			align    = 'top-left',
			elements = {
				{label = _U('pick'),  value = 'pick'},
				{label = _U('deposit'), value = 'deposit'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'pick' then
				TriggerServerEvent('gopostal_job:Item', data.current.item, data.current.value, data.current.label, 'pick')
			elseif data2.current.value == 'deposit' then
				TriggerServerEvent('gopostal_job:Item', data.current.item, data.current.value, data.current.label, 'deposit')
			end

			menu2.close()
		end, function(data2, menu2)
			menu2.close()
		end)

		
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'distribution'
		CurrentActionMsg  = _U('open_distribution')
		CurrentActionData = {}
	end)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									ZONE
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

AddEventHandler('gopostal_job:hasEnteredMarker', function(zone)

	local playerPed = GetPlayerPed(-1)

	if zone == 'CloakRoom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('open_cloakroom')
		CurrentActionData = {}
	end

	if zone == 'VehicleSpawner' and isInService then
		CurrentAction     = 'vehiclespawner'
		CurrentActionMsg  = _U('sort_vehicle')
		CurrentActionData = {}
	end

	if zone == 'VehicleDeleter' and isInService then
		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
			
		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle, distance = ESX.Game.GetClosestVehicle({
				x = coords.x,
				y = coords.y,
				z = coords.z
			})
			
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

			CurrentAction     = 'vehicledeleter'
			CurrentActionMsg  = _U('return_vehicle')
			CurrentActionData = {vehicle = vehicle}
					
		end

	end

	if zone == 'Distribution' and isInService then
		CurrentAction     = 'distribution'
		CurrentActionMsg  = _U('open_distribution')
		CurrentActionData = {}
	end

end)

AddEventHandler('gopostal_job:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									KEY CONTROLS
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

        if CurrentAction ~= nil then

        	SetTextComponentFormat('STRING')
        	AddTextComponentString(CurrentActionMsg)
       		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustReleased(0, 38) and IsJobTrucker() then -- Touche E
            	
            	if CurrentAction == 'cloakroom' then
            		cloakroom()
                end

                if CurrentAction == 'vehiclespawner' then
                	VehiculeSpawner()
                end

                if CurrentAction == 'distribution' then
                	MenuDistribution()
                end

                if CurrentAction == 'vehicledeleter' then
                	ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
                end


                CurrentAction = nil
            end
        end

        if IsControlJustReleased(0, 167) and IsJobTrucker() and isInService then -- Touche F6 si il est bien dans le job & en service
        	Livraison()
        end

    end
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									MARKERS & BLIP
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do
			if k == 'CloakRoom' and (IsJobTrucker() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			elseif isInService and (IsJobTrucker() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		if IsJobTrucker() then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('gopostal_job:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('gopostal_job:hasExitedMarker', lastZone)
			end

		end

	end
end)

-- CREATE BLIPS
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.CloakRoom.Pos.x, Config.Zones.CloakRoom.Pos.y, Config.Zones.CloakRoom.Pos.z)
  
	SetBlipSprite (blip, 357)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.2)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_job'))
	EndTextCommandSetBlipName(blip)
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									LIVRAISON
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function Livraison()

	District = SelectDistrict()

	if CurrentDelivery then
		LivraisonStop(district, true)
		CurrentDelivery = false
		
	else
		CurrentDelivery = true
		ESX.ShowAdvancedNotification(_U('notif_title_delivery'), '', _U('notif_district', district.label), 'CHAR_BRYONY', 1 )
		ESX.ShowAdvancedNotification(_U('notif_title_delivery'), '', _U('create_itinary'), 'CHAR_ANDREAS', 1 )
		LivraisonStart(district)
	end
end

function SelectDistrict() -- Selection du quartier pour la ronde

	for k,v in pairs (Config.Livraisons) do
		local DistrictLong = 0
		for i=1, #Config.Livraisons[k].Pos, 1 do 
			DistrictLong = DistrictLong + 1 
		end

		table.insert(district, {label = _U(k), value = k, long = DistrictLong} )
	end
	district = district[ math.random( #district ) ]
	return district;
end

function LivraisonStart(district)
	if CurrentDelivery then
		DeliveryPoint = district.value 
		local zone = Config.Livraisons[district.value]

		Blips['DeliveryPoint'] = AddBlipForCoord(zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z)
		SetBlipRoute(Blips['DeliveryPoint'], true)
		LetterAndColis()
		ESX.ShowNotification(_U('join_next'))
	end
end

function LivraisonStop(district, cancel)
	if Blips['DeliveryPoint'] ~= nil then
	    RemoveBlip(Blips['DeliveryPoint'])
	    Blips['DeliveryPoint'] = nil
	end

	if cancel then
		ESX.ShowNotification(_U('cancel_delivery'))
		CurrentDelivery = false
	else
		if progress < district.long then
			progress = progress + 1
			LivraisonStart(district)
		else
			CurrentDelivery = false
			progress = 1
			ESX.ShowAdvancedNotification(_U('notif_title_delivery'), '', _U('finish_delivery'), 'CHAR_BRYONY', 1 )
		end
	end
end


function LetterAndColis()

	local zone = Config.Livraisons[district.value]

	if zone.Pos[progress].letter then
		lettre = GetRandomIntInRange(Config.MinLetter, Config.MaxLetter)
	else
		lettre = 0
	end

	if zone.Pos[progress].colis then
		colis = GetRandomIntInRange(Config.MinColis, Config.MaxColis)
	else
		colis = 0
	end
	
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

	    if DeliveryPoint ~= nil then
	    	if CurrentDelivery then
		    	local coords = GetEntityCoords(GetPlayerPed(-1))
		      	local zone = Config.Livraisons[district.value]

		      	if GetDistanceBetweenCoords(coords, zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z, true) < 100.0 then
		      		DrawMarker(zone.Type, zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, zone.Size.x, zone.Size.y, zone.Size.z, zone.Color.r, zone.Color.g, zone.Color.b, 100, false, true, 2, false, false, false, false)
		      		Draw3DText(zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z + 1.5 , '📩 ~r~'.. _U('letter') .. ': ' .. lettre .. '\n📦 ~r~'.. _U('colis') .. ': ' .. colis)
		      		if GetDistanceBetweenCoords(coords, zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z, true) < 3.0 then
			        	HelpPromt(_U('pickup'))
			        	if IsControlJustReleased(0, 38) and IsJobTrucker() then
			        		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			          			ESX.TriggerServerCallback('gopostal_job:haveItem', function(haveItem)
			          				if haveItem then
			          					TriggerServerEvent('gopostal_job:end', lettre, colis)
			          					LivraisonStop(district, false)
			          				end

			          			end, lettre, colis)

			          			
			          		else
			          			ESX.ShowNotification(_U('must_be_walking'))
			          		end
			        	end
			        end
		      	end
		    end
	    end
	end
end)

function HelpPromt(text)
	Citizen.CreateThread(function()
    	SetTextComponentFormat('STRING')
        AddTextComponentString(text)
       	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  	end)
end
