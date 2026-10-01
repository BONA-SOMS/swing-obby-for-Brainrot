--==================================================
-- BONA TELEPORT
-- BONA swing obby for Brainrot
-- RAYFIELD + OUTSIDE TELEPORT BUTTONS
-- RUN / INSTANT MODE + CUSTOM SPEED
--==================================================

local RayfieldSuccess, Rayfield = pcall(function()
    return loadstring(game:HttpGet(
        "https://sirius.menu/rayfield"
    ))()
end)

if not RayfieldSuccess or not Rayfield then
    warn("[BONA] Failed to load Rayfield")
    return
end

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- LOCATIONS
--==================================================

local SafeZone = Vector3.new(
    -84.962,
    -9.820,
    -68.109
)

local LastStage = Vector3.new(
    -524.428,
    -43.805,
    -41505.555
)

--==================================================
-- SETTINGS
--==================================================

local TeleportMode = "Run"

local RunSpeed = 10000000

local MAX_SPEED = 1000000000000000000000000

local CurrentTween = nil

--==================================================
-- STOP MOVEMENT
--==================================================

local function StopMovement()

    if CurrentTween then
        pcall(function()
            CurrentTween:Cancel()
        end)

        CurrentTween = nil
    end
end

--==================================================
-- TELEPORT / RUN
--==================================================

local function TeleportTo(Position)

    local Character = Player.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    StopMovement()

    --==================================================
    -- INSTANT MODE
    --==================================================

    if TeleportMode == "Instant" then

        Root.CFrame =
            CFrame.new(Position)

        return
    end

    --==================================================
    -- RUN MODE
    --==================================================

    local Distance =
        (Root.Position - Position).Magnitude

    if Distance <= 0.1 then
        return
    end

    RunSpeed =
        math.clamp(
            RunSpeed,
            1,
            MAX_SPEED
        )

    local TravelTime =
        Distance / RunSpeed

    if TravelTime < 0.03 then
        TravelTime = 0.03
    end

    CurrentTween =
        TweenService:Create(
            Root,

            TweenInfo.new(
                TravelTime,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            ),

            {
                CFrame =
                    CFrame.new(Position)
            }
        )

    CurrentTween:Play()

    CurrentTween.Completed:Connect(function()
        CurrentTween = nil
    end)
end

--==================================================
-- RAYFIELD WINDOW
--==================================================

local Window = Rayfield:CreateWindow({

    Name = "BONA swing obby for Brainrot",

    LoadingTitle =
        "BONA swing obby for Brainrot",

    LoadingSubtitle =
        "BONA Teleport",

    ShowText = "Rayfield",

    ToggleUIKeybind = "K",

    ConfigurationSaving = {
        Enabled = false
    },

    Discord = {
        Enabled = false
    },

    KeySystem = false
})

--==================================================
-- TELEPORT TAB
--==================================================

local TeleportTab =
    Window:CreateTab(
        "Teleport",
        4483362458
    )

--==================================================
-- TELEPORT MODE
--==================================================

TeleportTab:CreateDropdown({

    Name = "Teleport Mode",

    Options = {
        "Run",
        "Instant"
    },

    CurrentOption = {
        "Run"
    },

    MultipleOptions = false,

    Callback = function(Option)

        if type(Option) == "table" then
            Option = Option[1]
        end

        if Option == "Instant" then
            TeleportMode = "Instant"
        else
            TeleportMode = "Run"
        end

        Rayfield:Notify({

            Title = "Teleport Mode",

            Content =
                "Mode: " ..
                TeleportMode,

            Duration = 2
        })
    end
})

--==================================================
-- RUN SPEED
--==================================================

TeleportTab:CreateInput({

    Name = "Run Speed",

    CurrentValue =
        "10000000",

    PlaceholderText =
        "Enter speed...",

    RemoveTextAfterFocusLost =
        false,

    Callback = function(Value)

        local Number =
            tonumber(Value)

        if not Number then

            Rayfield:Notify({

                Title =
                    "Invalid Speed",

                Content =
                    "Please enter a number.",

                Duration = 3
            })

            return
        end

        if Number < 1 then
            Number = 1
        end

        if Number > MAX_SPEED then

            Number = MAX_SPEED

            Rayfield:Notify({

                Title =
                    "Speed Limited",

                Content =
                    "Maximum speed reached.",

                Duration = 3
            })
        end

        RunSpeed = Number

        Rayfield:Notify({

            Title =
                "Run Speed",

            Content =
                "Speed set to " ..
                tostring(RunSpeed),

            Duration = 2
        })
    end
})

--==================================================
-- SAFE ZONE
--==================================================

TeleportTab:CreateButton({

    Name = "🟢 Safe Zone",

    Callback = function()

        TeleportTo(
            SafeZone
        )

    end
})

--==================================================
-- LAST STAGE
--==================================================

TeleportTab:CreateButton({

    Name = "🟣 Last Stage",

    Callback = function()

        TeleportTo(
            LastStage
        )

    end
})

--==================================================
-- LOCATION INFO
--==================================================

TeleportTab:CreateParagraph({

    Title =
        "Locations",

    Content =
        "🟢 Safe Zone\n" ..
        "Vector3.new(-84.962, -9.820, -68.109)\n\n" ..

        "🟣 Last Stage\n" ..
        "Vector3.new(-524.428, -43.805, -41505.555)"
})

--==================================================
-- SETTINGS INFO
--==================================================

TeleportTab:CreateParagraph({

    Title =
        "Run Settings",

    Content =
        "Default Speed: 10M\n" ..
        "10M = 10,000,000\n\n" ..

        "Maximum Speed:\n" ..
        "1,000,000,000,000,000,000,000,000\n\n" ..

        "Default Mode: Run"
})

--==================================================
-- OUTSIDE UI
--==================================================

local UIParent

pcall(function()

    if gethui then
        UIParent = gethui()
    end

end)

if not UIParent then
    UIParent = PlayerGui
end

local OldUI =
    UIParent:FindFirstChild(
        "BONA_OutsideTeleport"
    )

if OldUI then
    OldUI:Destroy()
end

--==================================================
-- SCREEN GUI
--==================================================

local OutsideUI =
    Instance.new("ScreenGui")

OutsideUI.Name =
    "BONA_OutsideTeleport"

OutsideUI.ResetOnSpawn =
    false

OutsideUI.IgnoreGuiInset =
    true

OutsideUI.DisplayOrder =
    2147483647

OutsideUI.ZIndexBehavior =
    Enum.ZIndexBehavior.Global

OutsideUI.Parent =
    UIParent

--==================================================
-- BUTTON HOLDER
--==================================================

local Holder =
    Instance.new("Frame")

Holder.Name =
    "TeleportButtons"

Holder.AnchorPoint =
    Vector2.new(1, 0)

Holder.Position =
    UDim2.new(
        1, -265,
        0, 78
    )

Holder.Size =
    UDim2.new(
        0, 260,
        0, 60
    )

Holder.BackgroundTransparency =
    1

Holder.BorderSizePixel =
    0

Holder.ZIndex =
    1000

Holder.Parent =
    OutsideUI

--==================================================
-- GREEN SAFE BUTTON
--==================================================

local SafeButton =
    Instance.new("TextButton")

SafeButton.Name =
    "SafeZone"

SafeButton.Size =
    UDim2.new(
        0, 125,
        0, 60
    )

SafeButton.Position =
    UDim2.new(
        0, 0,
        0, 0
    )

SafeButton.BackgroundColor3 =
    Color3.fromRGB(
        125, 190, 65
    )

SafeButton.BackgroundTransparency =
    0.05

SafeButton.Text =
    "safe"

SafeButton.TextColor3 =
    Color3.fromRGB(
        0, 0, 0
    )

SafeButton.TextSize =
    25

SafeButton.Font =
    Enum.Font.GothamBold

SafeButton.BorderSizePixel =
    0

SafeButton.AutoButtonColor =
    true

SafeButton.ZIndex =
    1001

SafeButton.Parent =
    Holder

local SafeCorner =
    Instance.new("UICorner")

SafeCorner.CornerRadius =
    UDim.new(0, 7)

SafeCorner.Parent =
    SafeButton

--==================================================
-- PURPLE LAST STAGE BUTTON
--==================================================

local LastButton =
    Instance.new("TextButton")

LastButton.Name =
    "LastStage"

LastButton.Size =
    UDim2.new(
        0, 125,
        0, 60
    )

LastButton.Position =
    UDim2.new(
        0, 135,
        0, 0
    )

LastButton.BackgroundColor3 =
    Color3.fromRGB(
        175, 65, 195
    )

LastButton.BackgroundTransparency =
    0.05

LastButton.Text =
    "last stage"

LastButton.TextColor3 =
    Color3.fromRGB(
        0, 0, 0
    )

LastButton.TextSize =
    23

LastButton.Font =
    Enum.Font.GothamBold

LastButton.BorderSizePixel =
    0

LastButton.AutoButtonColor =
    true

LastButton.ZIndex =
    1001

LastButton.Parent =
    Holder

local LastCorner =
    Instance.new("UICorner")

LastCorner.CornerRadius =
    UDim.new(0, 7)

LastCorner.Parent =
    LastButton

--==================================================
-- BUTTON ACTIONS
--==================================================

SafeButton.Activated:Connect(function()
    TeleportTo(SafeZone)
end)

LastButton.Activated:Connect(function()
    TeleportTo(LastStage)
end)

--==================================================
-- DRAGGABLE OUTSIDE UI
--==================================================

local Dragging = false
local DragStart
local StartPosition

Holder.InputBegan:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.Touch
        or
        Input.UserInputType ==
        Enum.UserInputType.MouseButton1 then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Holder.Position

        Input.Changed:Connect(function()

            if Input.UserInputState ==
                Enum.UserInputState.End then

                Dragging = false

            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType ==
        Enum.UserInputType.Touch
        or
        Input.UserInputType ==
        Enum.UserInputType.MouseMovement then

        local Delta =
            Input.Position -
            DragStart

        Holder.Position =
            UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
    end
end)

--==================================================
-- LOADED
--==================================================

Rayfield:Notify({

    Title =
        "BONA swing obby for Brainrot",

    Content =
        "🟩 Run mode | 10M speed | 🟪 Ready!",

    Duration = 4
})
