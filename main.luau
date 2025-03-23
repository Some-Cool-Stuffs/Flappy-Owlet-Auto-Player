local virtualUser = game:GetService("VirtualUser")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")

local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera -- Your player's camera. The machine's required to be in your FOV. (Field of Vision/View)

local model  = workspace.arcade.FlappyOwlet -- The model of the Machine we're playing. (Middle Player)

local playButton = model:FindFirstChild("PlayButtonNode") -- The green Play button. (Type: Part)
local screen = model:FindFirstChild("Screen") -- The screen of the Machine. (Type: Part)

local playCount = 0

local function main()
    local function giveInterface(size)
        for _, gui in screen:GetDescendants() do
            if gui:IsA("SurfaceGui") or gui:IsA("BillboardGui") then -- If found, returns the Billboard/SurfaceGUI instance of the game.
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
            mousemoveabs(position.X + 30 + i, position.Y + 80 + i) -- Moves your cursor over to the Play button to press it.
        end                                                        -- (Requires: `mousemoveabs`, `mouse1click`)

        mouse1click()
        delay(3, function()
            mouse1click()
        end)

        task.wait(3)
    end

    task.wait(3)

    while giveInterface(3) == nil and task.wait(0.5) do
        if math.abs(playCount) ~= 0 then
            print(`Completed a round of Flappy Owlet!! (x{playCount} Streak)`)
        end

        beginGame()

        local mainUI = giveInterface(3)
        if mainUI then
            local floor, bird = mainUI:FindFirstChild("Floor"), mainUI:FindFirstChild("Bird") -- The Floor and Bird instances in the game. (Type(s): ImageLabel, ImageLabel)

            if floor and bird then
                floor:Destroy()
                delay(1500, function()
                    bird.Position = UDim2.new(bird.Position.X.Scale, bird.Position.X.Offset, bird.Position.Y.Scale, 0) -- After 1,500s (~17m), kills your player to earn the TIX. (~2,000/game)
                end)
            end
        end

        playCount += 1
        task.wait(6)
    end
end

localPlayer.Idled:Connect(function()
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new()) -- Removes the ability for ROBLOX to idle-kick you. (For AFK/farming purposes)
end)

main() -- Just runs the main function. Only should ever be called once!
