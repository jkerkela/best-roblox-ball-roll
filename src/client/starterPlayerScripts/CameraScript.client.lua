local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Scriptable

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local ball = char:WaitForChild("PlayerBall")

local ballPos = ball.Position
local camPos = ballPos + Vector3.new(0, 0, 100)
local lookDir = Vector3.new(0, 0, -1)

camera.CFrame = CFrame.new(camPos, camPos + lookDir)
