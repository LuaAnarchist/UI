local Library = {}

local function StyleUI(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = obj

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Transparency = 0.8
    stroke.Parent = obj
end

local Themes = {
    Dark = {
        Background = Color3.fromRGB(25,25,25),
        Panel = Color3.fromRGB(35,35,35),
        Content = Color3.fromRGB(45,45,45),
        Header = Color3.fromRGB(40,40,40),
        Text = Color3.fromRGB(255,255,255)
    },
    Light = {
        Background = Color3.fromRGB(240,240,240),
        Panel = Color3.fromRGB(220,220,220),
        Content = Color3.fromRGB(230,230,230),
        Header = Color3.fromRGB(200,200,200),
        Text = Color3.fromRGB(0,0,0)
    },
    Blue = {
        Background = Color3.fromRGB(20,30,60),
        Panel = Color3.fromRGB(30,45,90),
        Content = Color3.fromRGB(40,60,120),
        Header = Color3.fromRGB(0,120,215),
        Text = Color3.fromRGB(255,255,255)
    },
    Green = {
        Background = Color3.fromRGB(20,50,20),
        Panel = Color3.fromRGB(30,90,30),
        Content = Color3.fromRGB(50,120,50),
        Header = Color3.fromRGB(0,150,80),
        Text = Color3.fromRGB(255,255,255)
    }
}

function Library:CreateWindow(config)
    config = config or {}
    local Folder = config.Folder or "Hub"
    local Title = config.Title or "My Hub"
    local Author = config.Author or "Unknown"
    local Size = config.Size or UDim2.fromOffset(720, 500)
    local Transparent = config.Transparent or false
    local ThemeName = config.Theme or "Dark"
    local Theme = Themes[ThemeName] or Themes.Dark

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Folder
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = Size
    Main.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = 1
    Main.Parent = ScreenGui
    Main.Active = true
    Main.Draggable = true
    StyleUI(Main, 12)

    game:GetService("TweenService"):Create(
        Main,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = Transparent and 0.2 or 0}
    ):Play()

    local Header = Instance.new("TextLabel", Main)
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Theme.Header
    Header.Text = Title .. " | " .. Author
    Header.TextColor3 = Theme.Text
    Header.Font = Enum.Font.SourceSansBold
    Header.TextSize = 18
    Header.BackgroundTransparency = 1
    StyleUI(Header, 8)

    game:GetService("TweenService"):Create(
        Header,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}
    ):Play()

    local TabPanel = Instance.new("Frame", Main)
    TabPanel.Size = UDim2.new(0, 150, 1, -40)
    TabPanel.Position = UDim2.new(0,0,0,40)
    TabPanel.BackgroundColor3 = Theme.Panel
    TabPanel.BackgroundTransparency = 1
    StyleUI(TabPanel, 8)

    game:GetService("TweenService"):Create(
        TabPanel,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}
    ):Play()

    local ContentPanel = Instance.new("Frame", Main)
    ContentPanel.Size = UDim2.new(1, -150, 1, -40)
    ContentPanel.Position = UDim2.new(0,150,0,40)
    ContentPanel.BackgroundColor3 = Theme.Content
    ContentPanel.BackgroundTransparency = 1
    StyleUI(ContentPanel, 8)

    game:GetService("TweenService"):Create(
        ContentPanel,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}
    ):Play()

    local Window = {}
    Window.Tabs = {}

    function Window:Tab(tabConfig)
        tabConfig = tabConfig or {}
        local TabTitle = tabConfig.Title or "Tab"

        local TabButton = Instance.new("TextButton", TabPanel)
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Position = UDim2.new(0, 5, 0, #TabPanel:GetChildren()*40)
        TabButton.Text = TabTitle
        TabButton.BackgroundColor3 = Theme.Panel
        TabButton.TextColor3 = Theme.Text
        StyleUI(TabButton, 6)

        local TabContent = Instance.new("Frame", ContentPanel)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.BackgroundTransparency = 1

        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(ContentPanel:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            TabContent.Visible = true
        end)

        local Tab = {}
        Tab.Content = TabContent

        function Tab:Button(text, callback)
            local Btn = Instance.new("TextButton", TabContent)
            Btn.Size = UDim2.new(0, 200, 0, 35)
            Btn.Position = UDim2.new(0, 20, 0, #TabContent:GetChildren()*40)
            Btn.Text = text
            Btn.BackgroundColor3 = Theme.Header
            Btn.TextColor3 = Theme.Text
            StyleUI(Btn, 6)
            Btn.MouseButton1Click:Connect(callback)
        end

        function Tab:Toggle(text, callback)
            local Toggled = false
            local Btn = Instance.new("TextButton", TabContent)
            Btn.Size = UDim2.new(0, 200, 0, 35)
            Btn.Position = UDim2.new(0, 20, 0, #TabContent:GetChildren()*40)
            Btn.Text = text .. ": OFF"
            Btn.BackgroundColor3 = Theme.Panel
            Btn.TextColor3 = Color3.fromRGB(255,0,0)
            StyleUI(Btn, 6)

            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Btn.Text = text .. (Toggled and ": ON" or ": OFF")
                Btn.TextColor3 = Toggled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
                callback(Toggled)
            end)
        end

        function Tab:Dropdown(text, list, callback)
            local DropMain = Instance.new("TextButton", TabContent)
            DropMain.Size = UDim2.new(0, 200, 0, 35)
            DropMain.Position = UDim2.new(0, 20, 0, #TabContent:GetChildren()*40)
            DropMain.Text = text .. " ▼"
            DropMain.BackgroundColor3 = Theme.Header
            DropMain.TextColor3 = Theme.Text
            StyleUI(DropMain, 6)

            local DropFrame = Instance.new("Frame", TabContent)
            DropFrame.Size = UDim2.new(0, 200, 0, 0)
            DropFrame.Position = DropMain.Position + UDim2.new(0,0,0,35)
            DropFrame.BackgroundColor3 = Theme.Content
            DropFrame.ClipsDescendants = true
            StyleUI(DropFrame, 6)

            local expanded = false
            DropMain.MouseButton1Click:Connect(function()
                expanded = not expanded
                local newSize = expanded and (#list*30) or 0
                DropFrame:TweenSize(UDim2.new(0,200,0,newSize), "Out", "Quad", 0.3, true)
            end)

            for i, v in ipairs(list) do
                local Opt = Instance.new("TextButton", DropFrame)
                Opt.Size = UDim2.new(1, 0, 0, 30)
                Opt.Position = UDim2.new(0, 0, 0, (i-1)*30)
                Opt.Text = v
                Opt.BackgroundColor3 = Theme.Panel
                Opt.TextColor3 = Theme.Text
                StyleUI(Opt, 6)
                Opt.MouseButton1Click:Connect(function()
                    DropMain.Text = text .. ": " .. v .. " ▼"
                    callback(v)
                end)
            end
        end

        return Tab
    end

    return Window
end

return Library
