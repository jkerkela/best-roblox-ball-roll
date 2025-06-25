local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local speed = 5 -- TODO add difficulty increase over time

RunService.RenderStepped:Connect(function(dt)
	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == "PlatformMarker" then
			obj.Velocity = Vector3.new(0, speed, 0)
		end
	end
end)