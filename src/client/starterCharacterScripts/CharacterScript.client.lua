local char = script.Parent

-- Clean up "default" char parts, this can done by removing original models from assets(?)
for _, item in ipairs(char:GetChildren()) do
	if item:IsA("BasePart") or item:IsA("Accessory") then
		item:Destroy()
	elseif item:IsA("Humanoid") then
		item:Destroy()
	end
end

local ball = Instance.new("Part")
ball.Name = "PlayerBall"
ball.Shape = Enum.PartType.Ball
ball.Size = Vector3.new(4,4,4)
--TODO: get middle of the screen dynamically
ball.Position = Vector3.new(0, 113, 0)
ball.Anchored = false
ball.CanCollide = true
ball.BrickColor = BrickColor.new("Really black")
ball.Material = Enum.Material.SmoothPlastic
ball.Parent = char
ball.CollisionGroup = "Player"


