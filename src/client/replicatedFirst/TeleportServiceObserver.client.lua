local TeleportService = game:GetService("TeleportService")
local gameServerReady = false
--NOTE: it is importeant that localPlayerArrivedFromTeleport is connected before the gameServerReady variable is set to true,
-- because of the timing of the teleportservice data
TeleportService.LocalPlayerArrivedFromTeleport:Connect(function()
	gameServerReady = true
end)

local replicatedStorage = game:GetService("ReplicatedStorage")
local sharedFolder = replicatedStorage:WaitForChild("Shared", 5)

if not sharedFolder then
	error("Shared folder not found in time")
	return
end
local GameState = require(sharedFolder:WaitForChild("GameState", 5))
if not GameState then
	error("Game state not found in time")
	return
else
	GameState.gameServerReady = gameServerReady
end

