ESX                           = nil
local PlayerData              = {}

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

-- Dyknings platser -- 

local locations = {
  { x = -1603.34, y = 5193.39, z = 4.31},
  { x = 3520.95, y = 3705.73, z = 20.99},
  { x = 1301.85, y = 4226.72, z = 33.91},
  { x = -3424.92, y = 957.35, z = 8.35},
  { x = -1845.22, y = -1195.98, z = 19.18},
  { x = -95.37, y = -2767.93, z = 6.08},
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(GetPlayerPed(-1))

    for k, v in pairs(locations) do
      if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
        DrawMarker(6, v.x, v.y, v.z-0.95, 0, 0, 0.1, 0, 0, 0, 1.5, 1.5, 1.5, 0, 205, 100, 200, 0, 0, 0, 0)
        Draw3DText(v.x, v.y, v.z+0.17, 'Tryck ~g~E~w~ för att byta om till ~b~dykarkläder')
				  if IsControlPressed(0, 38) then
           OpenMenu()
				end
			end
		end
	end
end)

function OpenMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'dykning',
    {
      title    = 'Välj Alternativ',
      align    = 'center',
      elements = {
    {label = 'Byt om till dykar kläder', value = 'dykning'},
    {label = 'Byt om till civil kläder', value = 'civil'},
      },
    },
    function(data, menu)
    
      if data.current.value == 'civil' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          playAnim('oddjobs@basejump@ig_15', 'puton_parachute', 2500)
          Citizen.Wait(3000)
          TriggerEvent('skinchanger:loadSkin', skin)
          menu.close()
          SetPedMaxTimeUnderwater(GetPlayerPed(-1), 16.00)
          sendNotification('Du bytte om hoppas din dyktur var rolig och du är välkommen tilbaka när du vill', 'error', 4000)
        end)
      end
      
      if data.current.value == 'dykning' then
          TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.sex == 0 then
              playAnim('oddjobs@basejump@ig_15', 'puton_parachute', 2500)
              Citizen.Wait(3000)
              TriggerEvent('skinchanger:loadClothes', skin, Config.DykWear.male)
              menu.close()
              SetEnableScuba(GetPlayerPed(-1),true)
              SetPedMaxTimeUnderwater(GetPlayerPed(-1), 2000.00)
              sendNotification('Du bytte om ha en trevlig dyktur men var försiktig och kom ihåg att alla skador sker på egen risk', 'error', 4000)
            else
              playAnim('oddjobs@basejump@ig_15', 'puton_parachute', 2500)
              Citizen.Wait(3000)
              TriggerEvent('skinchanger:loadClothes', skin, Config.DykWear.female)
              menu.close()
              SetEnableScuba(GetPlayerPed(-1),true)
              SetPedMaxTimeUnderwater(GetPlayerPed(-1), 1950.00)
              sendNotification('Du bytte om ha en trevlig dyktur men var försiktig och kom ihåg att alla skador sker på egen risk', 'error', 4000)
            end
          end)
        end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

RegisterNetEvent('explicit_dykning:kit')
AddEventHandler('explicit_dykning:kit', function(source)
  TriggerEvent('skinchanger:getSkin', function(skin)
    if skin.sex == 0 then
      playAnim('missheistdockssetup1hardhat@', 'put_on_hat', 2500)
      Citizen.Wait(500)
      TriggerEvent('skinchanger:loadClothes', skin, Config.ItemWear.male)
      SetPedMaxTimeUnderwater(GetPlayerPed(-1), 500.00)
    else
      playAnim('missheistdockssetup1hardhat@', 'put_on_hat', 2500)
      Citizen.Wait(500)
      TriggerEvent('skinchanger:loadClothes', skin, Config.ItemWear.female)
      SetPedMaxTimeUnderwater(GetPlayerPed(-1), 470.00)
    end
  end)
end)

Citizen.CreateThread(function()
	if Config.EnableBlips then
		for k, v in pairs(locations) do
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite(blip, 382)
			SetBlipScale(blip, 0.8)
			SetBlipColour(blip, 38)
			SetBlipDisplay(blip, 4)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Dykningsplats")
			EndTextCommandSetBlipName(blip)
		end
	end
end)
