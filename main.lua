local Library = {}

function Library:CreateWindow(config)
    local UIS = game:GetService("UserInputService")

    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local MainFrame = Instance.new("Frame", ScreenGui)
    local TopBar = Instance.new("Frame", MainFrame)
    local Title = Instance.new("TextLabel", TopBar)
    local CloseBtn = Instance.new("TextButton", TopBar)
    local MinBtn = Instance.new("TextButton", TopBar)
    local TabFrame = Instance.new("Frame", MainFrame)
    local Content = Instance.new("Frame", MainFrame)
    local UIListLayout = Instance.new("UIListLayout", TabFrame)

    ScreenGui.Name = config.Folder or "MyHub"
    MainFrame.Size = config.Size or UDim2.fromOffset(420, 340)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- TopBar
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TopBar.BorderSizePixel = 0

    -- Title
    Title.Text = (config.Title or "Name Hub") .. " | " .. (config.Author or "")
    Title.Size = UDim2.new(1, -90, 1, 0)
    Title.Position = UDim2.new(0, 5, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    -- CloseBtn (X)
    CloseBtn.Text = "X"
    CloseBtn.Size = UDim2.fromOffset(30, 30)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14

    -- MinBtn (-)
    MinBtn.Text = "-"
    MinBtn.Size = UDim2.fromOffset(30, 30)
    MinBtn.Position = UDim2.new(1, -60, 0, 0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14

    -- TabFrame
    TabFrame.Size = UDim2.new(0, 100, 1, -30)
    TabFrame.Position = UDim2.new(0, 0, 0, 30)
    TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    -- Content
    Content.Size = UDim2.new(1, -100, 1, -30)
    Content.Position = UDim2.new(0, 100, 0, 30)
    Content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    -- Close event
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Minimize (ẩn toàn bộ UI)
    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)

    -- Phím tắt để bật lại
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local Window = {}
    local Tabs = {}

    function Window:Tab(tabConfig)
        local TabBtn = Instance.new("TextButton", TabFrame)
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.Text = tabConfig.Title or "Tab"
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14

        local TabContent = Instance.new("ScrollingFrame", Content)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.BackgroundTransparency = 1
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)

        local List = Instance.new("UIListLayout", TabContent)
        List.Padding = UDim.new(0, 5)
        List.SortOrder = Enum.SortOrder.LayoutOrder

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Content.Visible = false
            end
            TabContent.Visible = true
        end)

        local Elements = {}

        function Elements:Button(txt, callback)
            local Btn = Instance.new("TextButton", TabContent)
            Btn.Size = UDim2.new(0, 200, 0, 30)
            Btn.Text = txt
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.MouseButton1Click:Connect(callback)
            return Btn
        end

        function Elements:Toggle(txt, callback)
            local Btn = Instance.new("TextButton", TabContent)
            Btn.Size = UDim2.new(0, 200, 0, 30)
            Btn.Text = txt .. ": OFF"
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14

            local state = false
            Btn.MouseButton1Click:Connect(function()
                state = not state
                Btn.Text = txt .. ": " .. (state and "ON" or "OFF")
                callback(state)
            end)
            return Btn
        end

        function Elements:Dropdown(txt, list, callback)
            local DD = Instance.new("TextButton", TabContent)
            DD.Size = UDim2.new(0, 200, 0, 30)
            DD.Text = txt .. " ▼"
            DD.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            DD.TextColor3 = Color3.fromRGB(255, 255, 255)
            DD.Font = Enum.Font.Gotham
            DD.TextSize = 14

            local Open = false
            DD.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    for _, v in ipairs(list) do
                        local Opt = Instance.new("TextButton", TabContent)
                        Opt.Size = UDim2.new(0, 200, 0, 25)
                        Opt.Text = v
                        Opt.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                        Opt.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Opt.Font = Enum.Font.Gotham
                        Opt.TextSize = 14
                        Opt.MouseButton1Click:Connect(function()
                            callback(v)
                            Opt:Destroy()
                            Open = false
                        end)
                    end
                end
            end)

            return DD
        end

        Tabs[#Tabs+1] = { Button = TabBtn, Content = TabContent }
        if #Tabs == 1 then
            TabContent.Visible = true
        end

        return Elements
    end

    return Window
end

return Library
