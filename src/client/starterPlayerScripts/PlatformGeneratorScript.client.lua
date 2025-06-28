local GameState = require(game.ReplicatedStorage.Shared:WaitForChild("GameState"))
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera 
local CollectionService = game:GetService("CollectionService")

local baseInterval = 1
local lastSpawnTime = 0
local spacingSize = 20
local plaformSize = 200
local screenEdgePadding = 90
local screenEdgeCoordAdjust = 30 -- TODO: in roblox studio, we seem to get edges that are not actually edges

local leftEdge = nil
local leftEdgeWithPadding = nil
local rightEdge = nil
local rightEdgeWithPadding = nil
local bottomEdge = nil
local topEdge = nil
local adjustPlatformSpawn = false
local spawnTimeAdjust = 0

local player = game.Players.LocalPlayer

repeat wait() until player.Character and camera
local char = player.Character
local ball = char:WaitForChild("PlayerBall")

local function getWorldPositionAtScreenPoint(screenX, screenY, depth)
	local ray = camera:ViewportPointToRay(screenX, screenY)
	return ray.Origin + ray.Direction.Unit * depth
end

local function spawnPlatforms()
	local screenXForSpacingMiddle = math.random(spacingSize, 180)

	local spawnPos = Vector3.new(screenXForSpacingMiddle - spacingSize/2 - plaformSize, bottomEdge, ball.Position.Z)
	local spawnPos2 = Vector3.new(screenXForSpacingMiddle + spacingSize/2, bottomEdge, ball.Position.Z)
	local function spawnPlatform(spawnPos)
		local platform = Instance.new("Part")
		platform.Size = Vector3.new(plaformSize, 5, 10)
		platform.BrickColor = BrickColor.new("Bright green")
		platform.Position = spawnPos
		platform.Anchored = false
		platform.CanCollide = true
		platform.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.1)
		platform.Material = Enum.Material.Ground
		platform.Name = "PlatformMarker"
		platform.Parent = workspace
		platform.CollisionGroup = "Platforms"
		CollectionService:AddTag(platform, "AutoClean")
	end
	spawnPlatform(spawnPos)
	spawnPlatform(spawnPos2)

end

local function spawnBottomFloor()
	local worldPosition = Vector3.new(0, bottomEdge, ball.Position.Z)

	local wall = Instance.new("Part")
	wall.Size = Vector3.new(600, 1, 10)
	wall.Position = worldPosition
	wall.Anchored = true
	wall.CanCollide = true
	wall.BrickColor = BrickColor.new("Bright red") 
	wall.Material = Enum.Material.Neon
	wall.Transparency = 1 -- make visible if needed for debug
	wall.Name = "ScreenBottomWall"
	wall.Parent = workspace
	wall.CollisionGroup = "Platforms"
end

local function spawnCeiling()
	local worldPosition = Vector3.new(0, topEdge, ball.Position.Z)

	local wall = Instance.new("Part")
	wall.Size = Vector3.new(600, 1, 10)
	wall.Position = worldPosition
	wall.Anchored = true
	wall.CanCollide = true
	wall.BrickColor = BrickColor.new("Bright red") 
	wall.Material = Enum.Material.Neon
	wall.Transparency = 1 -- make visible if needed for debug
	wall.Name = "ScreenCeiling"
	wall.Parent = workspace
	wall.CollisionGroup = "Platforms"
	
	wall.Touched:Connect(function(otherPart)
		if otherPart.Name == "PlayerBall" then
			GameState.EndGame(player)
		end
	end)
end

local function spawnSideWall(xCoords)
	local worldPosition = Vector3.new(xCoords, bottomEdge, ball.Position.Z) 

	local wall = Instance.new("Part")
	wall.Size = Vector3.new(1, 600, 10)
	wall.Position = worldPosition
	wall.Anchored = true
	wall.CanCollide = true
	wall.BrickColor = BrickColor.new("Bright red") 
	wall.Material = Enum.Material.Neon
	wall.Transparency = 1 -- make visible if needed for debug
	wall.Name = "ScreenSideWall"
	wall.Parent = workspace
	wall.CollisionGroup = "Platforms"
end

while camera.CFrame.Position.Magnitude < 1 do
	RunService.RenderStepped:Wait()
end
for i = 1, 3 do
	RunService.RenderStepped:Wait()
end
local function getWorldScreenEdgesAtZ(depthZ)
	local function screenXToWorldX(screenX)
		local screenY = camera.ViewportSize.Y / 2
		local ray = camera:ViewportPointToRay(screenX, screenY)
		local t = (depthZ - ray.Origin.Z) / ray.Direction.Z
		local worldPos = ray.Origin + ray.Direction * t
		return worldPos.X
	end
	local function screenYToWorldY(screenY)
		local screenX = camera.ViewportSize.X
		local ray = camera:ViewportPointToRay(screenX, screenY)
		local t = (depthZ - ray.Origin.Z) / ray.Direction.Z
		local worldPos = ray.Origin + ray.Direction * t
		return worldPos.Y
	end

	local leftX = screenXToWorldX(0)
	local rightX = screenXToWorldX(camera.ViewportSize.X)
	local topY = screenYToWorldY(0)
	local bottomY = screenYToWorldY(camera.ViewportSize.Y)

	return leftX, rightX, bottomY, topY
end

leftEdge, rightEdge, bottomEdge, topEdge = getWorldScreenEdgesAtZ(ball.Position.Z)
leftEdgeWithPadding = leftEdge + screenEdgePadding 
rightEdgeWithPadding = rightEdge - screenEdgePadding
spawnBottomFloor()
spawnCeiling()
spawnSideWall(leftEdge)
spawnSideWall(rightEdge)

RunService.RenderStepped:Connect(function(dt)
	if not GameState.menuOpen then
		local now = tick()
		if adjustPlatformSpawn and spawnTimeAdjust == 0 then
			spawnTimeAdjust = GameState.lastPauseTime
		end
		if ((now - lastSpawnTime) >= (baseInterval + spawnTimeAdjust)) then
			adjustPlatformSpawn = false
			spawnTimeAdjust = 0
			lastSpawnTime = now
			spawnPlatforms()
		end
	else
		adjustPlatformSpawn = true
	end
end)

player.CharacterAdded:Connect(function()
	for _, part in ipairs(CollectionService:GetTagged("AutoClean")) do
		part:Destroy()
	end
end)