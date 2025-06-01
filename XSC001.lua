-- UI SETUP
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.5, -125, 0.5, -175) -- Pusatkan frame
frame.Size = UDim2.new(0, 250, 0, 350)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = true -- Tampilkan frame saat skrip berjalan

-- Fungsi untuk membuat label
local function createLabel(text, y)
    local label = Instance.new("TextLabel", frame)
    label.Position = UDim2.new(0, 10, 0, y)
    label.Size = UDim2.new(0, 230, 0, 20)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

-- Fungsi untuk membuat tombol input
local function createInputButton(default, y, callback)
    local button = Instance.new("TextButton", frame)
    button.Position = UDim2.new(0, 10, 0, y)
    button.Size = UDim2.new(0, 230, 0, 25)
    button.Text = tostring(default)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)

    button.MouseButton1Click:Connect(function()
        callback(button)
    end)

    return button
end

-- Menambahkan nama Zedlist
createLabel("Zedlist", 0)

-- Input fields
createLabel("Delay beli item 1", 30)
local delayItem1Button = createInputButton("60 detik", 50, function(btn)
    -- Logika untuk mengubah delay item 1
    btn.Text = "Delay diubah"
end)

createLabel("Delay ganti map", 80)
local delayChangeMapButton = createInputButton("30 detik", 100, function(btn)
    -- Logika untuk mengubah delay ganti map
    btn.Text = "Delay diubah"
end)

createLabel("Delay beli item 2", 130)
local delayItem2Button = createInputButton("60 detik", 150, function(btn)
    -- Logika untuk mengubah delay item 2
    btn.Text = "Delay diubah"
end)

createLabel("Durasi Comprehend", 180)
local comprehendButton = createInputButton("120 detik", 200, function(btn)
    -- Logika untuk mengubah durasi comprehend
    btn.Text = "Durasi diubah"
end)

createLabel("Durasi UpdateQi", 230)
local updateQiAfterButton = createInputButton("120 detik", 250, function(btn)
    -- Logika untuk mengubah durasi update Qi
    btn.Text = "Durasi diubah"
end)

-- Tombol Start dan Stop
local startBtn = Instance.new("TextButton", frame)
startBtn.Position = UDim2.new(0, 10, 0, 290)
startBtn.Size = UDim2.new(0, 110, 0, 30)
startBtn.Text = "▶ Start"
startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
startBtn.TextColor3 = Color3.new(1, 1, 1)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Position = UDim2.new(0, 130, 0, 290)
stopBtn.Size = UDim2.new(0, 110, 0, 30)
stopBtn.Text = "■ Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
stopBtn.TextColor3 = Color3.new(1, 1, 1)

-- Status Label
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Position = UDim2.new(0, 10, 0, 320)
statusLabel.Size = UDim2.new(0, 230, 0, 30)
statusLabel.Text = "Status: Idle"
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)

-- Control flags
local running = false

-- Helper functions
local function updateStatus(txt)
    statusLabel.Text = "Status: " .. txt
end
-- Main logic
local function runCycle()
	while running do
		updateStatus("Reincarnating")
		game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Reincarnate", 9e9):FireServer({})

		-- Infinite loop process
		spawn(function()
			while running do
				local args = {}
				game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("IncreaseAptitude", 9e9):FireServer(args)
				game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Mine", 9e9):FireServer(args)
				wait()
			end
		end)

		-- Update Qi Loop
		stopUpdateQi = false
		spawn(function()
			while running and not stopUpdateQi do
				game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("UpdateQi", 9e9):FireServer({})
				wait(1)
			end
		end)

		-- Delay sebelum beli item pertama
		waitSeconds(tonumber(delayItem1Box.Text))

		updateStatus("Buying Item Batch 1")
		for _, item in ipairs({
			"Nine Heavens Galaxy Water",
			"Buzhou Divine Flower",
			"Fusang Divine Tree",
			"Calm Cultivation Mat"
		}) do
			game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("BuyItem", 9e9):FireServer({item})
		end

		-- Delay sebelum ganti map
		waitSeconds(tonumber(delayChangeMapBox.Text))

		updateStatus("Changing Map")
		local function changeMap(name)
			game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("AreaEvents", 9e9):WaitForChild("ChangeMap", 9e9):FireServer({name})
		end
		changeMap("immortal")
		changeMap("chaos")

		updateStatus("Chaotic Road")
		game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("AreaEvents", 9e9):WaitForChild("ChaoticRoad", 9e9):FireServer({})

		-- Delay sebelum beli item kedua
		waitSeconds(tonumber(delayItem2Box.Text))

		updateStatus("Buying Item Batch 2")
		for _, item in ipairs({
			"Traceless Breeze Lotus",
			"Reincarnation World Destruction Black Lotus",
			"Ten Thousand Bodhi Tree"
		}) do
			game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("BuyItem", 9e9):FireServer({item})
		end

		updateStatus("Returning to Immortal")
		changeMap("immortal")

		updateStatus("HiddenRemote")
		game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("AreaEvents", 9e9):WaitForChild("HiddenRemote", 9e9):FireServer({})

		waitSeconds(60)
		updateStatus("ForbiddenZone")
		game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("AreaEvents", 9e9):WaitForChild("ForbiddenZone", 9e9):FireServer({})

		-- Comprehend
		updateStatus("Comprehending")
		stopUpdateQi = true
		local compStart = tick()
		while tick() - compStart < tonumber(comprehendBox.Text) do
			if not running then return end
			game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 9e9):WaitForChild("Comprehend", 9e9):FireServer({})
			wait()
		end

		-- Update Qi after
		updateStatus("Post-Comprehend Qi")
		stopUpdateQi = false
		waitSeconds(tonumber(updateQiAfterBox.Text))
		stopUpdateQi = true

		updateStatus("Restarting Cycle")
	end
end

-- UI Event Handlers
startBtn.MouseButton1Click:Connect(function()
	if not running then
		running = true
		spawn(runCycle)
	end
end)

stopBtn.MouseButton1Click:Connect(function()
	running = false
	updateStatus("Stopped")
end)
