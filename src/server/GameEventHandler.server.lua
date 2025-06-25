local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local resetEvent = ReplicatedStorage:WaitForChild("ResetCharacter")
local quitEvent = ReplicatedStorage:WaitForChild("QuitRequest")

resetEvent.OnServerEvent:Connect(function(player)
	if player and player:IsA("Player") then
		player:LoadCharacter()
	end
end)

quitEvent.OnServerEvent:Connect(function(player, reason)
	player:Kick(reason)
end)