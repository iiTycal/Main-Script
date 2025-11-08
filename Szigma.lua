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

local function TeleportToWorld(worldName)
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if not remotes then 
        return false 
    end
    
    local bridge = remotes:FindFirstChild("Bridge")
    if not bridge then 
        return false 
    end
    
    local ohString1 = "General"
    local ohString2 = "Teleport"
    local ohString3 = "Teleport"
    local ohString4 = worldName
    
    local success, result = pcall(function()
        bridge:FireServer(ohString1, ohString2, ohString3, ohString4)
    end)
    
    if success then
        return true
    else
        return false
    end
end

local function GetAvailableWorlds()
    return {"Lobby", "Leaf Village", "Slayer Village", "Dragon Town"}
end

local function CreateWindowStarBackground(parent)
    local backgroundContainer = Instance.new("Frame")
    backgroundContainer.Name = "WindowStarBackground"
    backgroundContainer.Size = UDim2.new(1, 0, 1, 0)
    backgroundContainer.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
    backgroundContainer.BorderSizePixel = 0
    backgroundContainer.ZIndex = 0
    backgroundContainer.Parent = parent

    local starsContainer = Instance.new("Frame")
    starsContainer.Name = "StarsContainer"
    starsContainer.Size = UDim2.new(1, 0, 1, 0)
    starsContainer.BackgroundTransparency = 1
    starsContainer.ZIndex = 1
    starsContainer.Parent = backgroundContainer

    local shootingStarsContainer = Instance.new("Frame")
    shootingStarsContainer.Name = "ShootingStarsContainer"
    shootingStarsContainer.Size = UDim2.new(2, 0, 2, 0)
    shootingStarsContainer.Position = UDim2.new(-0.5, 0, -0.5, 0)
    shootingStarsContainer.BackgroundTransparency = 1
    shootingStarsContainer.Rotation = 45
    shootingStarsContainer.ZIndex = 1
    shootingStarsContainer.Parent = backgroundContainer

    local colors = {
        Color3.new(1, 1, 1),
        Color3.fromRGB(100, 150, 255),
        Color3.fromRGB(200, 100, 255),
        Color3.fromRGB(255, 200, 100)
    }

    local function createStars()
        for i = 1, 200 do
            local star = Instance.new("Frame")
            star.Name = "Star"
            star.Size = UDim2.new(0, math.random(1, 2), 0, math.random(1, 2))
            star.Position = UDim2.new(math.random(), 0, math.random(), 0)
            star.BackgroundColor3 = Color3.new(1, 1, 1)
            star.BackgroundTransparency = math.random(0, 0.4)
            star.BorderSizePixel = 0
            star.AnchorPoint = Vector2.new(0.5, 0.5)
            star.ZIndex = 1
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = star
            
            star.Parent = starsContainer
            
            local delay = math.random() * 4
            local duration = math.random() * 3 + 2
            
            coroutine.wrap(function()
                while star and star.Parent do
                    task.wait(delay)
                    
                    local tweenInfo = TweenInfo.new(
                        duration,
                        Enum.EasingStyle.Sine,
                        Enum.EasingDirection.InOut,
                        -1,
                        true
                    )
                    local tween = TweenService:Create(star, tweenInfo, {
                        BackgroundTransparency = star.BackgroundTransparency + 0.5
                    })
                    tween:Play()
                    
                    task.wait(duration * 2)
                    tween:Cancel()
                end
            end)()
        end
    end

    local function createShootingStars()
        for i = 1, 15 do
            local shootingStar = Instance.new("Frame")
            shootingStar.Name = "ShootingStar"
            shootingStar.Size = UDim2.new(0, 0, 0, 1)
            shootingStar.Position = UDim2.new(
                math.random() * 1.5 - 0.25, 0,
                math.random() * 1.5 - 0.25, 0
            )
            shootingStar.BackgroundTransparency = 1
            shootingStar.AnchorPoint = Vector2.new(0, 0.5)
            shootingStar.BorderSizePixel = 0
            shootingStar.ZIndex = 1
            
            local mainPart = Instance.new("Frame")
            mainPart.Name = "MainTrail"
            mainPart.Size = UDim2.new(1, 0, 1, 0)
            mainPart.BackgroundColor3 = colors[1]
            mainPart.BorderSizePixel = 0
            mainPart.ZIndex = 1
            mainPart.Parent = shootingStar
            
            if math.random() > 0.4 then
                local colorIndex = math.random(2, 4)
                mainPart.BackgroundColor3 = colors[colorIndex]
            end
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = mainPart
            
            local glow = Instance.new("UIStroke")
            glow.Color = mainPart.BackgroundColor3
            glow.Thickness = 1.5
            glow.Transparency = 0.4
            glow.Parent = mainPart
            
            shootingStar.Parent = shootingStarsContainer
            
            coroutine.wrap(function()
                local initialDelay = math.random() * 5
                task.wait(initialDelay)
                
                while shootingStar and shootingStar.Parent do
                    local delay = math.random() * 10 + 5
                    local duration = math.random() * 2 + 1.5
                    
                    shootingStar.Position = UDim2.new(
                        math.random() * 1.5 - 0.25, 0,
                        math.random() * 1.5 - 0.25, 0
                    )
                    shootingStar.Size = UDim2.new(0, 0, 0, 1)
                    mainPart.BackgroundTransparency = 0
                    glow.Transparency = 0.4
                    
                    local widthTweenInfo = TweenInfo.new(
                        duration * 0.3,
                        Enum.EasingStyle.Quad,
                        Enum.EasingDirection.Out
                    )
                    local widthTween = TweenService:Create(shootingStar, widthTweenInfo, {
                        Size = UDim2.new(0, math.random(80, 150), 0, 1)
                    })
                    
                    local moveTweenInfo = TweenInfo.new(
                        duration,
                        Enum.EasingStyle.Quad,
                        Enum.EasingDirection.Out
                    )
                    local moveTween = TweenService:Create(shootingStar, moveTweenInfo, {
                        Position = shootingStar.Position + UDim2.new(1.2, 0, 1.2, 0),
                        BackgroundTransparency = 1
                    })
                    
                    local glowTweenInfo = TweenInfo.new(
                        duration * 0.6,
                        Enum.EasingStyle.Quad,
                        Enum.EasingDirection.Out
                    )
                    local glowTween = TweenService:Create(glow, glowTweenInfo, {
                        Transparency = 1
                    })
                    
                    widthTween:Play()
                    moveTween:Play()
                    task.wait(duration * 0.3)
                    glowTween:Play()
                    
                    task.wait(duration * 0.7)
                    task.wait(delay)
                end
            end)()
        end
    end

    createStars()
    createShootingStars()

    return backgroundContainer
end

local function Create(Name, Properties, Children)
    local Object = Instance.new(Name)
    for i, v in next, Properties or {} do
        Object[i] = v
    end
    for i, v in next, Children or {} do
        v.Parent = Object
    end
    return Object
end

local function CopyLink(url)
    if setclipboard then
        setclipboard(url)
    end
end

function OrionLib:MakeWindow(WindowConfig)
    WindowConfig = WindowConfig or {}
    WindowConfig.Name = WindowConfig.Name or "Orion Library"
    
    local MainWindow = Create("Frame", {
        Parent = Orion,
        Position = UDim2.new(0.5, -300, 0.5, -150),
        Size = UDim2.new(0, 600, 0, 300),
        BackgroundColor3 = Color3.fromRGB(15, 15, 35),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Active = true,
        Name = "MainWindow"
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        Create("UIStroke", {
            Color = Color3.fromRGB(100, 100, 150),
            Thickness = 2
        })
    })

    local starBackground = CreateWindowStarBackground(MainWindow)
    
    local Title = Create("TextLabel", {
        Parent = MainWindow,
        Position = UDim2.new(0, 50, 0, 10),
        Size = UDim2.new(1, -100, 0, 30),
        BackgroundTransparency = 1,
        Text = "Hatching GUI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10,
        TextStrokeTransparency = 0.7,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    })
    
    local MinimizeButton = Create("TextButton", {
        Parent = MainWindow,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Color3.fromRGB(40, 40, 80),
        Text = "_",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Name = "MinimizeButton",
        ZIndex = 10
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Create("UIStroke", {
            Color = Color3.fromRGB(80, 80, 120),
            Thickness = 1
        })
    })
    
    local CloseButton = Create("TextButton", {
        Parent = MainWindow,
        Position = UDim2.new(1, -40, 0, 10),
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Color3.fromRGB(200, 60, 60),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Name = "CloseButton",
        ZIndex = 10
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Create("UIStroke", {
            Color = Color3.fromRGB(150, 40, 40),
            Thickness = 1
        })
    })
    
    local TabButtonsFrame = Create("ScrollingFrame", {
        Parent = MainWindow,
        Position = UDim2.new(0, 10, 0, 50),
        Size = UDim2.new(0, 130, 0, 200),
        BackgroundColor3 = Color3.fromRGB(25, 25, 50),
        BackgroundTransparency = 0.4,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Name = "TabButtonsFrame",
        ZIndex = 5
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Create("UIStroke", {
            Color = Color3.fromRGB(80, 80, 120),
            Thickness = 1
        }),
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })
    })
    
    local ContentFrame = Create("ScrollingFrame", {
        Parent = MainWindow,
        Position = UDim2.new(0, 150, 0, 50),
        Size = UDim2.new(0, 440, 0, 240),
        BackgroundColor3 = Color3.fromRGB(25, 25, 50),
        BackgroundTransparency = 0.4,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Name = "ContentFrame",
        ZIndex = 5
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Create("UIStroke", {
            Color = Color3.fromRGB(80, 80, 120),
            Thickness = 1
        }),
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        }),
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10)
        })
    })
    
    local SocialFrame = Create("Frame", {
        Parent = MainWindow,
        Position = UDim2.new(0, 0, 1, -40),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Name = "SocialFrame",
        ZIndex = 10,
        Visible = false
    }, {
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 15)
        })
    })
    
    local DiscordButton = Create("TextButton", {
        Parent = SocialFrame,
        Size = UDim2.new(0, 100, 0, 25),
        BackgroundColor3 = Color3.fromRGB(88, 101, 242),
        Text = "Discord",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Name = "DiscordButton",
        ZIndex = 10
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Create("UIStroke", {
            Color = Color3.fromRGB(60, 80, 220),
            Thickness = 1
        })
    })
    
    local YouTubeButton = Create("TextButton", {
        Parent = SocialFrame,
        Size = UDim2.new(0, 100, 0, 25),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        Text = "YouTube",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Name = "YouTubeButton",
        ZIndex = 10
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Create("UIStroke", {
            Color = Color3.fromRGB(200, 0, 0),
            Thickness = 1
        })
    })
    
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    
    local function Update(input)
        local delta = input.Position - DragStart
        MainWindow.Position = UDim2.new(
            StartPosition.X.Scale, 
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale, 
            StartPosition.Y.Offset + delta.Y
        )
    end
    
    MainWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPosition = MainWindow.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    MainWindow.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
    
    local function SetupButtonHover(button)
        local originalSize = button.Size
        local originalStroke = button:FindFirstChild("UIStroke")
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = originalSize + UDim2.new(0, 4, 0, 4)
            }):Play()
            if originalStroke then
                TweenService:Create(originalStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2
                }):Play()
            end
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = originalSize
            }):Play()
            if originalStroke then
                TweenService:Create(originalStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 1
                }):Play()
            end
        end)
    end
    
    SetupButtonHover(MinimizeButton)
    SetupButtonHover(CloseButton)
    SetupButtonHover(DiscordButton)
    SetupButtonHover(YouTubeButton)
    
    local Minimized = false
    local IsDestroyed = false

    local function SafeTween(object, tweenInfo, properties)
        if object and object.Parent then
            local success, result = pcall(function()
                return TweenService:Create(object, tweenInfo, properties)
            end)
            if success and result then
                result:Play()
                return true
            end
        end
        return false
    end

    MinimizeButton.MouseButton1Click:Connect(function()
        if IsDestroyed then return end
        if not Minimized then
            SafeTween(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            
            delay(0.3, function()
                if MainWindow and MainWindow.Parent then
                    MainWindow.Visible = false
                end
                Minimized = true
            end)
        end
    end)
    
    local KeybindConnection
    local function ToggleGUI()
        if IsDestroyed then return end
        
        if Minimized then
            if MainWindow and MainWindow.Parent then
                MainWindow.Visible = true
                SafeTween(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 600, 0, 300),
                    Position = UDim2.new(0.5, -300, 0.5, -150)
                })
            end
            Minimized = false
        else
            SafeTween(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            
            delay(0.3, function()
                if MainWindow and MainWindow.Parent then
                    MainWindow.Visible = false
                end
                Minimized = true
            end)
        end
    end

    KeybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if IsDestroyed then
            if KeybindConnection then
                KeybindConnection:Disconnect()
            end
            return
        end
        
        if not gameProcessed then
            if input.KeyCode == Enum.KeyCode.RightShift then
                ToggleGUI()
            end
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        if IsDestroyed then return end
        IsDestroyed = true
        
        if KeybindConnection then
            KeybindConnection:Disconnect()
        end
        
        SafeTween(MainWindow, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        
        delay(0.25, function()
            if MainWindow and MainWindow.Parent then
                MainWindow:Destroy()
            end
        end)
    end)
    
    DiscordButton.MouseButton1Click:Connect(function()
        CopyLink("https://discord.gg/4WwzYCB6vc")
        SafeTween(DiscordButton, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 90, 0, 22)
        })
        delay(0.1, function()
            if DiscordButton and DiscordButton.Parent then
                SafeTween(DiscordButton, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 100, 0, 25)
                })
            end
        end)
    end)
    
    YouTubeButton.MouseButton1Click:Connect(function()
        CopyLink("https://youtube.com/@iiTycal")
        SafeTween(YouTubeButton, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 90, 0, 22)
        })
        delay(0.1, function()
            if YouTubeButton and YouTubeButton.Parent then
                SafeTween(YouTubeButton, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 100, 0, 25)
                })
            end
        end)
    end)
    
    local Tabs = {}
    local FirstTabContent = nil
    local CurrentActiveTab = nil

    function Tabs:MakeTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        
        local TabButton = Create("TextButton", {
            Parent = TabButtonsFrame,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Color3.fromRGB(40, 40, 80),
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ClipsDescendants = true,
            ZIndex = 6
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIStroke", {
                Color = Color3.fromRGB(80, 80, 120),
                Thickness = 1,
                Transparency = 0.5
            }),
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
                }),
                Rotation = 135
            }),
            Create("TextLabel", {
                Name = "TabText",
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = TabConfig.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                ZIndex = 7,
                TextStrokeTransparency = 0.7,
                TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            }),
            
            Create("Frame", {
                Name = "RippleEffect",
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
                ZIndex = 6
            }, {
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            }),
            
            Create("Frame", {
                Name = "AnimatedBorder",
                Size = UDim2.new(1, 4, 1, 4),
                Position = UDim2.new(0, -2, 0, -2),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 5,
                Visible = false
            }, {
                Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 212, 255)),
                        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(112, 0, 255)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 229)),
                        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(112, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 212, 255))
                    }),
                    Rotation = 45
                }),
                Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
                Create("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 2,
                    LineJoinMode = Enum.LineJoinMode.Round
                })
            })
        })
        
        local borderGradient = TabButton.AnimatedBorder.UIGradient
        local borderConnection
        
        local function startBorderAnimation()
            if borderConnection then
                borderConnection:Disconnect()
            end
            
            borderConnection = RunService.Heartbeat:Connect(function(delta)
                local currentRotation = borderGradient.Rotation
                borderGradient.Rotation = (currentRotation + 30 * delta) % 360
            end)
        end
        
        local function stopBorderAnimation()
            if borderConnection then
                borderConnection:Disconnect()
                borderConnection = nil
            end
        end

        local function onHover()
            if TabButton == CurrentActiveTab then return end
            
            local tabText = TabButton:FindFirstChild("TabText")
            
            SafeTween(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, -2, 0, -3),
                Size = UDim2.new(1, 4, 0, 38)
            })
            
            if tabText then
                SafeTween(tabText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 1, 0, -1),
                    TextColor3 = Color3.fromRGB(220, 220, 255)
                })
            end
            
            SafeTween(TabButton.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(100, 150, 255),
                Thickness = 2
            })
            
            TabButton.AnimatedBorder.Visible = true
            startBorderAnimation()
        end

        local function onHoverEnd()
            if TabButton == CurrentActiveTab then return end
            
            local tabText = TabButton:FindFirstChild("TabText")
            
            SafeTween(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 35)
            })
            
            if tabText then
                SafeTween(tabText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0),
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                })
            end
            
            SafeTween(TabButton.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(80, 80, 120),
                Thickness = 1
            })
            
            TabButton.AnimatedBorder.Visible = false
            stopBorderAnimation()
        end

        local function createRippleEffect()
            local ripple = TabButton.RippleEffect
            if not ripple then return end
            
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local buttonPos = TabButton.AbsolutePosition
            local buttonSize = TabButton.AbsoluteSize
            
            local posX = (mouse.X - buttonPos.X) / buttonSize.X
            local posY = (mouse.Y - buttonPos.Y) / buttonSize.Y
            
            ripple.Position = UDim2.new(posX, 0, posY, 0)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.BackgroundTransparency = 0.7
            
            SafeTween(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1
            })
        end

        TabButton.MouseEnter:Connect(onHover)
        TabButton.MouseLeave:Connect(onHoverEnd)
        TabButton.MouseButton1Down:Connect(createRippleEffect)

        local TabContent = Create("Frame", {
            Parent = ContentFrame,
            Size = UDim2.new(1, -20, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ZIndex = 6
        }, {
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5)
            })
        })
        
        if FirstTabContent == nil then
            FirstTabContent = TabContent
            CurrentActiveTab = TabButton
            
            TabButton.UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 200)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
            })
            
            local tabText = TabButton:FindFirstChild("TabText")
            if tabText then
                tabText.TextColor3 = Color3.fromRGB(255, 255, 255)
                tabText.TextSize = 15
            end
            
            TabButton.AnimatedBorder.Visible = true
            startBorderAnimation()
        end
        
        local function ActivateTab()
            if IsDestroyed then return end
            
            for _, button in pairs(TabButtonsFrame:GetChildren()) do
                if button:IsA("TextButton") then
                    if button ~= TabButton then
                        local otherTabText = button:FindFirstChild("TabText")
                        
                        SafeTween(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = UDim2.new(0, 0, 0, 0),
                            Size = UDim2.new(1, 0, 0, 35)
                        })
                        
                        if otherTabText then
                            SafeTween(otherTabText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                Position = UDim2.new(0, 0, 0, 0),
                                TextColor3 = Color3.fromRGB(255, 255, 255),
                                TextSize = 14
                            })
                        end
                        
                        button.UIGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
                        })
                        
                        button.AnimatedBorder.Visible = false
                        stopBorderAnimation()
                    end
                end
            end
            
            for _, tab in pairs(ContentFrame:GetChildren()) do
                if tab:IsA("Frame") then
                    tab.Visible = false
                end
            end
            
            local tabText = TabButton:FindFirstChild("TabText")
            
            SafeTween(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, -2, 0, -3),
                Size = UDim2.new(1, 4, 0, 38)
            })
            
            if tabText then
                SafeTween(tabText, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 1, 0, -1),
                    TextColor3 = Color3.fromRGB(220, 240, 255),
                    TextSize = 15
                })
            end
            
            TabButton.UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 200)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
            })
            
            TabButton.AnimatedBorder.Visible = true
            startBorderAnimation()
            
            TabContent.Visible = true
            CurrentActiveTab = TabButton
            
            if TabConfig.Name == "Main" then
                SocialFrame.Visible = true
            else
                SocialFrame.Visible = false
            end
        end
        
        TabButton.MouseButton1Click:Connect(ActivateTab)
        
        TabButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, (#TabButtonsFrame:GetChildren() - 1) * 40)
        
        local Elements = {}
        
        function Elements:AddButton(ButtonConfig)
            ButtonConfig = ButtonConfig or {}
            ButtonConfig.Name = ButtonConfig.Name or "Button"
            ButtonConfig.Callback = ButtonConfig.Callback or function() end
            
            local Button = Create("TextButton", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(40, 40, 80),
                Text = ButtonConfig.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                ClipsDescendants = true,
                ZIndex = 7
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                Create("UIStroke", {
                    Color = Color3.fromRGB(80, 80, 120),
                    Thickness = 1
                }),
                Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
                    }),
                    Rotation = 135
                })
            })
            
            local ButtonRipple = Create("Frame", {
                Parent = Button,
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
                ZIndex = 8
            }, {
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            SetupButtonHover(Button)
            
            Button.MouseButton1Click:Connect(function()
                if IsDestroyed then return end
                SafeTween(Button, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, -5, 0, 32)
                })
                
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local buttonPos = Button.AbsolutePosition
                local buttonSize = Button.AbsoluteSize
                
                local posX = (mouse.X - buttonPos.X) / buttonSize.X
                local posY = (mouse.Y - buttonPos.Y) / buttonSize.Y
                
                ButtonRipple.Position = UDim2.new(posX, 0, posY, 0)
                ButtonRipple.Size = UDim2.new(0, 0, 0, 0)
                ButtonRipple.BackgroundTransparency = 0.7
                
                SafeTween(ButtonRipple, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1
                })
                
                delay(0.1, function()
                    if Button and Button.Parent then
                        SafeTween(Button, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 0, 35)
                        })
                    end
                end)
                
                ButtonConfig.Callback()
            end)
            
            local ButtonFunctions = {}
            function ButtonFunctions:Set(NewText)
                if Button and Button.Parent then
                    Button.Text = NewText
                end
            end
            
            return ButtonFunctions
        end
        
        function Elements:AddLabel(Text)
            local Label = Create("TextLabel", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = Text or "Label",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7,
                TextStrokeTransparency = 0.7,
                TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            })
            
            local LabelFunctions = {}
            function LabelFunctions:Set(NewText)
                if Label and Label.Parent then
                    Label.Text = NewText
                end
            end
            
            return LabelFunctions
        end
        
        function Elements:AddToggle(ToggleConfig)
            ToggleConfig = ToggleConfig or {}
            ToggleConfig.Name = ToggleConfig.Name or "Toggle"
            ToggleConfig.Default = ToggleConfig.Default or false
            ToggleConfig.Callback = ToggleConfig.Callback or function() end
            ToggleConfig.Flag = ToggleConfig.Flag or nil
            
            local Toggle = {Value = ToggleConfig.Default}
            
            local ToggleButton = Create("TextButton", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(40, 40, 80),
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                ClipsDescendants = true,
                ZIndex = 7
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                Create("UIStroke", {
                    Color = Color3.fromRGB(80, 80, 120),
                    Thickness = 1
                }),
                Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
                    }),
                    Rotation = 135
                }),
                Create("TextLabel", {
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    BackgroundTransparency = 1,
                    Text = ToggleConfig.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8,
                    TextStrokeTransparency = 0.7,
                    TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                }),
                Create("Frame", {
                    Name = "ToggleBackground",
                    Position = UDim2.new(1, -35, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 100),
                    AnchorPoint = Vector2.new(0, 0.5),
                    ZIndex = 8
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Create("UIStroke", {
                        Color = Color3.fromRGB(80, 80, 120),
                        Thickness = 1
                    })
                })
            })
            
            local ToggleDot = Create("Frame", {
                Parent = ToggleButton.ToggleBackground,
                Position = UDim2.new(0, 3, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                AnchorPoint = Vector2.new(0, 0.5),
                ZIndex = 9
            }, {
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            SetupButtonHover(ToggleButton)
            
            function Toggle:Set(Value)
                if IsDestroyed then return end
                Toggle.Value = Value
                if Value then
                    SafeTween(ToggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Position = UDim2.new(1, -17, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                    })
                    SafeTween(ToggleButton.ToggleBackground, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(30, 90, 150)
                    })
                    SafeTween(ToggleButton.ToggleBackground.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Color = Color3.fromRGB(0, 150, 255)
                    })
                else
                    SafeTween(ToggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 3, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                    })
                    SafeTween(ToggleButton.ToggleBackground, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(60, 60, 100)
                    })
                    SafeTween(ToggleButton.ToggleBackground.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Color = Color3.fromRGB(80, 80, 120)
                    })
                end
                ToggleConfig.Callback(Toggle.Value)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                if IsDestroyed then return end
                Toggle:Set(not Toggle.Value)
            end)
            
            Toggle:Set(Toggle.Value)
            
            if ToggleConfig.Flag then
                OrionLib.Flags[ToggleConfig.Flag] = Toggle
            end
            
            return Toggle
        end
        
        function Elements:AddDropdown(DropdownConfig)
            DropdownConfig = DropdownConfig or {}
            DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
            DropdownConfig.Options = DropdownConfig.Options or {}
            DropdownConfig.Default = DropdownConfig.Default or 1
            DropdownConfig.Callback = DropdownConfig.Callback or function() end
            DropdownConfig.Flag = DropdownConfig.Flag or nil
            
            local Dropdown = {Value = DropdownConfig.Options[DropdownConfig.Default] or ""}
            local DropdownOpen = false
            
            local DropdownFrame = Create("TextButton", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(40, 40, 80),
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                ClipsDescendants = true,
                ZIndex = 7
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                Create("UIStroke", {
                    Color = Color3.fromRGB(80, 80, 120),
                    Thickness = 1
                }),
                Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
                    }),
                    Rotation = 135
                }),
                Create("TextLabel", {
                    Name = "DropdownName",
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0.5, -10, 1, 0),
                    BackgroundTransparency = 1,
                    Text = DropdownConfig.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8,
                    TextStrokeTransparency = 0.7,
                    TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                }),
                Create("TextLabel", {
                    Name = "DropdownValue",
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, -10, 1, 0),
                    BackgroundTransparency = 1,
                    Text = Dropdown.Value,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 8,
                    TextStrokeTransparency = 0.7,
                    TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                })
            })
            
            local DropdownList = Create("ScrollingFrame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(40, 40, 80),
                BorderSizePixel = 0,
                ScrollBarThickness = 3,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                Visible = false,
                ZIndex = 19
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                Create("UIStroke", {
                    Color = Color3.fromRGB(80, 80, 120),
                    Thickness = 1
                }),
                Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            })
            
            local function UpdateDropdown()
                for _, option in pairs(DropdownList:GetChildren()) do
                    if option:IsA("TextButton") then
                        option:Destroy()
                    end
                end
                
                for i, option in pairs(DropdownConfig.Options) do
                    local OptionButton = Create("TextButton", {
                        Parent = DropdownList,
                        Size = UDim2.new(1, 0, 0, 25),
                        BackgroundColor3 = Color3.fromRGB(50, 50, 90),
                        Text = option,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        ZIndex = 20
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 3)})
                    })
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        Dropdown.Value = option
                        DropdownFrame.DropdownValue.Text = option
                        DropdownConfig.Callback(option)
                        DropdownOpen = false
                        SafeTween(DropdownList, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 0)
                        })
                        wait(0.2)
                        DropdownList.Visible = false
                    end)
                    
                    SetupButtonHover(OptionButton)
                end
                
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, #DropdownConfig.Options * 25)
            end
            
            DropdownFrame.MouseButton1Click:Connect(function()
                if IsDestroyed then return end
                DropdownOpen = not DropdownOpen
                if DropdownOpen then
                    DropdownList.Visible = true
                    SafeTween(DropdownList, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, math.min(#DropdownConfig.Options * 25, 100))
                    })
                else
                    SafeTween(DropdownList, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 0)
                    })
                    wait(0.2)
                    DropdownList.Visible = false
                end
            end)
            
            UpdateDropdown()
            
            if DropdownConfig.Flag then
                OrionLib.Flags[DropdownConfig.Flag] = Dropdown
            end
            
            local DropdownFunctions = {}
            function DropdownFunctions:Set(NewOptions)
                DropdownConfig.Options = NewOptions
                UpdateDropdown()
            end
            
            return DropdownFunctions
        end

        function Elements:AddWarning(Text)
            local WarningFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                BackgroundTransparency = 0.2,
                LayoutOrder = 999
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                Create("UIStroke", {
                    Color = Color3.fromRGB(255, 100, 100),
                    Thickness = 2
                }),
                Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 50, 50))
                    }),
                    Rotation = 90
                }),
                Create("TextLabel", {
                    Size = UDim2.new(1, -20, 1, -10),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Text = Text or "⚠️ WARNING",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    TextStrokeTransparency = 0.7,
                    TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                })
            })
            
            local WarningFunctions = {}
            function WarningFunctions:Set(NewText)
                if WarningFrame and WarningFrame:FindFirstChild("TextLabel") then
                    WarningFrame.TextLabel.Text = NewText
                end
            end
            
            return WarningFunctions
        end
        
        TabContent.ChildAdded:Connect(function()
            if IsDestroyed then return end
            local totalHeight = 0
            for _, child in pairs(TabContent:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
                    totalHeight += child.Size.Y.Offset + 5
                end
            end
            TabContent.Size = UDim2.new(1, -20, 0, totalHeight)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
        end)
        
        return Elements
    end

    task.defer(function()
        if FirstTabContent and not IsDestroyed then
            FirstTabContent.Visible = true
        end
    end)
    
    return Tabs
end

function OrionLib:Destroy()
    Orion:Destroy()
end

local function GetCurrentWorld()
    local player = Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local position = player.Character.HumanoidRootPart.Position
        
        local workspace = game:GetService("Workspace")
        
        if workspace:FindFirstChild("SlayerVillageArea") or 
           workspace:FindFirstChild("Slayer Village") or
           string.find(tostring(workspace:GetChildren()), "Slayer") then
            return "Slayer Village"
        end
        
        if workspace:FindFirstChild("DragonTownArea") or 
           workspace:FindFirstChild("Dragon Town") or
           string.find(tostring(workspace:GetChildren()), "Dragon") then
            return "Dragon Town"
        end
        
        if workspace:FindFirstChild("LeafVillageArea") or 
           workspace:FindFirstChild("Leaf Village") or
           string.find(tostring(workspace:GetChildren()), "Leaf") then
            return "Leaf Village"
        end
        
        if workspace:FindFirstChild("LobbyArea") or 
           workspace:FindFirstChild("Lobby") then
            return "Lobby"
        end
    end
    
    return "Unknown"
end

local KillAnimationEnabled = false
local LastStarFarmTime = 0
local StarFarmCooldown = 0.1

local function StartStarFarm()
    if _G.StarFarmExecuting then
        _G.StarFarmExecuting = false
        return
    end

    _G.StarFarmExecuting = true

    while _G.StarFarmExecuting and task.wait() do
        local currentTime = tick()
        if currentTime - LastStarFarmTime < StarFarmCooldown then
            continue
        end
        
        local args = {
            "General",
            "Star", 
            "Open"
        }
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remotes then
            local bridge = remotes:FindFirstChild("Bridge")
            if bridge then
                local success = pcall(function()
                    if KillAnimationEnabled then
                        bridge:FireServer(unpack(args))
                    else
                        bridge:FireServer(unpack(args))
                    end
                end)
                
                if success then
                    LastStarFarmTime = currentTime
                end
            end
        end
        
        if not _G.StarFarmExecuting then
            break
        end
    end
end

local function EnableKillAnimation()
    if KillAnimationEnabled then
        return
    end
    
    KillAnimationEnabled = true
    
    local success = pcall(function()
        local CoreGui = game:GetService("CoreGui")
        local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        
        if PlayerGui then
            for _, gui in ipairs(PlayerGui:GetDescendants()) do
                if gui:IsA("ScreenGui") and (gui.Name:find("Star") or gui.Name:find("Open") or gui.Name:find("Reward")) then
                    gui.Enabled = false
                end
            end
        end
        
        for _, gui in ipairs(CoreGui:GetDescendants()) do
            if gui:IsA("ScreenGui") and (gui.Name:find("Star") or gui.Name:find("Open") or gui.Name:find("Reward")) then
                gui.Enabled = false
            end
        end
        
        local starAnimationController = workspace:FindFirstChild("Client")
        if starAnimationController then
            starAnimationController = starAnimationController:FindFirstChild("Star")
            if starAnimationController then
                starAnimationController = starAnimationController:FindFirstChild("Model")
                if starAnimationController then
                    starAnimationController = starAnimationController:FindFirstChild("AnimationController")
                    if starAnimationController then
                        starAnimationController:Destroy()
                    end
                end
            end
        end
    end)
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

local function StartAutoFarm()
    if AutoFarm.Executing then
        AutoFarm.Executing = false
        task.wait(0.5)
        return
    end

    if not AutoFarm.CurrentMob or not AutoFarm.CurrentWorld then
        return
    end

    local currentWorld = GetCurrentWorld()

    if currentWorld ~= AutoFarm.CurrentWorld then
        local teleportSuccess = TeleportToWorld(AutoFarm.CurrentWorld)
        
        if not teleportSuccess then
            return
        end
        
        task.wait(1)
    end
    
    AutoFarm.Executing = true

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
                        
                        if mobDied then
                            for i = 1, 5 do
                                if not AutoFarm.Executing then break end
                                task.wait(1)
                            end
                        else
                            task.wait(0.5)
                        end
                        break
                    end
                end
            end
            
            if not foundAnyMob then
                task.wait(1)
            end
            
            if tick() % 10 < 0.1 then
                local currentCheck = GetCurrentWorld()
                if currentCheck ~= AutoFarm.CurrentWorld and currentCheck ~= "Unknown" then
                    AutoFarm.Executing = false
                    break
                end
            end
            
            task.wait(0.1)
        end
    end)
end

local function GetMobsInWorld(worldName)
    if worldName == "Slayer Village" then
        return {"Akaze", "Dake", "Rue", "Kokoshibe", "Muzen"}
    else
        return {}
    end
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

local Window = OrionLib:MakeWindow({
    Name = "Hatching GUI"
})

local MainTab = Window:MakeTab({
    Name = "Main"
})

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

local KillAnimationButton = HatchingTab:AddButton({
    Name = "Kill Animation",
    Callback = function()
        EnableKillAnimation()
    end
})

local AutoFarmTab = Window:MakeTab({
    Name = "AutoFarm"
})

local WorldDropdown
local MobDropdown

WorldDropdown = AutoFarmTab:AddDropdown({
    Name = "Select World",
    Options = {"Leaf Village", "Dragon Town", "Slayer Village"},
    Default = 1,
    Callback = function(Value)
        AutoFarm.CurrentWorld = Value
        local mobs = GetMobsInWorld(Value)
        
        if MobDropdown then
            if #mobs > 0 then
                MobDropdown:Set(mobs)
            else
                MobDropdown:Set({"No mobs available"})
                AutoFarm.CurrentMob = nil
            end
        end
    end
})

MobDropdown = AutoFarmTab:AddDropdown({
    Name = "Mob Type",
    Options = {"Select World First"},
    Default = 1,
    Callback = function(Value)
        if Value ~= "No mobs available" and Value ~= "Select World First" then
            AutoFarm.CurrentMob = Value
        else
            AutoFarm.CurrentMob = nil
        end
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

local Warning = AutoFarmTab:AddWarning("⚠️ REQUIRES:\nAutoAttack + AutoClick")

local TeleportTab = Window:MakeTab({
    Name = "Teleport"
})

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
            TeleportToWorld(worldInfo.WorldName)
        end
    })
end

local MiscTab = Window:MakeTab({
    Name = "Misc"
})

local AntiAFKButton = MiscTab:AddButton({
    Name = "Enable Anti-AFK",
    Callback = function()
        EnableAntiAFK()
    end
})

task.spawn(function()
    wait(1)
    if WorldDropdown then
        AutoFarm.CurrentWorld = "Leaf Village"
        local mobs = GetMobsInWorld("Leaf Village")
        MobDropdown:Set(mobs)
    end
end)

print("Successfully loaded! Press Right Shift to toggle GUI")

return OrionLib
