-- 99 Nights in the Forest | Full Deluxe GUI
-- GUI Title: Free Scripts
-- Features: Kill Aura, Bring Items, ESP, Auto Farm, Auto Cook, Auto Heal/Hunger, Teleports, Selectable Auto Rescue Child, Bring Weapons/Armor

pcall(function()

local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxScriptsDev/UI-Library/main/SimpleUILib.lua"))()
end)
if not success then return end

local Window = Library:CreateWindow("Free Scripts")
Window:SetDraggable(true)

local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Feature toggles
local killAuraEnabled, bringItemsEnabled, espEnabled, autoFarmEnabled, autoCookEnabled, autoHealEnabled = false, false, false, false, false, false

-- GUI visibility toggle
local guiVisible = true
Window:CreateButton("Toggle GUI", function()
    guiVisible = not guiVisible
    Window:SetVisible(guiVisible)
end)

-- Kill Aura
Window:CreateToggle("Kill Aura", function(state) killAuraEnabled = state end)

-- Bring Items
Window:CreateToggle("Bring Items", function(state) bringItemsEnabled = state end)

-- ESP
Window:CreateToggle("ESP", function(state)
    espEnabled = state
    if espEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= player.Name then
                if not obj:FindFirstChild("BoxESP") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "BoxESP"
                    box.Adornee = obj:FindFirstChild("HumanoidRootPart")
                    box.Size = Vector3.new(4,4,4)
                    box.Color3 = Color3.fromRGB(255,0,0)
                    box.Transparency = 0.5
                    box.AlwaysOnTop = true
                    box.Parent = workspace.CurrentCamera
                end
            end
        end
    else
        for _, box in pairs(workspace.CurrentCamera:GetChildren()) do
            if box.Name == "BoxESP" then box:Destroy() end
        end
    end
end)

-- Auto Farm
Window:CreateToggle("Auto Farm", function(state) autoFarmEnabled = state end)

-- Auto Cook
Window:CreateToggle("Auto Cook", function(state) autoCookEnabled = state end)

-- Auto Heal/Hunger
Window:CreateToggle("Auto Heal/Hunger", function(state) autoHealEnabled = state end)

-- Teleports
Window:CreateButton("Teleport to Campfire", function()
    local campfire = workspace:FindFirstChild("Campfire")
    if campfire and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = campfire.CFrame + Vector3.new(0,3,0)
    end
end)

Window:CreateButton("Teleport to Lost Child", function()
    for _, child in pairs(workspace:GetDescendants()) do
        if child.Name:match("Child") and child:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = child.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            break
        end
    end
end)

-- Selectable Auto Rescue Child
local selectedChildName
local childrenNames = {"Squid Kid", "Dino Kid", "Koala Kid"} -- add more as needed
Window:CreateDropdown("Select Child to Rescue", childrenNames, function(option) selectedChildName = option end)

Window:CreateButton("Rescue Selected Child", function()
    if not selectedChildName then warn("No child selected!") return end
    for _, child in pairs(workspace:GetDescendants()) do
        if child.Name == selectedChildName and child:FindFirstChild("HumanoidRootPart") then
            local hrp = child.HumanoidRootPart
            player.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0,5,0)
            wait(0.1)
            if hrp.Parent then hrp.Parent = player.Backpack end
            wait(0.1)
            local campfire = workspace:FindFirstChild("Campfire")
            if campfire then player.Character.HumanoidRootPart.CFrame = campfire.CFrame + Vector3.new(0,3,0) end
            break
        end
    end
end)

-- Bring Weapons/Armor button
Window:CreateButton("Bring Weapons/Armor", function()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") or item:IsA("Accessory") or item.Name:match("Sword|Axe|Bow|Armor|Helmet|Chestplate|Leggings|Boots") then
            if item:FindFirstChild("Handle") or item:IsA("Accessory") then
                item.Parent = player.Character
            end
        end
    end
end)

-- Core loop
RunService.RenderStepped:Connect(function()
    if bringItemsEnabled or autoFarmEnabled then
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Tool") or item.Name:match("Wood|Food|Fuel|Chest") then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    item.CFrame = player.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    if killAuraEnabled then
        for _, mob in pairs(workspace:GetDescendants()) do
            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob.Name ~= player.Name then
                mob.Humanoid.Health = 0
            end
        end
    end

    if autoCookEnabled then
        local campfire = workspace:FindFirstChild("Campfire")
        if campfire and player.Character and player:FindFirstChild("Backpack") then
            for _, item in pairs(player.Backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:match("Raw|Food") then
                    item.Parent = player.Character
                end
            end
        end
    end

    if autoHealEnabled then
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.Health = humanoid.MaxHealth end
        local hunger = player:FindFirstChild("Hunger")
        if hunger then hunger.Value = hunger.MaxValue end
    end
end)

print("✅ Delta Executor Ready | Full Deluxe GUI Loaded!")
end)
