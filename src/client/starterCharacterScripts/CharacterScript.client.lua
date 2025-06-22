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
ball.Position = char:GetPivot().Position + Vector3.new(0, 10, 0)
ball.Anchored = false
ball.CanCollide = true
ball.BrickColor = BrickColor.new("Really black")
ball.Material = Enum.Material.SmoothPlastic

ball.Parent = char

