local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local GameState = {
	startTime = 0,
	score = 0,
	started = false,
	menuOpen = true,
	menuOpenedAt = nil,
	totalPauseTime = 0,
	lastPauseTime = 0,
	gameServerReady = false
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
	GameState.CloseMenu(player)
	GameState.startTime = tick()
	GameState.score = 0
	GameState.totalPauseTime = 0
	GameState.started = true
	startPointsCalculation()	
end

function GameState.PauseGame(player)
	GameState.OpenMenu(player)
end

function GameState.EndGame(player)
	GameState.started = false
	local gameInfo = game.Players.LocalPlayer.PlayerGui.MainMenu.Frame.GameInfo
	local score = math.floor(GameState.score)
	gameInfo.Text = "Game over! Final score: " .. score
	game.ReplicatedStorage:WaitForChild("PublishScore"):FireServer(score)
	GameState.OpenMenu(player)
end

function GameState.QuitGame()
	GameState.started = false
	GameState.totalPauseTime = 0
	game.ReplicatedStorage:WaitForChild("QuitRequest"):FireServer("Player clicked quit")
end

function GameState.OpenMenu(player)
	if not GameState.menuOpen then
		GameState.menuOpen = true
		if GameState.started then
			GameState.menuOpenedAt = tick()
		end
		player.PlayerGui.MainMenu.Enabled = true
		player.PlayerGui.HUDOverlay.Frame.MenuButton.Visible = false
		if GameState.started then 
			player.PlayerGui.MainMenu.Frame.ReturnGameButton.Visible = true
			local gameInfo = game.Players.LocalPlayer.PlayerGui.MainMenu.Frame.GameInfo
			gameInfo.Text = "Game paused, continue game by clicking \"Return game\""
		else
			player.PlayerGui.MainMenu.Frame.ReturnGameButton.Visible = false
		end
	end
end

function GameState.CloseMenu(player)
	if GameState.menuOpen then
		GameState.menuOpen = false
		if GameState.started and GameState.menuOpenedAt then
			GameState.lastPauseTime = tick() - GameState.menuOpenedAt
			GameState.totalPauseTime += GameState.lastPauseTime
		end
		player.PlayerGui.MainMenu.Enabled = false
		player.PlayerGui.HUDOverlay.Frame.MenuButton.Visible = true
	end
end

function GameState.OpenLeaderboard(player)
	player.PlayerGui.MainMenu.LeaderboardFrame.Visible = true
	player.PlayerGui.MainMenu.Frame.Visible = false
end

function GameState.CloseLeaderboard(player)
	player.PlayerGui.MainMenu.Frame.Visible = true
	player.PlayerGui.MainMenu.LeaderboardFrame.Visible = false
end

return GameState
