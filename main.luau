local virtualUser = game:GetService("VirtualUser")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")

local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

local model  = workspace.arcade.FlappyOwlet

local playButton = model:FindFirstChild("PlayButtonNode")
local screen = model:FindFirstChild("Screen")

local playCount = 0

local function main()
    local function giveInterface(size)
        for _, gui in screen:GetDescendants() do
            if gui:IsA("SurfaceGui") or gui:IsA("BillboardGui") then
                if #gui:GetChildren() ~= size then
                    return gui
                end
            end
        end

        return nil
    end

    local function beginGame()
        local position = camera:WorldToScreenPoint(playButton.Position)
        for i = 5, 1, -1 do
            mousemoveabs(position.X + 30 + i, position.Y + 80 + i)
        end

        mouse1click()
        delay(4, function()
            mouse1click()
        end)

        task.wait(3)
    end

    task.wait(3)

    while task.wait(0.5) do
        if giveInterface(3) == nil then
            if math.abs(playCount) ~= 0 then
                print(`Completed a round of Flappy Owlet!! (x{playCount} Streak)`)
            end

            beginGame()

            local mainUI = giveInterface(3)
            if mainUI then
                local floor, bird = mainUI:FindFirstChild("Floor"), mainUI:FindFirstChild("Bird")
                
                if floor and bird then
                    floor:Destroy()

                    task.wait(1500)
                    bird.Position = UDim2.new(bird.Position.X.Scale, bird.Position.X.Offset, bird.Position.Y.Scale, 0)
                end
            end

            playCount += 1
            task.wait(8)
        end
    end
end

localPlayer.Idled:Connect(function()
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new())
end)

main()
