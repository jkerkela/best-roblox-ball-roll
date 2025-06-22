local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera 
local CollectionService = game:GetService("CollectionService")

local interval = 5
local lastSpawnTime = 0
leftEdge = nil
rightEdge = nil
bottomEdge = nil

local player = game.Players.LocalPlayer

repeat wait() until player.Character and camera
local char = player.Character
local ball = char:WaitForChild("PlayerBall")

local function getWorldPositionAtScreenPoint(screenX, screenY, depth)
	local ray = camera:ViewportPointToRay(screenX, screenY)
	return ray.Origin + ray.Direction.Unit * depth
end

--TODO: update to spawn 2 patforms with spacing in between them
local function spawnPlatform()
	local screenX = math.random() * (rightEdge - leftEdge) + leftEdge

	local spawnPos = Vector3.new(screenX, bottomEdge, ball.Position.Z)
	local platform = Instance.new("Part")
	platform.Size = Vector3.new(64, 4, 4)
	platform.BrickColor = BrickColor.new("Bright green")
	platform.Position = spawnPos
	platform.Anchored = false
	platform.CanCollide = true
	platform.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
	platform.Material = Enum.Material.Concrete
	platform.Name = "PlatformMarker"
	platform.Parent = workspace
	CollectionService:AddTag(platform, "PlatformMarker")
end

local function spawnBottomFloor()
	local viewOffset = Vector3.new(0, -70, -100) 
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
spawnBottomFloor()

RunService.RenderStepped:Connect(function(dt)
	local now = tick()
	if (now - lastSpawnTime >= interval) then
		lastSpawnTime = now
		spawnPlatform()
	end
end)