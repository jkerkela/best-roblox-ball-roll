-- @ScriptType: LocalScript
local GameState = require(game.ReplicatedStorage.Shared:WaitForChild("GameState"))
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local leftValue, rightValue = 0, 0

local ball = nil
player.CharacterAdded:Connect(function(char)
	ball = char:WaitForChild("PlayerBall")
end)

local moveSpeed = 60

local function onLeft(actionName, inputState)
	if inputState == Enum.UserInputState.Begin then	
		leftValue = 1
	elseif inputState == Enum.UserInputState.End then
		leftValue = 0
	end
end

local function onRight(actionName, inputState)
	if inputState == Enum.UserInputState.Begin then
		rightValue = 1
	elseif inputState == Enum.UserInputState.End then
		rightValue = 0
	end
end

local function onUpdate()
	if not GameState.menuOpen and ball then
		ball.Anchored = false
		local moveDirection = rightValue - leftValue
		local velocity = ball.AssemblyLinearVelocity
		ball.AssemblyLinearVelocity = Vector3.new(moveDirection * moveSpeed, velocity.Y, 0)
	elseif ball then
		ball.Anchored = true
	end
end

RunService:BindToRenderStep("Control", Enum.RenderPriority.Input.Value, onUpdate)
ContextActionService:BindAction("Left", onLeft, true, "a", Enum.KeyCode.Left, Enum.KeyCode.DPadLeft)
ContextActionService:BindAction("Right", onRight, true, "d", Enum.KeyCode.Right, Enum.KeyCode.DPadRight)