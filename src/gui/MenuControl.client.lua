local UserInputService = game:GetService("UserInputService")
local GameState = require(game.ReplicatedStorage.Shared:WaitForChild("GameState"))

local player = game.Players.LocalPlayer 
local menuActionsFrame = player.PlayerGui:WaitForChild("MainMenu").Frame
local newGameButton = menuActionsFrame:WaitForChild("NewGameButton")
local QuitButton = menuActionsFrame:WaitForChild("QuitButton")
local ReturnGameButton = menuActionsFrame:WaitForChild("ReturnGameButton")
local BackgroundFrameFrame = player.PlayerGui:WaitForChild("MainMenu").BackgroundFrame
local LeaderboardButton = BackgroundFrameFrame:WaitForChild("LeaderboardButton")

local ServerTransferFrame = player.PlayerGui:WaitForChild("MainMenu").ServerTransferFrame

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getLeaderboardData = ReplicatedStorage:WaitForChild("GetLeaderboardData")

local leaderboardFrame = player.PlayerGui:WaitForChild("MainMenu").LeaderboardFrame
local mainMenuButton = leaderboardFrame:WaitForChild("MainMenuButton")


if GameState.gameServerReady then
	ServerTransferFrame.Visible = false
	menuActionsFrame.Visible = true
else
	ServerTransferFrame.Visible = true
	menuActionsFrame.Visible = false
end


local function updateLeaderboard()
	local data = getLeaderboardData:InvokeServer()
	print("at updateLeaderboard after getLeaderboardData")
	for i = 1, 10 do
		local rankFrame = leaderboardFrame:FindFirstChild("RankFrame" .. i)
		if rankFrame then
			local nameLabel = rankFrame:FindFirstChild("PlayerName")
			local scoreLabel = rankFrame:FindFirstChild("PlayerScore")
			local entry = data[i]

			if entry then
				if nameLabel then nameLabel.Text = entry.Name end
				if scoreLabel then scoreLabel.Text = tostring(entry.Score) end
				rankFrame.Visible = true
			else
				if nameLabel then nameLabel.Text = "" end
				if scoreLabel then scoreLabel.Text = "" end
				rankFrame.Visible = false
			end
		end
	end
end

LeaderboardButton.MouseButton1Click:Connect(function()
	print("at LeaderboardButton.MouseButton1Click")
	updateLeaderboard()
	GameState.OpenLeaderboard(player)
end)

newGameButton.MouseButton1Click:Connect(function()
	GameState.StartGame(player)
end)

ReturnGameButton.MouseButton1Click:Connect(function()
	if GameState.started then
		GameState.CloseMenu(player)
	end
end)

QuitButton.MouseButton1Click:Connect(function()
	GameState.QuitGame(player)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
		GameState.PauseGame(player)
	end
end)

mainMenuButton.MouseButton1Click:Connect(function()
	GameState.CloseLeaderboard(player)
end)
