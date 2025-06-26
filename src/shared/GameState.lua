local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local GameState = {
	startTime = 0,
	score = 0,
	started = false,
	menuOpen = true,
	menuOpenedAt = nil,
	totalPauseTime = 0
}

local function startPointsCalculation()
	local speed = 10
	local prefix = "Points: "

	RunService.RenderStepped:Connect(function(dt)
		if GameState.started and not GameState.menuOpen then
			GameState.score += dt * speed
			local label = game.Players.LocalPlayer.PlayerGui.HUDOverlay.Frame.PointsDisplay
			label.Text = prefix .. math.floor(GameState.score)
		end
	end)
end

local function clearSpawnedPlatforms()
	for _, platform in pairs(CollectionService:GetTagged("PlatformMarker")) do
		if platform:IsDescendantOf(workspace) then
			platform:Destroy()
		end
	end
end

function GameState.StartGame(player)
	clearSpawnedPlatforms()
	game.ReplicatedStorage:WaitForChild("ResetCharacter"):FireServer()
	player.CharacterAdded:Wait()
	GameState.startTime = tick()
	GameState.score = 0
	GameState.started = true
	startPointsCalculation()	
end

function GameState.EndGame()
	GameState.started = false
	GameState.score = 0
	print("AT GameState.EndGame")
	game.ReplicatedStorage:WaitForChild("QuitRequest"):FireServer("Player clicked quit")
end

function GameState.ToggleMenu()
	GameState.menuOpen = not GameState.menuOpen
	if GameState.menuOpen then
		GameState.menuOpenedAt = tick()
	else
		if GameState.menuOpenedAt then
			GameState.totalPauseTime += tick() - GameState.menuOpenedAt
			GameState.menuOpenedAt = nil
		end
	end
end

return GameState