-- main.lua | UI Library fix full đen Dark Mode

local Library = {}
Library.__index = Library

-- Các theme màu
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        Topbar = Color3.fromRGB(30, 30, 30),
        Button = Color3.fromRGB(50, 50, 50),
        Tab = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        Topbar = Color3.fromRGB(230, 230, 230),
        Button = Color3.fromRGB(210, 210, 210),
        Tab = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(0, 0, 0)
    },
    Blue = {
        Background = Color3.fromRGB(20, 20, 35),
        Topbar = Color3.fromRGB(30, 30, 60),
        Button = Color3.fromRGB(40, 40, 80),
        Tab = Color3.fromRGB(35, 35, 70),
        Text = Color3.fromRGB(200, 200, 255)
    },
    Green = {
        Background = Color3.fromRGB(20, 35, 20),
        Topbar = Color3.fromRGB(30, 60, 30),
        Button = Color3.fromRGB(40, 80, 40),
        Tab = Color3.fromRGB(35, 70, 35),
        Text = Color3.fromRGB(200, 255, 200)
    }
}

-- Tạo Window
function Library:CreateWindow(config)
    local theme = Themes[config.Theme] or Themes.Dark

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = config.Size or UDim2.fromOffset(420, 340)
    MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset/2, 0.5, -MainFrame.Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- Hiệu ứng bo viền mờ
    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(0,0,0)
    UIStroke.Transparency = 0.3

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 30)
    Topbar.BackgroundColor3 = theme.Topbar
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame

    -- Title + Author
    local Title = Instance.new("TextLabel")
    Title.Text = config.Title .. " | " .. config.Author
    Title.Size = UDim2.new(1, -90, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 16
    Title.TextColor3 = theme.Text
    Title.Parent = Topbar

    -- Nút minimize (-)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 1, 0)
    MinBtn.Position = UDim2.new(1, -60, 0, 0)
    MinBtn.Text = "-"
    MinBtn.Font = Enum.Font.SourceSansBold
    MinBtn.TextSize = 18
    MinBtn.TextColor3 = theme.Text
    MinBtn.BackgroundColor3 = theme.Button
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = Topbar

    -- Nút close (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.Text = "X"
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.TextSize = 18
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = Topbar

    -- Content
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, 0, 1, -30)
    Content.Position = UDim2.new(0, 0, 0, 30)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- Tabs list
    local TabList = Instance.new("Frame")
    TabList.Size = UDim2.new(0, 100, 1, 0)
    TabList.BackgroundColor3 = theme.Tab
    TabList.BorderSizePixel = 0
    TabList.Parent = Content

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -100, 1, 0)
    Pages.Position = UDim2.new(0, 100, 0, 0)
    Pages.BackgroundColor3 = theme.Background
    Pages.BorderSizePixel = 0
    Pages.Parent = Content

    local TabFolder = Instance.new("Folder", Pages)

    local Window = {}
    Window.Tabs = {}

    function Window:Tab(info)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.Text = info.Title
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.TextSize = 16
        TabBtn.TextColor3 = theme.Text
        TabBtn.BackgroundTransparency = 1
        TabBtn.Parent = TabList

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 4
        TabPage.Parent = TabFolder

        local UIList = Instance.new("UIListLayout", TabPage)
        UIList.Padding = UDim.new(0, 5)
        UIList.FillDirection = Enum.FillDirection.Vertical
        UIList.SortOrder = Enum.SortOrder.LayoutOrder

        TabBtn.MouseButton1Click:Connect(function()
            for _, page in ipairs(TabFolder:GetChildren()) do
                page.Visible = false
            end
            TabPage.Visible = true
        end)

        local TabFuncs = {}
        function TabFuncs:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 200, 0, 30)
            Btn.Text = text
            Btn.Font = Enum.Font.SourceSansBold
            Btn.TextSize = 16
            Btn.TextColor3 = theme.Text
            Btn.BackgroundColor3 = theme.Button
            Btn.Parent = TabPage
            Btn.MouseButton1Click:Connect(callback)
        end

        function TabFuncs:Toggle(text, callback)
            local state = false
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 200, 0, 30)
            Btn.Text = text .. ": OFF"
            Btn.Font = Enum.Font.SourceSansBold
            Btn.TextSize = 16
            Btn.TextColor3 = theme.Text
            Btn.BackgroundColor3 = theme.Button
            Btn.Parent = TabPage
            Btn.MouseButton1Click:Connect(function()
                state = not state
                Btn.Text = text .. (state and ": ON" or ": OFF")
                callback(state)
            end)
        end

        function TabFuncs:Dropdown(text, options, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 200, 0, 30)
            Btn.Text = text
            Btn.Font = Enum.Font.SourceSansBold
            Btn.TextSize = 16
            Btn.TextColor3 = theme.Text
            Btn.BackgroundColor3 = theme.Button
            Btn.Parent = TabPage

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(0, 200, 0, #options * 25)
            DropFrame.Position = UDim2.new(0, 0, 0, 30)
            DropFrame.BackgroundColor3 = theme.Tab
            DropFrame.Visible = false
            DropFrame.Parent = Btn

            local UIList = Instance.new("UIListLayout", DropFrame)
            UIList.SortOrder = Enum.SortOrder.LayoutOrder

            for _, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 25)
                OptBtn.Text = opt
                OptBtn.TextSize = 14
                OptBtn.Font = Enum.Font.SourceSans
                OptBtn.TextColor3 = theme.Text
                OptBtn.BackgroundTransparency = 1
                OptBtn.Parent = DropFrame

                OptBtn.MouseButton1Click:Connect(function()
                    Btn.Text = text .. ": " .. opt
                    DropFrame.Visible = false
                    callback(opt)
                end)
            end

            Btn.MouseButton1Click:Connect(function()
                DropFrame.Visible = not DropFrame.Visible
            end)
        end

        Window.Tabs[info.Title] = TabFuncs
        if #TabFolder:GetChildren() == 1 then
            TabPage.Visible = true
        end
        return TabFuncs
    end

    -- Ẩn hiện UI
    MinBtn.MouseButton1Click:Connect(function()
        Content.Visible = not Content.Visible
    end)

    -- Đóng UI
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    return Window
end

return Library
