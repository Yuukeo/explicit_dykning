ESX               = nil 


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('dyk', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local dyk = xPlayer.getInventoryItem('dyk')
	
		if dyk.count > 0 then
			xPlayer.removeInventoryItem('dyk', 1)
			TriggerClientEvent('explicit_dykning:kit', source)
			sendNotifications(source, 'Du använde ett Dyknings Kit')
		end
end)

sendNotifications = function(xSource, message, messageType, messageTimeout)
    TriggerClientEvent("pNotify:SendNotification", xSource, {
        text = message,
        type = messageType,
        queue = "lök",
        timeout = messageTimeout,
        layout = "bottomCenter"
    })
end