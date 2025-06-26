local UserInputService = game:GetService("UserInputService")
local GameState = require(game.ReplicatedStorage.Shared:WaitForChild("GameState"))

local player = game.Players.LocalPlayer 
local menuActionsFrame = player.PlayerGui:WaitForChild("MainMenu").Frame
local newGameButton = menuActionsFrame:WaitForChild("NewGameButton")
local QuitButton = menuActionsFrame:WaitForChild("QuitButton")
local ReturnGameButton = menuActionsFrame:WaitForChild("ReturnGameButton")

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
