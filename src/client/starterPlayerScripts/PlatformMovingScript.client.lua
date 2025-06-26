local GameState = require(game.ReplicatedStorage.Shared:WaitForChild("GameState"))
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local baseSpeed = 15
local speedMax = 80

RunService.RenderStepped:Connect(function(dt)
	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == "PlatformMarker" then
			if not GameState.menuOpen then
				obj.Anchored = false
				local elapsed  = tick() - GameState.totalPauseTime - GameState.startTime
				-- TODO: replace exponential speed up with e.g. logarithmic and don't use cap
				local speed = baseSpeed * (1.20 ^ (elapsed / 10))
				obj.Velocity = Vector3.new(0, math.min(speed, speedMax), 0)
			else 
				obj.Anchored = true
			end
		end
	end
end)