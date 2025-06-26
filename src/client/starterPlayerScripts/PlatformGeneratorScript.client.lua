local GameState = require(game.ReplicatedStorage.Shared:WaitForChild("GameState"))
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera 
local CollectionService = game:GetService("CollectionService")

local baseInterval = 5
local intervalMin = 1.5
local lastSpawnTime = 0
local spacingSize = 20
local plaformSize = 250
local screenEdgePadding = 50
local screenEdgeCoordAdjust = 40 -- TODO: we seem to get edges that are not actually edges

local leftEdge = nil
local leftEdgeWithPadding = nil
local rightEdge = nil
local rightEdgeWithPadding = nil
local bottomEdge = nil

local player = game.Players.LocalPlayer

repeat wait() until player.Character and camera
local char = player.Character
local ball = char:WaitForChild("PlayerBall")

local function getWorldPositionAtScreenPoint(screenX, screenY, depth)
	local ray = camera:ViewportPointToRay(screenX, screenY)
	return ray.Origin + ray.Direction.Unit * depth
end

local function spawnPlatforms()
	local screenXForSpacingMiddle = math.random() * (rightEdgeWithPadding - leftEdgeWithPadding) + leftEdgeWithPadding

	local spawnPos = Vector3.new(screenXForSpacingMiddle - spacingSize/2 - plaformSize, bottomEdge, ball.Position.Z)
	local spawnPos2 = Vector3.new(screenXForSpacingMiddle + spacingSize/2, bottomEdge, ball.Position.Z)

	local function spawnPlatform(spawnPos)
		local platform = Instance.new("Part")
		platform.Size = Vector3.new(plaformSize, 5, 10)
		platform.BrickColor = BrickColor.new("Bright green")
		platform.Position = spawnPos
		platform.Anchored = false
		platform.CanCollide = true
		platform.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
		platform.Material = Enum.Material.Concrete
		platform.Name = "PlatformMarker"
		platform.Parent = workspace
		platform.CollisionGroup = "Platforms"
		CollectionService:AddTag(platform, "PlatformMarker")
		print("Spawned a platform to:", spawnPos)
	end
	spawnPlatform(spawnPos)
	spawnPlatform(spawnPos2)

end

local function spawnBottomFloor()
	--TODO: determine bottom floor dynamically
	local viewOffset = Vector3.new(0, -60, -200) 
	local worldPosition = camera.CFrame:PointToWorldSpace(viewOffset)

	local wall = Instance.new("Part")
	wall.Size = Vector3.new(600, 10, 10)
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

local function spawnSideWall(xCoords)
	local viewOffset = Vector3.new(xCoords, bottomEdge, -200) 
	local worldPosition = camera.CFrame:PointToWorldSpace(viewOffset)

	local wall = Instance.new("Part")
	wall.Size = Vector3.new(10, 600, 10)
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
	local bottomY = screenYToWorldY(camera.ViewportSize.Y)

	return leftX, rightX, bottomY
end

leftEdge, rightEdge, bottomEdge = getWorldScreenEdgesAtZ(ball.Position.Z)
leftEdgeWithPadding = leftEdge + screenEdgePadding 
rightEdgeWithPadding = rightEdge - screenEdgePadding
spawnBottomFloor()
spawnSideWall(leftEdge - screenEdgeCoordAdjust)
spawnSideWall(rightEdge + screenEdgeCoordAdjust)

RunService.RenderStepped:Connect(function(dt)
	if not GameState.menuOpen then
		local now = tick()
		local elapsed = now - GameState.totalPauseTime - GameState.startTime
		local newInterval = baseInterval * (0.8 ^ (elapsed / 10))
		if (now - lastSpawnTime >= math.max(newInterval, intervalMin)) then
			lastSpawnTime = now
			spawnPlatforms()
		end
	end
end)