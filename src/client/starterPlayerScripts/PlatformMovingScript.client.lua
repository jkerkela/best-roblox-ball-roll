local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local baseSpeed = 5
local speedMax = 20
local startTime = tick()

RunService.RenderStepped:Connect(function(dt)
	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == "PlatformMarker" then
			local elapsed  = tick() - startTime
			-- TODO: replace exponential speed up with e.g. logarithmic and don't use ca
			local speed = baseSpeed * (1.20 ^ (elapsed / 10))
			obj.Velocity = Vector3.new(0, math.min(speed, speedMax), 0)
		end
	end
end)