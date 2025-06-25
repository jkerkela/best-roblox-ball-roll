local CollectionService = game:GetService("CollectionService")

local GameState = {
	startTime = 0,
	score = 0,
	started = false,
	menuOpen = true,
	menuOpenedAt = nil,
	totalPauseTime = 0
}

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
end

function GameState.EndGame()
	GameState.started = false
	GameState.score = 0
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