local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local scoreStore = DataStoreService:GetOrderedDataStore("GlobalScores")
local getLeaderboard = ReplicatedStorage:WaitForChild("GetLeaderboardData")
local publishScoreEvent = ReplicatedStorage:WaitForChild("PublishScore")

local function publishScore(player, newScore)
	print("At publishScore: ", player, newScore)
	local currentScore = 0
	pcall(function()
		currentScore = scoreStore:GetAsync(player.UserId) or 0
	end)

	if newScore > currentScore then
		pcall(function()
			scoreStore:SetAsync(player.UserId, newScore)
		end)
	end
end

getLeaderboard.OnServerInvoke = function()
	local success, pages = pcall(function()
		return scoreStore:GetSortedAsync(false, 10)
	end)

	if not success then
		warn("Failed to retrieve leaderboard data")
		return {}
	end

	local data = {}
	for i, entry in ipairs(pages:GetCurrentPage()) do
		local name = "[Unknown]"
		pcall(function()
			name = Players:GetNameFromUserIdAsync(entry.key)
		end)
		table.insert(data, {
			Name = name,
			Score = entry.value
		})
	end

	return data
end

publishScoreEvent.OnServerEvent:Connect(function(player, score)
	publishScore(player, score)
end)