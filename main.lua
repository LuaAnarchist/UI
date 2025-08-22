--// Library UI Custom
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- Window tạo
function Library:CreateWindow(config)
    config = config or {}
    local title = config.Title or "My Hub"
    local author = config.Author or ""
    local size = config.Size or UDim2.fromOffset(500, 320)
    local theme = config.Theme or "Dark"

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Main
    local Main = Instance.new("Frame")
    Main.Size = size
    Main.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    Main.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(40,40,40) or theme == "Light" and Color3.fromRGB(240,240,240) or theme == "Blue" and Color3.fromRGB(30,60,120) or Color3.fromRGB(40,120,60)
    Main.BorderSizePixel = 0
    Main.Parent = gui

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.ZIndex = 0
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5028857472"
    Shadow.ImageColor3 = Color3.new(0,0,0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(24,24,276,276)
    Shadow.Parent = Main

    -- Viền
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.new(0,0,0)
    Stroke.Thickness = 2
    Stroke.Transparency = 0.4
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Main

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1,0,0,35)
    Header.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Header.BorderSizePixel = 0
    Header.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Text = title .. (author ~= "" and " | "..author or "")
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1,-100,1,0)
    Title.Position = UDim2.new(0,10,0,0)
    Title.Parent = Header

    -- Nút điều khiển
    local function CreateButton(txt, offsetX)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,30,1,0)
        btn.Position = UDim2.new(1, offsetX,0,0)
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamBold
        btn.Text = txt
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 16
        btn.Parent = Header
        return btn
    end

    local Close = CreateButton("X",-30)
    local Minimize = CreateButton("–",-60)
    local Hide = CreateButton("☐",-90)

    -- Tab holder
    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(0,120,1,-35)
    TabHolder.Position = UDim2.new(0,0,0,35)
    TabHolder.BackgroundColor3 = Color3.fromRGB(35,35,35)
    TabHolder.BorderSizePixel = 0
    TabHolder.Parent = Main

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabHolder

    -- Content holder
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1,-120,1,-35)
    ContentHolder.Position = UDim2.new(0,120,0,35)
    ContentHolder.BackgroundColor3 = Color3.fromRGB(45,45,45)
    ContentHolder.BorderSizePixel = 0
    ContentHolder.Parent = Main

    -- Hide logic
    local hidden = false
    Hide.MouseButton1Click:Connect(function()
        hidden = not hidden
        local goal = {Size = hidden and UDim2.fromOffset(0,0) or size, Transparency = hidden and 1 or 0}
        TweenService:Create(Main,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size = goal.Size}):Play()
        TweenService:Create(Stroke,TweenInfo.new(0.3),{Transparency = hidden and 1 or 0.4}):Play()
        TweenService:Create(Shadow,TweenInfo.new(0.3),{ImageTransparency = hidden and 1 or 0.5}):Play()
    end)

    -- Minimize logic
    local minimized = false
    Minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        ContentHolder.Visible = not minimized
        TabHolder.Visible = not minimized
        Main.Size = minimized and UDim2.fromOffset(size.X.Offset,35) or size
    end)

    -- Close logic
    Close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- API
    local windowAPI = {}
    windowAPI.__index = windowAPI

    function windowAPI:Tab(tabConfig)
        local tabName = tabConfig.Title or "Tab"

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1,0,0,30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(255,255,255)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.Parent = TabHolder

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1,0,1,0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentHolder

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0,5)
        TabLayout.Parent = TabContent

        TabBtn.MouseButton1Click:Connect(function()
            for _,child in pairs(ContentHolder:GetChildren()) do
                if child:IsA("Frame") then child.Visible = false end
            end
            TabContent.Visible = true
        end)

        local tabAPI = {}
        tabAPI.__index = tabAPI

        function tabAPI:Button(text,callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0,200,0,30)
            b.BackgroundColor3 = Color3.fromRGB(70,70,70)
            b.Text = text
            b.TextColor3 = Color3.new(1,1,1)
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.Parent = TabContent
            b.MouseButton1Click:Connect(function() callback() end)
            return b
        end

        function tabAPI:Toggle(text,callback)
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0,200,0,30)
            toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
            toggle.TextColor3 = Color3.new(1,1,1)
            toggle.Font = Enum.Font.Gotham
            toggle.TextSize = 14
            toggle.Text = text.." [OFF]"
            toggle.Parent = TabContent

            local state = false
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = text .. (state and " [ON]" or " [OFF]")
                callback(state)
            end)
            return toggle
        end

        function tabAPI:Dropdown(text,options,callback)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(0,200,0,30)
            holder.BackgroundColor3 = Color3.fromRGB(70,70,70)
            holder.Parent = TabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = text.." ▼"
            label.TextColor3 = Color3.new(1,1,1)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.Parent = holder

            local dropFrame = Instance.new("Frame")
            dropFrame.Size = UDim2.new(1,0,0, #options*25)
            dropFrame.Position = UDim2.new(0,0,1,0)
            dropFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
            dropFrame.Visible = false
            dropFrame.Parent = holder

            local list = Instance.new("UIListLayout")
            list.Parent = dropFrame

            for _,opt in ipairs(options) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,0,0,25)
                btn.Text = opt
                btn.TextColor3 = Color3.new(1,1,1)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.Parent = dropFrame
                btn.MouseButton1Click:Connect(function()
                    label.Text = text..": "..opt.." ▼"
                    dropFrame.Visible = false
                    callback(opt)
                end)
            end

            label.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dropFrame.Visible = not dropFrame.Visible
                end
            end)

            return holder
        end

        return setmetatable(tabAPI,{})
    end

    return setmetatable(windowAPI,{})
end

return Library
