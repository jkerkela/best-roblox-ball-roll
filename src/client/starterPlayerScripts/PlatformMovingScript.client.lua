local GameState = require(game.ReplicatedStorage.Shared:WaitForChild("GameState"))
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local baseSpeed = 20
local speedMax = 80
local speedIncreaseMultiplier = 1.20

RunService.RenderStepped:Connect(function(dt)
	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == "PlatformMarker" then
			if not GameState.menuOpen then
				obj.Anchored = false
				local elapsed  = tick() - GameState.totalPauseTime - GameState.startTime
				local speed = baseSpeed * (speedIncreaseMultiplier ^ (elapsed / 10))
				obj.Velocity = Vector3.new(0, math.min(speed, speedMax), 0)
			else 
				obj.Anchored = true
			end
		end
	end
end)