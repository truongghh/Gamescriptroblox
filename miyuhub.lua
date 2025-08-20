-- 🛠 Xóa GUI cũ để tránh tạo nhiều lần
if game.CoreGui:FindFirstChild("Loader_GUI") then
    game.CoreGui.Loader_GUI:Destroy()
end

-- ⚡ Dịch vụ Roblox
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- =========================================
-- 📌 Tạo GUI Loader
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Loader_GUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 150)
Frame.Position = UDim2.new(0.5, -200, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = false -- ❌ không di chuyển được
Frame.BackgroundTransparency = 1 -- bắt đầu ẩn
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

-- progress container
local ProgressContainer = Instance.new("Frame")
ProgressContainer.Size = UDim2.new(0, 360, 0, 20)
ProgressContainer.Position = UDim2.new(0, 20, 0, 60)
ProgressContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ProgressContainer.BorderSizePixel = 0
ProgressContainer.BackgroundTransparency = 0
ProgressContainer.Parent = Frame
Instance.new("UICorner", ProgressContainer).CornerRadius = UDim.new(0, 6)

-- progress bar
local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
ProgressBar.BorderSizePixel = 0
ProgressBar.BackgroundTransparency = 1 -- fade-in
ProgressBar.Parent = ProgressContainer
Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 6)

-- gradient effect
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 150)), -- xanh neon
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)) -- trắng sáng
}
UIGradient.Rotation = 0
UIGradient.Parent = ProgressBar

-- percent label
local PercentLabel = Instance.new("TextLabel")
PercentLabel.Size = UDim2.new(1, 0, 0, 30)
PercentLabel.Position = UDim2.new(0, 0, 0, 90)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PercentLabel.Font = Enum.Font.SourceSansBold
PercentLabel.TextSize = 24
PercentLabel.TextTransparency = 1 -- fade-in
PercentLabel.Parent = Frame

-- success label
local SuccessLabel = Instance.new("TextLabel")
SuccessLabel.Size = UDim2.new(1, 0, 0, 30)
SuccessLabel.Position = UDim2.new(0, 0, 0, 20)
SuccessLabel.BackgroundTransparency = 1
SuccessLabel.Text = ""
SuccessLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
SuccessLabel.Font = Enum.Font.SourceSansBold
SuccessLabel.TextSize = 26
SuccessLabel.TextTransparency = 1 -- fade-in
SuccessLabel.Parent = Frame

-- =========================================
-- ✨ Fade-in khi xuất hiện
TweenService:Create(Frame, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
TweenService:Create(ProgressBar, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
TweenService:Create(PercentLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()

-- =========================================
-- ⏳ Chạy thanh tải
task.spawn(function()
    task.wait(1) -- đợi fade-in xong rồi mới chạy progress
    for i = 1, 100 do
        ProgressBar.Size = UDim2.new(i/100, 0, 1, 0)
        PercentLabel.Text = i.."%"
        task.wait(0.03) -- tốc độ load
    end
    
    SuccessLabel.Text = "✅ Done!"
    TweenService:Create(SuccessLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    task.wait(1)

    -- 🎯 Script chính
    loadstring(game:HttpGet("https://raw.githubusercontent.com/truongghh/Gamescriptroblox/refs/heads/main/guiscript.lua"))()

    -- ✨ Fade-out toàn bộ GUI
    for _, obj in ipairs(Frame:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            TweenService:Create(obj, TweenInfo.new(1), {TextTransparency = 1}):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        end
    end
    TweenService:Create(Frame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()

    task.wait(1.1)
    ScreenGui:Destroy()
end)