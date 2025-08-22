local TweenService = game:GetService("TweenService")

local Library = {}

function Library:CreateWindow(config)
    local Title = config.Title or "UI Hub"
    local Author = config.Author or "Unknown"
    local Size = config.Size or UDim2.fromOffset(600, 400)
    local Theme = {
        Background = Color3.fromRGB(30, 30, 30),
        Header = Color3.fromRGB(20, 20, 20),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 170, 255)
    }

    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = Size
    Main.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = 0.05
    Main.ClipsDescendants = true
    Main.ZIndex = 1

    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(0, 0, 0)
    Stroke.Thickness = 2
    Stroke.Transparency = 0.4
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Shadow = Instance.new("ImageLabel", Main)
    Shadow.ZIndex = 0
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5028857472"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(24, 24, 276, 276)

    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundColor3 = Theme.Header
    Header.ZIndex = 2

    local TitleLabel = Instance.new("TextLabel", Header)
    TitleLabel.AutomaticSize = Enum.AutomaticSize.X
    TitleLabel.Size = UDim2.new(0, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 3

    local AuthorLabel = Instance.new("TextLabel", Header)
    AuthorLabel.AutomaticSize = Enum.AutomaticSize.X
    AuthorLabel.Size = UDim2.new(0, 0, 1, 0)
    AuthorLabel.Position = UDim2.new(0, TitleLabel.AbsoluteSize.X + 20, 0, 0)
    AuthorLabel.BackgroundTransparency = 1
    AuthorLabel.Text = " | by " .. Author
    AuthorLabel.TextColor3 = Theme.Text
    AuthorLabel.Font = Enum.Font.SourceSans
    AuthorLabel.TextSize = 14
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
    AuthorLabel.ZIndex = 3

    TitleLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        AuthorLabel.Position = UDim2.new(0, TitleLabel.AbsoluteSize.X + 20, 0, 0)
    end)

    local Close = Instance.new("TextButton", Header)
    Close.Size = UDim2.fromOffset(30, 30)
    Close.Position = UDim2.new(1, -30, 0, 0)
    Close.BackgroundTransparency = 1
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 70, 70)
    Close.Font = Enum.Font.SourceSansBold
    Close.TextSize = 18
    Close.ZIndex = 3

    local Minimize = Instance.new("TextButton", Header)
    Minimize.Size = UDim2.fromOffset(30, 30)
    Minimize.Position = UDim2.new(1, -65, 0, 0)
    Minimize.BackgroundTransparency = 1
    Minimize.Text = "-"
    Minimize.TextColor3 = Theme.Text
    Minimize.Font = Enum.Font.SourceSansBold
    Minimize.TextSize = 18
    Minimize.ZIndex = 3

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, 0, 1, -30)
    Content.Position = UDim2.new(0, 0, 0, 30)
    Content.BackgroundTransparency = 1
    Content.ZIndex = 1

    -- Ẩn/hiện toàn bộ UI (có cả viền + shadow)
    local hidden = false
    Minimize.MouseButton1Click:Connect(function()
        hidden = not hidden
        if hidden then
            TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(0, 0),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(Main, TweenInfo.new(0.35), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
            TweenService:Create(Shadow, TweenInfo.new(0.35), {ImageTransparency = 1}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.35), {Transparency = 1}):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = Size,
                BackgroundTransparency = 0.05
            }):Play()
            TweenService:Create(Main, TweenInfo.new(0.35), {Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)}):Play()
            TweenService:Create(Shadow, TweenInfo.new(0.35), {ImageTransparency = 0.5}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.35), {Transparency = 0.4}):Play()
        end
    end)

    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    return Main, Content
end

return Library
