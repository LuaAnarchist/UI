-- 🌌 Custom UI Library Full
local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Tạo Window
function Library:CreateWindow(config)
    local Window = {}
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.ResetOnSpawn = false

    -- Main Frame
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = config.Size or UDim2.fromOffset(420, 340)
    Main.Position = UDim2.new(0.5, -Main.Size.X.Offset/2, 0.5, -Main.Size.Y.Offset/2)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true

    -- Viền mờ
    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 6)

    local UIStroke = Instance.new("UIStroke", Main)
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(0,0,0)
    UIStroke.Transparency = 0.3

    -- Shadow
    local Shadow = Instance.new("ImageLabel", Main)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.Image = "rbxassetid://5028857084"
    Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    Shadow.ImageTransparency = 0.5
    Shadow.BackgroundTransparency = 1
    Shadow.ZIndex = 0

    -- Header
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Header.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Header)
    Title.Text = (config.Title or "My Hub") .. " | " .. (config.Author or "")
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 8, 0, 0)
    Title.Size = UDim2.new(1, -100, 1, 0)

    -- Nút X
    local Exit = Instance.new("TextButton", Header)
    Exit.Size = UDim2.new(0, 30, 1, 0)
    Exit.Position = UDim2.new(1, -30, 0, 0)
    Exit.Text = "X"
    Exit.Font = Enum.Font.GothamBold
    Exit.TextSize = 14
    Exit.TextColor3 = Color3.fromRGB(255,255,255)
    Exit.BackgroundColor3 = Color3.fromRGB(200,0,0)
    Exit.BorderSizePixel = 0

    Exit.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Nút ẩn hiện
    local Minimize = Instance.new("TextButton", Header)
    Minimize.Size = UDim2.new(0, 30, 1, 0)
    Minimize.Position = UDim2.new(1, -60, 0, 0)
    Minimize.Text = "-"
    Minimize.Font = Enum.Font.GothamBold
    Minimize.TextSize = 18
    Minimize.TextColor3 = Color3.fromRGB(255,255,255)
    Minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Minimize.BorderSizePixel = 0

    local Minimized = false
    Minimize.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Minimized and UDim2.fromOffset(Main.Size.X.Offset, 30) or (config.Size or UDim2.fromOffset(420, 340))
        }):Play()
    end)

    -- Tab Holder
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(0, 120, 1, -30)
    TabHolder.Position = UDim2.new(0, 0, 0, 30)
    TabHolder.BackgroundColor3 = Color3.fromRGB(30,30,30)
    TabHolder.BorderSizePixel = 0

    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Content Holder
    local ContentHolder = Instance.new("Frame", Main)
    ContentHolder.Size = UDim2.new(1, -120, 1, -30)
    ContentHolder.Position = UDim2.new(0, 120, 0, 30)
    ContentHolder.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ContentHolder.BorderSizePixel = 0

    -- Tab System
    function Window:Tab(cfg)
        local TabButton = Instance.new("TextButton", TabHolder)
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Text = cfg.Title or "Tab"
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.TextColor3 = Color3.fromRGB(255,255,255)
        TabButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
        TabButton.BorderSizePixel = 0

        local Content = Instance.new("Frame", ContentHolder)
        Content.Size = UDim2.new(1,0,1,0)
        Content.Visible = false
        Content.BackgroundTransparency = 1

        -- Tab API
        local tabAPI = {}

        function tabAPI:Show()
            for _,v in pairs(ContentHolder:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            Content.Visible = true
        end

        function tabAPI:Button(txt, callback)
            local Btn = Instance.new("TextButton", Content)
            Btn.Size = UDim2.new(0, 200, 0, 30)
            Btn.Text = txt
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.fromRGB(255,255,255)
            Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Btn.BorderSizePixel = 0
            Btn.MouseButton1Click:Connect(callback)
        end

        function tabAPI:Toggle(txt, callback)
            local state = false
            local Btn = Instance.new("TextButton", Content)
            Btn.Size = UDim2.new(0, 200, 0, 30)
            Btn.Text = txt.." [OFF]"
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.fromRGB(255,255,255)
            Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Btn.BorderSizePixel = 0
            Btn.MouseButton1Click:Connect(function()
                state = not state
                Btn.Text = txt .. (state and " [ON]" or " [OFF]")
                callback(state)
            end)
        end

        function tabAPI:Dropdown(txt, list, callback)
            local Box = Instance.new("TextButton", Content)
            Box.Size = UDim2.new(0, 200, 0, 30)
            Box.Text = txt.." ▼"
            Box.Font = Enum.Font.Gotham
            Box.TextSize = 14
            Box.TextColor3 = Color3.fromRGB(255,255,255)
            Box.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Box.BorderSizePixel = 0

            local Open = false
            local Holder = Instance.new("Frame", Content)
            Holder.Size = UDim2.new(0, 200, 0, #list*25)
            Holder.Position = UDim2.new(0,0,0,30)
            Holder.Visible = false
            Holder.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Holder.BorderSizePixel = 0

            local UIList = Instance.new("UIListLayout", Holder)

            for _,opt in pairs(list) do
                local Opt = Instance.new("TextButton", Holder)
                Opt.Size = UDim2.new(1,0,0,25)
                Opt.Text = opt
                Opt.Font = Enum.Font.Gotham
                Opt.TextSize = 14
                Opt.TextColor3 = Color3.fromRGB(255,255,255)
                Opt.BackgroundColor3 = Color3.fromRGB(70,70,70)
                Opt.BorderSizePixel = 0
                Opt.MouseButton1Click:Connect(function()
                    callback(opt)
                    Holder.Visible = false
                    Open = false
                end)
            end

            Box.MouseButton1Click:Connect(function()
                Open = not Open
                Holder.Visible = Open
            end)
        end

        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            tabAPI:Show()
        end)

        return tabAPI
    end

    return Window
end

return Library
