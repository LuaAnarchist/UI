--// UI Library Rebuild with Animation & Dark Theme
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

-- Theme colors
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25,25,25),
        Topbar = Color3.fromRGB(20,20,20),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(230,230,230)
    },
    Blue = {
        Background = Color3.fromRGB(15,20,30),
        Topbar = Color3.fromRGB(10,15,25),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(240,240,240)
    },
    Green = {
        Background = Color3.fromRGB(20,25,20),
        Topbar = Color3.fromRGB(15,20,15),
        Accent = Color3.fromRGB(0, 200, 100),
        Text = Color3.fromRGB(240,240,240)
    }
}

--// CreateWindow
function Library:CreateWindow(config)
    local theme = Themes[config.Theme] or Themes.Dark

    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = config.Size or UDim2.fromOffset(420, 340)
    MainFrame.Position = UDim2.fromScale(0.5,0.5)
    MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0,8)

    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(0,0,0)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.4

    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1,0,0,30)
    Topbar.BackgroundColor3 = theme.Topbar
    Topbar.BorderSizePixel = 0
    Topbar.Active = true
    Topbar.Draggable = true

    local Title = Instance.new("TextLabel", Topbar)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(0,200,1,0)
    Title.Position = UDim2.new(0,8,0,0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = (config.Title or "Untitled") .. " | " .. (config.Author or "")
    Title.TextColor3 = theme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local BtnFrame = Instance.new("Frame", Topbar)
    BtnFrame.BackgroundTransparency = 1
    BtnFrame.Size = UDim2.new(0,80,1,0)
    BtnFrame.Position = UDim2.new(1,-85,0,0)

    local function CreateBtn(txt)
        local b = Instance.new("TextButton", BtnFrame)
        b.Size = UDim2.new(0,25,0,25)
        b.Position = UDim2.new(0, (#BtnFrame:GetChildren()-1)*28, 0.5, -12)
        b.Text = txt
        b.BackgroundColor3 = theme.Topbar
        b.TextColor3 = theme.Text
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        local c = Instance.new("UICorner", b)
        c.CornerRadius = UDim.new(0,4)
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = theme.Topbar}):Play()
        end)
        return b
    end

    local MinBtn = CreateBtn("-")
    local CloseBtn = CreateBtn("X")

    -- Tab Holder
    local TabHolder = Instance.new("Frame", MainFrame)
    TabHolder.Size = UDim2.new(0,120,1,-30)
    TabHolder.Position = UDim2.new(0,0,0,30)
    TabHolder.BackgroundColor3 = theme.Topbar
    TabHolder.BorderSizePixel = 0

    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1,-120,1,-30)
    Content.Position = UDim2.new(0,120,0,30)
    Content.BackgroundTransparency = 1

    -- Logic
    local Window = {}
    Window.Tabs = {}

    function Window:Tab(info)
        local TabBtn = Instance.new("TextButton", TabHolder)
        TabBtn.Size = UDim2.new(1,0,0,30)
        TabBtn.Text = info.Title or "Tab"
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.TextColor3 = theme.Text
        TabBtn.BackgroundColor3 = theme.Topbar
        TabBtn.BorderSizePixel = 0

        local TabContent = Instance.new("Frame", Content)
        TabContent.Size = UDim2.new(1,0,1,0)
        TabContent.Visible = false
        TabContent.BackgroundTransparency = 1

        local List = Instance.new("UIListLayout", TabContent)
        List.Padding = UDim.new(0,6)
        List.SortOrder = Enum.SortOrder.LayoutOrder

        TabBtn.MouseButton1Click:Connect(function()
            for _,tb in pairs(Content:GetChildren()) do
                if tb:IsA("Frame") then tb.Visible = false end
            end
            TabContent.Visible = true
        end)

        local Tab = {}

        function Tab:Button(txt, callback)
            local btn = Instance.new("TextButton", TabContent)
            btn.Size = UDim2.new(0,150,0,30)
            btn.Text = txt
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = theme.Text
            btn.BackgroundColor3 = theme.Background
            local c = Instance.new("UICorner", btn)
            c.CornerRadius = UDim.new(0,4)
            btn.MouseButton1Click:Connect(callback)
        end

        function Tab:Toggle(txt, callback)
            local frame = Instance.new("Frame", TabContent)
            frame.Size = UDim2.new(0,150,0,30)
            frame.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", frame)
            lbl.Size = UDim2.new(0.7,0,1,0)
            lbl.Text = txt
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14
            lbl.TextColor3 = theme.Text

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(0.3,0,0.8,0)
            btn.Position = UDim2.new(0.7,0,0.1,0)
            btn.Text = "OFF"
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.TextColor3 = theme.Text
            btn.BackgroundColor3 = theme.Background
            local c = Instance.new("UICorner", btn)
            c.CornerRadius = UDim.new(0,4)

            local state = false
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = state and "ON" or "OFF"
                TweenService:Create(btn, TweenInfo.new(0.25), {
                    BackgroundColor3 = state and theme.Accent or theme.Background
                }):Play()
                callback(state)
            end)
        end

        function Tab:Dropdown(txt, list, callback)
            local frame = Instance.new("Frame", TabContent)
            frame.Size = UDim2.new(0,150,0,30)
            frame.BackgroundColor3 = theme.Background
            local c = Instance.new("UICorner", frame)
            c.CornerRadius = UDim.new(0,4)

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(1,0,1,0)
            btn.BackgroundTransparency = 1
            btn.Text = txt.." ▼"
            btn.TextColor3 = theme.Text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14

            local listFrame = Instance.new("Frame", frame)
            listFrame.Size = UDim2.new(1,0,0,0)
            listFrame.Position = UDim2.new(0,0,1,0)
            listFrame.BackgroundColor3 = theme.Topbar
            listFrame.Visible = false
            local l = Instance.new("UIListLayout", listFrame)

            for _,v in pairs(list) do
                local opt = Instance.new("TextButton", listFrame)
                opt.Size = UDim2.new(1,0,0,25)
                opt.Text = v
                opt.Font = Enum.Font.Gotham
                opt.TextSize = 13
                opt.TextColor3 = theme.Text
                opt.BackgroundColor3 = theme.Background
                opt.MouseButton1Click:Connect(function()
                    callback(v)
                    btn.Text = v.." ▼"
                    listFrame.Visible = false
                    listFrame.Size = UDim2.new(1,0,0,0)
                end)
            end

            btn.MouseButton1Click:Connect(function()
                listFrame.Visible = not listFrame.Visible
                TweenService:Create(listFrame, TweenInfo.new(0.25), {
                    Size = listFrame.Visible and UDim2.new(1,0,0,#list*25) or UDim2.new(1,0,0,0)
                }):Play()
            end)
        end

        return Tab
    end

    -- Btn logic
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    MinBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.fromOffset(0,0), Transparency = 1}):Play()
        wait(0.3)
        MainFrame.Visible = false
    end)
    UserInputService.InputBegan:Connect(function(input,gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = config.Size, Transparency = 0}):Play()
        end
    end)

    return Window
end

return Library
