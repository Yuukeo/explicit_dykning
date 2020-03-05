sendNotification = function(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "kok",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

Draw3DText = function(x, y, z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

  local scale = (1/dist)*1
  local fov = (1/GetGameplayCamFov())*100
  local scale = 1.9
  local factor = (string.len(text)) / 350
 
  if onScreen then
      SetTextScale(0.0*scale, 0.18*scale)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
      DrawRect(_x,_y+0.0115, 0.01+ factor, 0.025, 25, 25, 25, 185)
  
  end
end

playAnim = function(animDict, animName, duration)
	RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
    TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8.0, duration, 0, 0, false, false, false)
	RemoveAnimDict(animDict)
end