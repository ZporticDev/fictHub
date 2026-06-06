--[[
   __    __    _______  ___            __            __    __   ____  ____  _______   
  /" |  | "\  /"     "||"  |          /""\          /" |  | "\ ("  _||_ " ||   _  "\  
 (:  (__)  :)(: ______)||  |         /    \        (:  (__)  :)|   (  ) : |(. |_)  :) 
  \/      \/  \/    |  |:  |        /' /\  \        \/      \/ (:  |  | . )|:     \/  
  //  __  \  // ___)_  \  |___    //  __'  \       //  __  \  \ \__/ // (|  _  \  
 (:  (  )  :)(:      "|( \_|:  \  /   /  \  \     (:  (  )  :) /\ __ //\ |: |_)  :) 
  \__|  |__/  \_______) \_______)(___/    \___)     \__|  |__/ (__________)(_______/  
]]

-- // HelaHub UI Library

local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local Players = game:GetService('Players')
local CoreGui = game:GetService('CoreGui')
local RunService = game:GetService('RunService')
local Lighting = game:GetService('Lighting')
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

local Theme = {
	Background  = Color3.fromRGB(19, 19, 19),
	Row         = Color3.fromRGB(24, 24, 24),
	RowAlt      = Color3.fromRGB(10, 10, 10),
	Stroke      = Color3.fromRGB(40, 40, 40),
	Text        = Color3.fromRGB(245, 245, 245),
	ToggleOff   = Color3.fromRGB(40, 40, 40),
	ToggleOn    = Color3.fromRGB(245, 245, 245),
	KnobOn      = Color3.fromRGB(40, 40, 40),
	KnobOff     = Color3.fromRGB(245, 245, 245),
	SliderFill  = Color3.fromRGB(245, 245, 245),
	SliderTrack = Color3.fromRGB(40, 40, 40),
	WatermarkBg = Color3.fromRGB(22, 22, 22),
	WatermarkStroke = Color3.fromRGB(50, 50, 50),
	Accent      = Color3.fromRGB(0, 255, 128),
	ToastBg     = Color3.fromRGB(30, 30, 30),
}

local FONT  = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local FONT_SEMIBOLD = Font.new('rbxassetid://11702779517', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ROW_H = 51
local WIDTH = 284

local isStudio = RunService:IsStudio()

local ScreenGui = Instance.new('ScreenGui')
ScreenGui.Name = 'HelaHub'
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99999

if isStudio then
	ScreenGui.Parent = LocalPlayer:WaitForChild('PlayerGui')
else
	ScreenGui.Parent = CoreGui
end

local blur = Instance.new('BlurEffect')
blur.Name = 'HelaBlur'
blur.Size = 0
blur.Parent = Lighting

ScreenGui.AncestryChanged:Connect(function()
	if not ScreenGui.Parent then
		blur:Destroy()
	end
end)

local bg = Instance.new('CanvasGroup')
bg.Name = 'Background'
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.8
bg.BorderSizePixel = 0
bg.GroupTransparency = 1
bg.Visible = false
bg.Parent = ScreenGui

-- // Toast Notification - G to Open
local toast = Instance.new('Frame')
toast.Name = 'Toast'
toast.AnchorPoint = Vector2.new(0.5, 1)
toast.Position = UDim2.new(0.5, 0, 1, -60)
toast.Size = UDim2.new(0, 0, 0, 36)
toast.AutomaticSize = Enum.AutomaticSize.X
toast.BackgroundColor3 = Theme.ToastBg
toast.BackgroundTransparency = 0.1
toast.BorderSizePixel = 0
toast.Visible = false
toast.Parent = ScreenGui

local toastCorner = Instance.new('UICorner')
toastCorner.CornerRadius = UDim.new(0, 8)
toastCorner.Parent = toast

local toastStroke = Instance.new('UIStroke')
toastStroke.Color = Theme.WatermarkStroke
toastStroke.Thickness = 1
toastStroke.Transparency = 0.3
toastStroke.Parent = toast

local toastPadding = Instance.new('UIPadding')
toastPadding.PaddingLeft = UDim.new(0, 16)
toastPadding.PaddingRight = UDim.new(0, 16)
toastPadding.Parent = toast

local toastText = Instance.new('TextLabel')
toastText.Name = 'ToastText'
toastText.Size = UDim2.new(0, 0, 1, 0)
toastText.AutomaticSize = Enum.AutomaticSize.X
toastText.BackgroundTransparency = 1
toastText.BorderSizePixel = 0
toastText.Text = 'Press G to open'
toastText.TextColor3 = Theme.Text
toastText.TextSize = 14
toastText.FontFace = FONT
toastText.TextXAlignment = Enum.TextXAlignment.Center
toastText.TextYAlignment = Enum.TextYAlignment.Center
toastText.Parent = toast

local hintShown = false

local function showToast()
	if hintShown then return end
	hintShown = true

	toast.Visible = true
	toast.BackgroundTransparency = 1
	toastStroke.Transparency = 1
	toastText.TextTransparency = 1

	-- Fade in
	TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
	TweenService:Create(toastStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
	TweenService:Create(toastText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

	-- Wait 3 seconds then fade out
	task.delay(3, function()
		TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		TweenService:Create(toastStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
		TweenService:Create(toastText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()

		task.delay(0.3, function()
			toast.Visible = false
		end)
	end)
end

-- Show toast on startup
task.delay(0.5, showToast)

-- // Watermark (Top Bar Design - HelaHub + FPS)
local watermark = Instance.new('Frame')
watermark.Name = 'Watermark'
watermark.AnchorPoint = Vector2.new(0.5, 0)
watermark.Position = UDim2.new(0.5, 0, 0, 15)
watermark.Size = UDim2.new(0, 0, 0, 38)
watermark.AutomaticSize = Enum.AutomaticSize.X
watermark.BackgroundColor3 = Theme.WatermarkBg
watermark.BackgroundTransparency = 0.15
watermark.BorderSizePixel = 0
watermark.Parent = ScreenGui

local watermarkCorner = Instance.new('UICorner')
watermarkCorner.CornerRadius = UDim.new(0, 10)
watermarkCorner.Parent = watermark

local watermarkStroke = Instance.new('UIStroke')
watermarkStroke.Color = Theme.WatermarkStroke
watermarkStroke.Thickness = 1
watermarkStroke.Transparency = 0.3
watermarkStroke.Parent = watermark

-- Left section - HelaHub text (FONT - Medium)
local leftSection = Instance.new('Frame')
leftSection.Name = 'LeftSection'
leftSection.Size = UDim2.new(0, 0, 1, 0)
leftSection.AutomaticSize = Enum.AutomaticSize.X
leftSection.BackgroundTransparency = 1
leftSection.BorderSizePixel = 0
leftSection.Parent = watermark

local leftPadding = Instance.new('UIPadding')
leftPadding.PaddingLeft = UDim.new(0, 14)
leftPadding.PaddingRight = UDim.new(0, 10)
leftPadding.Parent = leftSection

local hubText = Instance.new('TextLabel')
hubText.Name = 'HubText'
hubText.Size = UDim2.new(0, 0, 1, 0)
hubText.AutomaticSize = Enum.AutomaticSize.X
hubText.BackgroundTransparency = 1
hubText.BorderSizePixel = 0
hubText.Text = 'HelaHub'
hubText.TextColor3 = Theme.Text
hubText.TextSize = 15
hubText.FontFace = FONT
hubText.TextXAlignment = Enum.TextXAlignment.Left
hubText.TextYAlignment = Enum.TextYAlignment.Center
hubText.Parent = leftSection

-- Divider 1
local div1 = Instance.new('Frame')
div1.Name = 'Divider1'
div1.Position = UDim2.new(1, 0, 0.15, 0)
div1.Size = UDim2.new(0, 1, 0.7, 0)
div1.BackgroundColor3 = Theme.WatermarkStroke
div1.BackgroundTransparency = 0.5
div1.BorderSizePixel = 0
local div1Corner = Instance.new('UICorner')
div1Corner.CornerRadius = UDim.new(1, 0)
div1Corner.Parent = div1
div1.Parent = leftSection

-- Right section - FPS
local rightSection = Instance.new('Frame')
rightSection.Name = 'RightSection'
rightSection.Position = UDim2.new(1, 0, 0, 0)
rightSection.Size = UDim2.new(0, 0, 1, 0)
rightSection.AutomaticSize = Enum.AutomaticSize.X
rightSection.BackgroundTransparency = 1
rightSection.BorderSizePixel = 0
rightSection.Parent = watermark

local rightPadding = Instance.new('UIPadding')
rightPadding.PaddingLeft = UDim.new(0, 10)
rightPadding.PaddingRight = UDim.new(0, 14)
rightPadding.Parent = rightSection

local fpsText = Instance.new('TextLabel')
fpsText.Name = 'FPSText'
fpsText.Size = UDim2.new(0, 0, 1, 0)
fpsText.AutomaticSize = Enum.AutomaticSize.X
fpsText.BackgroundTransparency = 1
fpsText.BorderSizePixel = 0
fpsText.Text = '60 FPS'
fpsText.TextColor3 = Theme.Accent
fpsText.TextSize = 15
fpsText.FontFace = FONT_SEMIBOLD
fpsText.TextXAlignment = Enum.TextXAlignment.Left
fpsText.TextYAlignment = Enum.TextYAlignment.Center
fpsText.Parent = rightSection

-- // FPS Update
local lastTime = tick()
local frameCount = 0
local fps = 60

local function updateFPS()
	RunService.RenderStepped:Connect(function()
		frameCount += 1
		local currentTime = tick()
		if currentTime - lastTime >= 1 then
			fps = frameCount
			frameCount = 0
			lastTime = currentTime
			fpsText.Text = tostring(fps) .. ' FPS'

			if fps >= 55 then
				fpsText.TextColor3 = Theme.Accent
			elseif fps >= 30 then
				fpsText.TextColor3 = Color3.fromRGB(255, 200, 0)
			else
				fpsText.TextColor3 = Color3.fromRGB(255, 80, 80)
			end
		end
	end)
end

updateFPS()

local Container = Instance.new('Frame')
Container.Name = 'Container'
Container.Size = UDim2.new(1, 0, 1, 0)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.Parent = ScreenGui

local ContainerLayout = Instance.new('UIListLayout')
ContainerLayout.FillDirection = Enum.FillDirection.Horizontal
ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContainerLayout.Padding = UDim.new(0, 15)
ContainerLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ContainerLayout.Parent = Container

local ContainerPadding = Instance.new('UIPadding')
ContainerPadding.PaddingTop = UDim.new(0, 80)
ContainerPadding.PaddingLeft = UDim.new(0, 25)
ContainerPadding.Parent = Container

local panels = {}
local guiOpen = false

local function makeDivider(parent)
	local d = Instance.new('Frame')
	d.Name = 'Divider'
	d.AnchorPoint = Vector2.new(0, 1)
	d.Position = UDim2.new(0, 0, 1, 0)
	d.Size = UDim2.new(1, 0, 0, 1)
	d.BackgroundColor3 = Theme.Stroke
	d.BorderSizePixel = 0
	d.Parent = parent
end

local function makeRow(parent, name, order, isAlt)
	local row = Instance.new('Frame')
	row.Name = name
	row.Size = UDim2.new(1, 0, 0, ROW_H)
	row.BackgroundColor3 = isAlt and Theme.RowAlt or Theme.Row
	row.BackgroundTransparency = 0.5
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent

	local rc = Instance.new('UICorner')
	rc.Parent = row

	makeDivider(row)

	return row
end

local function makeLabel(parent, text)
	local label = Instance.new('TextLabel')
	label.AnchorPoint = Vector2.new(0, 0.5)
	label.Position = UDim2.new(0, 10, 0.5, 0)
	label.Size = UDim2.new(0.55, 0, 0.8, 0)
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Text = text
	label.TextColor3 = Theme.Text
	label.TextSize = 16
	label.FontFace = FONT
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Parent = parent
	return label
end

-- // G Keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode ~= Enum.KeyCode.G then return end

	guiOpen = not guiOpen

	if guiOpen then
		-- bg fade in
		bg.Visible = true
		TweenService:Create(bg, TweenInfo.new(0.2), {GroupTransparency = 0}):Play()
		TweenService:Create(blur, TweenInfo.new(0.2), {Size = 24}):Play()

		-- paneller + strokeler staggered fade in (0.1s delay)
		for i, p in ipairs(panels) do
			p.Visible = true
			local stroke = p:FindFirstChildOfClass('UIStroke')
			if stroke then
				stroke.Transparency = 1
			end
			task.delay((i - 1) * 0.1, function()
				if stroke then
					TweenService:Create(stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()
				end
				TweenService:Create(p, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					GroupTransparency = 0
				}):Play()
			end)
		end
	else
		-- hepsi ayni anda fade out
		TweenService:Create(bg, TweenInfo.new(0.2), {GroupTransparency = 1}):Play()
		TweenService:Create(blur, TweenInfo.new(0.2), {Size = 0}):Play()

		for _, p in ipairs(panels) do
			local stroke = p:FindFirstChildOfClass('UIStroke')
			if stroke then
				TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
			end
			TweenService:Create(p, TweenInfo.new(0.2), {GroupTransparency = 1}):Play()
		end

		task.delay(0.2, function()
			bg.Visible = false
			for _, p in ipairs(panels) do
				p.Visible = false
			end
		end)
	end
end)

function Library:CreatePanel(config)
	local title = config.Title or 'Panel'
	local order = config.LayoutOrder or 0

	local panel = Instance.new('CanvasGroup')
	panel.Name = title
	panel.Size = UDim2.new(0, WIDTH, 0, 0)
	panel.AutomaticSize = Enum.AutomaticSize.Y
	panel.BackgroundColor3 = Theme.Background
	panel.BackgroundTransparency = 0.2
	panel.BorderSizePixel = 0
	panel.LayoutOrder = order
	panel.GroupTransparency = 1
	panel.Visible = false
	panel.Parent = Container

	table.insert(panels, panel)

	local panelCorner = Instance.new('UICorner')
	panelCorner.CornerRadius = UDim.new(0, 8)
	panelCorner.Parent = panel

	local panelStroke = Instance.new('UIStroke')
	panelStroke.Color = Theme.Stroke
	panelStroke.Transparency = 1
	panelStroke.Parent = panel

	local header = Instance.new('Frame')
	header.Name = 'Header'
	header.Size = UDim2.new(1, 0, 0, ROW_H)
	header.BackgroundColor3 = Theme.RowAlt
	header.BackgroundTransparency = 0.5
	header.BorderSizePixel = 0
	header.Parent = panel

	local headerCorner = Instance.new('UICorner')
	headerCorner.CornerRadius = UDim.new(0, 8)
	headerCorner.Parent = header

	local headerLabel = Instance.new('TextLabel')
	headerLabel.Size = UDim2.new(1, 0, 1, 0)
	headerLabel.BackgroundTransparency = 1
	headerLabel.BorderSizePixel = 0
	headerLabel.Text = title
	headerLabel.TextColor3 = Theme.Text
	headerLabel.TextSize = 18
	headerLabel.FontFace = FONT
	headerLabel.Parent = header

	local headerDiv = Instance.new('Frame')
	headerDiv.Name = 'Divider'
	headerDiv.AnchorPoint = Vector2.new(0, 1)
	headerDiv.Position = UDim2.new(0, 0, 1, 0)
	headerDiv.Size = UDim2.new(1, 0, 0, 1)
	headerDiv.BackgroundColor3 = Theme.Stroke
	headerDiv.BorderSizePixel = 0
	headerDiv.Parent = header

	local content = Instance.new('Frame')
	content.Name = 'Content'
	content.Position = UDim2.new(0, 0, 0, ROW_H)
	content.Size = UDim2.new(1, 0, 0, 0)
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Parent = panel

	local contentLayout = Instance.new('UIListLayout')
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 0)
	contentLayout.Parent = content

	contentLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		local rows = {}
		for _, child in ipairs(content:GetChildren()) do
			if child:IsA('Frame') then
				table.insert(rows, child)
			end
		end

		table.sort(rows, function(a, b)
			return a.LayoutOrder < b.LayoutOrder
		end)

		for i, row in ipairs(rows) do
			local divider = row:FindFirstChild('Divider')
			if divider then
				divider.Visible = i ~= #rows
			end
		end
	end)

	local rowCount = 0
	local Panel = {}

	function Panel:AddTitle(config)
		local text = config.Text or 'Title'

		rowCount += 1
		local isAlt = rowCount % 2 == 0

		local row = makeRow(content, 'Title_' .. rowCount, rowCount, isAlt)
		row.Size = UDim2.new(1, 0, 0, 36)

		local titleLabel = Instance.new('TextLabel')
		titleLabel.Size = UDim2.new(1, 0, 1, 0)
		titleLabel.BackgroundTransparency = 1
		titleLabel.BorderSizePixel = 0
		titleLabel.Text = text
		titleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		titleLabel.TextSize = 12
		titleLabel.FontFace = FONT
		titleLabel.TextXAlignment = Enum.TextXAlignment.Center
		titleLabel.TextYAlignment = Enum.TextYAlignment.Center
		titleLabel.Parent = row

		return row
	end

	function Panel:AddButton(config)
		local name     = config.Name or 'Button'
		local callback = config.Callback or function() end

		rowCount += 1
		local isAlt = rowCount % 2 == 0

		local row = makeRow(content, name, rowCount, isAlt)

		local btn = Instance.new('TextButton')
		btn.Name = 'Button'
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundColor3 = Theme.RowAlt
		btn.BackgroundTransparency = 0.3
		btn.BorderSizePixel = 0
		btn.Text = name
		btn.TextColor3 = Theme.Text
		btn.TextSize = 14
		btn.FontFace = FONT
		btn.Parent = row

		local btnCorner = Instance.new('UICorner')
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
		end)

		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
		end)

		btn.MouseButton1Click:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
			task.delay(0.1, function()
				TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
			end)
			callback()
		end)

		local button = {}

		function button:SetText(newText)
			btn.Text = newText
		end

		return button
	end

	function Panel:AddToggle(config)
		local name     = config.Name or 'Toggle'
		local default  = config.Default or false
		local callback = config.Callback or function() end

		rowCount += 1
		local state = default
		local isAlt = rowCount % 2 == 0

		local row = makeRow(content, name, rowCount, isAlt)
		makeLabel(row, name)

		local track = Instance.new('Frame')
		track.Name = 'Track'
		track.AnchorPoint = Vector2.new(1, 0.5)
		track.Position = UDim2.new(1, -10, 0.5, 0)
		track.Size = UDim2.new(0, 30, 0, 18)
		track.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
		track.BorderSizePixel = 0
		track.Parent = row

		local trackCorner = Instance.new('UICorner')
		trackCorner.CornerRadius = UDim.new(1, 0)
		trackCorner.Parent = track

		local knob = Instance.new('Frame')
		knob.Name = 'Knob'
		knob.AnchorPoint = Vector2.new(0, 0.5)
		knob.Position = state and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
		knob.Size = UDim2.new(0, 12, 0, 12)
		knob.BackgroundColor3 = state and Theme.KnobOn or Theme.KnobOff
		knob.BorderSizePixel = 0
		knob.Parent = track

		local knobCorner = Instance.new('UICorner')
		knobCorner.CornerRadius = UDim.new(1, 0)
		knobCorner.Parent = knob

		local function applyState(s)
			TweenService:Create(track, TWEEN, {
				BackgroundColor3 = s and Theme.ToggleOn or Theme.ToggleOff
			}):Play()
			TweenService:Create(knob, TWEEN, {
				Position = s and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
				BackgroundColor3 = s and Theme.KnobOn or Theme.KnobOff
			}):Play()
		end

		local btn = Instance.new('TextButton')
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundTransparency = 1
		btn.Text = ''
		btn.Parent = row

		btn.MouseButton1Click:Connect(function()
			state = not state
			applyState(state)
			callback(state)
		end)

		local toggle = {}

		function toggle:GetState()
			return state
		end

		function toggle:SetState(val)
			state = val
			applyState(state)
			callback(state)
		end

		return toggle
	end

	function Panel:AddSlider(config)
		local name     = config.Name or 'Slider'
		local min      = config.Min or 0
		local max      = config.Max or 100
		local default  = config.Default or min
		local callback = config.Callback or function() end

		rowCount += 1
		local isAlt = rowCount % 2 == 0
		local value = math.clamp(default, min, max)
		local dragging = false

		local row = makeRow(content, name, rowCount, isAlt)
		makeLabel(row, name)

		local valueLabel = Instance.new('TextLabel')
		valueLabel.AnchorPoint = Vector2.new(1, 0.5)
		valueLabel.Position = UDim2.new(1, -98, 0.5, 0)
		valueLabel.Size = UDim2.new(0, 30, 0.7, 0)
		valueLabel.BackgroundTransparency = 1
		valueLabel.BorderSizePixel = 0
		valueLabel.Text = tostring(value)
		valueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		valueLabel.TextSize = 13
		valueLabel.FontFace = FONT
		valueLabel.Parent = row

		local track = Instance.new('Frame')
		track.Name = 'Track'
		track.AnchorPoint = Vector2.new(1, 0.5)
		track.Position = UDim2.new(1, -10, 0.5, 0)
		track.Size = UDim2.new(0, 80, 0, 5)
		track.BackgroundColor3 = Theme.SliderTrack
		track.BorderSizePixel = 0
		track.Parent = row

		local trackCorner = Instance.new('UICorner')
		trackCorner.CornerRadius = UDim.new(1, 0)
		trackCorner.Parent = track

		local fill = Instance.new('Frame')
		fill.Name = 'Fill'
		fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
		fill.BackgroundColor3 = Theme.SliderFill
		fill.BorderSizePixel = 0
		fill.Parent = track

		local fillCorner = Instance.new('UICorner')
		fillCorner.CornerRadius = UDim.new(1, 0)
		fillCorner.Parent = fill

		local handle = Instance.new('Frame')
		handle.Name = 'Handle'
		handle.AnchorPoint = Vector2.new(0.5, 0.5)
		handle.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
		handle.Size = UDim2.new(0, 12, 0, 12)
		handle.BackgroundColor3 = Theme.SliderFill
		handle.BorderSizePixel = 0
		handle.Parent = track

		local handleCorner = Instance.new('UICorner')
		handleCorner.CornerRadius = UDim.new(1, 0)
		handleCorner.Parent = handle

		local function applyValue(inputX)
			local trackPos  = track.AbsolutePosition.X
			local trackSize = track.AbsoluteSize.X
			local relative  = math.clamp((inputX - trackPos) / trackSize, 0, 1)
			value = math.round(min + (max - min) * relative)
			local pct = (value - min) / (max - min)

			-- Clamp handle position so it stays inside track
			local handlePct = math.clamp(pct, 0, 1)
			local fillPct = math.clamp(pct, 0, 1)

			TweenService:Create(fill, TWEEN, {
				Size = UDim2.new(fillPct, 0, 1, 0)
			}):Play()
			TweenService:Create(handle, TWEEN, {
				Position = UDim2.new(handlePct, 0, 0.5, 0)
			}):Play()

			valueLabel.Text = tostring(value)
			callback(value)
		end

		track.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				applyValue(input.Position.X)
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				applyValue(input.Position.X)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		local slider = {}

		function slider:GetValue()
			return value
		end

		function slider:SetValue(val)
			value = math.clamp(val, min, max)
			local pct = (value - min) / (max - min)
			local handlePct = math.clamp(pct, 0, 1)
			local fillPct = math.clamp(pct, 0, 1)
			TweenService:Create(fill, TWEEN, {
				Size = UDim2.new(fillPct, 0, 1, 0)
			}):Play()
			TweenService:Create(handle, TWEEN, {
				Position = UDim2.new(handlePct, 0, 0.5, 0)
			}):Play()
			valueLabel.Text = tostring(value)
			callback(value)
		end

		return slider
	end

	return Panel
end

return Library