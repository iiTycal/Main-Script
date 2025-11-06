local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local OrionLib = {
    Themes = {
        Default = {
            Main = Color3.fromRGB(25, 25, 25),
            Second = Color3.fromRGB(32, 32, 32),
            Stroke = Color3.fromRGB(60, 60, 60),
            Text = Color3.fromRGB(240, 240, 240),
            ActiveTab = Color3.fromRGB(0, 100, 180),
        }
    },
    SelectedTheme = "Default",
    Flags = {}
}

local Orion = Instance.new("ScreenGui")
Orion.Name = "Orion"
Orion.Parent = game.CoreGui
Orion.ResetOnSpawn = false
Orion.DisplayOrder = 999
Orion.ZIndexBehavior = Enum.ZIndexBehavior.Global

for _, Interface in ipairs(game.CoreGui:GetChildren()) do
    if Interface.Name == Orion.Name and Interface ~= Orion then
        Interface:Destroy()
    end
end

-- Funkcja teleportu używająca RemoteEvent
local function TeleportToWorld(worldName)
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if not remotes then 
        warn("Remotes not found!")
        return false 
    end
    
    local bridge = remotes:FindFirstChild("Bridge")
    if not bridge then 
        warn("Bridge remote not found!")
        return false 
    end
    
    local ohString1 = "General"
    local ohString2 = "Teleport"
    local ohString3 = "Teleport"
    local ohString4 = worldName
    
    -- Wysyłanie komendy teleportu
    local success, result = pcall(function()
        bridge:FireServer(ohString1, ohString2, ohString3, ohString4)
    end)
    
    if success then
        print("Successfully teleported to: " .. worldName)
        return true
    else
        warn("Failed to teleport to " .. worldName .. ": " .. tostring(result))
        return false
    end
end

-- Funkcja do znajdowania wszystkich dostępnych światów (dla UI)
local function GetAvailableWorlds()
    return {"Lobby", "Leaf Village", "Dragon Town", "Slayer Village"}
end

-- Reszta kodu pozostaje bez zmian (tworzenie GUI, efekty wizualne, itd.)
-- ... (cały kod GUI pozostaje bez zmian)

-- Funkcje AutoFarm pozostają bez zmian
local function StartStarFarm()
    if _G.StarFarmExecuting then
        _G.StarFarmExecuting = false
        return
    end

    _G.StarFarmExecuting = true

    while _G.StarFarmExecuting and task.wait() do
        local args = {
            "General",
            "Star", 
            "Open"
        }
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remotes then
            local bridge = remotes:FindFirstChild("Bridge")
            if bridge then
                pcall(function()
                    bridge:FireServer(unpack(args))
                end)
            end
        end
    end
end

local AutoFarm = {
    Executing = false,
    CurrentMob = nil,
    CurrentWorld = nil
}

local AkazePaths = {
    "workspace.Client.Enemies:GetChildren()[5]",
    "workspace.Client.Enemies.Akaze",
    "workspace.Client.Enemies:GetChildren()[2]",
    "workspace.Client.Enemies:GetChildren()[8]",
    "workspace.Client.Enemies:GetChildren()[7]",
    "workspace.Client.Enemies:GetChildren()[6]",
    "workspace.Client.Enemies:GetChildren()[9]",
    "workspace.Client.Enemies:GetChildren()[4]",
    "workspace.Client.Enemies:GetChildren()[3]"
}

local DakePaths = {
    "workspace.Client.Enemies:GetChildren()[11]",
    "workspace.Client.Enemies.Dake",
    "workspace.Client.Enemies:GetChildren()[14]",
    "workspace.Client.Enemies:GetChildren()[13]",
    "workspace.Client.Enemies:GetChildren()[12]"
}

local RuePaths = {
    "workspace.Client.Enemies:GetChildren()[13]",
    "workspace.Client.Enemies.Rue",
    "workspace.Client.Enemies:GetChildren()[21]",
    "workspace.Client.Enemies:GetChildren()[22]"
}

local KokoshibePaths = {
    "workspace.Client.Enemies:GetChildren()[16]",
    "workspace.Client.Enemies.Kokoshibe",
    "workspace.Client.Enemies:GetChildren()[17]"
}

local MuzenPaths = {
    "workspace.Client.Enemies.Muzen"
}

local function GetMobFromPath(path, mobType)
    local success, mob = pcall(function()
        if path == "workspace.Client.Enemies.Akaze" and mobType == "Akaze" then
            return workspace.Client.Enemies:FindFirstChild("Akaze")
        elseif path == "workspace.Client.Enemies.Dake" and mobType == "Dake" then
            return workspace.Client.Enemies:FindFirstChild("Dake")
        elseif path == "workspace.Client.Enemies.Rue" and mobType == "Rue" then
            return workspace.Client.Enemies:FindFirstChild("Rue")
        elseif path == "workspace.Client.Enemies.Kokoshibe" and mobType == "Kokoshibe" then
            return workspace.Client.Enemies:FindFirstChild("Kokoshibe")
        elseif path == "workspace.Client.Enemies.Muzen" and mobType == "Muzen" then
            return workspace.Client.Enemies:FindFirstChild("Muzen")
        else
            local index = tonumber(path:match("%[(%d+)%]"))
            if index then
                local children = workspace.Client.Enemies:GetChildren()
                if children[index] then
                    local mob = children[index]
                    if mobType == "Akaze" and (string.find(mob.Name:lower(), "akaze") or mob.Name == "Akaze") then
                        return mob
                    elseif mobType == "Dake" and (string.find(mob.Name:lower(), "dake") or mob.Name == "Dake") then
                        return mob
                    elseif mobType == "Rue" and (string.find(mob.Name:lower(), "rue") or mob.Name == "Rue") then
                        return mob
                    elseif mobType == "Kokoshibe" and (string.find(mob.Name:lower(), "kokoshibe") or mob.Name == "Kokoshibe") then
                        return mob
                    elseif mobType == "Muzen" and (string.find(mob.Name:lower(), "muzen") or mob.Name == "Muzen") then
                        return mob
                    end
                end
            end
        end
        return nil
    end)
    
    if success and mob then
        return mob
    end
    return nil
end

local function TeleportToMob(mob)
    if mob and mob:FindFirstChild("HumanoidRootPart") then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            return true
        end
    end
    return false
end

local function MobExists(mob)
    return mob and mob.Parent ~= nil and mob:FindFirstChild("HumanoidRootPart")
end

local function WaitForMobDeath(mob)
    local startTime = tick()
    
    while MobExists(mob) and AutoFarm.Executing do
        task.wait(0.1)
        
        if tick() - startTime > 5 then
            return false
        end
    end
    
    return not MobExists(mob)
end

-- Zaktualizowana funkcja StartAutoFarm z automatycznym teleportem
local function StartAutoFarm()
    if AutoFarm.Executing then
        AutoFarm.Executing = false
        task.wait(0.5)
        return
    end

    if not AutoFarm.CurrentMob or not AutoFarm.CurrentWorld then
        warn("Select both world and mob type first!")
        return
    end

    -- Najpierw teleportujemy do wybranej areny
    print("Teleporting to " .. AutoFarm.CurrentWorld .. " before starting AutoFarm...")
    local teleportSuccess = TeleportToWorld(AutoFarm.CurrentWorld)
    
    if not teleportSuccess then
        warn("Failed to teleport to " .. AutoFarm.CurrentWorld .. ". AutoFarm not started.")
        return
    end
    
    -- Czekamy chwilę po teleporcie
    task.wait(3)
    
    AutoFarm.Executing = true
    print("AutoFarm started in " .. AutoFarm.CurrentWorld .. " for " .. AutoFarm.CurrentMob)

    spawn(function()
        while AutoFarm.Executing do
            local foundAnyMob = false
            local paths = {}
            
            if AutoFarm.CurrentMob == "Akaze" then
                paths = AkazePaths
            elseif AutoFarm.CurrentMob == "Dake" then
                paths = DakePaths
            elseif AutoFarm.CurrentMob == "Rue" then
                paths = RuePaths
            elseif AutoFarm.CurrentMob == "Kokoshibe" then
                paths = KokoshibePaths
            elseif AutoFarm.CurrentMob == "Muzen" then
                paths = MuzenPaths
            end
            
            for _, path in ipairs(paths) do
                if not AutoFarm.Executing then break end
                
                local mob = GetMobFromPath(path, AutoFarm.CurrentMob)
                if MobExists(mob) then
                    foundAnyMob = true
                    
                    if TeleportToMob(mob) then
                        local mobDied = WaitForMobDeath(mob)
                        task.wait(0.3)
                        break
                    end
                end
            end
            
            if not foundAnyMob then
                task.wait(1)
            end
            
            task.wait(0.1)
        end
    end)
end

-- Zaktualizowana funkcja GetMobsInWorld
local function GetMobsInWorld(worldName)
    if worldName == "Leaf Village" then
        return {"Akaze", "Dake", "Rue"}
    elseif worldName == "Dragon Town" then
        return {"Akaze", "Dake", "Rue", "Kokoshibe", "Muzen"}
    elseif worldName == "Slayer Village" then
        return {"Akaze", "Dake", "Rue", "Kokoshibe"}
    end
    return {}
end

local AntiAFKEnabled = false

local function EnableAntiAFK()
    if AntiAFKEnabled then
        return
    end
    
    AntiAFKEnabled = true
    
    local speaker = game.Players.LocalPlayer
    local Services = game:GetService("VirtualUser")
    
    if getconnections then
        for _, connection in pairs(getconnections(speaker.Idled)) do
            if connection["Disable"] then
                connection["Disable"](connection)
            elseif connection["Disconnect"] then
                connection["Disconnect"](connection)
            end
        end
    else
        speaker.Idled:Connect(function()
            Services:CaptureController()
            Services:ClickButton2(Vector2.new())
        end)
    end
end

-- Tworzenie GUI
local Window = OrionLib:MakeWindow({
    Name = "Hatching GUI"
})

local MainTab = Window:MakeTab({
    Name = "Main"
})

local InfoLabel = MainTab:AddLabel("Auto hatch stars for faster progression")
local InfoLabel2 = MainTab:AddLabel("Toggle ON in Hatching tab to start farming")
local InfoLabel3 = MainTab:AddLabel("Press Right Shift to toggle GUI")

local HatchingTab = Window:MakeTab({
    Name = "Hatching"
})

local FarmToggle = HatchingTab:AddToggle({
    Name = "Fast Hatch",
    Default = false,
    Callback = function(Value)
        if Value then
            StartStarFarm()
        else
            if _G.StarFarmExecuting then
                _G.StarFarmExecuting = false
            end
        end
    end
})

local AutoFarmTab = Window:MakeTab({
    Name = "AutoFarm"
})

local WorldDropdown
local MobDropdown

-- Zaktualizowana lista światów w odpowiedniej kolejności
WorldDropdown = AutoFarmTab:AddDropdown({
    Name = "Select World",
    Options = {"Leaf Village", "Dragon Town", "Slayer Village"},
    Default = 1,
    Callback = function(Value)
        AutoFarm.CurrentWorld = Value
        local mobs = GetMobsInWorld(Value)
        if MobDropdown then
            MobDropdown:Set(mobs)
        end
    end
})

MobDropdown = AutoFarmTab:AddDropdown({
    Name = "Mob Type",
    Options = {"Select a world first"},
    Default = 1,
    Callback = function(Value)
        AutoFarm.CurrentMob = Value
    end
})

local AutoFarmToggle = AutoFarmTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        if Value then
            StartAutoFarm()
        else
            AutoFarm.Executing = false
        end
    end
})

local ReloadButton = AutoFarmTab:AddButton({
    Name = "Reload Mob List",
    Callback = function()
        if AutoFarm.CurrentWorld then
            local mobs = GetMobsInWorld(AutoFarm.CurrentWorld)
            MobDropdown:Set(mobs)
        end
    end
})

local InfoLabel4 = AutoFarmTab:AddLabel("Auto-teleports to selected world before farming")
local InfoLabel5 = AutoFarmTab:AddLabel("Fast farming - moves immediately to next mob")

local TeleportTab = Window:MakeTab({
    Name = "Teleport"
})

-- Tworzenie przycisków teleportu tylko dla podstawowych światów
local worldTeleports = {
    {DisplayName = "Lobby", WorldName = "Lobby"},
    {DisplayName = "Leaf Village", WorldName = "Leaf Village"},
    {DisplayName = "Dragon Town", WorldName = "Dragon Town"},
    {DisplayName = "Slayer Village", WorldName = "Slayer Village"}
}

for _, worldInfo in ipairs(worldTeleports) do
    local worldButton = TeleportTab:AddButton({
        Name = worldInfo.DisplayName,
        Callback = function()
            local success = TeleportToWorld(worldInfo.WorldName)
            if not success then
                warn("Could not teleport to " .. worldInfo.DisplayName)
            end
        end
    })
end

local TeleportInfo1 = TeleportTab:AddLabel("Teleport to different locations")
local TeleportInfo2 = TeleportTab:AddLabel("Click buttons to teleport instantly")

local MiscTab = Window:MakeTab({
    Name = "Misc"
})

local AntiAFKButton = MiscTab:AddButton({
    Name = "Enable Anti-AFK",
    Callback = function()
        EnableAntiAFK()
    end
})

local AntiAFKInfo = MiscTab:AddLabel("Click once to enable Anti-AFK permanently")
local AntiAFKInfo2 = MiscTab:AddLabel("Prevents getting kicked for being AFK")

-- Automatyczne ustawienie początkowych wartości
task.spawn(function()
    wait(1)
    if WorldDropdown then
        -- Ustaw domyślnie Leaf Village i załaduj odpowiednie moby
        AutoFarm.CurrentWorld = "Leaf Village"
        local mobs = GetMobsInWorld("Leaf Village")
        MobDropdown:Set(mobs)
    end
end)

print("Successfully loaded! Press Right Shift to toggle GUI")
print("AutoFarm system ready - automatically teleports to selected world")
print("Teleport system ready with " .. #worldTeleports .. " locations")

return OrionLib
