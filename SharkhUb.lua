-- 🦈 Shark Hub | BlockSpin
-- Versión Mejorada (estilo Hermanos)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Anti AFK
player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

if playerGui:FindFirstChild("SharkHub") then
	playerGui.SharkHub:Destroy()
end

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "SharkHub"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = playerGui

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(1, -70, 0.5, -27)
openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
openBtn.Text = "🦈"
openBtn.TextSize = 26
openBtn.Font = Enum.Font.GothamBold
openBtn.TextColor3 = Color3.fromRGB(240, 240, 255)
openBtn.BorderSizePixel = 0
openBtn.ZIndex = 20
openBtn.Parent = sg
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 270, 0, 360)
main.Position = UDim2.new(0.5, -135, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundTransparency = 1
title.Text = "🦈 Shark Hub"
title.TextColor3 = Color3.fromRGB(220, 230, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Parent = main

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -16, 1, -50)
container.Position = UDim2.new(0, 8, 0, 42)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 3
container.CanvasSize = UDim2.new(0, 0, 0, 460)
container.Parent = main

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 7)
list.Parent = container

local function createToggle(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.Parent = container
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -45, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(220, 225, 240)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = btn

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 16, 0, 16)
	indicator.Position = UDim2.new(1, -28, 0.5, -8)
	indicator.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
	indicator.BorderSizePixel = 0
	indicator.Parent = btn
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

	local enabled = false
	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		indicator.BackgroundColor3 = enabled and Color3.fromRGB(70, 190, 120) or Color3.fromRGB(55, 55, 70)
		callback(enabled)
	end)
end

-- Variables
local autoPesca = false
local autoLimpiador = false
local autoCajas = false
local autoATM = false
local speedBoost = false
local infiniteJump = false
local noClip = false

createToggle("🎣 Auto Pesca", function(v) autoPesca = v end)
createToggle("🧹 Auto Limpiador", function(v) autoLimpiador = v end)
createToggle("📦 Auto Cajas", function(v) autoCajas = v end)
createToggle("💰 Auto ATM", function(v) autoATM = v end)
createToggle("⚡ Speed Boost", function(v)
	speedBoost = v
	if humanoid then humanoid.WalkSpeed = v and 32 or 16 end
end)
createToggle("🦘 Infinite Jump", function(v) infiniteJump = v end)
createToggle("👻 NoClip", function(v) noClip = v end)

-- Rejoin
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(1, 0, 0, 34)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
rejoinBtn.BorderSizePixel = 0
rejoinBtn.Text = "🔄 Rejoin"
rejoinBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
rejoinBtn.Font = Enum.Font.Gotham
rejoinBtn.TextSize = 14
rejoinBtn.Parent = container
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 8)
rejoinBtn.MouseButton1Click:Connect(function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

-- Toggle GUI
local open = false
openBtn.MouseButton1Click:Connect(function()
	open = not open
	main.Visible = open
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if infiniteJump and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- NoClip
RunService.Stepped:Connect(function()
	if noClip and character then
		for _, v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
	if speedBoost then humanoid.WalkSpeed = 32 end
end)

-- ========== AUTO FARM MEJORADO ==========
local function fireAllPrompts()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") and obj.Enabled then
			pcall(function()
				fireproximityprompt(obj)
			end)
		end
	end
end

-- Loop más rápido y agresivo
task.spawn(function()
	while true do
		task.wait(0.35)
		if autoPesca or autoLimpiador or autoCajas or autoATM then
			pcall(fireAllPrompts)
		end
	end
end)

-- Segundo loop por si acaso
task.spawn(function()
	while true do
		task.wait(0.8)
		if autoPesca or autoLimpiador or autoCajas or autoATM then
			pcall(fireAllPrompts)
		end
	end
end)

print("🦈 Shark Hub Mejorado cargado")
