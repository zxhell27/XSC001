-- UI SETUP
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "ZedlistGui"
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- drag support

-- Minimize button
local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18

-- Toggle visibility logic
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in pairs(frame:GetChildren()) do
		if child ~= minimizeBtn then
			child.Visible = not minimized
		end
	end
	minimizeBtn.Text = minimized and "+" or "-"
end)

-- Label pembuka
local function createLabel(text, y)
	local label = Instance.new("TextLabel", frame)
	label.Position = UDim2.new(0, 10, 0, y)
	label.Size = UDim2.new(0, 280, 0, 20)
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	return label
end

-- Input field
local function createInputBox(default, y)
	local box = Instance.new("TextBox", frame)
	box.Position = UDim2.new(0, 10, 0, y)
	box.Size = UDim2.new(0, 280, 0, 25)
	box.Text = tostring(default)
	box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.SourceSans
	box.TextSize = 16
	box.ClearTextOnFocus = false
	return box
end

-- Wait helper
local function waitSeconds(sec)
	local t = tonumber(sec)
	if t and t > 0 then wait(t) end
end

-- UI Fields
createLabel("Delay beli item 1 (detik)", 40)
local delayItem1Box = createInputBox("60", 60)

createLabel("Delay ganti map (detik)", 90)
local delayChangeMapBox = createInputBox("30", 110)

createLabel("Delay beli item 2 (detik)", 140)
local delayItem2Box = createInputBox("60", 160)

createLabel("Durasi Comprehend (detik)", 190)
local comprehendBox = createInputBox("120", 210)

createLabel("Delay UpdateQi setelah Comprehend", 240)
local updateQiAfterBox = createInputBox("120", 260)

-- Status
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Position = UDim2.new(0, 10, 0, 290)
statusLabel.Size = UDim2.new(0, 280, 0, 20)
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 16
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol start/stop
local startBtn = Instance.new("TextButton", frame)
startBtn.Position = UDim2.new(0, 10, 0, 320)
startBtn.Size = UDim2.new(0, 130, 0, 30)
startBtn.Text = "▶ Start"
startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 16

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Position = UDim2.new(0, 160, 0, 320)
stopBtn.Size = UDim2.new(0, 130, 0, 30)
stopBtn.Text = "■ Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 16

-- Control flags
local running = false
local stopUpdateQi = false

-- Status updater
local function updateStatus(txt)
	statusLabel.Text = "Status: " .. txt
end

-- Fungsi utama
local function runCycle()
	while running do
		updateStatus("Reincarnating")
		game:GetService("ReplicatedStorage").RemoteEvents.Reincarnate:FireServer({})

		-- Passive increase & mine
		spawn(function()
			while running do
				game:GetService("ReplicatedStorage").RemoteEvents.IncreaseAptitude:FireServer({})
				game:GetService("ReplicatedStorage").RemoteEvents.Mine:FireServer({})
				wait()
			end
		end)

		-- Update Qi
		stopUpdateQi = false
		spawn(function()
			while running and not stopUpdateQi do
				game:GetService("ReplicatedStorage").RemoteEvents.UpdateQi:FireServer({})
				wait(1)
			end
		end)

		waitSeconds(delayItem1Box.Text)

		updateStatus("Buying Item Batch 1")
		for _, item in ipairs({
			"Nine Heavens Galaxy Water",
			"Buzhou Divine Flower",
			"Fusang Divine Tree",
			"Calm Cultivation Mat"
		}) do
			game:GetService("ReplicatedStorage").RemoteEvents.BuyItem:FireServer({item})
		end

		waitSeconds(delayChangeMapBox.Text)
		updateStatus("Changing Map")
		local changeMap = function(name)
			game:GetService("ReplicatedStorage").RemoteEvents.AreaEvents.ChangeMap:FireServer({name})
		end
		changeMap("immortal")
		changeMap("chaos")

		updateStatus("Chaotic Road")
		game:GetService("ReplicatedStorage").RemoteEvents.AreaEvents.ChaoticRoad:FireServer({})

		waitSeconds(delayItem2Box.Text)

		updateStatus("Buying Item Batch 2")
		for _, item in ipairs({
			"Traceless Breeze Lotus",
			"Reincarnation World Destruction Black Lotus",
			"Ten Thousand Bodhi Tree"
		}) do
			game:GetService("ReplicatedStorage").RemoteEvents.BuyItem:FireServer({item})
		end

		updateStatus("Returning to Immortal")
		changeMap("immortal")

		updateStatus("HiddenRemote")
		game:GetService("ReplicatedStorage").RemoteEvents.AreaEvents.HiddenRemote:FireServer({})

		waitSeconds(60)

		updateStatus("ForbiddenZone")
		game:GetService("ReplicatedStorage").RemoteEvents.AreaEvents.ForbiddenZone:FireServer({})

		updateStatus("Comprehending")
		stopUpdateQi = true
		local compStart = tick()
		while tick() - compStart < tonumber(comprehendBox.Text) do
			if not running then return end
			game:GetService("ReplicatedStorage").RemoteEvents.Comprehend:FireServer({})
			wait()
		end

		updateStatus("Post-Comprehend Qi")
		stopUpdateQi = false
		waitSeconds(updateQiAfterBox.Text)
		stopUpdateQi = true

		updateStatus("Restarting Cycle")
	end
end

-- Tombol event
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
