local PetAssetID = "rbxassetid://11262253318"
local PetName = "MyPet"
local FollowDistance = 6

local function loadPet()
    local ok, model = pcall(function()
        return game:GetObjects(PetAssetID)[1]
    end)
    if ok and model then
        model.Name = PetName
        return model
    else
        warn("Failed to load pet model.")
        return nil
    end
end

local function followPlayer(pet, plr)
    game:GetService("RunService").Heartbeat:Connect(function()
        if pet and pet.PrimaryPart and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local goal = hrp.Position - hrp.CFrame.LookVector * FollowDistance + Vector3.new(0, 0.5, 0)
            local current = pet.PrimaryPart.Position
            local nextPos = current:Lerp(goal, 0.15)
            pet:SetPrimaryPartCFrame(CFrame.new(nextPos, hrp.Position))
        end
    end)
end

local function spawnPet()
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local pet = loadPet()
    if not pet then return end

    pet.Parent = workspace
    task.wait(0.2)

    if not pet.PrimaryPart then
        for _, v in ipairs(pet:GetDescendants()) do
            if v:IsA("BasePart") then
                pet.PrimaryPart = v
                break
            end
        end
    end

    if not pet.PrimaryPart then
        warn("No PrimaryPart on pet model.")
        return
    end

    pet:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame * CFrame.new(2, 0, -FollowDistance))
    followPlayer(pet, plr)
end

spawnPet()
