local GameState = require(game.ReplicatedStorage.Shared:WaitForChild("GameState"))
local player = game.Players.LocalPlayer 

local hudFrame = player.PlayerGui:WaitForChild("HUDOverlay").Frame
local menuButton = hudFrame:WaitForChild("MenuButton")

menuButton.MouseButton1Click:Connect(function()
	if not GameState.menuOpen then
		GameState.PauseGame(player)
	end
end)