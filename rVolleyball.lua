--[[
        Package Name: rVolleyball
        Last Updated: 07/29/2023

        Game(s) Supported:
        https://www.roblox.com/games/3840352284/Volleyball-4-2
        https://www.roblox.com/games/4596514848/Volleyball-4-4
        https://www.roblox.com/games/6734275465/SEASON-5-Beyond-Volleyball-League
        https://www.roblox.com/games/6598790477/Volleyball-Academy
--]]

-- Constants
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Physics 
local function PHYSICS_STUFF(velocity, position)
    local acceleration = -workspace.Gravity
    local timeToLand = (-velocity.y - math.sqrt(velocity.y * velocity.y - 4 * 0.5 * acceleration * position.y)) / (2 * 0.5 * acceleration)
    local horizontalVelocity = Vector3.new(velocity.x, 0, velocity.z)
    local landingPosition = position + horizontalVelocity * timeToLand + Vector3.new(0, -position.y, 0)
    return landingPosition
end

local function Ball_Prediction(obj)
    
    RunService:BindToRenderStep("VisualizeLandingPosition", Enum.RenderPriority.Camera.Value, function() -- 4.2, 4.4, BVL
        for _, ballModel in ipairs(workspace:GetDescendants()) do
            if ballModel:IsA("Model") and ballModel.Name == "Ball" then
                local ball = ballModel:FindFirstChild(tostring(obj))
                if ball and not ball:FindFirstChild("Marker") then
                    local Marker = Instance.new("Part")
                    Marker.Name = "Marker"
                    Marker.Size = Vector3.new(2, 2, 2)
                    Marker.Shape = Enum.PartType.Ball
                    Marker.BrickColor = BrickColor.new("Bright violet")
                    Marker.CanCollide = false
                    Marker.Anchored = true
                    Marker.Parent = ball
                    Marker.Material = Enum.Material.Neon
                    Marker.Transparency = 0.5
                end
                local initialVelocity = ballModel.Velocity
                local landingPosition = PHYSICS_STUFF(initialVelocity.Value, ball.Position)
                ball:FindFirstChild("Marker").CFrame = CFrame.new(landingPosition)
                if ballModel:FindFirstChild("Marker") then
                    ball:FindFirstChild("Marker"):Destroy()
                end
            end
        end
    end)

    if game.PlaceId == 6598790477 then -- Volleyball Academy
        RunService:BindToRenderStep("VisualizeLandingPosition", Enum.RenderPriority.Camera.Value, function()
            for _, ballModel in ipairs(workspace:GetDescendants()) do
                if ballModel:IsA("BasePart") and ballModel.Name == "Ball" then
                    if ballModel and not ballModel:FindFirstChild("Marker") then
                        local Marker = Instance.new("Part")
                        Marker.Name = "Marker"
                        Marker.Size = Vector3.new(2, 2, 2)
                        Marker.Shape = Enum.PartType.Ball
                        Marker.BrickColor = BrickColor.new("Bright violet")
                        Marker.CanCollide = false
                        Marker.Anchored = true
                        Marker.Parent = ballModel
                        Marker.Material = Enum.Material.Neon
                        Marker.Transparency = 0.5
                    end
                    local initialVelocity = ballModel.Properties.Velo
                    local landingPosition = PHYSICS_STUFF(initialVelocity.Value, ballModel.Position)
                    ballModel:FindFirstChild("Marker").CFrame = CFrame.new(landingPosition)
                    if ballModel:FindFirstChild("Properties").Dead.Value == true then
                        ballModel:FindFirstChild("Marker"):Destroy()
                    end
                end
            end
        end)
    end

end

-- 
if game.PlaceId == 3840352284 then -- Volleyball 4.2
	print("Volleyball 4.2")
	repeat wait() until workspace:FindFirstChild("Ball")
    Ball_Prediction("BallPart")
elseif game.PlaceId == 4596514848 then -- Volleyball 4.4
	print("Volleyball 4.4")
	repeat wait() until workspace:FindFirstChild("Ball")
    Ball_Prediction("Ball")
elseif game.PlaceId == 6734275465 then -- Beyond Volleyball League
	print("Beyond Volleyball League")
	repeat wait() until workspace:FindFirstChild("Balls"):FindFirstChild("Ball")
    Ball_Prediction("Ball")
elseif game.PlaceId == 6598790477 then -- Volleyball Academy
	print("Volleyball Academy")
	repeat wait() until workspace:FindFirstChild("Balls"):FindFirstChild("Ball")
    Ball_Prediction("Ball")
end
