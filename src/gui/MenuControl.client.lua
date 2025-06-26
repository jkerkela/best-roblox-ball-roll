local UserInputService = game:GetService("UserInputService")
local GameState = require(game.ReplicatedStorage.Shared:WaitForChild("GameState"))
GameState.menuOpen = true

local player = game.Players.LocalPlayer 
local mainMenu = script.Parent
local menuActionsFrame = player.PlayerGui:WaitForChild("MainMenu").Frame
local menuBackGroundFrame = player.PlayerGui:WaitForChild("MainMenu").BackgroundFrame
local newGameButton = menuActionsFrame:WaitForChild("NewGameButton")
local QuitButton = menuActionsFrame:WaitForChild("QuitButton")
local ReturnGameButton = menuActionsFrame:WaitForChild("ReturnGameButton")

newGameButton.MouseButton1Click:Connect(function()
	GameState.StartGame(player)
	GameState.ToggleMenu()
	mainMenu.Enabled = false
	player.PlayerGui.HUDOverlay.Frame.MenuButton.Visible = true
end)

ReturnGameButton.MouseButton1Click:Connect(function()
	if GameState.started then
		GameState.ToggleMenu()
		mainMenu.Enabled = false
		player.PlayerGui.HUDOverlay.Frame.MenuButton.Visible = true
	end
end)

QuitButton.MouseButton1Click:Connect(function()
	GameState.EndGame()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.Space and not gameProcessed and not mainMenu.Enabled then
		GameState.ToggleMenu()
		mainMenu.Enabled = true
		player.PlayerGui.HUDOverlay.Frame.MenuButton.Visible = false
	end
end)
