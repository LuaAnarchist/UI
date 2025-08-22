-- Library UI
local Library = {}

local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        Header = Color3.fromRGB(35, 35, 35),
        Text = Color3.fromRGB(255, 255, 255),
        Button = Color3.fromRGB(60, 60, 60)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Header = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(0, 0, 0),
        Button = Color3.fromRGB(220, 220, 220)
    },
    Blue = {
        Background = Color3.fromRGB(20, 25, 60),
        Header = Color3.fromRGB(40, 80, 160),
        Text = Color3.fromRGB(255, 255, 255),
        Button = Color3.fromRGB(70, 120, 200)
    },
    Green = {
        Background = Color3.fromRGB(20, 60, 30),
        Header = Color3.fromRGB(40, 120, 60),
        Text = Color3.fromRGB(255, 255, 255),
        Button = Color3.fromRGB(70, 160, 90)
    }
}

local function StyleUI(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

function Library:CreateWindow(cfg)
    local Folder = cfg.Folder or "MyHub"
    local Title = cfg.Title or "Hub"
    local Author = cfg.Author or "Unknown"
    local Size = cfg.Size or UDim2.fromOffset(500, 350)
    local Theme = Themes[cfg.Theme] or Themes.Dark

    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = Folder

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = Size
    Main.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    Main.BackgroundColor3 = Theme.Background
    Main.Active = true
    Main.Draggable = true
    StyleUI(Main, 8)

    -- Header
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = Theme.Header
    StyleUI(Header, 8)

    local TitleLabel = Instance.new("TextLabel", Header)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local AuthorLabel = Instance.new("TextLabel", Header)
    AuthorLabel.Size = UDim2.new(0, 150, 1, 0)
    AuthorLabel.Position = UDim2.new(0, 220, 0, 0)
    AuthorLabel.BackgroundTransparency = 1
    AuthorLabel.Text = "by " .. Author
    AuthorLabel.TextColor3 = Theme.Text
    AuthorLabel.Font = Enum.Font.SourceSans
    AuthorLabel.TextSize = 14
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Hide Button
    local HideButton = Instance.new("TextButton", Header)
    HideButton.Size = UDim2.new(0, 30, 0, 25)
    HideButton.Position = UDim2.new(1, -70, 0.5, -12)
    HideButton.BackgroundColor3 = Theme.Button
    HideButton.Text = "-"
    HideButton.TextColor3 = Theme.Text
    StyleUI(HideButton, 6)

    -- Exit Button
    local ExitButton = Instance.new("TextButton", Header)
    ExitButton.Size = UDim2.new(0, 30, 0, 25)
    ExitButton.Position = UDim2.new(1, -35, 0.5, -12)
    ExitButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ExitButton.Text = "X"
    ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StyleUI(ExitButton, 6)

    ExitButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local hidden = false
    HideButton.MouseButton1Click:Connect(function()
        hidden = not hidden
        for _, v in pairs(Main:GetChildren()) do
            if v ~= Header then
                v.Visible = not hidden
            end
        end
        HideButton.Text = hidden and "+" or "-"
    end)

    -- Tab container
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(0, 120, 1, -35)
    TabHolder.Position = UDim2.new(0, 0, 0, 35)
    TabHolder.BackgroundColor3 = Theme.Header
    StyleUI(TabHolder, 6)

    local TabButtons = Instance.new("Frame", TabHolder)
    TabButtons.Size = UDim2.new(1, 0, 1, 0)
    TabButtons.BackgroundTransparency = 1

    local TabList = Instance.new("UIListLayout", TabButtons)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -120, 1, -35)
    Pages.Position = UDim2.new(0, 120, 0, 35)
    Pages.BackgroundTransparency = 1

    local Tabs = {}

    function Library:Tab(cfg)
        local TabName = cfg.Title or "Tab"

        local TabButton = Instance.new("TextButton", TabButtons)
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Text = TabName
        TabButton.BackgroundColor3 = Theme.Button
        TabButton.TextColor3 = Theme.Text
        StyleUI(TabButton, 6)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 6

        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 6)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        if #Pages:GetChildren() == 1 then
            Page.Visible = true
        end

        local TabAPI = {}

        function TabAPI:Button(txt, callback)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(0, 200, 0, 30)
            b.Text = txt
            b.BackgroundColor3 = Theme.Button
            b.TextColor3 = Theme.Text
            StyleUI(b, 6)
            b.MouseButton1Click:Connect(callback)
        end

        function TabAPI:Toggle(txt, callback)
            local t = Instance.new("TextButton", Page)
            t.Size = UDim2.new(0, 200, 0, 30)
            t.BackgroundColor3 = Theme.Button
            t.TextColor3 = Theme.Text
            t.Text = txt .. ": OFF"
            StyleUI(t, 6)
            local state = false
            t.MouseButton1Click:Connect(function()
                state = not state
                t.Text = txt .. ": " .. (state and "ON" or "OFF")
                callback(state)
            end)
        end

        function TabAPI:Dropdown(txt, list, callback)
            local d = Instance.new("TextButton", Page)
            d.Size = UDim2.new(0, 200, 0, 30)
            d.BackgroundColor3 = Theme.Button
            d.TextColor3 = Theme.Text
            d.Text = txt .. " ▼"
            StyleUI(d, 6)

            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(0, 200, 0, #list * 25)
            Frame.BackgroundColor3 = Theme.Header
            Frame.Visible = false
            StyleUI(Frame, 6)

            local layout = Instance.new("UIListLayout", Frame)
            layout.SortOrder = Enum.SortOrder.LayoutOrder

            for _, v in ipairs(list) do
                local opt = Instance.new("TextButton", Frame)
                opt.Size = UDim2.new(1, 0, 0, 25)
                opt.BackgroundColor3 = Theme.Button
                opt.TextColor3 = Theme.Text
                opt.Text = v
                StyleUI(opt, 6)
                opt.MouseButton1Click:Connect(function()
                    d.Text = txt .. ": " .. v
                    Frame.Visible = false
                    callback(v)
                end)
            end

            d.MouseButton1Click:Connect(function()
                Frame.Visible = not Frame.Visible
            end)
        end

        Tabs[TabName] = TabAPI
        return TabAPI
    end

    return Library
end

return Library
