----------[  Variables  ]----------
local players = game:GetService("Players");
local localPlayer = players.LocalPlayer;
local localCharacter = localPlayer.Character;
local localHumanoid = localCharacter.Humanoid;
local root = localHumanoid.RootPart;

local runService = game:GetService("RunService");
local starterGui = game:GetService("StarterGui");
local heartBeat = runService.Heartbeat;
-----------------------------------


----------[  Settings  ]----------
_G.settings = {
	speed = 0.25,
	mode = 1,
	player = localPlayer.Name,
	customBodyPartPos = false
};
----------------------------------


----------[   Custom  ]----------
_G.customPositions = {
	leftArm = Vector3.new(-0.5, 0, -0.75),
	rightArm = Vector3.new(0.5, 0, -0.75),
	leftLeg = Vector3.new(0, 0, 0),
	rightLeg = Vector3.new(0, 0, 0),
	torso = Vector3.new(0, 0, 0),
	head = Vector3.new(0, 0, 0),
};

_G.customOrientations = {
	leftArm = Vector3.new(45, 0, -30),
	rightArm = Vector3.new(45, 0, 30),
	leftLeg = Vector3.new(0, 0, 0),
	rightLeg = Vector3.new(0, 0, 0),
	torso = Vector3.new(0, 0, 0),
	head = Vector3.new(0, 0, 0)
};
------------------------------


----------[  Base  ]----------
local basePositions = {
	leftArm = Vector3.new(1.5, 0, 0),
	rightArm = Vector3.new(-1.5, 0, 0),
	leftLeg = Vector3.new(0.5, -2, 0),
	rightLeg = Vector3.new(-0.5, -2, 0),
	torso = Vector3.new(0, 0, 0),
	head = Vector3.new(0, 1, 0),
};

local baseOrientations = {
	leftArm = Vector3.new(0, 0, 0),
	rightArm = Vector3.new(0, 0, 0),
	leftLeg = Vector3.new(0, 0, 0),
	rightLeg = Vector3.new(0, 0, 0),
	torso = Vector3.new(0, 0, 0),
	head = Vector3.new(0, 0, 0)
};
------------------------------

local hatAttachments = {};
local bodyPartPosConnection
local hatConnection
local function startMain()
	----------[  Main function  ]----------


	----------[  Netless  ]----------
	local netlessConnection
	for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then 
			netlessConnection = game:GetService("RunService").Heartbeat:connect(function()
				v.Velocity = Vector3.new(-30, 0, 0)
				v.Massless = true
			end)
		end
	end
	---------------------------------


	if not players:FindFirstChild(_G.settings.player) or not players:FindFirstChild(_G.settings.player).Character then
		_G.settings.player = localplayer
	end
	localCharacter = localPlayer.Character;
	localHumanoid = localCharacter.Humanoid;
	root = localHumanoid.RootPart;
	task.spawn(function()
		for i,v in pairs(localCharacter:GetDescendants()) do
			if v:IsA("SpecialMesh") and v.Parent.Name ~= "Head" then
				v:Destroy();
			end;
		end;
	end)

	local parts = {};
	local hatParts = {};
	local bodyParts = {};
	for i,v in pairs(localCharacter:GetDescendants()) do
		if v.Name == "Handle" then
			table.insert(hatParts, v);
			table.insert(parts, v);
		end;
		-- if #hatParts == 9 then
		--     break
		-- end

		if v.Name == "Left Arm" then
			table.insert(bodyParts, v);
			table.insert(parts, v);
		end;
		if v.Name == "Right Arm" then
			table.insert(bodyParts, v);
			table.insert(parts, v);
		end;
		-- if v.Name == "Left Leg" then
		-- 	table.insert(bodyParts, v);
		-- 	table.insert(parts, v);
		-- end;
		-- if v.Name == "Right Leg" then
		-- 	table.insert(bodyParts, v);
		-- 	table.insert(parts, v);
		-- end;
	end;
	-------------------------------------------


	----------[  Body Part Manipulation  ]----------
    --[[ DISABLED DUE TO REJECTCHARACTERDELETIONS 
    local bodyAttachments = {};
    local bodyAttachmentsOne = {};
    for i, v in pairs(bodyParts) do
        local attachment1 = Instance.new("Attachment", v);
        -- local attachment2 = Instance.new("Attachment", root);
        local attachment2 = Instance.new("Attachment", players:FindFirstChild(_G.settings.player).Character.Humanoid.RootPart);
        attachment2.Position = Vector3.new(0,-5,0);

        local alignPosition = Instance.new("AlignPosition");
        alignPosition.Parent = v;
        alignPosition.MaxForce = math.huge;
        alignPosition.MaxVelocity = math.huge;
        alignPosition.Responsiveness = math.huge;
        alignPosition.Attachment0 = attachment1;
        alignPosition.Attachment1 = attachment2;

        local alignOrientation = Instance.new("AlignOrientation");
        alignOrientation.Parent = v;
        alignOrientation.MaxAngularVelocity = math.huge;
        alignOrientation.MaxTorque = math.huge;
        alignOrientation.Responsiveness = math.huge;
        alignOrientation.Attachment0 = attachment1;
        alignOrientation.Attachment1 = attachment2;

        bodyAttachmentsOne[i] = attachment1;
        bodyAttachments[i] = attachment2;

        if v.Name == "Left Arm" then
            attachment2.Position = basePositions.leftArm + _G.customPositions.leftArm;
            attachment2.Orientation = baseOrientations.leftArm + _G.customOrientations.leftArm;
        end;
        if v.Name == "Right Arm" then
            attachment2.Position = basePositions.rightArm + _G.customPositions.rightArm;
            attachment2.Orientation = baseOrientations.rightArm + _G.customOrientations.rightArm;
        end;
        if v.Name == "Left Leg" then
            attachment2.Position = basePositions.leftLeg + _G.customPositions.leftLeg;
            attachment2.Orientation = baseOrientations.leftLeg + _G.customOrientations.leftLeg;
        end;
        if v.Name == "Right Leg" then
            attachment2.Position = basePositions.rightLeg + _G.customPositions.rightLeg;
            attachment2.Orientation = baseOrientations.rightLeg + _G.customOrientations.rightLeg;
        end;

        bodyPartPosConnection = heartBeat:Connect(function()
            if _G.settings.customBodyPartPos == true then
                for i, attachment in pairs(bodyAttachmentsOne) do
                    local attachmentTwo = bodyAttachments[i]
                    if attachment.Parent.Name == "Left Arm" then
                        attachmentTwo.Position = basePositions.leftArm + _G.customPositions.leftArm;
                        attachmentTwo.Orientation = baseOrientations.leftArm + _G.customOrientations.leftArm;
                    elseif attachment.Parent.Name == "Right Arm" then
                        attachmentTwo.Position = basePositions.rightArm + _G.customPositions.rightArm;
                        attachmentTwo.Orientation = baseOrientations.rightArm + _G.customOrientations.rightArm;
                    elseif attachmentTwo.Parent.Name == "Left Leg" then
                        attachmentTwo.Position = basePositions.leftLeg + _G.customPositions.leftLeg;
                        attachmentTwo.Orientation = baseOrientations.leftLeg + _G.customOrientations.leftLeg;
                    elseif attachmentTwo.Parent.Name == "Right Leg" then
                        attachmentTwo.Position = basePositions.rightLeg + _G.customPositions.rightLeg;
                        attachmentTwo.Orientation = baseOrientations.rightLeg + _G.customOrientations.rightLeg;
                    end;
                end
            else
                for i, attachment in pairs(bodyAttachmentsOne) do
                    attachmentTwo = bodyAttachments[i]
                    if attachment.Parent.Name == "Left Arm" then
                        attachmentTwo.Position = basePositions.leftArm
                        attachmentTwo.Orientation = baseOrientations.leftArm
                    end;
                    if attachment.Parent.Name == "Right Arm" then
                        attachmentTwo.Position = basePositions.rightArm
                        attachmentTwo.Orientation = baseOrientations.rightArm
                    end;
                    if attachment.Parent.Name == "Left Leg" then
                        attachmentTwo.Position = basePositions.leftLeg
                        attachmentTwo.Orientation = baseOrientations.leftLeg
                    end;
                    if attachment.Parent.Name == "Right Leg" then
                        attachmentTwo.Position = basePositions.rightLeg
                        attachmentTwo.Orientation = baseOrientations.rightLeg
                    end;
                end  
            end
        end)

        v:BreakJoints();
    end;
    ------------------------------------------------
--]]

	----------[  Hat Manipulation  ]----------
	hatAttachments = {};
	for i,v in pairs(hatParts) do
		local attachment1 = Instance.new("Attachment", v);
		-- local attachment2 = Instance.new("Attachment", root);
		local attachment2 = Instance.new("Attachment", players:FindFirstChild(_G.settings.player).Character.Humanoid.RootPart);
		attachment2.Position = Vector3.new(0,-5,0);

		local alignPosition = Instance.new("AlignPosition");
		alignPosition.Parent = v;
		alignPosition.MaxForce = math.huge;
		alignPosition.MaxVelocity = math.huge;
		alignPosition.Responsiveness = math.huge;
		alignPosition.Attachment0 = attachment1;
		alignPosition.Attachment1 = attachment2;

		local alignOrientation = Instance.new("AlignOrientation");
		alignOrientation.Parent = v;
		alignOrientation.MaxAngularVelocity = math.huge;
		alignOrientation.MaxTorque = math.huge;
		alignOrientation.Responsiveness = math.huge;
		alignOrientation.Attachment0 = attachment1;
		alignOrientation.Attachment1 = attachment2;

		hatAttachments[i] = attachment2;

		hatConnection = heartBeat:Connect(function()
			attachment2.Parent = players:FindFirstChild(_G.settings.player).Character.Humanoid.RootPart
		end)

		v:BreakJoints();
	end;

	hatAttachments[1].Position = Vector3.new(-0.55, -1.5, -1);
	hatAttachments[2].Position = Vector3.new(0.55, -1.5, -1);
	-- hatAttachments[1].Position = Vector3.new(-0.55, 0.3, -1);
	-- hatAttachments[2].Position = Vector3.new(0.55, 0.3, -1);
end

task.spawn(function()
	local z = 0;
	while task.wait() do
		if _G.settings.mode == 1 then
			if z < 2 then 
				z += 1*_G.settings.speed ;
			else
				z = 0;
			end;
		elseif _G.settings.mode == 2 then
			if z < 2 then 
				z += 1*_G.settings.speed ;
			else 
				task.wait(0.5);
				z = 0;
			end;
		end
		for x,y in pairs(hatAttachments) do
			if x == 1 or x == 2 then continue end
			hatAttachments[x].Position = Vector3.new(0, -1, -x-z+3);
		end;
	end
end)
------------------------------------------

----------[  GUI FUNCTIONS  ]----------
local function getPlayerByPlayerName(name)
	if name then
		name = name:lower()
		for i, v in ipairs(players:GetPlayers()) do
			if string.lower(string.sub(v.Name, 1, #name)) == name then
				return v
			end
			if string.lower(string.sub(v.DisplayName, 1, #name)) == name then
				return v
			end
		end
		for i, v in ipairs(players:GetPlayers()) do
			if string.match(v.Name:lower(), name) then
				return v
			end
			if string.match(v.DisplayName:lower(), name) then
				return v
			end
		end
	end
end

local function getTargetPlayer(name) -- try to get a target player from the name
	local target
	if name == " " or name == "" then
		-- if target player isn't specified, use the localplayer
		target = localPlayer
		return target
	end
	local matchingPlayer = getPlayerByPlayerName(name)
	if name:lower() == "me" then
		target = localPlayer
		return target
	elseif name:lower() == "random" then
		local playerTable = players:GetPlayers()
		target = playerTable[math.random(#playerTable)]
		return target
	elseif matchingPlayer then
		target = matchingPlayer
		return target
	end
	target = localPlayer
	return target
end
------------------------------------------


----------[  Events  ]----------
localHumanoid.Died:Connect(function()
	bodyPartPosConnection:Disconnect()
	netlessConnection:Disconnect()
	hatConnection:Disconnect()
end)

------------------------------------------

-- Gui to Lua
-- Version: 3.2

-- Instances:

local benis = Instance.new("ScreenGui")
local Commands = Instance.new("Frame")
local Container = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")
local TextLabel_2 = Instance.new("TextLabel")
local TextBox = Instance.new("TextBox")
local UICorner_4 = Instance.new("UICorner")
local TextLabel_3 = Instance.new("TextLabel")
local UICorner_5 = Instance.new("UICorner")
local TextLabel_4 = Instance.new("TextLabel")
local TextBox_2 = Instance.new("TextBox")
local UICorner_6 = Instance.new("UICorner")
local Topbar = Instance.new("Frame")
local Icon = Instance.new("ImageLabel")
local Exit = Instance.new("TextButton")
local ImageLabel = Instance.new("ImageLabel")
local Minimize = Instance.new("TextButton")
local ImageLabel_2 = Instance.new("ImageLabel")
local TopBar = Instance.new("Frame")
local ImageLabel_3 = Instance.new("ImageLabel")
local ImageLabel_4 = Instance.new("ImageLabel")
local Title = Instance.new("TextLabel")
local UICorner_7 = Instance.new("UICorner")
local UIGradient_2 = Instance.new("UIGradient")

--Properties:

benis.Name = "benis"
benis.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
benis.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
benis.ResetOnSpawn = false

Commands.Name = "Commands"
Commands.Parent = benis
Commands.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Commands.BackgroundTransparency = 0.140
Commands.BorderColor3 = Color3.fromRGB(139, 139, 139)
Commands.BorderSizePixel = 0
Commands.Position = UDim2.new(0.222225085, 0, 0.349429816, 0)
Commands.Size = UDim2.new(0, 259, 0, 246)
Commands.Active = true
Commands.Draggable = true

Container.Name = "Container"
Container.Parent = Commands
Container.AnchorPoint = Vector2.new(0.5, 1)
Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Container.BackgroundTransparency = 0.500
Container.BorderColor3 = Color3.fromRGB(255, 255, 255)
Container.BorderSizePixel = 0
Container.ClipsDescendants = true
Container.Position = UDim2.new(0.5, 0, 1, -5)
Container.Size = UDim2.new(1, -10, 1.01153851, -30)

UICorner.CornerRadius = UDim.new(0, 9)
UICorner.Parent = Container

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 4, 20))}
UIGradient.Parent = Container

TextButton.Parent = Container
TextButton.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
TextButton.Position = UDim2.new(0.154723391, 0, 0.0685436428, 0)
TextButton.Size = UDim2.new(0, 170, 0, 28)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Active the PP"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 20.000
TextButton.TextWrapped = true

UICorner_2.Parent = TextButton

TextLabel.Parent = Container
TextLabel.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
TextLabel.Position = UDim2.new(0.030450169, 0, 0.265035599, 0)
TextLabel.Size = UDim2.new(0, 235, 0, 25)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = ""
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 14.000

UICorner_3.Parent = TextLabel

TextLabel_2.Parent = TextLabel
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.Position = UDim2.new(0.0723404288, 0, 0.0533337407, 0)
TextLabel_2.Size = UDim2.new(0, 64, 0, 23)
TextLabel_2.Font = Enum.Font.SourceSans
TextLabel_2.Text = "Target name"
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextSize = 14.000

TextBox.Parent = TextLabel
TextBox.BackgroundColor3 = Color3.fromRGB(7, 3, 11)
TextBox.Position = UDim2.new(0.46808511, 0, 0.159999996, 0)
TextBox.Size = UDim2.new(0, 106, 0, 17)
TextBox.Font = Enum.Font.SourceSans
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14.000

UICorner_4.Parent = TextBox

TextLabel_3.Parent = Container
TextLabel_3.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
TextLabel_3.Position = UDim2.new(0.030450169, 0, 0.402123004, 0)
TextLabel_3.Size = UDim2.new(0, 235, 0, 25)
TextLabel_3.Font = Enum.Font.SourceSans
TextLabel_3.Text = ""
TextLabel_3.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.TextSize = 14.000

UICorner_5.Parent = TextLabel_3

TextLabel_4.Parent = TextLabel_3
TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.BackgroundTransparency = 1.000
TextLabel_4.Position = UDim2.new(0.0723404288, 0, 0.0533337407, 0)
TextLabel_4.Size = UDim2.new(0, 35, 0, 23)
TextLabel_4.Font = Enum.Font.SourceSans
TextLabel_4.Text = "Speed"
TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.TextSize = 14.000

TextBox_2.Parent = TextLabel_3
TextBox_2.BackgroundColor3 = Color3.fromRGB(7, 3, 11)
TextBox_2.Position = UDim2.new(0.46808511, 0, 0.159999996, 0)
TextBox_2.Size = UDim2.new(0, 106, 0, 17)
TextBox_2.Font = Enum.Font.SourceSans
TextBox_2.Text = ""
TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox_2.TextSize = 14.000

UICorner_6.Parent = TextBox_2

Topbar.Name = "Topbar"
Topbar.Parent = Commands
Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Topbar.BackgroundTransparency = 1.000
Topbar.Size = UDim2.new(1, 0, 0, 25)

Icon.Name = "Icon"
Icon.Parent = Topbar
Icon.AnchorPoint = Vector2.new(0, 0.5)
Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Icon.BackgroundTransparency = 1.000
Icon.Position = UDim2.new(0, 10, 0.5, 0)
Icon.Size = UDim2.new(0, 13, 0, 13)
Icon.Image = "rbxgameasset://Images/menuIcon"

Exit.Name = "Exit"
Exit.Parent = Topbar
Exit.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
Exit.BackgroundTransparency = 0.500
Exit.BorderSizePixel = 0
Exit.Position = UDim2.new(0.996138811, -42, -0.0800012201, 2)
Exit.Size = UDim2.new(-0.0359999985, 40, 0.994000018, -10)
Exit.Font = Enum.Font.Gotham
Exit.Text = "X"
Exit.TextColor3 = Color3.fromRGB(255, 255, 255)
Exit.TextSize = 13.000

ImageLabel.Parent = Exit
ImageLabel.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.Position = UDim2.new(1.00000012, 0, 0, 0)
ImageLabel.Size = UDim2.new(0, 8, 0, 14)
ImageLabel.Image = "http://www.roblox.com/asset/?id=8650484523"
ImageLabel.ImageColor3 = Color3.fromRGB(12, 4, 20)
ImageLabel.ImageTransparency = 0.500

Minimize.Name = "Minimize"
Minimize.Parent = Topbar
Minimize.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
Minimize.BackgroundTransparency = 0.500
Minimize.BorderSizePixel = 0
Minimize.Position = UDim2.new(1.01254416, -69, -0.0800036639, 2)
Minimize.Size = UDim2.new(-0.00933771208, 26, 0.994256616, -10)
Minimize.Font = Enum.Font.Gotham
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 13.000

ImageLabel_2.Parent = Minimize
ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_2.BackgroundTransparency = 1.000
ImageLabel_2.Position = UDim2.new(-0.400999993, 0, 0, 0)
ImageLabel_2.Size = UDim2.new(0, 9, 0, 14)
ImageLabel_2.Image = "http://www.roblox.com/asset/?id=10555881849"
ImageLabel_2.ImageColor3 = Color3.fromRGB(12, 4, 20)
ImageLabel_2.ImageTransparency = 0.500

TopBar.Name = "TopBar"
TopBar.Parent = Topbar
TopBar.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
TopBar.BackgroundTransparency = 0.500
TopBar.BorderSizePixel = 0
TopBar.Position = UDim2.new(0.326113552, 0, 0, 0)
TopBar.Size = UDim2.new(0.0134112388, 82, 0.994254291, -10)

ImageLabel_3.Parent = TopBar
ImageLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_3.BackgroundTransparency = 1.000
ImageLabel_3.Position = UDim2.new(1, 0, 0.000328668219, 0)
ImageLabel_3.Size = UDim2.new(0, 14, 0, 15)
ImageLabel_3.Image = "http://www.roblox.com/asset/?id=8650484523"
ImageLabel_3.ImageColor3 = Color3.fromRGB(12, 4, 20)
ImageLabel_3.ImageTransparency = 0.500

ImageLabel_4.Parent = TopBar
ImageLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_4.BackgroundTransparency = 1.000
ImageLabel_4.Position = UDim2.new(-0.14339906, 1, 0, 0)
ImageLabel_4.Size = UDim2.new(0, 11, 0, 14)
ImageLabel_4.Image = "http://www.roblox.com/asset/?id=10555881849"
ImageLabel_4.ImageColor3 = Color3.fromRGB(12, 4, 20)
ImageLabel_4.ImageTransparency = 0.500

Title.Name = "Title"
Title.Parent = TopBar
Title.AnchorPoint = Vector2.new(0, 0.5)
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderSizePixel = 0
Title.Position = UDim2.new(-0.465272665, 32, 0.377092898, 0)
Title.Size = UDim2.new(0.295272678, 80, 0.602230132, -7)
Title.Font = Enum.Font.SourceSansLight
Title.Text = "pp"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17.000

UICorner_7.CornerRadius = UDim.new(0, 9)
UICorner_7.Parent = Commands

UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(0.53, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 4, 20))}
UIGradient_2.Parent = Commands

-- Scripts:

local function BLUEWBX_fake_script() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript', TextButton)

	script.Parent.MouseButton1Click:Connect(function()
		startMain()
	end)
end
coroutine.wrap(BLUEWBX_fake_script)()
local function USSK_fake_script() -- TextBox.LocalScript 
	local script = Instance.new('LocalScript', TextBox)

	script.Parent.FocusLost:Connect(function()--when the user stops inputting text
		local text = script.Parent.Text
		_G.settings.player = getTargetPlayer(text).Name
		print("event was fired ")
	end) 
end
coroutine.wrap(USSK_fake_script)()
local function AJZO_fake_script() -- TextBox_2.LocalScript 
	local script = Instance.new('LocalScript', TextBox_2)

	script.Parent.FocusLost:Connect(function()--when the user stops inputting text
		local text = script.Parent.Text
		_G.settings.speed = text / 10
	end) 
end
coroutine.wrap(AJZO_fake_script)()
local function IKUF_fake_script() -- Exit.LocalScript 
	local script = Instance.new('LocalScript', Exit)

	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Parent.Parent.Parent:Destroy()
	end)
end
coroutine.wrap(IKUF_fake_script)()
local function DUZE_fake_script() -- Commands.LocalScript 
	local script = Instance.new('LocalScript', Commands)

	script.Parent.Active = true
	script.Parent.Parent.ResetOnSpawn = false
end
coroutine.wrap(DUZE_fake_script)()
