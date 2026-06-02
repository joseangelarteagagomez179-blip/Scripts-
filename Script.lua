--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

--// Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

--// Anti AFK
spawn(function()
    while task.wait(5) do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--// Load Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Scripts JoseAngel_Blox",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "KickBlock",
    IntroText = "JoseAngel_Blox | 02/06/2026"
})

--[[
------------------------------------------------------------------
                          1) INFO
------------------------------------------------------------------
]]
local TabInfo = Window:MakeTab({
    Name = "ℹ️ Info",
    Icon = "rbxassetid://4458900437",
    PremiumOnly = false
})

TabInfo:AddLabel("Creador: JoseAngel_Blox")
TabInfo:AddLabel("Fecha: 02/06/2026")
TabInfo:AddLabel("Juego: Kick a Lucky Block")

--[[
------------------------------------------------------------------
                          2) MAIN
------------------------------------------------------------------
]]
local TabMain = Window:MakeTab({
    Name = "⚡ Main",
    Icon = "rbxassetid://4458900437",
    PremiumOnly = false
})

--// Auto Farm
local AutoFarmToggle = false
local PosicionSegura = nil

TabMain:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        AutoFarmToggle = Value
        if Value then
            task.spawn(function()
                while AutoFarmToggle do
                    local success, err = pcall(function()
                        if not PosicionSegura then PosicionSegura = HRP.CFrame end
                        
                        -- Buscar Bloque
                        for _, v in pairs(Workspace:GetChildren()) do
                            if v.Name:find("LuckyBlock") or v.Name:find("Block") then
                                -- Ir al bloque
                                HRP.CFrame = v.CFrame * CFrame.new(0, 1, -2)
                                
                                -- Patear
                                if v:FindFirstChildOfClass("ClickDetector") then
                                    fireclickdetector(v.ClickDetector)
                                end
                                
                                task.wait(0.5)
                                
                                -- Regresar
                                if PosicionSegura then
                                    HRP.CFrame = PosicionSegura
                                end
                                break
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

--// Auto Weight
local AutoWeightToggle = false

TabMain:AddToggle({
    Name = "Auto Weight",
    Default = false,
    Callback = function(Value)
        AutoWeightToggle = Value
        if Value then
            task.spawn(function()
                while AutoWeightToggle do
                    local success, err = pcall(function()
                        local Backpack = Player:FindFirstChild("Backpack")
                        if not Backpack then return end
                        
                        -- Buscar Pesa
                        for _, v in pairs(Backpack:GetChildren()) do
                            if v.Name:lower():find("weight") or v.ClassName == "Tool" then
                                v.Parent = Character
                                task.wait()
                                local Tool = Character:FindFirstChild(v.Name)
                                if Tool then Tool:Activate() end
                                break
                            end
                        end
                        
                        -- Click rapido
                        while AutoWeightToggle and Character.Humanoid.Health > 0 do
                            Mouse1Press()
                            task.wait(0.01)
                        end
                        
                        -- Desequipar
                        if not AutoWeightToggle then
                            for _, v in pairs(Character:GetChildren()) do
                                if v.ClassName == "Tool" then
                                    v.Parent = Backpack
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            -- Desequipar al apagar
            local Backpack = Player:FindFirstChild("Backpack")
            for _, v in pairs(Character:GetChildren()) do
                if v.ClassName == "Tool" then
                    v.Parent = Backpack
                end
            end
        end
    end
})

--// Auto Collect Money
local AutoCollectToggle = false

TabMain:AddToggle({
    Name = "Auto Collect Money",
    Default = false,
    Callback = function(Value)
        AutoCollectToggle = Value
        if Value then
            task.spawn(function()
                while AutoCollectToggle do
                    local success, err = pcall(function()
                        for _, v in pairs(Workspace:GetChildren()) do
                            if v.Name == "Brainrot" and v:IsA("Part") then
                                HRP.CFrame = v.CFrame
                                task.wait(0.05)
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

--// Enable Move (No Congelar)
local EnableMoveToggle = false

TabMain:AddToggle({
    Name = "Enable Move (Sin Congelar)",
    Default = false,
    Callback = function(Value)
        EnableMoveToggle = Value
    end
})

-- Bucle Enable Move
spawn(function()
    while task.wait(0.1) do
        if EnableMoveToggle and Humanoid then
            pcall(function()
                Humanoid.WalkSpeed = 50
                Humanoid.JumpPower = 50
                if HRP then HRP.Anchored = false end
            end)
        end
    end
end)

--// WalkSpeed
TabMain:AddSlider({
    Name = "Velocidad de Caminata",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.new(0,0,1),
    Callback = function(Value)
        Humanoid.WalkSpeed = Value
    end
})

--[[
------------------------------------------------------------------
                          3) PLAYER
------------------------------------------------------------------
]]
local TabPlayer = Window:MakeTab({
    Name = "👤 Player",
    Icon = "rbxassetid://4458900437",
    PremiumOnly = false
})

--// Fly
local FlyToggle = false
local FlySpeed = 50
local BV = Instance.new("BodyVelocity")

TabPlayer:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        FlyToggle = Value
        if Value then
            BV.Parent = HRP
            BV.MaxForce = Vector3.new(1e4,1e4,1e4)
            BV.Velocity = Vector3.new()
        else
            BV:Destroy()
            BV = Instance.new("BodyVelocity")
        end
    end
})

TabPlayer:AddSlider({
    Name = "Velocidad de Vuelo",
    Min = 20,
    Max = 300,
    Default = 50,
    Color = Color3.new(0,1,0),
    Callback = function(Value)
        FlySpeed = Value
    end
})

-- Bucle Fly
RunService.Heartbeat:Connect(function()
    if FlyToggle and HRP then
        local CamCF = workspace.CurrentCamera.CFrame
        local MoveDir = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDir += CamCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDir -= CamCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDir -= CamCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDir += CamCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then MoveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then MoveDir -= Vector3.new(0,1,0) end
        
        BV.Velocity = MoveDir * FlySpeed
    end
end)

--// Invisible
local InvisibleToggle = false
local OriginalC0 = nil

TabPlayer:AddToggle({
    Name = "Invisible",
    Default = false,
    Callback = function(Value)
        InvisibleToggle = Value
        if Value then
            local success, err = pcall(function()
                local Joint = HRP:FindFirstChild("RootJoint")
                if Joint then
                    OriginalC0 = Joint.C0
                    Joint.C0 = OriginalC0 * CFrame.new(0, -99999, 0)
                end
            end)
        else
            local Joint = HRP:FindFirstChild("RootJoint")
            if Joint and OriginalC0 then
                Joint.C0 = OriginalC0
            end
        end
    end
})

--[[
------------------------------------------------------------------
                          4) CONFIGURACIONES
------------------------------------------------------------------
]]
local TabConfig = Window:MakeTab({
    Name = "⚙️ Configuraciones",
    Icon = "rbxassetid://4458900437",
    PremiumOnly = false
})

--// FPS
local FPSLabel = TabConfig:AddLabel("FPS Actuales: 0")

spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1/RunService.Heartbeat:Wait())
        FPSLabel:Set("FPS Actuales: " .. fps)
    end
end)

--// Optimizacion / Modo Patata
TabConfig:AddToggle({
    Name = "Modo Patata (Max Rendimiento)",
    Default = false,
    Callback = function(Value)
        if Value then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.Brightness = 2
            
            spawn(function()
                while task.wait(1) do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        pcall(function()
                            if v:IsA("BasePart") then
                                v.Material = Enum.Material.SmoothPlastic
                                v.Reflectance = 0
                            end
                            if v:IsA("Texture") or v:IsA("Decal") then
                                v:Destroy()
                            end
                            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                                v.Enabled = false
                            end
                        end)
                    end
                end
            end)
        end
    end
})

--// Init
OrionLib:Init()

--// Respawn Handler
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HRP = Character:WaitForChild("HumanoidRootPart")
end)

print("✅ Script JoseAngel_Blox Cargado Correctamente!")
