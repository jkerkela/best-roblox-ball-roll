local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local PLACE_ID = game.PlaceId

if game.PrivateServerId == "" then
	Players.PlayerAdded:Connect(function(player)
		local code = TeleportService:ReserveServer(PLACE_ID)
		TeleportService:TeleportToPrivateServer(PLACE_ID, code, {player})
	end)
end

